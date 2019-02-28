//
//  CouponsBaseController.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/29.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXBaseController.h"

typedef NS_ENUM(NSInteger, CouponsType){
    noUsedCouponsType = 0,
    usedCouponsType = 1,
    outTimeCouponsType = 2
};

@interface CouponsBaseController : LXBaseController

@property(nonatomic, assign)CouponsType type;
@property(nonatomic, strong)UIColor *bgColor;

@end
