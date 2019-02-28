//
//  MineServeCell.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/21.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "MineServeCell.h"

@implementation MineServeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CGRect rect = self.frame;
    self.frame = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), kDeviceWidth, CGRectGetHeight(rect));
   self.views[0] = [self reloadViewWithX:0];
   self.views[1] = [self reloadViewWithX:kDeviceWidth/4.f];
    self.views[2] = [self reloadViewWithX:kDeviceWidth/2.f];
    self.views[3] = [self reloadViewWithX:kDeviceWidth*3/4.f];
}

-(MineServeBaseView *)reloadViewWithX:(CGFloat)x{
    MineServeBaseView *v = [MineServeBaseView shareWithFrame:CGRectMake(x, 0, kDeviceWidth/4.f, CGRectGetHeight(self.frame))];
    [v.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:v];
    return v;
}

-(void)btnAction:(UIButton *)sender{
    if (self.block) {
        self.block(sender.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)resetSelf{
    for (MineServeBaseView *view in self.views) {
        view.hidden = YES;
    }
}
@end
