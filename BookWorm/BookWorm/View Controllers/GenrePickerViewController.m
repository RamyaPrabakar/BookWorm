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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
