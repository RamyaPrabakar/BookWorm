//
//  SearchDetailsViewController.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/12/22.
//

#import "SearchDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Parse/Parse.h"

@interface SearchDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@property (weak, nonatomic) IBOutlet UILabel *bookSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *authors;
@property (weak, nonatomic) IBOutlet UILabel *bookDesciption;
@property (weak, nonatomic) IBOutlet UIButton *markThisBookButton;
@property (weak, nonatomic) IBOutlet UITableView *optionsTableView;

@end
@implementation SearchDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.bookTitle.text = self.bookPassed.title;
    self.bookSubtitle.text = self.bookPassed.subtitle;
    self.bookDesciption.text = self.bookPassed.bookDescription;
    
    NSURL *bookPosterURL = [NSURL URLWithString:self.bookPassed.bookImageLink];
    [self.bookImage setImageWithURL:bookPosterURL placeholderImage:nil];
    
    NSString *authors = @"";
    int i;
    
    for (i = 0; i < [self.bookPassed.authors count] - 1; i++) {
        authors = [authors stringByAppendingFormat:@"%@%@", [self.bookPassed.authors objectAtIndex:i], @", "];
    }
    
    authors = [authors stringByAppendingFormat:@"%@", [self.bookPassed.authors objectAtIndex:i]];
    
    self.authors.text = authors;
    
    self.optionsData = [[NSArray alloc] initWithObjects:@"To Read", @"Reading", @"Read", @"Mark this book", nil];
    self.optionsTableView.delegate = self;
    self.optionsTableView.dataSource = self;
    self.optionsTableView.hidden = YES;
    
    PFUser *currUser = [PFUser currentUser];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = self.optionsData[indexPath.row];
    return  cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.optionsData count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.optionsTableView cellForRowAtIndexPath:indexPath];
    [self.markThisBookButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
    self.optionsTableView.hidden = YES;
    
    
     PFUser *currUser = [PFUser currentUser];
    
    if ([[self.markThisBookButton currentTitle] isEqualToString:@"To Read"]) {
        currUser[@"toRead"] = @YES;
    } else if ([[self.markThisBookButton currentTitle] isEqualToString:@"Read"]) {
        currUser[@"read"] = @YES;
    } else if ([[self.markThisBookButton currentTitle] isEqualToString:@"Reading"]) {
        currUser[@"reading"] = @YES;
    } else {
        currUser[@"read"] = @NO;
        currUser[@"toRead"] = @NO;
        currUser[@"reading"] = @NO;
    }
    
    [currUser saveInBackground];
}

- (IBAction)markButtonPressed:(id)sender {
    if (self.optionsTableView.hidden == YES) {
        self.optionsTableView.hidden = NO;
    } else {
        self.optionsTableView.hidden = YES;
    }
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
