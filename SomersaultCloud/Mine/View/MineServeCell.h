//
//  MineServeCell.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/21.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXTableCell.h"
#import "MineServeBaseView.h"

typedef void(^MineServeCellBlock)(NSInteger tag);

@interface MineServeCell : LXTableCell

@property (strong, nonatomic) IBOutletCollection(MineServeBaseView) NSMutableArray *views;
@property(nonatomic, copy)MineServeCellBlock block;


-(void)resetSelf;

@end
