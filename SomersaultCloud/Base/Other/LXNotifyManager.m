//
//  NMNotifyManager.m
//  NMHomes
//
//  Created by mac book air on 16/8/18.
//  Copyright © 2016年 mac book air. All rights reserved.
//

#import "LXNotifyManager.h"

#define NM_NOTIFY_TARGET @"target"
#define NM_NOTIFY_KEY @"key"
#define NM_NOTIFY_SELECTOR @"selector"
#define NM_NOTIFY_BLOCK @"BLOCK"

@interface LXNotifyManager ()
@property(nonatomic,strong)NSMutableDictionary* pTable;


@end


@implementation LXNotifyManager

+(instancetype)shareInstance{
    static LXNotifyManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LXNotifyManager alloc] init];
    });
    return manager;
}

-(id)init{
    self=[super init];
    
    self.pTable=[NSMutableDictionary dictionaryWithCapacity:10];
    
    return self;
}


-(void)addTarget:(id)target withKey:(NSString*)key withSelector:(SEL)selector
{
    
    NSDictionary* content=@{NM_NOTIFY_TARGET:[NSValue valueWithNonretainedObject:target],
                            NM_NOTIFY_KEY:key,
                            NM_NOTIFY_SELECTOR:NSStringFromSelector(selector)};
    
    NSString* subKey=[self identifyFromTarget:target];
    
    NSMutableDictionary* subDict=[self.pTable objectForKey:key];
    
    if(!subDict)
    {
        subDict=[NSMutableDictionary dictionaryWithCapacity:10];
    }
    
    subDict[subKey]=content;
    
    self.pTable[key]=subDict;
}


-(void)addTarget:(id)target withKey:(NSString*)key withBlock:(LXNotifyBlock)block
{
    NSDictionary* content=@{NM_NOTIFY_TARGET:[NSValue valueWithNonretainedObject:target],
                            NM_NOTIFY_KEY:key,
                            NM_NOTIFY_BLOCK:block};
    
    NSString* subKey=[self identifyFromTarget:target];
    
    NSMutableDictionary* subDict=[self.pTable objectForKey:key];
    
    if(!subDict)
    {
        subDict=[NSMutableDictionary dictionaryWithCapacity:10];
    }
    
    subDict[subKey]=content;
    
    self.pTable[key]=subDict;
}

/** 是否存在通知键名 */
-(BOOL)hasNotifyKey:(NSString*)key withTarget:(id)target{
    
    NSDictionary* subDict=[self.pTable objectForKey:key];
    
    if(!subDict)
        return NO;
    
    NSString* subKey=[self identifyFromTarget:target]; // 根据target获取子键
    
    id content=subDict[subKey];
    
    if(!content) // 键值不存在
        return NO;
    
    if([content[NM_NOTIFY_KEY] isEqualToString:key]) // 如果兼职存在则，返回YES
        return YES;
    
    return NO;
    
}

/** 移除通知 */
-(void)removeNotifyKey:(NSString*)key withTarget:(id)target{
    
    NSMutableDictionary* notifyDict=[self.pTable objectForKey:key];
    
    if(!notifyDict)
        return;
    
    NSString* objKey=[self identifyFromTarget:target]; // 根据target获取子键
    
    [notifyDict removeObjectForKey:objKey];
    
    if([notifyDict count]==0) // 如果全部删除，则移除此消息键值
        [self.pTable removeObjectForKey:key];
    
}

/**
 发送目标通知
 */
-(void)postNotifyKey:(NSString*)key
{
    NSDictionary* subDict=[self.pTable objectForKey:key];
    
    if(!subDict)
        return;
    
    for(NSString* subKey in [subDict allKeys]) {
        
        NSDictionary* content=subDict[subKey];
        
        if(content[NM_NOTIFY_BLOCK])
        {
            LXNotifyBlock block=content[NM_NOTIFY_BLOCK];
            block(nil);
        }
        
        if(content[NM_NOTIFY_SELECTOR])
        {
            SEL sel=NSSelectorFromString(content[NM_NOTIFY_SELECTOR]);
            id target=(id)content[NM_NOTIFY_TARGET];
            //            [target performSelector:sel withObject:nil];
            @try {
                [[target nonretainedObjectValue] performSelectorOnMainThread:sel withObject:nil waitUntilDone:NO];
            }
            @catch (NSException *exception) {
            }
            @finally {
                
            }
        }
    }
    
}

/**
 发送目标通知
 */
-(void)postNotifyKey:(NSString*)key userInfo:(NSDictionary*)userInfo
{
    NSDictionary* subDict=[self.pTable objectForKey:key];
    
    if(!subDict)
        return;
    
    for(NSString* subKey in [subDict allKeys]) {
        
        NSDictionary* content=subDict[subKey];
        
        if(content[NM_NOTIFY_BLOCK])
        {
            LXNotifyBlock block=content[NM_NOTIFY_BLOCK];
            block(userInfo);
        }
        
        if(content[NM_NOTIFY_SELECTOR])
        {
            SEL sel=NSSelectorFromString(content[NM_NOTIFY_SELECTOR]);
            id target=(id)content[NM_NOTIFY_TARGET];
            [[target nonretainedObjectValue] performSelectorOnMainThread:sel withObject:userInfo waitUntilDone:NO];
        }
    }
    
}



-(void)removeTarget:(id)target withKey:(NSString*)key
{
    NSString* uid=[self identifyFromTarget:target fromKey:key];
    
    [self.pTable removeObjectForKey:uid];
}

/**
 目标唯一Id
 */
-(NSString*)identifyFromTarget:(NSObject*)target fromKey:(NSString*)key{
    return [NSString stringWithFormat:@"%@_%@_%@",NSStringFromClass([target class]),@([target hash]),key];
}
-(NSString*)identifyFromTarget:(NSObject*)target{
    return [NSString stringWithFormat:@"%@",@([target hash])];
}




@end

