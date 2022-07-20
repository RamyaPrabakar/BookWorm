//
//  InnerChatCell.h
//  BookWorm
//
//  Created by Ramya Prabakar on 7/20/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface InnerChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *privateChatProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *privateChatUsername;
@property (weak, nonatomic) IBOutlet UILabel *privateChatMessage;

@end

NS_ASSUME_NONNULL_END
