//
//  MakeOrderPetNumTableCell.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/17.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXTableCell.h"

typedef void(^MakeOrderPetNumTCBlock)(NSInteger lxTag, NSInteger tag);

@interface MakeOrderPetNumTableCell : LXTableCell

@property (weak, nonatomic) IBOutlet UIView *line;
@property(nonatomic, copy, nullable)MakeOrderPetNumTCBlock block;
@property (strong, nonatomic) IBOutletCollection(LXButton) NSArray *btns;
- (IBAction)btnAction:(LXButton *)sender ;
@end
