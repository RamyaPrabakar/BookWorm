//
//  GoogleBook.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/11/22.
//

#import "GoogleBook.h"

@implementation GoogleBook

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.title = dictionary[@"title"];
    self.subtitle = dictionary[@"subtitle"];
    self.publisher = dictionary[@"publisher"];
    self.buyLink = dictionary[@"buyLink"];
    self.bookDescription = dictionary[@"description"];
    self.authors = dictionary[@"authors"];
    // self.bookImageLink = [dictionary[@"imageLinks"][@"thumbnail"] stringByAppendingString:@".png"];
    self.bookImageLink = dictionary[@"imageLinks"][@"thumbnail"];
    return self;
}

@end
