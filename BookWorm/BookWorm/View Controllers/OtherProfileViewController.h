//
//  OtherProfileViewController.h
//  BookWorm
//
//  Created by Ramya Prabakar on 7/19/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface OtherProfileViewController : UIViewController
@property (nonatomic, strong) PFUser *userPassed;
@end

NS_ASSUME_NONNULL_END
