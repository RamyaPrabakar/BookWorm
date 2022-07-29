//
//  NewMessageUserCell.m
//  BookWorm
//
//  Created by Ramya Prabakar on 7/29/22.
//

#import "NewMessageUserCell.h"

@implementation NewMessageUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)checkButtonPressed:(id)sender {
    if (self.checkButton.selected) {
        [self.checkButton setImage:[UIImage imageNamed:@"circle.fill"] forState:UIControlStateNormal];
    } else {
        [self.checkButton setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    }
    
    self.checkButton.selected = !self.checkButton.selected;
}


@end
