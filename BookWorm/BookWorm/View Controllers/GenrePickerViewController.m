//
//  GenrePickerViewController.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/6/22.
//

#import "GenrePickerViewController.h"
#import "BookWorm-Swift.h"

@interface GenrePickerViewController ()
@end

@implementation GenrePickerViewController

NSArray *data;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self confettiAnimation];
}


- (void)confettiAnimation {
    ConfettiAnimation *confettiAnimation = [[ConfettiAnimation alloc] init];
    [confettiAnimation playMatchAnimationForView:self.view];
}

@end
