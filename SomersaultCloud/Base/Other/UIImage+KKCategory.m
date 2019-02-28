//
//  UIImage+KKCategory.m
//  EasyToWork
//
//  Created by GKK on 2017/11/30.
//  Copyright © 2017年 MM. All rights reserved.
//

#import "UIImage+KKCategory.h"
#import "UIImage+GIF.h"

@implementation UIImage (KKCategory)
+ (UIImage *)imageOriginalWithName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
+ (UIImage *)imageWithGifImageName:(NSString *)imageName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_animatedGIFWithData:data];
    return image;
}
+ (UIImage *)gradualImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0};
    UIColor * endColor = Color(255, 126, 84);
    UIColor * startColor = Color(237, 76, 51);
    NSArray *colors = @[(__bridge id) startColor.CGColor, (__bridge id) endColor.CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(0, size.height);
    CGPoint endPoint = CGPointMake(size.width, size.height);
    CGContextSaveGState(gc);
    CGContextClip(gc);
    CGContextDrawLinearGradient(gc, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(gc);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


+ (NSMutableArray *)gifImages:(NSString *)imageName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (!data) {
        return nil;
    }
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);

        size_t count = CGImageSourceGetCount(source);
        NSMutableArray *images = [NSMutableArray array];
        UIImage *animatedImage;
        if (count <= 1) {
           animatedImage = [[UIImage alloc] initWithData:data];
            [images addObject:animatedImage];
        } else {
            for (size_t i = 0; i < count; i++) {
                CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
                    if (!image) {
                              continue;
                    }
                [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
                    CGImageRelease(image);
            }
    }
    return images;
}



@end


