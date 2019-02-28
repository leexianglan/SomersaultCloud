//
//  PetStationPriceView.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/29.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "PetStationPriceView.h"

@implementation PetStationPriceView


+(PetStationPriceView *)shareWithFrame:(CGRect)frame{
    PetStationPriceView *view = [[NSBundle mainBundle] loadNibNamed:@"PetStationPriceView" owner:nil options:nil].firstObject;
    view.frame = frame;
    view.baseView.layer.shadowColor = k_6_Color.CGColor;
    view.baseView.layer.shadowOffset = CGSizeMake(0, 3);
    view.baseView.layer.shadowOpacity = 0.18;
    view.baseView.layer.shadowRadius = 2;
    return view;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [[LXViewControllerManager shareManager] fixFontWithView:self];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
