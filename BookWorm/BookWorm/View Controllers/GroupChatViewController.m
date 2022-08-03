//
//  GroupChatViewController.m
//  BookWorm
//
//  Created by Ramya Prabakar on 8/2/22.
//

#import "GroupChatViewController.h"
#import "GroupChat.h"
#import "GroupConversation.h"
#import "GroupMembersViewController.h"
#import "InnerChatCell.h"

@interface GroupChatViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *groupName;
@property (weak, nonatomic) IBOutlet UITableView *groupChatTableView;
@property (weak, nonatomic) IBOutlet UITextField *messageBar;
@property (nonatomic, strong) NSMutableArray *arrayOfMessagesForGroupChat;
@property (nonatomic, strong) PFLiveQueryClient *liveQueryClient;
@property (nonatomic, strong) PFLiveQuerySubscription *subscription;

@end

@implementation GroupChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.groupName.title = self.groupNameString;
    self.groupChatTableView.dataSource = self;
    self.arrayOfMessagesForGroupChat = [[NSMutableArray alloc] init];
    
    [self fetchFromParse];
    
    // using live query to immediately show the change
    self.liveQueryClient = [[PFLiveQueryClient alloc] initWithServer:@"wss://bookworm.b4a.io" applicationId:@"cfEqijsSr9AS03FR76DJYM374KHH5GddQSQvIU7H" clientKey:@"F9dLUvMhb8D7aMCAukUDMFae630qhhlYTki6dGxP"];
    
    
    // Live Query
    PFQuery *chatQuery = [PFQuery queryWithClassName:@"GroupChat"];
    NSLog(@"%@", self.groupChatId);
    [chatQuery whereKey:@"groupConversationId" equalTo:self.groupChatId];
    self.subscription = [self.liveQueryClient subscribeToQuery:chatQuery];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [self.subscription addCreateHandler:^(PFQuery<PFObject *> * _Nonnull query, PFObject * _Nonnull object) {
        __strong typeof (self) strongSelf = weakSelf;
        
        if (strongSelf != nil) {
            [strongSelf.arrayOfMessagesForGroupChat insertObject:object atIndex:strongSelf.arrayOfMessagesForGroupChat.count];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.groupChatTableView reloadData];
            });
        }
    }];
}



-(void) fetchFromParse {
    PFQuery *query = [PFQuery queryWithClassName:@"GroupChat"];
    [query whereKey:@"groupConversationId" equalTo:self.groupChatId];
    [query orderByAscending:@"createdAt"];
    
    // A little trick for removing the cell separators
    self.groupChatTableView.separatorColor = [UIColor clearColor];
    
    // Finding all the chats that are a part of this group chat
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.arrayOfMessagesForGroupChat = objects;
        }
        
        [self.groupChatTableView reloadData];
    
    }];
}


- (IBAction)pressedSend:(id)sender {
    // __block NSString *objectId;
    
    // posting the chat to the group chat class
    PFObject *groupChat = [PFObject objectWithClassName:@"GroupChat"];
    PFUser *currUser = [PFUser currentUser];
    NSLog(@"%@", self.groupChatId);
    groupChat[@"author"] = currUser;
    groupChat[@"message"] = self.messageBar.text;
    groupChat[@"groupConversationId"] = self.groupChatId;
    [groupChat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Group Chat Saved");
            self.messageBar.text = nil;
        } else {
            NSLog(@"Failed to save group chat");
        }
    }];
    
    /* if ([self.groupChatId isEqualToString:@"NewGroupChat"]) {
        // Creating a new conversation object
        PFObject *groupConversation = [PFObject objectWithClassName:@"GroupConversation"];
        PFUser *currUser = [PFUser currentUser];
        NSLog(@"Group name string: ");
        NSLog(@"%@", self.groupNameString);
        groupConversation[@"groupName"] = self.groupNameString;
        groupConversation[@"users"] = self.groupChatUsers;
        
        [groupConversation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
           if (succeeded) {
               objectId = groupConversation.objectId;
               self.groupChatId = objectId;
               
               // posting the chat to the group chat class
               PFObject *groupChat = [PFObject objectWithClassName:@"GroupChat"];
               // PFUser *currUser = [PFUser currentUser];
               groupChat[@"author"] = currUser;
               groupChat[@"message"] = self.messageBar.text;
               groupChat[@"groupConversationId"] = objectId;
               
               [groupChat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                   if (succeeded) {
                       NSLog(@"Group Chat Saved");
                       self.groupChatId = objectId;
                   } else {
                       NSLog(@"Failed to save group chat");
                   }
                   self.messageBar.text = nil;
               }];
           } else {
               NSLog(@"Failed to save group conversation");
           }
        }];
        
    } else {
        // posting the chat to the group chat class
        PFObject *groupChat = [PFObject objectWithClassName:@"GroupChat"];
        PFUser *currUser = [PFUser currentUser];
        NSLog(@"%@", self.groupChatId);
        groupChat[@"author"] = currUser;
        groupChat[@"message"] = self.messageBar.text;
        groupChat[@"groupConversationId"] = self.groupChatId;
        [groupChat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Group Chat Saved");
                self.messageBar.text = nil;
            } else {
                NSLog(@"Failed to save group chat");
            }
        }];
    } */
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:true];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InnerChatCell *otherCell = [tableView dequeueReusableCellWithIdentifier:@"OtherInnerChatCell"];
    InnerChatCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"MyInnerChatCell"];
    GroupChat *groupChat = self.arrayOfMessagesForGroupChat[indexPath.row];
    
    
    PFUser *author = groupChat[@"author"];
    PFUser *currUser = [PFUser currentUser];
    [author fetchIfNeeded];
    
    if ([author.username isEqualToString:currUser.username]) {
        myCell.privateChatMessage.text = groupChat.message;
        myCell.privateChatUsername.text = groupChat.author.username;
        myCell.privateChatProfilePicture.file = groupChat.author[@"profilePicture"];
        [myCell.privateChatProfilePicture loadInBackground];
        myCell.privateChatProfilePicture.layer.cornerRadius = myCell.privateChatProfilePicture.frame.size.height / 2;
        myCell.privateChatProfilePicture.layer.masksToBounds = YES;
        
        NSDate *createdAt = groupChat.createdAt;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        // Configure the input format to parse the date string
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        
        // Configure output format
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        
        // Convert Date to String
        myCell.messageTimeStamp.text = [formatter stringFromDate:createdAt];
        
        myCell.viewAroundMessage.backgroundColor = [UIColor systemGreenColor];
        myCell.viewAroundMessage.layer.cornerRadius = 5;
        myCell.viewAroundMessage.layer.masksToBounds = true;
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return myCell;
    } else {
        otherCell.privateChatMessage.text = groupChat.message;
        otherCell.privateChatUsername.text = groupChat.author.username;
        otherCell.privateChatProfilePicture.file = groupChat.author[@"profilePicture"];
        [otherCell.privateChatProfilePicture loadInBackground];
        otherCell.privateChatProfilePicture.layer.cornerRadius = otherCell.privateChatProfilePicture.frame.size.height / 2;
        otherCell.privateChatProfilePicture.layer.masksToBounds = YES;
        
        NSDate *createdAt = groupChat.createdAt;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        // Configure the input format to parse the date string
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        
        // Configure output format
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        
        // Convert Date to String
        otherCell.messageTimeStamp.text = [formatter stringFromDate:createdAt];
        
        otherCell.viewAroundMessage.backgroundColor = [UIColor whiteColor];
        otherCell.viewAroundMessage.layer.cornerRadius = 5;
        otherCell.viewAroundMessage.layer.masksToBounds = true;
        otherCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return otherCell;
    }
    
    return otherCell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayOfMessagesForGroupChat.count;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSArray *groupMembersToPass = self.groupChatUsers;
    GroupMembersViewController *groupMembersVC = [segue destinationViewController];
    groupMembersVC.groupMembersPassed = groupMembersToPass;
}

     
@end
     
