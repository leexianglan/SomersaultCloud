//
//  PeaBaseCell.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/21.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXTableCell.h"
#import "BeanItem.h"

@interface PeaBaseCell : LXTableCell

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *numLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;


-(void)setModel:(BeanItem*)item;
@end
