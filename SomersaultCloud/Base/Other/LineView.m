//
//  LineView.m
// 
//
//  Created by 李相兰 on 2018/4/9.
//  Copyright © 2018年  All rights reserved.
//

#import "LineView.h"

@implementation LineView

-(void)drawRect:(CGRect)rect{

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx,  Color1(220).CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0.f, self.bounds.size.width, 0.5f));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end

@implementation FlatLineDash


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    const CGFloat *components = CGColorGetComponents(Color1(220).CGColor);
    
    CGContextSetRGBStrokeColor(ctx,components[0], components[1], components[2], 1);//线条颜色
    
    CGFloat dashArray1[] = {5, 5};
    
    CGContextSetLineDash(ctx, 0, dashArray1, 2);//画虚线,可参考http://blog.csdn.net/zhangao0086/article/details/7234859
    
    CGContextMoveToPoint(ctx, 0, 0);//开始画线, x，y 为开始点的坐标
    
    CGContextAddLineToPoint(ctx, self.bounds.size.width, 0.5f);//画直线, x，y 为线条结束点的坐标
    
    CGContextStrokePath(ctx);//开始画线
    
}

@end


