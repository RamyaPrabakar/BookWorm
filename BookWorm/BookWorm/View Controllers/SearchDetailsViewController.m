//
//  SearchDetailsViewController.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/12/22.
//

#import "SearchDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Parse/Parse.h"
#import "ComposeViewController.h"

@interface SearchDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@property (weak, nonatomic) IBOutlet UILabel *bookSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *authors;
@property (weak, nonatomic) IBOutlet UILabel *bookDesciption;
@property (weak, nonatomic) IBOutlet UIButton *markThisBookButton;
@property (weak, nonatomic) IBOutlet UITableView *optionsTableView;
@property (weak, nonatomic) NSString *buttonString;
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;

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
    
    self.commentsTableView.delegate = self;
    self.commentsTableView.dataSource = self;
    self.commentsTableView.hidden = YES;
    
    PFUser *currUser = [PFUser currentUser];
    
    // Fetching books from the user's "reading" list
    for (GoogleBook * book in currUser[@"Reading"]) {
        [book fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (!error && [book.bookId isEqualToString:self.bookPassed.bookId]) {
                [self.markThisBookButton setTitle:@"Reading" forState:UIControlStateNormal];
                return;
            }
        }];
    }
    
    // Fetching books from the user's "read" list
    for (GoogleBook * book in currUser[@"Read"]) {
        [book fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (!error && [book.bookId isEqualToString:self.bookPassed.bookId]) {
                [self.markThisBookButton setTitle:@"Read" forState:UIControlStateNormal];
                return;
            }
        }];
    }
    
    // Fetching books from the user's "to read" list
    for (GoogleBook * book in currUser[@"ToRead"]) {
        [book fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (!error && [book.bookId isEqualToString:self.bookPassed.bookId]) {
                [self.markThisBookButton setTitle:@"To Read" forState:UIControlStateNormal];
                return;
            }
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (tableView == self.optionsTableView) {
        cell.textLabel.text = self.optionsData[indexPath.row];
    } else if (tableView == self.commentsTableView) {
        cell.textLabel.text = @"Commments will be here";
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return  cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.optionsTableView) {
        return [self.optionsData count];
    }
    
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.optionsTableView) {
        UITableViewCell *cell = [self.optionsTableView cellForRowAtIndexPath:indexPath];
        
        // getting the previous title of the button
        NSString *prevTitle = self.markThisBookButton.titleLabel.text;
        
        // setting the new title of the button
        [self.markThisBookButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
        self.optionsTableView.hidden = YES;
        
        NSString *currTitle = [self.markThisBookButton currentTitle];
        self.buttonString = currTitle;
        
        currTitle = [currTitle stringByReplacingOccurrencesOfString:@" " withString:@""];
        prevTitle = [prevTitle stringByReplacingOccurrencesOfString:@" " withString:@""];
            
        PFUser *currUser = [PFUser currentUser];
        
        // no change to be made
        if ([currTitle isEqualToString:prevTitle]) {
            return;
        } else if ([currTitle isEqualToString:@"Markthisbook"]) {
            // We are unmarking this book. This means we want to remove
            // the GoogleBook pointer for the previous array and delete
            // the book from the Google Book database
            [currUser removeObject:self.bookPassed forKey:prevTitle];
        } else if ([prevTitle isEqualToString:@"Markthisbook"]) {
            // We just add the object to the list we want to add it too
            [currUser addUniqueObject:self.bookPassed forKey:currTitle];
        } else {
            // changing from one list to another. Remove the book from one list.
            // Put the pointer to the same book in another list
            [currUser removeObject:self.bookPassed forKey:prevTitle];
            [currUser addUniqueObject:self.bookPassed forKey:currTitle];
        }
        
        [currUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // TODO: See if I can add a notification to tell the user that the change has been saved
            } else {
                // TODO: Notify the user that the change has not been saved
            }
        }];
    }
}

- (IBAction)markButtonPressed:(id)sender {
    if (self.optionsTableView.hidden == YES) {
        self.optionsTableView.hidden = NO;
    } else {
        self.optionsTableView.hidden = YES;
    }
}

- (IBAction)commentsButtonPressed:(id)sender {
    if (self.commentsTableView.hidden == YES) {
        self.commentsTableView.hidden = NO;
    } else {
        self.commentsTableView.hidden = YES;
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"composeSegue"]) {
        GoogleBook *bookToPass = self.bookPassed;
        ComposeViewController *composeVC = [segue destinationViewController];
        composeVC.bookPassed = bookToPass;
    }
}

@end
