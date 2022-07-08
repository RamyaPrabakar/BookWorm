//
//  Book.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/8/22.
//

#import "Book.h"

@implementation Book

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.author = dictionary[@"author"];
    self.bookImageLink = dictionary[@"book_image"];
    self.description = dictionary[@"description"];
    self.amazonProductURL = dictionary[@"amazon_product_url"];
    self.title = dictionary[@"title"];
    
    return self;
}

@end
