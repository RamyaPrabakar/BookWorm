//
//  NewMessageViewController.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/29/22.
//

#import "NewMessageViewController.h"
#import "NewMessageUserCell.h"

@interface NewMessageViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchBar;
@property (weak, nonatomic) IBOutlet UITextView *userToAddBar;
@property (nonatomic, strong) NSArray *arrayOfUsers;
@property (nonatomic, strong) NSMutableArray *usersToAddToGroup;
@end

@implementation NewMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayOfUsers = [[NSArray alloc] init];
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // A little trick for removing the cell separators
    self.tableView.tableFooterView = [UIView new];
}

- (IBAction)searchPressed:(id)sender {
    NSString *searchString = self.searchBar.text;
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" containsString:searchString];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      if (!error) {
          self.arrayOfUsers = objects;
          [self.tableView reloadData];
          
      }
    }];
    
    NSLog(@"%@", self.arrayOfUsers);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewMessageUserCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"NewMessageUserCell"];
    PFUser *user = self.arrayOfUsers[indexPath.row];
    cell.username.text = user[@"username"];
    cell.profileImage.file = user[@"profilePicture"];
    [cell.profileImage loadInBackground];
    cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.height / 2;
    cell.profileImage.layer.masksToBounds = YES;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfUsers.count;
}

- (IBAction)clearSearch:(id)sender {
    self.searchBar.text = @"";
}

- (IBAction)userChosen:(id)sender {
    PFUser *currUser = self.arrayOfUsers[[self.tableView indexPathForCell:sender].row];
    NSString *oldText = self.userToAddBar.text;
    NSString *newText;
    NSLog(@"%@", currUser.username);
    if ([oldText length] == 0) {
        newText = currUser.username;
    } else {
        newText = [NSString stringWithFormat:@"%@%@%@", oldText, @", ", currUser.username];
    }
    
    self.userToAddBar.text = newText;
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

@end
