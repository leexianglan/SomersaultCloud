//
//  LXButtonWithRotaingImg.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/14.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXButtonWithRotaingImg.h"

@interface LXButtonWithRotaingImg()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgVX;

@end

@implementation LXButtonWithRotaingImg

+(instancetype)shareViewWithBtnTitle:(NSString *)title{
    LXButtonWithRotaingImg *view = [[[NSBundle mainBundle] loadNibNamed:@"LXButtonWithRotaingImg" owner:nil options:nil] lastObject];
    [view.btn setTitle:title forState:UIControlStateNormal];
    if (kDeviceWidth == 320) {
        view.btn.titleLabel.font = [UIFont systemFontOfSize:13*kEqualHeight];
    }
    CGFloat textWidth = [[LXViewControllerManager shareManager] getWidthWithContent:title font:15];
    view.imgVX.constant = 10+textWidth/2.f;
    [view updateConstraints];
    
    return view;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [[LXViewControllerManager shareManager] fixFontWithView:self];
}

-(void)rotatingBehindImage{
    static int imgRotating = 180;
    CGAffineTransform transform = CGAffineTransformMakeRotation(imgRotating*M_PI/180.0);
    [UIView animateWithDuration:.5 animations:^{
        [self.imgV setTransform:transform];
    }];
    imgRotating += 180;
}


- (IBAction)btnAction:(UIButton *)sender {
    if (self.block) {
        self.block(sender.tag);
    }
    [self rotatingBehindImage];
}


-(void)setFrame:(CGRect)frame{
    if (CGRectGetWidth(frame) != kDeviceWidth/3.f) {
        frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), kDeviceWidth/3.f, CGRectGetHeight(frame));
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

@end
