//
//  LoginViewController.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/5/22.
//

#import "LoginViewController.h"
#import "RecommendationsViewController.h"
// Frameworks
#import <FBSDKCoreKit/FBSDKCoreKit.h>//
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize fbLoginButtonView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.delegate = self;
    loginButton.center = fbLoginButtonView.center;
    loginButton.permissions = @[@"public_profile", @"email"];
    [self.view addSubview:loginButton];
}

#pragma mark - FBSDKLoginButton Delegate Methods

- (void)loginButton :(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult * _Nullable)result error:(NSError * _Nullable)error {
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    if (result.isCancelled) {
        NSLog(@"User cancelled the login");
    } else if (result.declinedPermissions.count > 0) {
        NSLog(@"User has declined the permissions");
    } else {
        // User logged in successfully. Take user to next view
        RecommendationsViewController *recommendationsViewController = [[RecommendationsViewController alloc] initWithNibName:@"RecommendationsViewController" bundle:nil];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:recommendationsViewController];
        [self presentViewController:navController animated:YES completion:nil];
    }
}

- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    NSLog(@"User logged out");
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
