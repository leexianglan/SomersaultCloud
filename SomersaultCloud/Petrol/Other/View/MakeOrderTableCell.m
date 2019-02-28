//
//  MakeOrderTableCell.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/15.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "MakeOrderTableCell.h"

@interface MakeOrderTableCell ()



@end

@implementation MakeOrderTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.focusBtn.layer.borderColor = kRedColor.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)selectFocusBtn:(BOOL)select{
    self.focusBtn.enabled = !select;
    self.focusBtn.layer.borderColor = !select?kRedColor.CGColor:k_9_Color.CGColor;
}

- (IBAction)focusBtnAction:(LXButton *)sender {
    if (self.block) {
        self.block(sender.selected);
    }
}

-(void)setModel:(StationDetailItem *)item{
    self.titleLbl.text = item.name;
    self.addressLbl.text = item.address;
    self.disLbl.text = [NSString stringWithFormat:@"%.1fKM", [item.distance floatValue]];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", host, item.logo]]];
    self.numLbl.text = [NSString stringWithFormat:@"成交%@单", item.orders];
    
}

@end
