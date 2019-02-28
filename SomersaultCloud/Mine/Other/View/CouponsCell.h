//
//  CouponsCell.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/29.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXTableCell.h"


typedef void(^CouponsCellBlock)(NSInteger lxTag,NSInteger tag);
@interface CouponsCell : LXTableCell

@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UILabel *conditionLbl;
@property (weak, nonatomic) IBOutlet UIImageView *baseImgView;
@property (weak, nonatomic) IBOutlet UILabel *couponsTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *outTimeImg;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet LXButton *useBtn;
@property (weak, nonatomic) IBOutlet UIImageView *usedImgView;

@property(nonatomic, copy)CouponsCellBlock block;



-(void)canUseWithType:(int)type;
@end
