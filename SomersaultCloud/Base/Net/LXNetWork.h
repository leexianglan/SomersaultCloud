//
//  LXNetWork.h
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/12.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(NSDictionary* dic);                                 // 成功返回的数据
typedef void(^FaileBlock)(NSError * error);
static NSString *host = @"http://49.4.53.159/";//  @"http://www.hnjindouyun.com/";


#define HOST_ALIPAY_NOTIFYURL                      [NSString stringWithFormat:@"%@%@", host, @""]
#define HOST_WEIXINPAY_NOTIFYURL                 [NSString stringWithFormat:@"%@%@", host, @""]
@interface LXNetWork : NSObject


+ (void)postDataWithParm:(NSDictionary *)parmDic url:(NSString *)url successBlock:(void(^)(NSDictionary *dic))successBlock errorBlock:(void(^)(NSError *error))errorBlock;
+ (void)getDataWithParm:(NSDictionary *)parmDic url:(NSString *)url successBlock:(void(^)(NSDictionary *dic))successBlock errorBlock:(void(^)(NSError *error))errorBlock;
+(void)nativePost:(NSString *)urlString bodyparam:(NSDictionary *)param success:(SuccessBlock)successBlock faile:(FaileBlock)faileBlock contentType:(NSString *)contentType;
+(void)uploadImageArr:(NSArray *)imgArr fileName:(NSArray *)fileArr  parm:(NSDictionary *)parmDic url:(NSString *)url successBlock:(void(^)(NSDictionary *dic))successBlock errorBlock:(void(^)(NSError *error))errorBlock;


@end
