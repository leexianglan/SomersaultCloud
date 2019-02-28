//
//  OrderCodeCell.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/10/9.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "OrderCodeCell.h"

@implementation OrderCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    FlatLineDash *line = [[FlatLineDash alloc] initWithFrame:CGRectMake(15, 15, kDeviceWidth-30, 0.5)];
    [self.lineView addSubview:line];
    self.btn.layer.borderColor = kRedColor.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)showBtn:(BOOL)show{
    self.btn.hidden = !show;
    self.hintLbl.hidden = show;
    self.statusLbl.text = show?@"扫码关注":@"请把二维码对准，扫码区域取票！";
}


@end
