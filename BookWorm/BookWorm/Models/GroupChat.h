//
//  GroupChat.h
//  BookWorm
//
//  Created by Ramya Prabakar on 8/2/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupChat : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *groupConversationId;
@property (nonatomic, strong) PFUser *author;
@end

NS_ASSUME_NONNULL_END
