//
//  ChatCell.h
//  BookWorm
//
//  Created by Ramya Prabakar on 7/20/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *chatProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *chatUsername;

@end

NS_ASSUME_NONNULL_END
