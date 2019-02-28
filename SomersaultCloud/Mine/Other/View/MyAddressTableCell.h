//
//  MyAddressTableCell.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/25.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXTableCell.h"

@interface MyAddressTableCell : LXTableCell

@property (weak, nonatomic) IBOutlet UILabel *lbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;


-(void)resetSelf;
@end
