//
//  IndividualChatViewController.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/20/22.
//

#import "IndividualChatViewController.h"
#import "InnerChatCell.h"
#import "Conversation.h"
#import "Chat.h"
#import "OtherProfileViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface IndividualChatViewController ()
@property (weak, nonatomic) IBOutlet UITableView *privateChatTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *usernameTop;
@property (nonatomic, strong) NSMutableArray *arrayOfMessagesForIndividualChat;
@property (nonatomic) bool conversationAlreadyExists;
@property (weak, nonatomic) IBOutlet UITextField *typingBar;
@property (nonatomic, strong) PFLiveQueryClient *liveQueryClient;
@property (nonatomic, strong) PFLiveQuerySubscription *subscription;
@end

@implementation IndividualChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.privateChatTableView.dataSource = self;
    self.usernameTop.title = self.userPassed[@"username"];
    self.arrayOfMessagesForIndividualChat = [[NSMutableArray alloc] init];
    
    // A little trick for removing the cell separators
    self.privateChatTableView.separatorColor = [UIColor clearColor];
    
    PFUser *currUser = [PFUser currentUser];
    PFQuery *query1 = [PFQuery queryWithClassName:@"Conversation"];
    [query1 whereKey:@"user1" equalTo:currUser.username];

    PFQuery *query2 = [PFQuery queryWithClassName:@"Conversation"];
    [query2 whereKey:@"user2" equalTo:currUser.username];

    PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1, query2]];
    [query includeKey:@"user1"];
    [query includeKey:@"user2"];
    [query includeKey:@"chats"];
    [query orderByDescending:@"createdAt"];
    
    // Finding all the conversations where either the user1 or the user2 is the
    // current user
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      if (!error) {
          for (Conversation *conversation in objects) {
              // If there is already a conversation between the current user
              // and the passed in user, then we just add the chat to the
              // chats column of the already existing conversation
              if ([conversation.user1 isEqualToString:self.userPassed.username] ||
                  [conversation.user2 isEqualToString:self.userPassed.username]) {
                  self.arrayOfMessagesForIndividualChat = conversation[@"chats"];
                  
              }
          }
          
          [self.privateChatTableView reloadData];
      }
    }];
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString *appId = [dict objectForKey: @"ParseAppId"];
    NSString *clientKey = [dict objectForKey: @"ParseClientKey"];
    NSString *parseServerName = [dict objectForKey: @"ParseServerName"];
    
    // using live query to immediately show the change
    self.liveQueryClient = [[PFLiveQueryClient alloc] initWithServer:parseServerName applicationId:appId clientKey:clientKey];
    
    // Query for (When the author is currUser AND the "to" is passedUser.username)
    // OR (When the author is passedUser and the "to" is currUser.username)
    PFQuery *chatQuery1 = [PFQuery queryWithClassName:@"Chat"];
    [chatQuery1 whereKey:@"author" equalTo:currUser];
    [chatQuery1 whereKey:@"to" equalTo:self.userPassed.username];

    PFQuery *chatQuery2 = [PFQuery queryWithClassName:@"Chat"];
    [chatQuery2 whereKey:@"author" equalTo:self.userPassed];
    [chatQuery2 whereKey:@"to" equalTo:currUser.username];
    PFQuery *chatQuery = [PFQuery orQueryWithSubqueries:@[chatQuery1, chatQuery2]];
    
    self.subscription = [self.liveQueryClient subscribeToQuery:chatQuery];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [self.subscription addCreateHandler:^(PFQuery<PFObject *> * _Nonnull query, PFObject * _Nonnull object) {
        __strong typeof (self) strongSelf = weakSelf;
        
        if (strongSelf != nil) {
            [strongSelf.arrayOfMessagesForIndividualChat insertObject:object atIndex:strongSelf.arrayOfMessagesForIndividualChat.count];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.privateChatTableView reloadData];
            });
        }
    }];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:true];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InnerChatCell *otherCell = [tableView dequeueReusableCellWithIdentifier:@"OtherInnerChatCell"];
    InnerChatCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"MyInnerChatCell"];
    Chat *chat = self.arrayOfMessagesForIndividualChat[indexPath.row];
    
    
    PFUser *author = chat[@"author"];
    PFUser *currUser = [PFUser currentUser];
    [author fetchIfNeeded];
    
    if ([author.username isEqualToString:currUser.username]) {
        myCell.privateChatMessage.text = chat.message;
        myCell.privateChatUsername.text = chat.author.username;
        myCell.privateChatProfilePicture.file = chat.author[@"profilePicture"];
        [myCell.privateChatProfilePicture loadInBackground];
        myCell.privateChatProfilePicture.layer.cornerRadius = myCell.privateChatProfilePicture.frame.size.height / 2;
        myCell.privateChatProfilePicture.layer.masksToBounds = YES;
        
        NSDate *createdAt = chat.createdAt;
        
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
        otherCell.privateChatMessage.text = chat.message;
        otherCell.privateChatUsername.text = chat.author.username;
        otherCell.privateChatProfilePicture.file = chat.author[@"profilePicture"];
        [otherCell.privateChatProfilePicture loadInBackground];
        otherCell.privateChatProfilePicture.layer.cornerRadius = otherCell.privateChatProfilePicture.frame.size.height / 2;
        otherCell.privateChatProfilePicture.layer.masksToBounds = YES;
        
        NSDate *createdAt = chat.createdAt;
        
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
    return self.arrayOfMessagesForIndividualChat.count;
}

- (IBAction)sendButtonPressed:(id)sender {
    self.conversationAlreadyExists = false;
    
    // posting the chat to the chat class
    PFObject *chat = [PFObject objectWithClassName:@"Chat"];
    PFUser *currUser = [PFUser currentUser];
    chat[@"author"] = currUser;
    chat[@"message"] = self.typingBar.text;
    chat[@"to"] = self.userPassed.username;
    
    [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Message Saved");
        } else {
            NSLog(@"Failed to save message");
        }
    }];
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Conversation"];
    [query1 whereKey:@"user1" equalTo:currUser.username];

    PFQuery *query2 = [PFQuery queryWithClassName:@"Conversation"];
    [query2 whereKey:@"user2" equalTo:currUser.username];

    PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1, query2]];
    [query includeKey:@"user1"];
    [query includeKey:@"user2"];
    [query includeKey:@"chats"];
    
    __block Boolean shouldCreateNewConversion = true;
    
    // updating the Conversation table by either creating a new row (when there is
    // no previous conversation between the two users) or updating the old conversation
    // row by adding this new chat
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      if (!error) {
          for (Conversation *conversation in objects) {
              // If there is already a conversation between the current user
              // and the passed in user, then we just add the chat to the
              // chats column of the already existing conversation
              if ([conversation.user1 isEqualToString:self.userPassed.username] ||
                  [conversation.user2 isEqualToString:self.userPassed.username]) {
                  [conversation addObject:chat forKey:@"chats"];
                  [conversation saveInBackground];
                  shouldCreateNewConversion = false;
                  break;
              }
          }
          
          // If there is no conversation between the current user and
          // the passed in user, then create a create a new Conversation
          // object and save it to the database
          if (shouldCreateNewConversion) {
              // Creating a new conversation object
              PFObject *conversation = [PFObject objectWithClassName:@"Conversation"];
              PFUser *currUser = [PFUser currentUser];
              conversation[@"user1"] = currUser.username;
              conversation[@"user2"] = self.userPassed.username;
              [conversation addUniqueObject:chat forKey:@"chats"];
              
              [conversation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                  if (succeeded) {
                      NSLog(@"Conversation Saved");
                  } else {
                      NSLog(@"Failed to save conversation");
                  }
              }];
          }
      }
    }];
    
    self.typingBar.text = nil;
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    OtherProfileViewController *otherProfileVC = [segue destinationViewController];
    otherProfileVC.userPassed = self.userPassed;
}

@end
