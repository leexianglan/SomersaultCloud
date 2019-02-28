//
//  ConfirmOrderTableCell.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/10/8.
//  Copyright © 2018年 李相兰. All rights reserved.
//


#import "LXTableCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface ConfirmOrderTableCell : LXTableCell

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIImageView *downImgView;


@end

NS_ASSUME_NONNULL_END
