//
//  PetOrderCell.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/26.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "PetOrderCell.h"

@implementation PetOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSLog(@"%@", self.jinDouLbl.textColor);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)resetSelf{
    self.payOrTicketBtn.hidden = YES;
    self.getTicketImg.hidden = YES;
    self.disLbl.text = @"";
    self.numLbl.text = @"";
    self.jinDouLbl.text = @"";
    self.preferentOrPriceLbl.text = @"";
}

-(void)orderHadComplete:(BOOL)complete{
    [self resetSelf];
    if (complete) {
        self.preferentOrPriceLbl.font = [UIFont systemFontOfSize:15*kEqualHeight];
        self.getTicketImg.hidden = NO;
        self.jinDouLbl.textColor = k_6_Color;
        self.priceLbl.textColor = k_6_Color;
        self.stationImg.image = [UIImage imageNamed:@"me_dingdan_icon_youxiang_dis"];
    }else{
        self.preferentOrPriceLbl.font = [UIFont systemFontOfSize:12*kEqualHeight];
        self.payOrTicketBtn.hidden = NO;
        self.jinDouLbl.textColor = kRedColor;
        self.priceLbl.textColor = kRedColor;
        self.stationImg.image = [UIImage imageNamed:@"icon_youzhan"];
    }
}

-(void)setModel:(PetOrderItem *)model tag:(NSInteger)tag{
    self.payOrTicketBtn.tag = tag;
    self.timeLbl.text = model.insertDate;
    self.jinDouLbl.text = @"";
    if ([model.payStatus intValue]== waitPayState || [model.payStatus intValue] == payFailedState) {
        [self orderHadComplete:NO];
        [self setPayOrTicketBtnLxTag:waitPayState];
        [[LXViewControllerManager shareManager] setMutableAttributedStringLbl:self.priceLbl strArr:@[@"待支付  ", [NSString stringWithFormat:@"￥%@", model.realAmount]] colorArr:@[k_6_Color, kRedColor]];
        
        self.titleLbl.text = [NSString stringWithFormat:@"车牌号：%@", model.carId];
        self.preferentOrPriceLbl.text = [NSString stringWithFormat:@"平台优惠：￥%.0f/升", [model.oilDensity floatValue]/100];
    }else if ([model.payStatus integerValue] == paySuccessState){
        [self orderHadComplete:NO];
        [self setPayOrTicketBtnLxTag:paySuccessState];
        self.titleLbl.text = [NSString stringWithFormat:@"订单号：%@", model.oilOrderId];
        self.preferentOrPriceLbl.text = [NSString stringWithFormat:@"平台优惠：￥%.0f/升", [model.oilDensity floatValue]/100];
        self.jinDouLbl.text = [NSString stringWithFormat:@"获取金豆：%@", model.goldBean];
        self.jinDouLbl.textColor = kRedColor;
        self.priceLbl.text = [NSString stringWithFormat:@"￥%@", model.realAmount];
        self.priceLbl.textColor = kRedColor;
    }else if ([model.payStatus integerValue] == completeState){
        [self orderHadComplete:YES];
        self.jinDouLbl.text = [NSString stringWithFormat:@"获取金豆：%@", model.goldBean];
        self.jinDouLbl.textColor = k_6_Color;
        self.numLbl.text = @"100000单";
        self.disLbl.text = @"10000KM";
        self.preferentOrPriceLbl.text = @"￥50000/升";
        self.priceLbl.text = [NSString stringWithFormat:@"￥%@", model.realAmount];
        self.priceLbl.textColor = k_6_Color;
        self.titleLbl.text = model.stationName;
    }
    [[LXViewControllerManager shareManager] setThroughAttributedStringLbl:self.oldPriceLbl str:[NSString stringWithFormat:@"￥%@", model.oilAmount] throughColor:k_9_Color];
}

-(void)setPayOrTicketBtnLxTag:(NSInteger)tag{
    [self.payOrTicketBtn setTitle:tag == waitPayState?@"去支付":@"" forState:UIControlStateNormal];
    [self.payOrTicketBtn setBackgroundImage:[UIImage imageNamed:tag == waitPayState?@"myOrder_goPay_border":@"myOrder_getTicket"] forState:UIControlStateNormal];
    self.payOrTicketBtn.lxTag = tag;
}

- (IBAction)btnAction:(LXButton *)sender {
    if (self.block) {
        self.block(sender.lxTag, sender.tag);
    }
}



@end
