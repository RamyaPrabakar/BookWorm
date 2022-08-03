//
//  GroupMembersViewController.m
//  BookWorm
//
//  Created by Ramya Prabakar on 8/3/22.
//

#import "GroupMembersViewController.h"

@interface GroupMembersViewController ()
@property (weak, nonatomic) IBOutlet UITableView *groupMembersTableView;
@end

@implementation GroupMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.groupMembersPassed);
    self.groupMembersTableView.dataSource = self;
    // A little trick for removing the cell separators
    self.groupMembersTableView.separatorColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = self.groupMembersPassed[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groupMembersPassed.count;
}



@end
