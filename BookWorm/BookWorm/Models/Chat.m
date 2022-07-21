//
//  Chat.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/21/22.
//

#import "Chat.h"

@implementation Chat

@dynamic message;
@dynamic receiver;
@dynamic author;

+ (nonnull NSString *)parseClassName {
    return @"Chat";
}

@end
