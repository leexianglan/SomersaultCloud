//
//  PeaBaseController.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/21.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXBaseController.h"

typedef NS_ENUM(NSInteger, PeaType){
    peaGetType = 2,
    peaCusType = 1,
    peaAllType = 0
};

@interface PeaBaseController : LXBaseController

@property(nonatomic, assign)PeaType type;

@end
