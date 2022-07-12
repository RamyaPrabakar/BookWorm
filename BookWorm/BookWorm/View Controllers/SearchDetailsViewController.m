//
//  SearchDetailsViewController.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/12/22.
//

#import "SearchDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface SearchDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@property (weak, nonatomic) IBOutlet UILabel *bookSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *authors;
@property (weak, nonatomic) IBOutlet UILabel *bookDesciption;
@property (weak, nonatomic) IBOutlet UITextView *buyLink;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation SearchDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bookTitle.text = self.bookPassed.title;
    self.bookSubtitle.text = self.bookPassed.subtitle;
    self.bookDesciption.text = self.bookPassed.bookDescription;
    
    // NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Buy this book"
                                                                           // attributes:@{NSLinkAttributeName: [NSURL // URLWithString:self.bookPassed.buyLink]}];
    // self.buyLink.attributedText = attributedString;
    
    NSURL *bookPosterURL = [NSURL URLWithString:self.bookPassed.bookImageLink];
    [self.bookImage setImageWithURL:bookPosterURL placeholderImage:nil];
    
    NSString *authors = @"";
    int i;
    
    for (i = 0; i < [self.bookPassed.authors count] - 1; i++) {
        authors = [authors stringByAppendingFormat:@"%@%@", [self.bookPassed.authors objectAtIndex:i], @", "];
    }
    
    authors = [authors stringByAppendingFormat:@"%@", [self.bookPassed.authors objectAtIndex:i]];
    
    self.authors.text = authors;
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
