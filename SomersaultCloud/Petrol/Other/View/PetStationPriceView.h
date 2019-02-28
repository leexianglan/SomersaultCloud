//
//  PetStationPriceView.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/29.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PetStationPriceView : UIView

@property (weak, nonatomic) IBOutlet UILabel *petNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *preferLbl;
@property (weak, nonatomic) IBOutlet UIView *baseView;


+(PetStationPriceView *)shareWithFrame:(CGRect)frame;
@end
