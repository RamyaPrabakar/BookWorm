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
    self.buyLink.text = self.bookPassed.amazonProductURL;
    
    NSURL *bookPosterURL = [NSURL URLWithString:self.bookPassed.bookImageLink];
    [self.bigBookImage setImageWithURL:bookPosterURL placeholderImage:nil];
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
