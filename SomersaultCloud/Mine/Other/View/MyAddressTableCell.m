//
//  MyAddressTableCell.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/25.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "MyAddressTableCell.h"

@interface MyAddressTableCell()




@end



@implementation MyAddressTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)resetSelf{
    self.lbl.text = @"";
    self.detailLbl.text = @"";
}

@end
