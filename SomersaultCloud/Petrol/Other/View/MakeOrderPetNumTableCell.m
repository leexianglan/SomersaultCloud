//
//  MakeOrderPetNumTableCell.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/17.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "MakeOrderPetNumTableCell.h"

@implementation MakeOrderPetNumTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

-(void)resetSelf{
    [self unSelectBtns];
    [self hideBtns];
    self.line.hidden = YES;
}



-(void)unSelectBtns{
    for (LXButton *btn in self.btns) {
        btn.layer.borderColor = k_3_Color.CGColor;
        btn.backgroundColor = [UIColor clearColor];
        btn.selected = NO;
    }
}

-(void)hideBtns{
    for (LXButton *btn in self.btns) {
        btn.hidden = YES;
    }
}

- (IBAction)btnAction:(LXButton *)sender {
    if (!sender.selected) {
        [self unSelectBtns];
        sender.selected = YES;
        sender.layer.borderColor = [UIColor clearColor].CGColor;
        sender.backgroundColor = Color(255,87,66);
        if (self.block) {
            self.block(sender.lxTag, sender.tag);
        }
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
