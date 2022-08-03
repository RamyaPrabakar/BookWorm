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

@interface GroupChatViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *groupName;
@property (weak, nonatomic) IBOutlet UITableView *groupChatTableView;
@property (weak, nonatomic) IBOutlet UITextField *messageBar;

@end

@implementation GroupChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.groupName.title = self.groupNameString;
}

- (IBAction)pressedSend:(id)sender {
    __block NSString *objectId;
    
    // Creating a new conversation object
    PFObject *groupConversation = [PFObject objectWithClassName:@"GroupConversation"];
    PFUser *currUser = [PFUser currentUser];
    NSLog(@"Group name string: ");
    NSLog(@"%@", self.groupNameString);
    groupConversation[@"groupName"] = self.groupNameString;
    groupConversation[@"users"] = self.groupChatUsers;
    // [groupConversation saveInBackground];
    [groupConversation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
       if (succeeded) {
           objectId = groupConversation.objectId;
           
           // posting the chat to the group chat class
           PFObject *groupChat = [PFObject objectWithClassName:@"GroupChat"];
           // PFUser *currUser = [PFUser currentUser];
           groupChat[@"author"] = currUser;
           groupChat[@"message"] = self.messageBar.text;
           groupChat[@"groupConversationId"] = objectId;
           
           [groupChat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
               if (succeeded) {
                   NSLog(@"Group Chat Saved");
               } else {
                   NSLog(@"Failed to save group chat");
               }
           }];
           
           // Adding the chat to the conversation object
           PFQuery *query = [PFQuery queryWithClassName:@"GroupConversation"];
           [query whereKey:@"objectId" equalTo:objectId];
           
           [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
               if (!error) {
                   GroupConversation *groupConversation = objects[0];
                   [groupConversation addObject:groupChat forKey:@"chats"];
               }
           }];
           
           self.messageBar.text = nil;
       } else {
           NSLog(@"Failed to save group conversation");
       }
    }];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:true];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSArray *groupMembersToPass = self.groupChatUsers;
    GroupMembersViewController *groupMembersVC = [segue destinationViewController];
    groupMembersVC.groupMembersPassed = groupMembersToPass;
}

@end
