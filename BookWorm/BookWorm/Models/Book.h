//
//  Book.h
//  BookWorm
//
//  Created by Ramya Prabakar on 7/8/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Book : NSObject

@property (nonatomic, strong) NSString *author; // The author of the book
@property (nonatomic, strong) NSString *bookImageLink; // Link to the book image
@property (nonatomic, strong) NSString *bookDescription; // Desription of the book
@property (nonatomic, strong) NSString *amazonProductURL; // Amazon product url
@property (nonatomic, strong) NSString *title; // The title of the book

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
