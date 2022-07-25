//
//  OuterChatCell.h
//  BookWorm
//
//  Created by Ramya Prabakar on 7/22/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OuterChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@end

NS_ASSUME_NONNULL_END
