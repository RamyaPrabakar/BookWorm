//
//  LoginViewController.h
//  BookWorm
//
//  Created by Ramya Prabakar on 7/5/22.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController<FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet UIView *fbLoginButtonView;

@end

NS_ASSUME_NONNULL_END
