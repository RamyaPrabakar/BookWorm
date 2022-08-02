//
//  GroupConversation.h
//  BookWorm
//
//  Created by Ramya Prabakar on 8/2/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupConversation : PFObject<PFSubclassing>
@property (nonatomic, strong) NSArray *users; // All the users that are part of this group chat
@property (nonatomic, strong) NSArray *chats; // All the chats that are part of this group chat
@property (nonatomic, strong) NSString *groupName; // The name of the group chat
@end

NS_ASSUME_NONNULL_END
