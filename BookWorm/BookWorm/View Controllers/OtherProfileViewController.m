//
//  OtherProfileViewController.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/19/22.
//

#import "OtherProfileViewController.h"
#import "PFImageView.h"

@interface OtherProfileViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;

@end

@implementation OtherProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.userPassed fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        self.usernameLabel.text = self.userPassed[@"username"];
        self.fullName.text = self.userPassed[@"fullName"];
        self.bioTextView.text = self.userPassed[@"bio"];
        self.profileImage.file = self.userPassed[@"profilePicture"];
        [self.profileImage loadInBackground];
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2;
        self.profileImage.layer.masksToBounds = YES;
    }];
}

@end
