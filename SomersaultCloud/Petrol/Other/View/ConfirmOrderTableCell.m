//
//  ConfirmOrderTableCell.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/10/8.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "ConfirmOrderTableCell.h"

@implementation ConfirmOrderTableCell

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
    self.titleLbl.textColor = k_3_Color;
    self.detailLbl.textColor = k_6_Color;
    self.titleLbl.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:14*kEqualHeight];
    self.detailLbl.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:14*kEqualHeight];
    self.baseView.hidden = YES;
    self.downImgView.hidden = YES;
}

@end
