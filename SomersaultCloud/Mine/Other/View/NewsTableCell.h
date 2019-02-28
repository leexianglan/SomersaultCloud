//
//  NewsTableCell.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/27.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXTableCell.h"

@interface NewsTableCell : LXTableCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *stateLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UIButton *btn;


@end
