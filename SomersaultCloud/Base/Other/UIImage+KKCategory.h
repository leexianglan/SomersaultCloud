//
//  UIImage+KKCategory.h
//  EasyToWork
//
//  Created by GKK on 2017/11/30.
//  Copyright © 2017年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (KKCategory)
+ (UIImage *)imageOriginalWithName:(NSString *)imageName;
+ (UIImage *)gradualImageWithSize:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithGifImageName:(NSString *)imageName;
+ (NSMutableArray *)gifImages:(NSString *)imageName;


@end


