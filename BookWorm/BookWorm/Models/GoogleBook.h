//
//  GoogleBook.h
//  BookWorm
//
//  Created by Ramya Prabakar on 7/11/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoogleBook : PFObject<PFSubclassing>

@property (nonatomic, strong) NSArray *authors; // The author of the book
@property (nonatomic, strong) NSString *bookImageLink; // Link to the book image
@property (nonatomic, strong) NSString *bookDescription; // Desription of the book
@property (nonatomic, strong) NSString *buyLink; // Link to buy the book
@property (nonatomic, strong) NSString *title; // The title of the book
@property (nonatomic, strong) NSString *subtitle; // The subtitle of the book
@property (nonatomic, strong) NSString *publisher; // The publisher of the book
@property (nonatomic, strong) NSString *bookId; // Unique id that represents the book
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
