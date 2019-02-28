//
//  MakeOrderTableCell.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/15.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXTableCell.h"
#import "StationDetailItem.h"

typedef void(^MakeOrderCellBlock)(BOOL select);

@interface MakeOrderTableCell : LXTableCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *disLbl;
@property (weak, nonatomic) IBOutlet UILabel *numLbl;
@property (weak, nonatomic) IBOutlet UIButton *navBtn;
@property (weak, nonatomic) IBOutlet LXButton *focusBtn;
@property(nonatomic, copy)MakeOrderCellBlock block;


-(void)setModel:(StationDetailItem*)item;
-(void)selectFocusBtn:(BOOL)select;

@end
