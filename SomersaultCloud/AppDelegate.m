//
//  AppDelegate.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/12.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "AFNetworkReachabilityManager.h"
#import "LXTabBarController.h"
#import "WXApi.h"


@interface AppDelegate ()<UNUserNotificationCenterDelegate, WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[LXTabBarController alloc] init];
    
    [self registerRemoteNotification:application];
    [self networkState];
    
    [WXApi registerApp:kWeChatAppID];
    return YES;
}


- (void)registerRemoteNotification:(UIApplication*)application{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 10){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound + UNAuthorizationOptionAlert + UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
            }
        }];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

-(void)networkState{
    [LXViewControllerManager shareManager].netState = 1;
    AFNetworkReachabilityManager * manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netReachChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

-(void)netReachChanged:(NSNotification *)notificaition{
    NSDictionary *userInfo = notificaition.userInfo;
    int state ;
    if ([userInfo[@"AFNetworkingReachabilityNotificationStatusItem"] intValue] == 0 || [userInfo[@"AFNetworkingReachabilityNotificationStatusItem"] intValue] == -1) {
        state = -1;
    }else{
        state = 1;
    }
    [LXViewControllerManager shareManager].netState = state;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"applicationState"];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    [self openURL:url];
    if(url != nil && [[url host] isEqualToString:@"pay"] /*|| [[url host] isEqualToString:@"oauth"] )*/){
        //微信支付
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

-(void)openURL:(NSURL *)url{
//    if ([url.host isEqualToString:@"safepay"]) {
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000){
//                [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccess object:nil];
//            }else{
//                [[NSNotificationCenter defaultCenter] postNotificationName:kPayFailed object:nil];
//            }
//        }];
//    }
//    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
//
//        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
//            if ([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000){
//                [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccess object:nil];
//            }else{
//                [[NSNotificationCenter defaultCenter] postNotificationName:kPayFailed object:nil];
//            }
//        }];
//    }
    
    
}

#pragma mark weChatDelegate
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        //发送媒体消息结果
    }
    if([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp* authResp = (SendAuthResp*)resp;
        
        switch (resp.errCode) {
            case WXSuccess:
                NSLog(@"RESP:code:%@,state:%@\n", authResp.code, authResp.state);
                [[LXNotifyManager shareInstance] postNotifyKey:kWechatAuthSuccess userInfo:@{@"code": authResp.code}];
//                [self wxGetAccessTokenWithCode:authResp.code];
                break;
            case WXErrCodeAuthDeny:
                break;
            case WXErrCodeUserCancel:
            default:
                break;
        }
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case WXSuccess: {
                [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccess object:nil];
                //...支付成功相应的处理，跳转界面等
                break;
            }
            case WXErrCodeUserCancel: {
                [[NSNotificationCenter defaultCenter] postNotificationName:kPayFailed object:nil];
                //...支付取消相应的处理
                break;
            }
            default: {
                [[NSNotificationCenter defaultCenter] postNotificationName:kPayFailed object:nil];
                //...做相应的处理，重新支付或删除支付
                break;
            }
        }
    }
    
}


@end
