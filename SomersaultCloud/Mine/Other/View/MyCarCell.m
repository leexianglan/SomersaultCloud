//
//  MyCarCell.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/28.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "MyCarCell.h"

@implementation MyCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(CarItem *)model{
    NSArray *arr = [model.carType componentsSeparatedByString:@"-"];
    if (arr.count == 2) {
        self.brandLbl.text = arr[0];
        self.styleLbl.text = arr[1];
    }
    self.carNumLbl.text = model.carNo;
    self.mileageLbl.text = [NSString stringWithFormat:@"%@万公里", model.travelDistance];
    
}

@end
