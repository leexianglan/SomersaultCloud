//
//  EditCarCell.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/28.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXTableCell.h"

@interface EditCarCell : LXTableCell

@property (weak, nonatomic) IBOutlet UILabel *leftLbl;
@property (weak, nonatomic) IBOutlet UILabel *rightLbl;
@property (weak, nonatomic) IBOutlet UITextField *txtField;
@property (weak, nonatomic) IBOutlet UIButton *btn;


/**
 是否显示选择省份btn
 */
-(void)baseViewShow:(BOOL)show;
@end
