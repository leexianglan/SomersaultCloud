//
//  OrderCodeCell.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/10/9.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderCodeCell : LXTableCell

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *hintLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet LXButton *btn;

-(void)showBtn:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
