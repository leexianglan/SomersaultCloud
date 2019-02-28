//
//  CouponsCell.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/29.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "CouponsCell.h"

@interface CouponsCell()
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseViewW;


@end

@implementation CouponsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)resetSelf{
    self.outTimeImg.hidden = YES;
    self.useBtn.hidden = YES;
    self.usedImgView.hidden = YES;
}


/**
 @param type 0 可用 1 已使用 2 已过期
 */
-(void)canUseWithType:(int)type{
    [self resetSelf];
    if (type == 0) {
        self.baseImgView.image = [UIImage imageNamed:@"me_myquan_red"];
        self.couponsTypeLbl.backgroundColor = kRedColor;
        self.useBtn.hidden = NO;
        self.outTimeImg.hidden = NO;
    }else{
        self.baseImgView.image = [UIImage imageNamed:@"me_myquan"];
        self.couponsTypeLbl.backgroundColor = Color1(171);
        self.usedImgView.hidden = NO;
        if (type == 1) {
            self.usedImgView.image = [UIImage imageNamed:@"hadUsed"];
        }else if (type == 2){
            self.usedImgView.image = [UIImage imageNamed:@"hadExpired"];
        }
    }
}

- (IBAction)useBtnAction:(LXButton*)sender {
    if (self.block) {
        self.block(sender.lxTag, sender.tag);
    }
}




@end
