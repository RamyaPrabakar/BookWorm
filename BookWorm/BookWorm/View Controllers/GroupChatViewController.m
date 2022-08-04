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
    self.liveQueryClient = [[PFLiveQueryClient alloc] initWithServer:@"wss://bookwormnew.b4a.io" applicationId:@"uJmLEb8geUHYaMmMWTk3rBlYQJ0L2MzIfaCPwFrh" clientKey:@"4oKQmiYRyr49sVDqLo9TJDUIU9FYRwUfCgRKBKjW"];
    
    
    // Live Query
    PFQuery *chatQuery = [PFQuery queryWithClassName:@"GroupChat"];
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
    
    // posting the chat to the group chat class
    PFObject *groupChat = [PFObject objectWithClassName:@"GroupChat"];
    PFUser *currUser = [PFUser currentUser];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSArray *groupMembersToPass = self.groupChatUsers;
    GroupMembersViewController *groupMembersVC = [segue destinationViewController];
    groupMembersVC.groupMembersPassed = groupMembersToPass;
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -keyboardSize.height;
        self.view.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
    }];
}

     
@end
     
