//
//  NewMessageUserCell.h
//  BookWorm
//
//  Created by Ramya Prabakar on 7/29/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewMessageUserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *checkmark;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) NSString *searchText;
// @property (nonatomic, copy) void(^selectButtonTapHandler)(void);
@end

NS_ASSUME_NONNULL_END
