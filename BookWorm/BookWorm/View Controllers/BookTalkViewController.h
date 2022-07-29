//
//  BookTalkViewController.h
//  BookWorm
//
//  Created by Ramya Prabakar on 7/6/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "PFImageView.h"
#import "UIScrollView+EmptyDataSet.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookTalkViewController : UIViewController <UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

NS_ASSUME_NONNULL_END
