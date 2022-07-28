//
//  RecommendationsDetailViewController.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/8/22.
//

#import "RecommendationsDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface RecommendationsDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bigBookImage;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@property (weak, nonatomic) IBOutlet UILabel *bookDescription;
@property (weak, nonatomic) IBOutlet UITextView *buyLink;
@end

@implementation RecommendationsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.author.text = self.bookPassed.author;
    self.bookTitle.text = self.bookPassed.title;
    self.bookDescription.text = self.bookPassed.bookDescription;
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Buy this book"
                                                                           attributes:@{ NSLinkAttributeName: [NSURL URLWithString:self.bookPassed.amazonProductURL] }];
    self.buyLink.attributedText = attributedString;
    
    NSURL *bookPosterURL = [NSURL URLWithString:self.bookPassed.bookImageLink];
    [self.bigBookImage setImageWithURL:bookPosterURL placeholderImage:nil];
}

@end
