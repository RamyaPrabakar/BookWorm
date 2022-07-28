//
//  SearchViewController.h
//  BookWorm
//
//  Created by Ramya Prabakar on 7/8/22.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

NS_ASSUME_NONNULL_END
