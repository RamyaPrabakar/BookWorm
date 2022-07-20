//
//  BookTalkViewController.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/6/22.
//

#import "BookTalkViewController.h"
#import "ChatCell.h"
#import "IndividualChatViewController.h"

@interface BookTalkViewController ()
@property (weak, nonatomic) IBOutlet UITableView *outerChatTableView;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (nonatomic, strong) NSArray *arrayOfUsers;
@property (weak, nonatomic) IBOutlet UITextField *searchBar;
@end

@implementation BookTalkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.outerChatTableView.dataSource = self;
    
    self.searchTableView.dataSource = self;
    
    self.arrayOfUsers = [[NSArray alloc] init];
    // Do any additional setup after loading the view.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatCell *cell = [self.searchTableView dequeueReusableCellWithIdentifier:@"outerChatCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tableView == self.searchTableView) {
        NSLog(@"cell for row at index path");
        PFUser *user = self.arrayOfUsers[indexPath.row];
        cell.chatUsername.text = user[@"username"];
        cell.chatProfilePicture.file = user[@"profilePicture"];
        [cell.chatProfilePicture loadInBackground];
        cell.chatProfilePicture.layer.cornerRadius = cell.chatProfilePicture.frame.size.height / 2;
        cell.chatProfilePicture.layer.masksToBounds = YES;
    } else if (tableView == self.outerChatTableView) {
        // Case when the table view is the outer chat table view
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"number of rows in section");
    if (tableView == self.outerChatTableView) {
        return 0;
    } else if (tableView == self.searchTableView) {
        return self.arrayOfUsers.count;
    }
    
    return 0;
}

- (IBAction)searchPressed:(id)sender {
    NSLog(@"search is pressed");
    self.searchTableView.hidden = NO;
    
    NSString *searchString = self.searchBar.text;
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" containsString:searchString];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      if (!error) {
          NSLog(@"No errors");
          self.arrayOfUsers = objects;
          NSLog(@"%lu", (unsigned long)objects.count);
          NSLog(@"%lu", (unsigned long)self.arrayOfUsers.count);
          [self.searchTableView reloadData];
      }
    }];
}

- (IBAction)exitSearch:(id)sender {
    NSLog(@"Exiting search");
    self.searchTableView.hidden = YES;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"personalChatSegue"]) {
        PFUser *userToPass = self.arrayOfUsers[[self.searchTableView indexPathForCell:sender].row];
        IndividualChatViewController *chatVC = [segue destinationViewController];
        chatVC.userPassed = userToPass;
    }
}

@end
