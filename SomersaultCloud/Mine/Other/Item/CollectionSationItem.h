//
//  CollectionSationItem.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/11/8.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectionSationItem : LXItem

@property (nonatomic, strong) NSString * stationId;
@property (nonatomic, strong) NSString * delFlag;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *stationName;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString * oilPrice;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *stationAddress;
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString *openId;
@property (nonatomic, strong) NSString * distance;
@property (nonatomic, strong) NSString *updateTime;
@end

NS_ASSUME_NONNULL_END
