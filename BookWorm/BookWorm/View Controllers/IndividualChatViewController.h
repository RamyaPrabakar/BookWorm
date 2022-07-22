//
//  IndividualChatViewController.h
//  BookWorm
//
//  Created by Ramya Prabakar on 7/20/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "ParseLiveQuery-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface IndividualChatViewController : UIViewController <UITableViewDataSource>
@property (nonatomic, strong) PFUser *userPassed;
@end

NS_ASSUME_NONNULL_END
