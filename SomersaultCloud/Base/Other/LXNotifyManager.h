//
//  NMNotifyManager.h
//  NMHomes
//
//  Created by mac book air on 16/8/18.
//  Copyright © 2016年 mac book air. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kkkHideYBPopView @"kkkHideYBPopView"
#define kPaySuccess @"kPaySuccess"
#define kPayFailed @"kPayFailed"
#define kWechatAuthSuccess @"kWechatAuthSuccess"
#define kRefreshInvoiceList @"kRefreshInvoiceList"
#define kRefreshAddressList @"kRefreshAddressList"
#define kRefreshCarList @"kRefreshCarList"
#define kRefreshUserInfo @"kRefreshUserInfo"
#define kRefreshMineVC @"kRefreshMineVC"


typedef void (^LXNotifyBlock)(NSDictionary *userInfo);

@interface LXNotifyManager : NSObject


+(instancetype)shareInstance;


-(void)addTarget:(id)target withKey:(NSString*)key withSelector:(SEL)selector;

-(void)addTarget:(id)target withKey:(NSString*)key withBlock:(LXNotifyBlock)block;

/** 移除通知 */
-(void)removeNotifyKey:(NSString*)key withTarget:(id)target;


-(void)removeTarget:(id)target withKey:(NSString*)key;

/** 是否存在通知键名 */
-(BOOL)hasNotifyKey:(NSString*)key withTarget:(id)target;


-(void)postNotifyKey:(NSString*)key;


-(void)postNotifyKey:(NSString*)key userInfo:(NSDictionary*)userInfo;


@end

