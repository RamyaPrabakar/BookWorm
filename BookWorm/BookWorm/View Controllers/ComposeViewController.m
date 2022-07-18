//
//  ComposeViewController.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/18/22.
//

#import "ComposeViewController.h"
#import "Parse/Parse.h"

@class GoogleBook;
@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *commentSpace;
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@property (weak, nonatomic) IBOutlet UILabel *characterCount;
@property (weak, nonatomic) IBOutlet UILabel *commentSaved;
@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self.commentSpace layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.commentSpace layer] setBorderWidth:2.3];
    [[self.commentSpace layer] setCornerRadius:15];
    
    NSLog(@"Book Passed");
    NSLog(@"%@", self.bookPassed);
}

- (void)textViewDidChange:(UITextView *)textView {
    self.commentSaved.text = @"";
    NSString *substring = [NSString stringWithString:textView.text];
    
    if (substring.length > 0) {
        self.characterCount.hidden = NO;
        self.characterCount.text = [NSString stringWithFormat:@"%lu", substring.length];
    }
    
    if (substring.length == 0) {
        self.characterCount.hidden = YES;
    }
    
    if (substring.length > 200) {
        self.alertLabel.text = @"Character count (200) exceeded";
        [[self.navigationItem.rightBarButtonItems objectAtIndex:0] setEnabled:NO];
    } else {
        self.alertLabel.text = nil;
        [[self.navigationItem.rightBarButtonItems objectAtIndex:0] setEnabled:YES];
    }
}

- (IBAction)compose:(id)sender {
    NSLog(@"Umm hello???");
    PFObject *comment = [PFObject objectWithClassName:@"Comment"];
    PFUser *currUser = [PFUser currentUser];
    comment[@"author"] = currUser;
    comment[@"comment"] = self.commentSpace.text;
    
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            self.commentSaved.text = @"Comment saved";
        } else {
            self.commentSaved.text = @"Error saving comment";
        }
    }];
    
    PFQuery *query = [PFQuery queryWithClassName:@"GoogleBook"];
    NSLog(@"I got here");
    NSLog(@"%@", self.bookPassed.bookId);
    [query whereKey:@"bookId" equalTo:self.bookPassed.bookId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      if (!error) {
        // The find succeeded.
          NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
          
          // Case when there is no Google book with the current bookId
          // in the database
          if ([objects count] == 0) {
              GoogleBook *newBook = [GoogleBook new];
              newBook.bookId = self.bookPassed.bookId;
              newBook.title = self.bookPassed.title;
              newBook.subtitle = self.bookPassed.subtitle;
              newBook.publisher = self.bookPassed.publisher;
              newBook.buyLink = self.bookPassed.buyLink;
              newBook.bookDescription = self.bookPassed.bookDescription;
              newBook.authors = self.bookPassed.authors;
              newBook.bookImageLink = self.bookPassed.bookImageLink;
              [newBook addObject:comment forKey:@"comments"];
              [newBook saveInBackground];
          } else {
              GoogleBook *book = objects[0];
              [book addObject:comment forKey:@"comments"];
              [book saveInBackground];
          }
      } else {
        // Log details of the failure
        NSLog(@"Error: %@ %@", error, [error userInfo]);
      }
    }];
    
    /* GoogleBook *book = (GoogleBook*)self.bookPassed;
    [book addUniqueObject:comment forKey:@"comments"];
    
    [book saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // TODO: See if I can add a notification to tell the user that the comment has been saved
        } else {
            // TODO: Notify the user that the comment has not been saved
        }
    }];*/
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
