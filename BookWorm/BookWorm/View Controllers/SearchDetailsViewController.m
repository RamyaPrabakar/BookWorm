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
@property (weak, nonatomic) NSString *buttonString;

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
    
    for (GoogleBook * obj in currUser[@"Reading"]) {
        [obj fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (!error) {
                if ([obj.bookId isEqualToString:self.bookPassed.bookId]) {
                    [self.markThisBookButton setTitle:@"Reading" forState:UIControlStateNormal];
                    return;
                }
            }
        }];
    }
    
    for (GoogleBook * obj in currUser[@"Read"]) {
        [obj fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (!error) {
                if ([obj.bookId isEqualToString:self.bookPassed.bookId]) {
                    [self.markThisBookButton setTitle:@"Read" forState:UIControlStateNormal];
                    return;
                }
            }
        }];
    }
    
    for (GoogleBook * obj in currUser[@"ToRead"]) {
        [obj fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (!error) {
                if ([obj.bookId isEqualToString:self.bookPassed.bookId]) {
                    [self.markThisBookButton setTitle:@"To Read" forState:UIControlStateNormal];
                    return;
                }
            }
        }];
    }
    
    /* PFQuery *query = [PFQuery queryWithClassName:@"GoogleBooks"];
    [query whereKey:@"objectId" containedIn:readingUserObjectIds];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSLog(@"%@", objects);
        readingArray = [[NSArray alloc] initWithArray:objects];
    }];
    
    NSLog(@"I came here");
    NSLog(@"%@", readingArray);*/
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
    
    // getting the previous title of the button
    NSString *prevTitle = self.markThisBookButton.titleLabel.text;
    // NSLog(@"prev title");
    // NSLog(@"%@", prevTitle);
    // setting the new title of the button
    [self.markThisBookButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
    // NSLog(@"I got here");
    self.optionsTableView.hidden = YES;
    
    NSString *currTitle = [self.markThisBookButton currentTitle];
    self.buttonString = currTitle;
    // NSLog(@"current title");
    // NSLog(@"%@", currTitle);
    
    currTitle = [currTitle stringByReplacingOccurrencesOfString:@" " withString:@""];
    prevTitle = [prevTitle stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // NSLog(@"prev title");
    // NSLog(@"%@", prevTitle);
    
    // NSLog(@"current title");
    // NSLog(@"%@", currTitle);
    
    
    PFUser *currUser = [PFUser currentUser];
    
    if ([currTitle isEqualToString:prevTitle]) {
        return;
    } else if ([currTitle isEqualToString:@"Markthisbook"]) {
        [currUser removeObject:self.bookPassed forKey:prevTitle];
    } else if ([prevTitle isEqualToString:@"Markthisbook"]) {
        [currUser addObject:self.bookPassed forKey:currTitle];
    } else {
        [currUser removeObject:self.bookPassed forKey:prevTitle];
        [currUser saveInBackground];
        [currUser addObject:self.bookPassed forKey:currTitle];
    }
    
    [currUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Saved!");
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];
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
