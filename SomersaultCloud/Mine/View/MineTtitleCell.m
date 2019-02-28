//
//  MineTtitleCell.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/21.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "MineTtitleCell.h"

@implementation MineTtitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)resetSelf{
    self.titleLbl.font = [UIFont systemFontOfSize:14*kEqualHeight];
    self.titleLbl.textColor = k_3_Color;
    self.detailLbl.textColor = k_3_Color;
    self.detailLbl.text = @"";
    self.signV.hidden = YES;
    self.line.hidden = YES;
}

@end
