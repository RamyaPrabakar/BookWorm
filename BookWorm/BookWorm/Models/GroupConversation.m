//
//  GroupConversation.m
//  BookWorm
//
//  Created by Ramya Prabakar on 8/2/22.
//

#import "GroupConversation.h"

@implementation GroupConversation

@dynamic users;
@dynamic chats;
@dynamic groupName;

+ (nonnull NSString *)parseClassName {
    return @"GroupConversation";
}

@end
