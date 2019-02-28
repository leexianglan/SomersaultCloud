//
//  UserItem.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/11/6.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserItem : LXItem


@property (nonatomic, strong) NSString * userMoney;
@property (nonatomic, strong) NSString *wechat;
@property (nonatomic, strong) NSString * visitCount;
@property (nonatomic, strong) NSString * isBind;
@property (nonatomic, strong) NSString *userAddress;
@property (nonatomic, strong) NSString * sex;
@property (nonatomic, strong) NSString * isCertify;
@property (nonatomic, strong) NSString * userBeans;
@property (nonatomic, strong) NSString * regTime;
@property (nonatomic, strong) NSString *userHeader;
@property (nonatomic, strong) NSString *openId;
@property (nonatomic, strong) NSString * userId;
@property(nonatomic, strong)NSString *mobilePhone;

@end

NS_ASSUME_NONNULL_END
