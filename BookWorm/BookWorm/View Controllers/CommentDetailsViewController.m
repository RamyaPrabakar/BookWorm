//
//  CommentDetailsViewController.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/19/22.
//

#import "CommentDetailsViewController.h"
#import "PFImageView.h"
#import "OtherProfileViewController.h"

@interface CommentDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;

@end

@implementation CommentDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.usernameLabel.text = self.commentPassed[@"author"][@"username"];
    self.commentLabel.text = self.commentPassed.comment;
    self.profileImage.file = self.commentPassed[@"author"][@"profilePicture"];
    [self.profileImage loadInBackground];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2;
    self.profileImage.layer.masksToBounds = YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PFUser *userToPass = self.commentPassed[@"author"];
    OtherProfileViewController *otherProfileVC = [segue destinationViewController];
    otherProfileVC.userPassed = userToPass;
}

@end
