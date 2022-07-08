//
//  GenrePickerViewController.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/6/22.
//

#import "GenrePickerViewController.h"

@interface GenrePickerViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation GenrePickerViewController

NSArray *data;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    data = @[@"Fiction", @"Nonfiction", @"Advice, How-To & Miscellaneous", @"Young Adult", @"Children's Series", @"Children's Picture Books", @"Children's Middle Grade"];
    self.tableView.dataSource = self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = data[indexPath.row];
    return  cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return data.count;
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
