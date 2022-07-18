//
//  Comment.h
//  BookWorm
//
//  Created by Ramya Prabakar on 7/18/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Comment : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) PFUser *author;
@end

NS_ASSUME_NONNULL_END
