//
//  PetOrderCell.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/26.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXTableCell.h"
#import "PetOrderItem.h"

typedef NS_ENUM(NSInteger, PetOrderState){
    waitPayState = 1,
    paySuccessState = 2,
    payFailedState = 3,// 支付失败
    completeState = 4
};

typedef void(^PetOrderCellBlock)(NSInteger lxtag, NSInteger tag);

@interface PetOrderCell : LXTableCell

@property (weak, nonatomic) IBOutlet UIImageView *stationImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *jinDouLbl;
@property (weak, nonatomic) IBOutlet UILabel *disLbl;
@property (weak, nonatomic) IBOutlet UILabel *numLbl;
@property (weak, nonatomic) IBOutlet UIImageView *getTicketImg;
@property (weak, nonatomic) IBOutlet UILabel *preferentOrPriceLbl;
@property (weak, nonatomic) IBOutlet LXButton *payOrTicketBtn;
@property(nonatomic, copy)PetOrderCellBlock block;



-(void)setModel:(PetOrderItem *)model tag:(NSInteger)tag;

@end
