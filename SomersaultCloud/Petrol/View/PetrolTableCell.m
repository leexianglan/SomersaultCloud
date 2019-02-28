//
//  PetrolTableCell.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/15.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "PetrolTableCell.h"


@interface PetrolTableCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *downProceLbl;
@property (weak, nonatomic) IBOutlet UILabel *disLbl;
@property (weak, nonatomic) IBOutlet UILabel *numLbl;
@property (weak, nonatomic) IBOutlet UIButton *navBtn;

@end


@implementation PetrolTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)navBtnAction:(UIButton *)sender {
    if (self.block) {
        self.block(sender.tag);
    }
}

-(void)setModel:(StationItem *)item row:(NSInteger)row{
    self.titleLbl.text = item.name;
    self.addressLbl.text = item.address;
    self.priceLbl.text = [NSString stringWithFormat:@"￥%@", item.oilNowPrice];
    self.downProceLbl.text = [NSString stringWithFormat:@"已降%@元", item.reducedPrice];
    self.disLbl.text = [NSString stringWithFormat:@"%.1fKM", [item.distance floatValue]];
    self.numLbl.text = [NSString stringWithFormat:@"%@单", item.orders];
    self.navBtn.tag = row;
}

@end
