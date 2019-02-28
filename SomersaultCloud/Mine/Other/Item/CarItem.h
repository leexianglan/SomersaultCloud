//
//  CarItem.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/10/15.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface CarItem : LXItem

@property(nonatomic, strong)NSString *carNo;
@property(nonatomic, strong)NSString *carRegDate;
@property(nonatomic, strong)NSString *carType;
@property(nonatomic, strong)NSString *delFlag;
@property(nonatomic, strong)NSString *remark;// 备注
@property(nonatomic, strong)NSString *travelDistance;// 公里数
@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)NSString *username;
@property(nonatomic, strong)NSString *vinNo;// 车架号



@end


@interface CarBrandItem : LXItem

@property(nonatomic, strong)NSString *brand;
@property(nonatomic, strong)NSString *brandId;
@property(nonatomic, strong)NSString *seriesName;

@end

NS_ASSUME_NONNULL_END
