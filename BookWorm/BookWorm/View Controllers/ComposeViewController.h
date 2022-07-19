//
//  ComposeViewController.h
//  BookWorm
//
//  Created by Ramya Prabakar on 7/18/22.
//

#import <UIKit/UIKit.h>
#import "GoogleBook.h"
NS_ASSUME_NONNULL_BEGIN

@interface ComposeViewController : UIViewController
@property (nonatomic, strong) GoogleBook *bookPassed;
@end

NS_ASSUME_NONNULL_END
