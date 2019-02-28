//
//  ConfirmOrderSelectCell.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/10/8.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXTableCell.h"

typedef void(^ConfirmOSBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface ConfirmOrderSelectCell : LXTableCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *lbl;
@property(nonatomic, copy)ConfirmOSBlock block;
@property (weak, nonatomic) IBOutlet UIView *line;


@end

NS_ASSUME_NONNULL_END
