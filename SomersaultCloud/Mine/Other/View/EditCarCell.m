//
//  EditCarCell.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/28.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "EditCarCell.h"

@interface EditCarCell()

@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseViewW;


@end

@implementation EditCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)resetSelf{
    self.leftLbl.textColor = k_3_Color;
    self.rightLbl.text = @"";
    [self baseViewShow:NO];
    self.txtField.text = @"";
}

-(void)baseViewShow:(BOOL)show{
    if (show) {
        self.baseViewW.constant = 44*kEqualHeight;
    }else{
        self.baseViewW.constant = 0;
    }
    [self updateConstraints];
}


@end
