//
//  PeaDetailCell.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/28.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "PeaDetailCell.h"

@implementation PeaDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)resetSelf{
    [super resetSelf];
    self.leftLbl.textColor = k_9_Color;
    self.leftLbl.font = [UIFont systemFontOfSize:12*kEqualHeight];
    self.rightLbl.textColor = k_9_Color;
    self.rightLbl.font = [UIFont systemFontOfSize:12*kEqualHeight];
    self.line.hidden = YES;
}

@end
