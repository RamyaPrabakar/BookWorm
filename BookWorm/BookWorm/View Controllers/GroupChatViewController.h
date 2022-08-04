//
//  GroupChatViewController.h
//  BookWorm
//
//  Created by Ramya Prabakar on 8/2/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "ParseLiveQuery-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupChatViewController : UIViewController
@property (nonatomic, strong) NSArray *groupChatUsers;
@property (nonatomic, strong) NSString *groupNameString;
@property (nonatomic, strong) NSString *groupChatId;
@end

NS_ASSUME_NONNULL_END
