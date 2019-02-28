//
//  PetStationPriceCell.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/29.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXTableCell.h"
#import "PetStationPriceView.h"
#import "StationDetailItem.h"

@interface PetStationPriceCell : LXTableCell

@property(nonatomic, strong)PetStationPriceView *leftView;
@property(nonatomic, strong)PetStationPriceView *centerView;
@property(nonatomic, strong)PetStationPriceView *rightView;

-(void)setModelWithArr:(NSArray *)arr;
@end
