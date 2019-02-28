//
//  StationDetailItem.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/11/7.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface StationDetailItem : LXItem

@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *dimension;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString * distance;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSArray *oilPriceList;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString * orders;

@end

NS_ASSUME_NONNULL_END


@interface OilPriceItem : LXItem

@property (nonatomic, strong) NSString * unionDiscountPrice;
@property (nonatomic, strong) NSString * oilPrice;
@property (nonatomic, strong) NSString * pageSize;
@property (nonatomic, strong) NSString * sort;
@property (nonatomic, strong) NSString * reducedPrice;
@property (nonatomic, strong) NSString *oilType;
@property (nonatomic, strong) NSString * latitude;
@property (nonatomic, strong) NSString *oilMachineImg;
@property (nonatomic, strong) NSString * longitude;
@property (nonatomic, strong) NSString * distance;
@property (nonatomic, strong) NSString * stationId;
@property (nonatomic, strong) NSString * oilNowPrice;
@property (nonatomic, strong) NSString * discountPrice;
@property (nonatomic, strong) NSString * page;
@property (nonatomic, strong) NSString * start;
@property (nonatomic, strong) NSString * oilTypeId;

@end
