//
//  MineServeBaseView.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/21.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "MineServeBaseView.h"

@implementation MineServeBaseView

+(MineServeBaseView *)shareWithFrame:(CGRect)frame{
    MineServeBaseView *view = [[NSBundle mainBundle] loadNibNamed:@"MineServeBaseView" owner:nil options:nil].firstObject;
    view.frame = frame;
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
