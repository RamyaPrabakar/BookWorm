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

@interface IndividualChatViewController ()
@property (weak, nonatomic) IBOutlet UITableView *privateChatTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *usernameTop;
@property (nonatomic, strong) NSArray *arrayOfMessagesForIndividualChat;
@property (nonatomic, strong) NSArray *totalArrayOfChatsForThisUser;
@property (nonatomic) bool conversationAlreadyExists;
@property (weak, nonatomic) IBOutlet UITextField *typingBar;
@end

@implementation IndividualChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.privateChatTableView.dataSource = self;
    self.usernameTop.title = self.userPassed[@"username"];
    self.arrayOfMessagesForIndividualChat = [[NSArray alloc] init];
    // Do any additional setup after loading the view.
    
    PFUser *currUser = [PFUser currentUser];
    PFQuery *query1 = [PFQuery queryWithClassName:@"Conversation"];
    [query1 whereKey:@"user1" equalTo:currUser.username];

    PFQuery *query2 = [PFQuery queryWithClassName:@"Conversation"];
    [query2 whereKey:@"user2" equalTo:currUser.username];

    PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1, query2]];
    [query includeKey:@"user1"];
    [query includeKey:@"user2"];
    [query includeKey:@"chats"];
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
          
          NSLog(@"%@", self.arrayOfMessagesForIndividualChat);
          [self.privateChatTableView reloadData];
      }
    }];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InnerChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"innerChatCell"];
    
    Chat *chat = self.arrayOfMessagesForIndividualChat[indexPath.row];
    cell.privateChatMessage.text = chat.message;
    
    PFUser *author = chat[@"author"];
    
    [author fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        cell.privateChatUsername.text = chat.author.username;
        cell.privateChatProfilePicture.file = chat.author[@"profilePicture"];
        [cell.privateChatProfilePicture loadInBackground];
        cell.privateChatProfilePicture.layer.cornerRadius = cell.privateChatProfilePicture.frame.size.height / 2;
        cell.privateChatProfilePicture.layer.masksToBounds = YES;
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
    
    __block int flag = 0;
    
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
                  flag = -1;
                  break;
              }
          }
          
          // If there is no conversation between the cu      rrent user and
          // the passed in user, then create a create a new Conversation
          // object and save it to the database
          if (flag == 0) {
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
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
