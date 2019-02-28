//
//  ConfirmOrderSelectCell.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/10/8.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "ConfirmOrderSelectCell.h"

@implementation ConfirmOrderSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnAction:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        if (self.block) {
            self.block(sender.tag);
        }
    }
}

-(void)resetSelf{
    [super resetSelf];
    self.btn.selected = NO;
    self.line.hidden = YES;
}

@end
