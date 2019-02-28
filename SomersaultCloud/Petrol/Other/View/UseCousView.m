//
//  UseCousView.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/10/10.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "UseCousView.h"


@implementation UseCousView

+(UseCousView *)share{
    UseCousView *view = [[NSBundle mainBundle] loadNibNamed:@"UseCousView" owner:nil options:nil].firstObject;
    [[LXViewControllerManager shareManager] fixFontWithView:view];
    return view;
}
- (IBAction)closeBtnAction:(id)sender {
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
