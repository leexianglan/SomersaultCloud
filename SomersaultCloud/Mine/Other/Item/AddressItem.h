//
//  AddressItem.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/11/9.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddressItem : LXItem
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString *telphone;
@property (nonatomic, strong) NSString *userAddress;
@property (nonatomic, strong) NSString *detailAddr;
@property (nonatomic, strong) NSString * isDefault;

@end

NS_ASSUME_NONNULL_END
