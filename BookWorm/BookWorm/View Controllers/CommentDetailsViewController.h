//
//  CommentDetailsViewController.h
//  BookWorm
//
//  Created by Ramya Prabakar on 7/19/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Comment.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentDetailsViewController : UIViewController
@property (nonatomic, strong) Comment *commentPassed;
@end

NS_ASSUME_NONNULL_END
