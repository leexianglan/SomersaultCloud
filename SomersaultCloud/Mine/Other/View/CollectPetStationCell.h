//
//  CollectPetStationCell.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/25.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXTableCell.h"
#import "CollectionSationItem.h"

@interface CollectPetStationCell : LXTableCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;
@property (weak, nonatomic) IBOutlet UILabel *disLbl;
@property (weak, nonatomic) IBOutlet UIButton *navBtn;


-(void)setModel:(CollectionSationItem*)item section:(NSInteger)section;

@end
