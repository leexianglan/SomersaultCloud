//
//  EmptyView.m
// 
//
//  Created by 李相兰 on 2018/4/18.
//  Copyright © 2018年 . All rights reserved.
//

#import "EmptyView.h"

@implementation EmptyView

+(instancetype)shareView{
    EmptyView *view = [[[NSBundle mainBundle] loadNibNamed:@"EmptyView" owner:nil options:nil] lastObject];
    view.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    view.tag = 418;
    [[LXViewControllerManager shareManager] fixFontWithView:view.lbl];
    return view;
}

-(void)setFrame:(CGRect)frame{
    if (CGRectGetWidth(frame) > kDeviceWidth) {
        frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), kDeviceWidth, CGRectGetHeight(frame));
    }
    [super setFrame:frame];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


// 
@end

// 
