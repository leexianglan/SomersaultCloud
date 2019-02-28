//
//  PetrolTableCell.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/15.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXTableCell.h"
#import "StationItem.h"

typedef void(^PetrolTableCellBlock)(NSInteger tag);

@interface PetrolTableCell : LXTableCell


@property(nonatomic, copy)PetrolTableCellBlock block;

-(void)setModel:(StationItem*)item row:(NSInteger)row;

@end
