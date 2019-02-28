//
//  ConfirmOrderController.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/10/8.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXBaseController.h"
#import "BeaAndDiscountMoneyItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConfirmOrderController : LXBaseController

@property(nonatomic, strong)NSString *orderid;
@property(nonatomic, strong)NSString *carNo;
@property(nonatomic, strong)BeaAndDiscountMoneyItem *bADitem;

@end

NS_ASSUME_NONNULL_END
