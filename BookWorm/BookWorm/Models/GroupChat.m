//
//  GroupChat.m
//  BookWorm
//
//  Created by Ramya Prabakar on 8/2/22.
//

#import "GroupChat.h"

@implementation GroupChat

@dynamic message;
@dynamic author;
@dynamic groupConversationId;

+ (nonnull NSString *)parseClassName {
    return @"GroupChat";
}

@end
