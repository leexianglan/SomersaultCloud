//
//  MakeOrderSelectCell.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/17.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "MakeOrderSelectCell.h"

@interface MakeOrderSelectCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgW;

@end

@implementation MakeOrderSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)resetSelf{
    self.jdLbl.text = @"";
    self.rightV.hidden = YES;
    self.titleLbl.text = @"";
    [self setImgWidth:0];
    self.line.hidden = YES;
}

-(void)setImgWidth:(CGFloat)width{
    self.imgW.constant = width;
    [self.imgView updateConstraints];
}

@end
