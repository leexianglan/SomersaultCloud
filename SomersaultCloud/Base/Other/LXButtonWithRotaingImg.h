//
//  LXButtonWithRotaingImg.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/14.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LXButtonWithRotaingImgBlock)(NSInteger tag);
@interface LXButtonWithRotaingImg : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property(nonatomic, copy)LXButtonWithRotaingImgBlock block;

+(instancetype)shareViewWithBtnTitle:(NSString *)title;
-(void)rotatingBehindImage;

@end
