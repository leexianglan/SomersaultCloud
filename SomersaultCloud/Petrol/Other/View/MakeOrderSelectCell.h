//
//  MakeOrderSelectCell.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/17.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXTableCell.h"

@interface MakeOrderSelectCell : LXTableCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *jdLbl;
@property (weak, nonatomic) IBOutlet UIImageView *rightV;
@property (weak, nonatomic) IBOutlet UIView *line;


-(void)resetSelf;
-(void)setImgWidth:(CGFloat)width;
@end
