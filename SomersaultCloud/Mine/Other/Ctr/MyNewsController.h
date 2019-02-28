//
//  MyNewsController.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/27.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXBaseController.h"

typedef NS_ENUM(NSInteger , NewsType){
    newsType = 0,
    eventType = 1
};

@interface MyNewsController : LXBaseController

@property(nonatomic, assign)NewsType type;

@end
