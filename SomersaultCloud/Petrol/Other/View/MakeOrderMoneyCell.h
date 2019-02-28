//
//  MakeOrderMoneyCell.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/17.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXTableCell.h"

typedef void(^MakeOrderMoneyCellBlock)(NSString *money);

@interface MakeOrderMoneyCell : LXTableCell

@property (weak, nonatomic) IBOutlet UITextField *txtField;
@property (weak, nonatomic) IBOutlet UILabel *moneyLbl;
@property(nonatomic, copy)MakeOrderMoneyCellBlock block;


@end
