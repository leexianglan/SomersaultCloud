//
//  LXViewControllerManager.m
// 
//
//  Created by 李相兰 on 2018/4/4.
//  Copyright © 2018年 . All rights reserved.
//

#import "LXViewControllerManager.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
#import <MapKit/MapKit.h>


@interface LXViewControllerManager()
@property(nonatomic, strong)MBProgressHUD *hud;




@end


@implementation LXViewControllerManager

+(LXViewControllerManager *)shareManager{
    static LXViewControllerManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LXViewControllerManager alloc] init];
    });
    return manager;
}



-(void)showHUD:(NSString *)message
{
    if (!message || [message isKindOfClass:[NSNull class]]) {
        [self.hud removeFromSuperview];
        return;
    }
    if (self.hud) {
        [self.hud removeFromSuperview];
    }
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    self.hud.userInteractionEnabled = NO;
    self.hud.mode = MBProgressHUDModeText;
    self.hud.detailsLabel.text = message;
    self.hud.detailsLabel.font = [UIFont systemFontOfSize:14*kEqualHeight];
    self.hud.margin = 10.0f;
    self.hud.removeFromSuperViewOnHide = YES;
    [self.hud hideAnimated:YES afterDelay:1.5];
}

-(void)showHUDOnly{
    if (self.hud) {
        [self.hud removeFromSuperview];
    }
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
//    self.hud.userInteractionEnabled = NO;
//    self.hud.dimBackground = NO;
    self.hud.margin = 10.0f;
}

-(void)hideHUD{
    if (self.hud) {
        [self.hud removeFromSuperview];
    }
}

-(void)showAlertView:(NSString *)title message:(NSString *)message{
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [self showAlertView:title message:message actions:@[action]];
}

-(void)showAlertView:(NSString *)title message:(NSString *)message actions:(NSArray *)actions{
    
    UIAlertController *ctr = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    for (UIAlertAction *action in actions) {
        [ctr addAction:action];
    }
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:ctr animated:YES completion:nil];
}


-(void)setThroughAttributedStringLbl:(UILabel *)lbl str:(NSString *)str throughColor:(UIColor*)color{
    NSUInteger length = str.length;
    if (!color) {
        color = k_9_Color;
    }
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:color range:NSMakeRange(0, length)];
    [lbl setAttributedText:attri];
}




-(void)setMutableAttributedStringLbl:(UILabel *)lbl strArr:(NSArray *)strArr colorArr:(NSArray*)colorArr{
    NSString *str = @"";
    for (NSString *string in strArr) {
        str = [str stringByAppendingString:string];
    }
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
    //修改颜色
    NSString *tempStr = @"";
    UIColor *color = k_3_Color;
    int count = 0;
    for (int i = 0; i < strArr.count; i++) {
        tempStr = strArr[i];
        if (i<colorArr.count) {
            color = colorArr[i];
        }
         [string addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(count, tempStr.length)];
        count += tempStr.length;
    }
    lbl.attributedText = string;
}

-(void)pushToLoginVCFromVC:(UIViewController *)vc toRootVC:(BOOL)toRoot{
    if (self.isLoginVC || [LXUserDefault userItem]) {
        return;
    }
    self.isLoginVC = YES;
    LoginViewController *ctr = [[LoginViewController alloc] init];
    ctr.toRootVC = toRoot;
    ctr.hidesBottomBarWhenPushed = YES;
//    [[LXNotifyManager shareInstance] postNotifyKey:kkkReloadMineVC];
    dispatch_async(kMainQueue, ^{
        [vc.navigationController pushViewController:ctr animated:YES];
    });
}





-(void)addEmptyView:(UIViewController *)ctr frame:(CGRect)frame title:(NSString *)title font:(CGFloat)font img:(NSString *)img bgColor:(UIColor *)bgColor{
    [self removeEmptyView:ctr];
    UITableView *tableView = nil;
    for (UIView *view in ctr.view.subviews) {
        if ([view isKindOfClass:[UITableView class]]) {
            tableView = (UITableView *)view;
        }
    }
    EmptyView *emptyView = [EmptyView shareView];
    if (bgColor) {
        emptyView.backgroundColor = bgColor;
    }
    if (img) {
        emptyView.imgView.image = [UIImage imageNamed:img];
    }
    if (font>0) {
        emptyView.lbl.font = [UIFont systemFontOfSize:font*kEqualHeight];
    }
    if (title) {
        emptyView.lbl.text  =title;
    }
    if (tableView) {
        emptyView.frame = tableView.bounds;
        [tableView addSubview:emptyView];
    }else{
        emptyView.frame = ctr.view.bounds;
        [ctr.view addSubview:emptyView];
    }
    if (CGRectGetHeight(frame)>0 && CGRectGetWidth(frame)>0) {
        emptyView.frame = frame;
    }
}

-(void)removeEmptyView:(UIViewController *)ctr{
    UITableView *tableView = nil;
    for (UIView *view in ctr.view.subviews) {
        if ([view isKindOfClass:[UITableView class]]) {
            tableView = (UITableView *)view;
        }
    }
    if (tableView) {
        for (UIView *view in tableView.subviews) {
            if (view.tag == 418) {
                [view removeFromSuperview];
            }
        }
    }else{
        for (UIView *view in ctr.view.subviews) {
            if (view.tag == 418) {
                [view removeFromSuperview];
            }
        }
    }
}



-(double)getCombinnationNum:(int)num num1:(int)num1{
    long long n =  [self getArrangement:num]/([self getArrangement:num1]*[self getArrangement:(num - num1)]);
    return n;
}

-(double)getArrangement:(int)num{
    if (num <= 0) {
        return 1;
    }
    double combinnation = 1;
    for (int i = 1; i<=num; i++) {
        combinnation *=i;
    }
    return combinnation;
}


-(NSString *)subString:(NSString *)string tailLength:(NSInteger)length{
    NSString *result = @"";
    if (!string || string.length < length) {
        return result;
    }
    result = [string substringFromIndex:string.length-length];
    return result;
}


-(CGFloat )heightForText:(NSString *)strText font:(CGFloat)font marginW:(CGFloat)marginW marginH:(CGFloat)marginH{
    
    CGRect rect= [strText boundingRectWithSize:CGSizeMake(kDeviceWidth-marginW, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font*kEqualHeight]} context:nil];
    CGFloat height = CGRectGetHeight(rect) + marginH;
    if (height>= kDeviceHeight) {
        return kDeviceHeight - 80;
    }
    return height;
}

-(CGFloat)getWidthWithContent:(NSString *)content font:(CGFloat)font{
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:font*kEqualHeight]};
    CGSize  size = [content boundingRectWithSize:CGSizeMake(kDeviceWidth, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size.width;
}

-(void)setIsLoginVC:(BOOL)isLoginVC{
    _isLoginVC = isLoginVC;
}


- (NSString *)imageToString:(UIImage *)image {
    
    NSData *imagedata = UIImagePNGRepresentation(image);
    
    NSString *image64 = [imagedata base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return image64;
}



- (UIImage *)createCodeImgWithText:(NSString *)text withSize:(CGFloat)size{
    
    //1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    
    NSString *urlStr = [@"jindouyun|" stringByAppendingString:text];
    NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    // 6. 将CIImage转换成UIImage，并显示于imageView上 (此时获取到的二维码比较模糊,所以需要用下面的createNonInterpolatedUIImageFormCIImage方法重绘二维码)
    
    CGRect extent = CGRectIntegral(outputImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:outputImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

-(void)fixFontWithView:(UIView *)sender{
    if (sender.subviews.count > 0) {
        for (UIView *v in sender.subviews) {
            [self realFixFontWithView:v];
        }
    }else{
        [self realFixFontWithView:sender];
    }
}

-(void)realFixFontWithView:(UIView*)v{
    if ([v isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)v;
        UIFont *font = label.font;
        label.font = [self newFontWithFont:font];
    }else if ([v isKindOfClass:[UITextView class]]){
        UITextView *textView = (UITextView *)v;
        UIFont *font = textView.font;
        textView.font = [self newFontWithFont:font];
    }else if ([v isKindOfClass:[UITextField class]]){
        UITextField *textField = (UITextField *)v;
        UIFont *font = textField.font;
        textField.font = [self newFontWithFont:font];
    }else if ([v isKindOfClass:[UIButton class]]){
        UIButton *button = (UIButton *)v;
        UIFont *font = button.titleLabel.font;
        button.titleLabel.font = [self newFontWithFont:font];
    }else if (v.subviews.count > 0){
        [self fixFontWithView:v];
    }
}

-(UIFont *)newFontWithFont:(UIFont*)font{
    return [UIFont fontWithName:font.fontName size:font.pointSize*kEqualHeight];
}

-(void)navActionWithCtr:(UIViewController*)controller lon:(NSString *)lon lat:(NSString*)lat name:(NSString *)name{
    UIAlertController *ctr = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]){
            UIAlertAction *baiduAction = [UIAlertAction actionWithTitle:@"使用百度地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self useBaiDuMapToNavigationLon:lon lat:lat name:name];
            }];
            [baiduAction setValue:k_3_Color forKey:@"_titleTextColor"];
            [ctr addAction:baiduAction];
            
        }
     if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
         UIAlertAction *gaodeAction  =[UIAlertAction actionWithTitle:@"使用高德地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self useGaoDeMapToNavigationLon:lon lat:lat name:name];
         }];
         [gaodeAction setValue:k_3_Color forKey:@"_titleTextColor"];
         [ctr addAction:gaodeAction];
     }
    
    UIAlertAction *appleAction = [UIAlertAction actionWithTitle:@"使用苹果地图导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self useAppleMapToNavigationLon:lon lat:lat name:name];
    }];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [appleAction setValue:k_3_Color forKey:@"_titleTextColor"];
    [cancleAction setValue:Color(255, 88, 76) forKey:@"_titleTextColor"];
    
    [ctr addAction:appleAction];
    [ctr addAction:cancleAction];
    [controller presentViewController:ctr animated:YES completion:nil];
}

// 百度导航
-(void)useBaiDuMapToNavigationLon:(NSString *)lon lat:(NSString*)lat name:(NSString *)name{
    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%@,%@|name:我的位置&destination=latlng:%@,%@|name:%@&mode=driving&coord_type=%@",[LXUserDefault location].lastObject, [LXUserDefault location].firstObject ,lat,lon,name,@"gcj02"] stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy]] ;
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
}

-(void)useGaoDeMapToNavigationLon:(NSString *)lon lat:(NSString*)lat name:(NSString *)name{
   
    NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%@&slon=%@&sname=我的位置&did=BGVIS2&dlat=%@&dlon=%@&dname=%@&dev=0&m=0&t=0", [LXUserDefault location].lastObject, [LXUserDefault location].firstObject , lat, lon, name] stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy]];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    
}

-(void)useAppleMapToNavigationLon:(NSString *)lon lat:(NSString*)lat name:(NSString *)name{
    
    CLLocationCoordinate2D coord2;
    coord2.latitude = [lat floatValue];
    coord2.longitude = [lon floatValue];
    
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coord2 addressDictionary:nil]];
    toLocation.name = name;
    NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
    NSDictionary *options ;
    options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
    //打开苹果自身地图应用，并呈现特定的item
    [MKMapItem openMapsWithItems:items launchOptions:options];
}


-(BOOL)checkEmptyText:(NSString *)text msg:(NSString *)msg{
    if (!text || [text isEqualToString:@""]) {
        [[LXViewControllerManager shareManager] showHUD:[NSString stringWithFormat:@"%@不能为空", msg]];
        return YES;
    }
    return NO;
}

-(NSString *)divided100:(NSString*)text{
    NSString *str = nil;
    if (text) {
        str = [NSString stringWithFormat:@"%.2f", [text floatValue]/100.f];
    }
    return str;
}

-(void)aggregatePay:(NSString *)urlString bodyparam:(NSDictionary *)param{
    [self showHUDOnly];
    NSString *comUrl = [NSString stringWithFormat:@"%@%@", host, urlString];
    //1.url
    NSURL *url = [NSURL URLWithString:comUrl];
    //2.创建可变的请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    //4.修改请求方法为POST
    request.HTTPMethod =@"POST";
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[LXUserDefault token] forHTTPHeaderField:@"skynet_token"];
    
    //有参数请求题
    if (param) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
        request.HTTPBody = jsonData;
    }
    //3.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError * _Nullable error) {

        dispatch_async(kMainQueue, ^{
            [self hideHUD];
            LXWebViewController *ctr = [[LXWebViewController alloc] init];
            ctr.data = data;
            [self.currentVC.navigationController pushViewController:ctr animated:YES];
        });
    }];
    
    //7.执行任务
    [dataTask resume];
}

@end

