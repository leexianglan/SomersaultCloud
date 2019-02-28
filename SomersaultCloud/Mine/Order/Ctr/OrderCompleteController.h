//
//  OrderCompleteController.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/10/9.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXBaseController.h"
#import "PetOrderItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderCompleteController : LXBaseController

@property(nonatomic, strong)PetOrderItem *item;

@end

NS_ASSUME_NONNULL_END
