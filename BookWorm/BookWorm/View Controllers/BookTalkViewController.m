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
#import "GroupConversation.h"
#import "GroupChatViewController.h"
#import "MarkingCell.h"

@interface BookTalkViewController ()
@property (weak, nonatomic) IBOutlet UITableView *outerChatTableView;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (nonatomic, strong) NSMutableArray *conversations;
@property (nonatomic, strong) NSMutableArray *groupConversations;
@property (nonatomic, strong) NSMutableArray *groupConversationUsers;
@property (nonatomic, strong) NSMutableArray *groupIds;
@property (nonatomic, strong) NSArray *arrayOfUsers;
@property (nonatomic, strong) NSMutableArray *namesOfUsersWithConversations;
@property (weak, nonatomic) IBOutlet UITextField *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *groupChatTableView;
@property (nonatomic, strong) PFLiveQueryClient *liveQueryClient;
@property (nonatomic, strong) PFLiveQuerySubscription *subscription;
@property NSInteger lastClickedRow;
@end

@implementation BookTalkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.outerChatTableView.dataSource = self;
    self.searchTableView.dataSource = self;
    self.groupChatTableView.dataSource = self;
    self.groupChatTableView.delegate = self;
    
    self.arrayOfUsers = [[NSArray alloc] init];
    self.conversations = [[NSMutableArray alloc] init];
    self.namesOfUsersWithConversations = [[NSMutableArray alloc] init];
    self.groupConversations = [[NSMutableArray alloc] init];
    self.groupConversationUsers = [[NSMutableArray alloc] init];
    self.groupIds = [[NSMutableArray alloc] init];
    
    self.outerChatTableView.emptyDataSetSource = self;
    self.outerChatTableView.emptyDataSetDelegate = self;
    self.groupChatTableView.emptyDataSetSource = self;
    self.groupChatTableView.emptyDataSetDelegate = self;
    
    // A little trick for removing the cell separators
    self.outerChatTableView.tableFooterView = [UIView new];
    self.groupChatTableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated {
    self.searchTableView.hidden = YES;
    [self.namesOfUsersWithConversations removeAllObjects];
    [self.conversations removeAllObjects];
    [self.groupConversations removeAllObjects];
    [self.groupConversationUsers removeAllObjects];
    [self.groupIds removeAllObjects];
    
    // fetching from parse every time the view appears
    [self fetchFromParse];
    [self.outerChatTableView reloadData];
    [self.groupChatTableView reloadData];
}

- (void)fetchFromParse {
    // Fetching all the private conversations that the user is part of
    PFUser *currUser = [PFUser currentUser];
    PFQuery *query1 = [PFQuery queryWithClassName:@"Conversation"];
    [query1 whereKey:@"user1" equalTo:currUser.username];

    PFQuery *query2 = [PFQuery queryWithClassName:@"Conversation"];
    [query2 whereKey:@"user2" equalTo:currUser.username];

    PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1, query2]];
    [query includeKey:@"user1"];
    [query includeKey:@"user2"];
    [query orderByDescending:@"createdAt"];
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
                    // Finding all the PFUsers the current user has conversations with
                    [self.conversations addObject:objects[0]];
                }
              
                [self.outerChatTableView reloadData];
              }];
          }
      }
    }];
    
    // fetching all the group conversations that the user is part of
    PFQuery *groupQuery = [PFQuery queryWithClassName:@"GroupConversation"];
    [groupQuery whereKey:@"users" containsAllObjectsInArray:@[currUser.username]];
    
    [groupQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      if (!error) {
          for (GroupConversation *grpConversation in objects) {
              // fetching all the group conversations the user is a part of
              [self.groupConversations addObject:grpConversation.groupName];
              
              // fetching the users in each of these group conversations
              [self.groupConversationUsers addObject:grpConversation.users];
              
              // fetching the objectId of each of these group conversations
              [self.groupIds addObject:grpConversation.objectId];
          }
          
          [self.groupChatTableView reloadData];
      }
    }];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:true];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.groupChatTableView) {
        self.lastClickedRow = indexPath.row;
        [self performSegueWithIdentifier:@"outerScreenToGroupChatSegue" sender:nil];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.searchTableView) {
        ChatCell *cell = [self.searchTableView dequeueReusableCellWithIdentifier:@"outerChatCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.arrayOfUsers.count == 0) {
            UITableViewCell *noUsersCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            noUsersCell.textLabel.text = @"No user for that search";
            noUsersCell.selectionStyle = UITableViewCellSelectionStyleNone;
            noUsersCell.backgroundColor = [UIColor systemGreenColor];
            return noUsersCell;
        }
        
        PFUser *user = self.arrayOfUsers[indexPath.row];
        cell.chatUsername.text = user[@"username"];
        cell.chatProfilePicture.file = user[@"profilePicture"];
        [cell.chatProfilePicture loadInBackground];
        cell.chatProfilePicture.layer.cornerRadius = cell.chatProfilePicture.frame.size.height / 2;
        cell.chatProfilePicture.layer.masksToBounds = YES;
        cell.backgroundColor = [UIColor systemGreenColor];
        return cell;
    } else if (tableView == self.outerChatTableView) {
        // Case when the table view is the outer chat table view
        OuterChatCell *cell = [self.outerChatTableView dequeueReusableCellWithIdentifier:@"chatDetailsCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        PFUser *user = self.conversations[indexPath.row];
        cell.usernameLabel.text = user[@"username"];
        cell.profilePicture.file = user[@"profilePicture"];
        [cell.profilePicture loadInBackground];
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.height / 2;
        cell.profilePicture.layer.masksToBounds = YES;
        return cell;
    } else if (tableView == self.groupChatTableView) {
        MarkingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MarkingCell"];
        cell.bookTitle.text = self.groupConversations[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.outerChatTableView) {
        return self.conversations.count;
    } else if (tableView == self.searchTableView) {
        if (self.arrayOfUsers.count == 0) {
            return 1;
        }
        return self.arrayOfUsers.count;
    } else if (tableView == self.groupChatTableView) {
        return self.groupConversations.count;
        
    }
    
    return 0;
}

// Delegate method of table view to swipe and delete chats
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.outerChatTableView) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            PFUser *otherUser = self.conversations[indexPath.row];
            PFUser *currUser = [PFUser currentUser];
            [self.conversations removeObjectAtIndex:indexPath.row];
            [self.outerChatTableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            PFQuery *query1 = [PFQuery queryWithClassName:@"Conversation"];
            [query1 whereKey:@"user1" equalTo:currUser.username];
            [query1 whereKey:@"user2" equalTo:otherUser.username];
            
            PFQuery *query2 = [PFQuery queryWithClassName:@"Conversation"];
            [query2 whereKey:@"user2" equalTo:currUser.username];
            [query2 whereKey:@"user1" equalTo:otherUser.username];
            
            PFQuery *query = [PFQuery orQueryWithSubqueries:@[query1, query2]];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
              if (!error) {
                  for (Conversation *conversation in objects) {
                      [conversation deleteInBackground];
                  }
              }
            }];
        }
    } else if (tableView == self.groupChatTableView) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            NSString *groupIdToDelete = self.groupIds[indexPath.row];
            [self.groupConversations removeObjectAtIndex:indexPath.row];
            [self.groupConversationUsers removeObjectAtIndex:indexPath.row];
            [self.groupIds removeObjectAtIndex:indexPath.row];
            [self.groupChatTableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            PFQuery *query = [PFQuery queryWithClassName:@"GroupConversation"];
            [query whereKey:@"objectId" equalTo:groupIdToDelete];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
              if (!error) {
                  for (GroupConversation *groupConversation in objects) {
                      [groupConversation deleteInBackground];
                  }
              }
            }];
        }
    }
}

// making the searchTableView uneditable (can't swipe to delete)
- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchTableView) {
        return NO;
    } else {
        return YES;
    }
}

// Searches for users with the search string from the search bar
- (IBAction)searchPressed:(id)sender {
    self.searchTableView.hidden = NO;
    
    NSString *searchString = self.searchBar.text;
    PFUser *currUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" containsString:searchString];
    [query whereKey:@"username" notEqualTo:currUser.username];
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

// Empty state methods
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_placeholder"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"No chats yet";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"Search for users or make group chats with people you want to chat with!";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
                                 
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL) emptyDataSetShouldAllowImageViewAnimate:(UIScrollView *)scrollView {
    return YES;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"chatDetailsSegue"]) {
        PFUser *userToPass = self.conversations[[self.outerChatTableView indexPathForCell:sender].row];
        IndividualChatViewController *chatVC = [segue destinationViewController];
        chatVC.userPassed = userToPass;
    } else if ([[segue identifier] isEqualToString:@"searchChatDetailsSegue"]) {
        PFUser *userToPass = self.arrayOfUsers[[self.searchTableView indexPathForCell:sender].row];
        IndividualChatViewController *chatVC = [segue destinationViewController];
        chatVC.userPassed = userToPass;
    } else if ([[segue identifier] isEqualToString:@"outerScreenToGroupChatSegue"]) {
        NSString *groupNameToPass = self.groupConversations[self.lastClickedRow];
        NSArray *groupChatUsersToPass = self.groupConversationUsers[self.lastClickedRow];
        NSString *groupIdToPass = self.groupIds[self.lastClickedRow];
        GroupChatViewController *groupChatVC = [segue destinationViewController];
        groupChatVC.groupNameString = groupNameToPass;
        groupChatVC.groupChatUsers = groupChatUsersToPass;
        groupChatVC.groupChatId = groupIdToPass;
    }
}

@end
