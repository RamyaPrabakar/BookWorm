//
//  Conversation.h
//  BookWorm
//
//  Created by Ramya Prabakar on 7/21/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Conversation : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *user1; // the first user in this conversation
@property (nonatomic, strong) NSString *user2; // the second user in this conversation
@property (nonatomic, strong) NSArray *chats; // the array of chats that are a part of this coversation
@end

NS_ASSUME_NONNULL_END
