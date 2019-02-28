//
//  LXUserDefault.h
// 
//
//  Created by 李相兰 on 2018/4/12.
//  Copyright © 2018年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserItem.h"



@interface LXUserDefault : NSObject

+(void)saveToken:(NSString *)token;
+(NSString *)token;

+(void)saveOpenid:(NSString*)openid;
+(NSString *)openid;

+(void)saveUserid:(NSString *)userid;
+(NSString *)userid;


+(void)saveUserItem:(UserItem*)useritem;
+(UserItem*)userItem;

+(void)saveLocation:(double)lon lat:(double)lat;
+(NSArray *)location;


+(void)clear;


@end

