//
//  EditInvoiceController.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/27.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXBaseController.h"
#import "InvoiceItem.h"

@interface EditInvoiceController : LXBaseController

@property(nonatomic, assign)BOOL isPersonType;
@property(nonatomic, strong)InvoiceItem *item;

@end
