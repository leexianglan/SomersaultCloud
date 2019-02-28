//
//  UseCousView.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/10/10.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UseCousView : UIView

@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

+(UseCousView *)share;
@end

NS_ASSUME_NONNULL_END
