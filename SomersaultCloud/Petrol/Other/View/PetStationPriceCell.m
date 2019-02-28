//
//  PetStationPriceCell.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/29.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "PetStationPriceCell.h"

@implementation PetStationPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.leftView = [self getPetStationViewWithIndex:0];
    self.centerView = [self getPetStationViewWithIndex:1];
    self.rightView = [self getPetStationViewWithIndex:2];
}

-(PetStationPriceView *)getPetStationViewWithIndex:(NSInteger)index{
    PetStationPriceView *view = [PetStationPriceView shareWithFrame:CGRectZero];
    view.hidden = YES;
    [self addSubview:view];
    return view;
}

-(CGRect)getFrameWithIndex:(NSInteger)index{
    CGFloat width = (kDeviceWidth - 74)/3.f;
    CGFloat x = 15;
    if (index == 1) {
        x += 22;
        x += width;
    }else if (index == 2){
        x += 22*2;
        x += 2*width;
    }
    return CGRectMake(x, 0, width, CGRectGetHeight(self.bounds)*.72);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.leftView.frame = [self getFrameWithIndex:0];
    self.centerView.frame = [self getFrameWithIndex:1];
    self.rightView.frame = [self getFrameWithIndex:2];
}

-(void)setModelWithArr:(NSArray *)arr{
    for (int i = 0; i < arr.count; i++) {
        OilPriceItem *item = arr[i];
        if (i == 0) {
            [self setModel:item view:self.leftView];
        }else if (i == 1){
            [self setModel:item view:self.centerView];
        }else if (i == 2){
            [self setModel:item view:self.rightView];
        }
    }
}

-(void)setModel:(OilPriceItem*)item view:(PetStationPriceView*)view{
    view.hidden = NO;
    view.petNumLbl.text = item.oilType;
    view.priceLbl.text = [NSString stringWithFormat:@"￥%@", item.oilNowPrice];
    view.oldPriceLbl.text = [NSString stringWithFormat:@"市场价￥%@", item.oilPrice];
    view.preferLbl.text = [NSString stringWithFormat:@"降%@元", item.reducedPrice];
}

@end
