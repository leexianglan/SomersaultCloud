//
//  MineServeBaseView.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/21.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineServeBaseView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lbl;
@property (weak, nonatomic) IBOutlet UILabel *hintLbl;
@property (weak, nonatomic) IBOutlet UIImageView *feedBackV;
@property (weak, nonatomic) IBOutlet UIButton *btn;

+(MineServeBaseView *)shareWithFrame:(CGRect)frame;
@end
