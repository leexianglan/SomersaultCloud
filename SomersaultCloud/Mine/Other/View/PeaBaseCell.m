//
//  PeaBaseCell.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/21.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "PeaBaseCell.h"

@implementation PeaBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(BeanItem *)item{
    self.titleLbl.text = item.lTitle;
    self.numLbl.text = item.beanNum;
    self.timeLbl.text = item.createTime;
}

@end
