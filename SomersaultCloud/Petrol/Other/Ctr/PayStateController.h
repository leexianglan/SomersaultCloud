//
//  PayStateController.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/10/8.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PayStateController : LXBaseController

@property(nonatomic, strong)NSString *orderid;

@property(nonatomic, assign)BOOL success;

@end

NS_ASSUME_NONNULL_END
