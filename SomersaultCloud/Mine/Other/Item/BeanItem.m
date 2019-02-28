//
//  BeanItem.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/10/17.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "BeanItem.h"

@implementation BeanItem


-(void)setTransactionType:(NSString *)transactionType{
    _transactionType = transactionType;
    switch ([transactionType intValue]) {
        case 1:
            self.lTitle = @"抽油得金豆";
            break;
        case 2:
            self.lTitle = @"抢油得金豆";
            break;
        case 3:
            self.lTitle = @"加油得金豆";
            break;
        case 4:
            self.lTitle = @"金豆消费";
            break;
        case 5:
            self.lTitle = @"分享得金豆";
            break;
        case 6:
            self.lTitle = @"签到得金豆";
            break;
        case 7:
            self.lTitle = @"反馈信息得金豆";
            
        default:
            break;
    }
}
@end
