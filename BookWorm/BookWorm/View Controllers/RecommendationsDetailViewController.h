//
//  RecommendationsDetailViewController.h
//  BookWorm
//
//  Created by Ramya Prabakar on 7/8/22.
//

#import <UIKit/UIKit.h>
#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecommendationsDetailViewController : UIViewController <UIGestureRecognizerDelegate>
@property (nonatomic, strong) Book *bookPassed;
@end

NS_ASSUME_NONNULL_END
