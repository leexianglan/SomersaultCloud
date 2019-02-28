//
//  StationItem.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/11/6.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface StationItem : LXItem

@property (nonatomic, strong) NSString * unionDiscountPrice;

@property (nonatomic, strong) NSString * orders;

@property (nonatomic, strong) NSString * oilPrice;

@property (nonatomic, strong) NSString * pageSize;

@property (nonatomic, strong) NSString *telephone;

@property (nonatomic, strong) NSString * sort;

@property (nonatomic, strong) NSString * reducedPrice;

@property (nonatomic, strong) NSString *oilType;

@property (nonatomic, strong) NSString * latitude;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *oilMachineImg;

@property (nonatomic, strong) NSString * longitude;

@property (nonatomic, strong) NSString * distance;

@property (nonatomic, strong) NSString * stationId;

@property (nonatomic, strong) NSString * oilNowPrice;

@property (nonatomic, strong) NSString * discountPrice;

@property (nonatomic, strong) NSString * page;

@property (nonatomic, strong) NSString * start;

@property (nonatomic, strong) NSString *logo;

@property (nonatomic, strong) NSString * oilTypeId;

@property (nonatomic, strong) NSString *address;

@end

NS_ASSUME_NONNULL_END

@interface OilTypeItem : LXItem
@property (nonatomic, strong) NSString *oilType;
@property (nonatomic, strong) NSString * discountMoney;
@property (nonatomic, strong) NSString * oilPrice;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString * oilTypeId;
@property (nonatomic, strong) NSString * cateId;
@property (nonatomic, strong) NSString *updateDate;
@property (nonatomic, strong) NSString * platformDiscountPrice;
@property (nonatomic, strong) NSString * literNum;
@property (nonatomic, strong) NSString *oilDensity;
@property (nonatomic, strong) NSString * status;
@end

@interface OilBannerItem : LXItem
@property (nonatomic, strong) NSNumber * discount;
@property (nonatomic, strong) NSString *carId;
@property (nonatomic, strong) NSNumber * minute;
@property (nonatomic, strong) NSString *stationName;

@end
