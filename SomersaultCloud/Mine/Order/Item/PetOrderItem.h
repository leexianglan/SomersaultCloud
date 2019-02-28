//
//  PetOrderItem.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/11/10.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface PetOrderItem : LXItem

@property (nonatomic, strong) NSString * goldBean;
@property (nonatomic, strong) NSString * realAmount;
@property (nonatomic, strong) NSString *insertDate;
@property (nonatomic, strong) NSString * amountNumY;
@property (nonatomic, strong) NSString * oilAmount;
@property (nonatomic, strong) NSString *payee;
@property (nonatomic, strong) NSString * oilNum;
@property (nonatomic, strong) NSString * todayIncome;
@property (nonatomic, strong) NSString * payStatus;
@property (nonatomic, strong) NSString *carId;
@property (nonatomic, strong) NSString * os;
@property (nonatomic, strong) NSString *payType;
@property (nonatomic, strong) NSString * amountNum;
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString *oilOrderId;
@property (nonatomic, strong) NSString * isPrint;
@property (nonatomic, strong) NSString * yesterdayIncome;
@property(nonatomic, strong)NSString *oilName;
@property(nonatomic, strong)NSString *oilDensity;
@property (nonatomic, strong) NSString *updateDate;
@property (nonatomic, strong) NSString *qrcode;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *tradeNo;
@property (nonatomic, strong) NSString *realOilNum;
/**
 组合优惠
 */
@property (nonatomic, strong) NSString *unionDiscountPrice;
@property (nonatomic, strong) NSString *orderNumY;
@property (nonatomic, strong) NSString *orderNum;
@property (nonatomic, strong) NSString *stationPrice;
@property (nonatomic, strong) NSString *couponId;
@property (nonatomic, strong) NSString *orderStatus;
/**
 平台优惠金额
 */
@property (nonatomic, strong) NSString *platformDiscountPrice;
@property (nonatomic, strong) NSString *todayOrder;
@property (nonatomic, strong) NSString *stationName;
@property (nonatomic, strong) NSString *paymentTypes;
@property (nonatomic, strong) NSString *vcode;
@property (nonatomic, strong) NSString *updateBy;
@property (nonatomic, strong) NSString *isWriteOff;
@property (nonatomic, strong) NSString *oilTypeId;
@property (nonatomic, strong) NSString *stationDiscount;
@property (nonatomic, strong) NSString *stationId;
@property (nonatomic, strong) NSString *isPrintInvoice;
@property (nonatomic, strong) NSString *hourNum;
@property (nonatomic, strong) NSString *yesterdayOrder;
@property (nonatomic, strong) NSString *hourNumY;
@property (nonatomic, strong) NSString *oilPrice;
@property (nonatomic, strong) NSString *platformPrice;
@property (nonatomic, strong) NSString *platformDiscount;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *couponName;
@property (nonatomic, strong) NSString *realOilAmount;


@end

NS_ASSUME_NONNULL_END
