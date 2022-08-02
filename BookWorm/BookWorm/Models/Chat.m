//
//  Chat.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/21/22.
//

#import "Chat.h"

@implementation Chat

@dynamic message;
@dynamic author;
@dynamic to;

+ (nonnull NSString *)parseClassName {
    return @"Chat";
}

@end
