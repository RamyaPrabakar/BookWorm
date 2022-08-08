//
//  NewMessageViewController.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/29/22.
//

#import "NewMessageViewController.h"
#import "NewMessageUserCell.h"
#import "GroupChatViewController.h"

@interface NewMessageViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchBar;
@property (weak, nonatomic) IBOutlet UITextView *userToAddBar;
@property (nonatomic, strong) NSArray *arrayOfUsers;
@property (nonatomic, strong) NSMutableArray *usersToAddToGroup;
@property (weak, nonatomic) IBOutlet UITextField *groupNameTextField;
@property NSString* objectId;
@end

@implementation NewMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayOfUsers = [[NSArray alloc] init];
    self.usersToAddToGroup = [[NSMutableArray alloc] init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    PFUser *currUser = [PFUser currentUser];
    // A little trick for removing the cell separators
    self.tableView.tableFooterView = [UIView new];

    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" containsString:@""];
    [query whereKey:@"username" notEqualTo:currUser.username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      if (!error) {
          self.arrayOfUsers = objects;
          [self.tableView reloadData];
      }
    }];
    
    [self.usersToAddToGroup removeAllObjects];
    [self.usersToAddToGroup addObject:currUser.username];
}

// searching for Users of the app
- (IBAction)searchPressed:(id)sender {
    NSString *searchString = self.searchBar.text;
    PFUser *currUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" containsString:searchString];
    [query whereKey:@"username" notEqualTo:currUser.username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      if (!error) {
          self.arrayOfUsers = objects;
          [self.tableView reloadData];
          
      }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewMessageUserCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"NewMessageUserCell"];
    PFUser *user = self.arrayOfUsers[indexPath.row];
    cell.username.text = user[@"username"];
    cell.profileImage.file = user[@"profilePicture"];
    [cell.profileImage loadInBackground];
    cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.height / 2;
    cell.profileImage.layer.masksToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSRange range = [self.userToAddBar.text rangeOfString:user.username];
    NSArray *array = [self.userToAddBar.text componentsSeparatedByString:@" "];
    BOOL isTheObjectThere1 = [array containsObject: user.username];
    BOOL isTheObjectThere2 = [array containsObject: [NSString stringWithFormat:@"%@%@", user.username, @","]];
    if ([self.userToAddBar.text isEqualToString:user.username] || isTheObjectThere1 == YES || isTheObjectThere2 == YES) {
        cell.checkmark.hidden = NO;
    } else {
        cell.checkmark.hidden = YES;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfUsers.count;
}

 //selecting users to add to group
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFUser *currUser = self.arrayOfUsers[indexPath.row];
    NSString *oldText = self.userToAddBar.text;
    NSArray *array = [oldText componentsSeparatedByString:@" "];
    NSString *newText = @"";
    
    NewMessageUserCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.checkmark.hidden == YES) {
        cell.checkmark.hidden = NO;
        
        if ([oldText length] == 0) {
            newText = currUser.username;
        } else {
            newText = [NSString stringWithFormat:@"%@%@%@", oldText, @", ", currUser.username];
        }
        
        [self.usersToAddToGroup addObject:currUser.username];
    } else {
        cell.checkmark.hidden = YES;
        NSString *stringToRemove = [NSString stringWithFormat:@"%@%@", currUser.username, @","];
        
        for (int i = 0; i < [array count]; i++) {
            if ([array[i] isEqualToString:currUser.username] == NO && [array[i] isEqualToString:stringToRemove] == NO) {
                newText = [newText stringByAppendingString:[NSString stringWithFormat:@"%@%@", array[i], @" "]];
            }
        }
        
        [self.usersToAddToGroup removeObject:currUser.username];
    }
    
    NSString *trimmed = [newText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.userToAddBar.text = trimmed;
}

- (IBAction)clearSearch:(id)sender {
    self.searchBar.text = @"";
    PFUser *currUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" containsString:@""];
    [query whereKey:@"username" notEqualTo:currUser.username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      if (!error) {
          self.arrayOfUsers = objects;
          [self.tableView reloadData];
          
      }
    }];
}

// creating group chat with the selected users
- (IBAction)createGroupChat:(id)sender {
    if ([self.usersToAddToGroup count] == 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No users chosen"
                                    message:@"You can't create group chat with no members!"
                                     preferredStyle:(UIAlertControllerStyleAlert)];
       // create an OK action
       UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * _Nonnull action) {
                                    // handle response here.
                                  }];
        
       // add the OK action to the alert controller
       [alert addAction:okAction];
       
       [self presentViewController:alert animated:YES completion:^{
           // optional code for what happens after the alert controller has finished presenting
       }];
    } else if ([self.usersToAddToGroup count] == 2) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Only one user chosen"
                                    message:@"You can't create group chat with only one other member! Search their username on the previous page and private message them instead"
                                    preferredStyle:(UIAlertControllerStyleAlert)];
       // create an OK action
       UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * _Nonnull action) {
                                    // handle response here.
                                  }];
        
       // add the OK action to the alert controller
       [alert addAction:okAction];
       
       [self presentViewController:alert animated:YES completion:^{
           // optional code for what happens after the alert controller has finished presenting
       }];
    } else if ([self.groupNameTextField.text length] == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No group name"
                                    message:@"Add name for your groupchat!"
                                    preferredStyle:(UIAlertControllerStyleAlert)];
       // create an OK action
       UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * _Nonnull action) {
                                    // handle response here.
                                  }];
        
       // add the OK action to the alert controller
       [alert addAction:okAction];
       
       [self presentViewController:alert animated:YES completion:^{
           // optional code for what happens after the alert controller has finished presenting
       }];
    } else {
        // Creating a new conversation object
        PFObject *groupConversation = [PFObject objectWithClassName:@"GroupConversation"];
        groupConversation[@"groupName"] = self.groupNameTextField.text;
        groupConversation[@"users"] = self.usersToAddToGroup;
        
        [groupConversation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
           if (succeeded) {
               self.objectId = groupConversation.objectId;
               [self performSegueWithIdentifier:@"groupChatSegue" sender:nil];
           } else {
               NSLog(@"Failed to save group conversation");
           }
        }];
    }
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:true];
}

// Empty state methods
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"userTalk"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"No user searches yet";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"Search for users that you want to create a chat with!";
    
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

#pragma mark UIGestureRecognizerDelegate methods
    
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
  if (![touch.view isEqual: self.tableView] && [touch.view isDescendantOfView:self.tableView]) {
            
    // Don't let selections of auto-complete entries fire the
    // gesture recognizer
    return NO;
  }
        
  return YES;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"groupChatSegue"]) {
        NSArray *userToPass = self.usersToAddToGroup;
        NSString *groupNameToPass = self.groupNameTextField.text;
        GroupChatViewController *groupChatVC = [segue destinationViewController];
        groupChatVC.groupChatUsers = userToPass;
        groupChatVC.groupNameString = groupNameToPass;
        groupChatVC.groupChatId = self.objectId;
    }
}


@end
