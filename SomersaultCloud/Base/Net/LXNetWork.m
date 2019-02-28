//
//  LXNetWork.m
//  SomersaultCloud
//
//  Created by 李相兰 on 2018/9/12.
//  Copyright © 2018年 李相兰. All rights reserved.
//

#import "LXNetWork.h"

@implementation LXNetWork

+ (void)postDataWithParm:(NSDictionary *)parmDic url:(NSString *)url successBlock:(void(^)(NSDictionary *dic))successBlock errorBlock:(void(^)(NSError *error))errorBlock
{
    if (![LXNetWork netIsReachable]) {
        [[LXViewControllerManager shareManager] showHUD:@"网络连接异常，请稍后重试"];
        errorBlock(nil);
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    // 设置请求格式
    if ([LXUserDefault token]) {
        [manager.requestSerializer setValue:[LXUserDefault token] forHTTPHeaderField:@"skynet_token"];
    }

    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *comUrl = [NSString stringWithFormat:@"%@%@", host, url];
    
    [manager POST:comUrl parameters:parmDic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:nil];
        successBlock(resultDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorBlock(error);
    }];
}


+(void)uploadImageArr:(NSArray *)imgArr fileName:(NSArray *)fileArr  parm:(NSDictionary *)parmDic url:(NSString *)url successBlock:(void(^)(NSDictionary *dic))successBlock errorBlock:(void(^)(NSError *error))errorBlock{
    if (![LXNetWork netIsReachable]) {
        [[LXViewControllerManager shareManager] showHUD:@"网络连接异常，请稍后重试"];
        errorBlock(nil);
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",@"application/xml", @"multipart/form-data", nil];
    NSString *comUrl = [NSString stringWithFormat:@"%@%@", host, url];
    [manager POST:comUrl parameters:parmDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *fileName =@"";
        
        for (int i = 0 ; i < imgArr.count ; i++){
            UIImage *image = imgArr[i];
            NSString *file = @"file";
            if (fileArr.count >i){
                file = fileArr[i];
            }
            NSData *data = UIImageJPEGRepresentation(image, 0.5);
            fileName = [NSString stringWithFormat:@"%d.png", arc4random()%999+1000];
            [formData appendPartWithFileData:data name:file fileName:fileName mimeType:@"multipart/form-data"];
            
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock((NSDictionary *)responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorBlock(error);
    }];
    
}


+ (void)getDataWithParm:(NSDictionary *)parmDic url:(NSString *)url successBlock:(void(^)(NSDictionary *dic))successBlock errorBlock:(void(^)(NSError *error))errorBlock
{
    if (![LXNetWork netIsReachable]) {
        [[LXViewControllerManager shareManager] showHUD:@"网络连接异常，请稍后重试"];
        errorBlock(nil);
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if ([LXUserDefault token]) {
        [manager.requestSerializer setValue:[LXUserDefault token] forHTTPHeaderField:@"skynet_token"];
    }
    NSString *comUrl = [NSString stringWithFormat:@"%@%@", host, url];
    
    [manager GET:comUrl parameters:parmDic progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableContainers error:nil];
//        if ([NSJSONSerialization isValidJSONObject:responseObject]) {
//            NSLog(@"yes json");
//        }else{
//            NSLog(@"no json");
//        }
        successBlock(resultDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorBlock(error);
    }];
    
}




+(void)nativePost:(NSString *)urlString bodyparam:(NSDictionary *)param success:(SuccessBlock)successBlock faile:(FaileBlock)faileBlock contentType:(NSString *)contentType{
    if (![LXNetWork netIsReachable]) {
        [[LXViewControllerManager shareManager] showHUD:@"网络连接异常，请稍后重试"];
        faileBlock(nil);
        return;
    }
    NSString *comUrl = [NSString stringWithFormat:@"%@%@", host, urlString];
    //1.url
    NSURL *url = [NSURL URLWithString:comUrl];
    //2.创建可变的请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    //4.修改请求方法为POST
    request.HTTPMethod =@"POST";
//    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    if (!contentType) {
        contentType = @"application/json;charset=utf-8";
    }
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    if ([LXUserDefault token]) {
        [request addValue:[LXUserDefault token] forHTTPHeaderField:@"skynet_token"];
    }
    //    [request addValue:@"Jackpot" forHTTPHeaderField:@"User-Agent"];
    
    //有参数请求题
    if (param) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
        request.HTTPBody = jsonData;
    }
    //3.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError * _Nullable error) {
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //8.解析数据
        if (!error) {
            id dict = nil;
            if (data) {
                // 解析服务器返回的数据(返回的数据为JSON格式，因此使用NSJNOSerialization进行反序列化)
                dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//                NSHTTPURLResponse * da =(NSHTTPURLResponse *)response;
//                NSDictionary *allheadsFiles = da.allHeaderFields;
            }
            dispatch_group_async( dispatch_group_create(), kMainQueue, ^{
                if (dict) {
                    successBlock((NSDictionary *)dict);
                }else{
                    successBlock(nil);
                }
            });
        }else{
            faileBlock(error);
            NSLog(@"网络请求失败");
        }
        
        
    }];
    
    //7.执行任务
    [dataTask resume];
}


+(BOOL)netIsReachable{
    return [LXViewControllerManager shareManager].netState > 0;
}

@end
