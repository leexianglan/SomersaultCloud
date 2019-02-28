//
//  CollectPetStationCell.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/25.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "CollectPetStationCell.h"

@implementation CollectPetStationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)resetSelf{
    self.imgView.image = nil;
    self.titleLbl.text = @"";
    self.detailLbl.text = @"";
    self.disLbl.text = @"";
    self.priceLbl.text = @"";
}

-(void)setModel:(CollectionSationItem *)item section:(NSInteger)section{
    self.navBtn.tag = section;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", host, item.logo]]];
    self.titleLbl.text = item.stationName;
    self.detailLbl.text = item.stationAddress;
    self.disLbl.text = [NSString stringWithFormat:@"%.1fKM", [item.distance floatValue]];
    self.priceLbl.text = [NSString stringWithFormat:@"￥%@", item.oilPrice];
}

@end
