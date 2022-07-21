//
//  Chat.h
//  BookWorm
//
//  Created by Ramya Prabakar on 7/21/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Chat : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *receiver;
@property (nonatomic, strong) PFUser *author;
@end

NS_ASSUME_NONNULL_END
