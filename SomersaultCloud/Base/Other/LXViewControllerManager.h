//
//  LXViewControllerManager.h
// 
//
//  Created by 李相兰 on 2018/4/4.
//  Copyright © 2018年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LXUserDefault.h"
#import "LXNetWork.h"
#import "LXNetWorkManager.h"
#import "LineView.h"
#import <MJRefresh/MJRefresh.h>
#import "MJExtension.h"
#import "UIImage+KKCategory.h"
#import "NSDictionary+Property.h"
#import "NSString+KKCategory.h"
#import "WHStringHelper.h"
#import "LXButton.h"
#import "LXTableCell.h"
#import "LXNotifyManager.h"
#import "LXButtonWithRotaingImg.h"
#import "EmptyView.h"
#import "LXBaseController.h"
#import "LXWebViewController.h"

typedef void(^LXViewControllerManagerBlock)(id item);
#define kMainQueue dispatch_get_main_queue()
@interface LXViewControllerManager : NSObject

@property(nonatomic, strong)LXBaseController *currentVC;
@property(nonatomic, assign)BOOL isLoginVC;
@property(nonatomic, assign)int netState;


+(LXViewControllerManager *)shareManager;


-(void)showHUD:(NSString *)message;
-(void)showHUDOnly;
-(void)hideHUD;
-(void)showAlertView:(NSString *)title message:(NSString *)message;
-(void)showAlertView:(NSString *)title message:(NSString *)message actions:(NSArray *)actions;
-(void)setThroughAttributedStringLbl:(UILabel *)lbl str:(NSString *)str throughColor:(UIColor*)color;
-(void)setMutableAttributedStringLbl:(UILabel *)lbl strArr:(NSArray *)strArr colorArr:(NSArray*)colorArr;
-(void)pushToLoginVCFromVC:(UIViewController *)vc toRootVC:(BOOL)toRoot;


-(void)addEmptyView:(UIViewController *)ctr frame:(CGRect)frame title:(NSString *)title font:(CGFloat)font img:(NSString *)img bgColor:(UIColor *)bgColor;
-(void)removeEmptyView:(UIViewController *)ctr;


-(double)getCombinnationNum:(int)num num1:(int)num1;
-(double)getArrangement:(int)num;

-(NSString *)subString:(NSString *)string tailLength:(NSInteger)length;

-(CGFloat )heightForText:(NSString *)strText font:(CGFloat)font marginW:(CGFloat)marginW marginH:(CGFloat)marginH;

-(CGFloat)getWidthWithContent:(NSString *)content font:(CGFloat)font;
- (UIImage *)createCodeImgWithText:(NSString *)text withSize:(CGFloat)size;
-(void)fixFontWithView:(UIView *)sender;
-(void)navActionWithCtr:(UIViewController*)controller lon:(NSString *)lon lat:(NSString*)lat name:(NSString *)name;
-(BOOL)checkEmptyText:(NSString *)text msg:(NSString *)msg;
-(NSString *)divided100:(NSString*)text;

/**
 使用聚合支付
 */
-(void)aggregatePay:(NSString *)urlString bodyparam:(NSDictionary *)param;
@end

