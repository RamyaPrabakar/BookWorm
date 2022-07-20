//
//  CommentCell.h
//  BookWorm
//
//  Created by Ramya Prabakar on 7/18/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;

@end

NS_ASSUME_NONNULL_END
