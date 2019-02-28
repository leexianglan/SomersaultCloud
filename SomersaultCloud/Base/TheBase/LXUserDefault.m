//
//  LXUserDefault.m
// 
//
//  Created by 李相兰 on 2018/4/12.
//  Copyright © 2018年  All rights reserved.
//

#import "LXUserDefault.h"

@implementation LXUserDefault

+(void)saveToken:(NSString *)token{
    [[LXUserDefault userDefault] setObject:token forKey:@"token"];
}

+(NSString *)token{
//    return @"fda1bfe1f8c4df75229c758e3b7cd9e9";
    return [[LXUserDefault userDefault] objectForKey:@"token"];
}

+(void)saveOpenid:(NSString *)openid{
    [[LXUserDefault userDefault] setObject:openid forKey:@"openid"];
}

+(NSString *)openid{
//    return @"oMzhX0vFiL4WQuc14dPfp140KDFY";
    return [[LXUserDefault userDefault] objectForKey:@"openid"];
}

+(void)saveUserid:(NSString *)userid{
    [[LXUserDefault userDefault] setObject:userid forKey:@"userid"];
}

+(NSString *)userid{
    return [[LXUserDefault userDefault] objectForKey:@"userid"];
}

+(void)saveUserItem:(UserItem *)useritem{
    if (!useritem) {
        [[LXUserDefault userDefault] removeObjectForKey:@"useritem"];
        return;
    }
    NSDictionary *dic = [useritem mj_keyValues];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    [[LXUserDefault userDefault] setObject:jsonData forKey:@"useritem"];
}

+(UserItem *)userItem{
    NSData *data = [[LXUserDefault userDefault] objectForKey:@"useritem"];
    if (!data) {
        return nil;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    UserItem *item = [UserItem mj_objectWithKeyValues:dic];
    return item;
}


+(void)saveLocation:(double)lon lat:(double)lat{
    [[LXUserDefault userDefault] setObject:[NSString stringWithFormat:@"%f*%f", lon, lat] forKey:@"location"];
}

+(NSArray *)location{
    NSString *str = [[LXUserDefault userDefault] objectForKey:@"location"];
    if (str) {
        return [str componentsSeparatedByString:@"*"];
    }
    return @[@"113.800266",@"34.794991"];
}


+(void)clear{
    NSUserDefaults *defatluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [defatluts dictionaryRepresentation];
    for(NSString *key in [dictionary allKeys]){
        if (![key isEqualToString:@"userloginNum"] && ![key isEqualToString:@"timelineVC"]) {
            [defatluts removeObjectForKey:key];
        }
    }

}

+(NSUserDefaults *)userDefault{
    return [NSUserDefaults standardUserDefaults];
}


@end

