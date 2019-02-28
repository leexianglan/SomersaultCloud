//
//  BeanItem.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/10/17.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface BeanItem : LXItem

@property(nonatomic, strong)NSString *beanNum;

/**
 1消费  2 获取
 */
@property(nonatomic, strong)NSString *consumType;
@property(nonatomic, strong)NSString *createTime;
@property(nonatomic, strong)NSString *startEffectTime;
@property(nonatomic, strong)NSString *endEffectTime;
@property(nonatomic, strong)NSString *orderId;

/**
 (1.抽油  2.抢油   3.加油赠送  4.消费 5. 分享  6.签到 7.反馈信息)
 */
@property(nonatomic, strong)NSString *transactionType;
@property(nonatomic, strong)NSString *updateBy;
@property(nonatomic, strong)NSString *updateTime;
@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)NSString *lTitle;

@end

NS_ASSUME_NONNULL_END
