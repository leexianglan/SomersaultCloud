//
//  InvoiceItem.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/10/17.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface InvoiceItem : LXItem


@property(nonatomic, strong)NSString *userName;
@property(nonatomic, strong)NSString *taxType;
@property(nonatomic, strong)NSString *createTime;

@property(nonatomic, strong)NSString *address;
@property(nonatomic, strong)NSString *bankAccount;
@property(nonatomic, strong)NSString *openBank;
@property(nonatomic, strong)NSString *taxCompany;
@property(nonatomic, strong)NSString *taxId;
@property(nonatomic, strong)NSString *telephone;

@end

NS_ASSUME_NONNULL_END
