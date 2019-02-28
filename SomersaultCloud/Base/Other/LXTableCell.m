//
//  LXTableCell.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/13.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXTableCell.h"

@implementation LXTableCell

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setSeparatorInset:UIEdgeInsetsZero];
        [self setLayoutMargins:UIEdgeInsetsZero];
        self.preservesSuperviewLayoutMargins = NO;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [[LXViewControllerManager shareManager] fixFontWithView:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)resetSelf{
    
}

@end
