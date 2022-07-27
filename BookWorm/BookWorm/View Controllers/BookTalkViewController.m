//
//  BookTalkViewController.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/6/22.
//

#import "BookTalkViewController.h"
#import "ChatCell.h"
#import "IndividualChatViewController.h"
#import "Conversation.h"
#import "OuterChatCell.h"

@interface BookTalkViewController ()
@property (weak, nonatomic) IBOutlet UITableView *outerChatTableView;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (nonatomic, strong) NSMutableArray *usersWithConversations;
@property (nonatomic, strong) NSArray *arrayOfUsers;
@property (nonatomic, strong) NSMutableArray *namesOfUsersWithConversations;
@property (weak, nonatomic) IBOutlet UITextField *searchBar;
@property (nonatomic, strong) PFLiveQueryClient *liveQueryClient;
@property (nonatomic, strong) PFLiveQuerySubscription *subscription;
@end

@implementation BookTalkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.outerChatTableView.dataSource = self;
    
    self.searchTableView.dataSource = self;
    self.searchTableView.hidden = YES;
    
    self.arrayOfUsers = [[NSArray alloc] init];
    self.usersWithConversations = [[NSMutableArray alloc] init];
    self.namesOfUsersWithConversations = [[NSMutableArray alloc] init];
    
    PFUser *currUser = [PFUser currentUser];
    PFQuery *query1 = [PFQuery queryWithClassName:@"Conversation"];
    [query1 whereKey:@"user1" equalTo:currUser.username];

    PFQuery *query2 = [PFQuery queryWithClassName:@"Conversation"];
    [query2 whereKey:@"user2" equalTo:currUser.username];

    PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1, query2]];
    [query includeKey:@"user1"];
    [query includeKey:@"user2"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      if (!error) {
          for (Conversation *conversation in objects) {
              // creating an array of all the users that the current user has a
              // conversation with
              if ([conversation.user1 isEqualToString:currUser.username]) {
                  [self.namesOfUsersWithConversations addObject:conversation.user2];
              } else {
                  [self.namesOfUsersWithConversations addObject:conversation.user1];
              }
          }
          
          for (NSString *username in self.namesOfUsersWithConversations) {
              PFQuery *query = [PFQuery queryWithClassName:@"_User"];
              [query whereKey:@"username" equalTo:username];
              
              [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    [self.usersWithConversations addObject:objects[0]];
                }
              
                [self.outerChatTableView reloadData];
              }];
          }
      }
    }];
    
    // Do any additional setup after loading the view.
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:true];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.searchTableView) {
        ChatCell *cell = [self.searchTableView dequeueReusableCellWithIdentifier:@"outerChatCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        PFUser *user = self.arrayOfUsers[indexPath.row];
        cell.chatUsername.text = user[@"username"];
        cell.chatProfilePicture.file = user[@"profilePicture"];
        [cell.chatProfilePicture loadInBackground];
        cell.chatProfilePicture.layer.cornerRadius = cell.chatProfilePicture.frame.size.height / 2;
        cell.chatProfilePicture.layer.masksToBounds = YES;
        return cell;
    } else if (tableView == self.outerChatTableView) {
        // Case when the table view is the outer chat table view
        OuterChatCell *cell = [self.outerChatTableView dequeueReusableCellWithIdentifier:@"chatDetailsCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        PFUser *user = self.usersWithConversations[indexPath.row];
        cell.usernameLabel.text = user[@"username"];
        cell.profilePicture.file = user[@"profilePicture"];
        [cell.profilePicture loadInBackground];
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.height / 2;
        cell.profilePicture.layer.masksToBounds = YES;
        return cell;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.outerChatTableView) {
        return self.usersWithConversations.count;
    } else if (tableView == self.searchTableView) {
        return self.arrayOfUsers.count;
    }
    
    return 0;
}

- (IBAction)searchPressed:(id)sender {
    self.searchTableView.hidden = NO;
    
    NSString *searchString = self.searchBar.text;
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" containsString:searchString];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      if (!error) {
          self.arrayOfUsers = objects;
          [self.searchTableView reloadData];
      }
    }];
}

- (IBAction)exitSearch:(id)sender {
    self.searchTableView.hidden = YES;
    self.searchBar.text = nil;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"chatDetailsSegue"]) {
        PFUser *userToPass = self.usersWithConversations[[self.outerChatTableView indexPathForCell:sender].row];
        IndividualChatViewController *chatVC = [segue destinationViewController];
        chatVC.userPassed = userToPass;
    } else if ([[segue identifier] isEqualToString:@"searchChatDetailsSegue"]) {
        PFUser *userToPass = self.arrayOfUsers[[self.searchTableView indexPathForCell:sender].row];
        IndividualChatViewController *chatVC = [segue destinationViewController];
        chatVC.userPassed = userToPass;
    }
}

@end
