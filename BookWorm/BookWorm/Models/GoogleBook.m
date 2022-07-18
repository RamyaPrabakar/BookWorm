//
//  GoogleBook.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/11/22.
//

#import "GoogleBook.h"

@implementation GoogleBook

@dynamic bookId;
@dynamic title;
@dynamic subtitle;
@dynamic publisher;
@dynamic buyLink;
@dynamic bookDescription;
@dynamic authors;
@dynamic bookImageLink;
@dynamic comments;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    self.bookId = dictionary[@"id"];
    self.title = dictionary[@"volumeInfo"][@"title"];
    self.subtitle = dictionary[@"volumeInfo"][@"subtitle"];
    self.publisher = dictionary[@"volumeInfo"][@"publisher"];
    self.buyLink = dictionary[@"volumeInfo"][@"buyLink"];
    self.bookDescription = dictionary[@"volumeInfo"][@"description"];
    self.authors = dictionary[@"volumeInfo"][@"authors"];
    self.bookImageLink = dictionary[@"volumeInfo"][@"imageLinks"][@"thumbnail"];
    return self;
}

+ (nonnull NSString *)parseClassName {
    return @"GoogleBook";
}

@end
