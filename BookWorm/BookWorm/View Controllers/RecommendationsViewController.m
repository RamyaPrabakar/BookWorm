//
//  RecommendationsViewController.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/6/22.
//

#import "RecommendationsViewController.h"

// Frameworks
#import <FBSDKCoreKit/FBSDKProfile.h>
@interface RecommendationsViewController ()

@end

@implementation RecommendationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile * _Nullable profile, NSError * _Nullable error) {
            if (profile) {
                // get users profile name
                self.navigationItem.title = [NSString stringWithFormat:@"Hello %@ %@", profile.firstName, profile.lastName];
            }
        }];
    });
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