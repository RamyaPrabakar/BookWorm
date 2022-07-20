//
//  IndividualChatViewController.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/20/22.
//

#import "IndividualChatViewController.h"
#import "InnerChatCell.h"

@interface IndividualChatViewController ()
@property (weak, nonatomic) IBOutlet UITableView *privateChatViewController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *usernameTop;
@end

@implementation IndividualChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.privateChatViewController.dataSource = self;
    self.usernameTop.title = self.userPassed[@"username"];
    // Do any additional setup after loading the view.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InnerChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"innerChatCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
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
