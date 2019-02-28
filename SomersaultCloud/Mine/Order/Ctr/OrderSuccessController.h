//
//  OrderSuccessController.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/10/9.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXBaseController.h"
#import "PetOrderItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderSuccessController : LXBaseController

@property(nonatomic, strong)PetOrderItem *item;
@property(nonatomic, strong)NSString *orderid;

@end

NS_ASSUME_NONNULL_END
