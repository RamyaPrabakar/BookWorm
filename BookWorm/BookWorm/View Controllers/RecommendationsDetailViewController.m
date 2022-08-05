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

CGFloat lastScale;

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
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc]
        initWithTarget:self action:@selector(handlePinchGesture:)];
    pinchGestureRecognizer.delegate = self;
    [self.bigBookImage addGestureRecognizer:pinchGestureRecognizer];
}

// Pinch to zoom gesture
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)gestureRecognizer {

     if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
         // Reset the last scale, necessary if there are multiple objects with different scales.
         lastScale = [gestureRecognizer scale];
     }

     if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ||
         [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
         CGFloat currentScale = [[[gestureRecognizer view].layer valueForKeyPath:@"transform.scale"] floatValue];
         
         // Constants to adjust the max/min values of zoom.
         const CGFloat kMaxScale = 2.0;
         const CGFloat kMinScale = 1.0;
         
         // new scale is in the range (0-1)
         CGFloat newScale = 1 -  (lastScale - [gestureRecognizer scale]);
         newScale = MIN(newScale, kMaxScale / currentScale);
         newScale = MAX(newScale, kMinScale / currentScale);
         CGAffineTransform transform = CGAffineTransformScale([[gestureRecognizer view] transform], newScale, newScale);
         [gestureRecognizer view].transform = transform;
         
         // Store the previous. scale factor for the next pinch gesture call
         lastScale = [gestureRecognizer scale];
      }
}

@end
