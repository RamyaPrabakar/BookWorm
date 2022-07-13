//
//  SearchDetailsViewController.h
//  BookWorm
//
//  Created by Ramya Prabakar on 7/12/22.
//

#import <UIKit/UIKit.h>
#import "GoogleBook.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) GoogleBook *bookPassed;
@property (nonatomic, strong) NSArray *optionsData;
@end

NS_ASSUME_NONNULL_END
