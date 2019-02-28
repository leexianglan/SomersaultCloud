//
//  MyCarCell.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/28.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXTableCell.h"
#import "CarItem.h"

@interface MyCarCell : LXTableCell


@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *brandLbl;
@property (weak, nonatomic) IBOutlet UILabel *styleLbl;
@property (weak, nonatomic) IBOutlet UILabel *carNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *mileageLbl;
@property (weak, nonatomic) IBOutlet UIImageView *zhaohuiImg;

-(void)setModel:(CarItem*)model;


@end
