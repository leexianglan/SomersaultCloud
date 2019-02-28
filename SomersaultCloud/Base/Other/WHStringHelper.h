//
//  StringHelper.h
//  CaoPanBao
//
//  Created by lxl on 14-5-8.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>




@interface WHStringHelper : NSObject

/** 
 日期增加前缀0
 2014-9-1 => 2014-09-01
 1-9 转为 01,02,03..09 */
+(NSString*)prefixDate:(int)value;

/**返回19:30:59*/
+(NSString*)timeDate:(NSDateComponents*)date;

/** 时间戳转nsdate */
+(NSDate*)dateByTimeStamp:(double)timestamp;

/** 返回05-21 19:30 */
+(NSString*)shortDate:(NSDateComponents*)date;

/** 返回2014-05-21 19:30 */
+(NSString*)longDateTime:(NSDateComponents*)date;
/** 返回 2016-08-10 12:20*/
+(NSString*)longDateTime7:(NSDate *)date;

/**  返回6/28*/
+(NSString*)longDateTime17:(NSDate *)date;

/** 返回7.12*/
+(NSString*)longDateTime117:(NSDate *)date;

/** 返回7月12日*/
+(NSString*)longDateTime127:(NSDate *)date;

/** 返回12：10*/
+(NSString*)longDateTime137:(NSDate *)date;

/** 返回2014-05-21 19:30:59 */
+(NSString*)longDateTime2:(NSDateComponents*)date;

/** 返回2014-05-21 19:30:59 */
+(NSString*)longDateTime3:(NSDate *)date;


+(NSString *)hourOfDate:(NSDate *)date;

/** 返回2014-05-21 00:00:00 省略时分秒为0 */
+(NSString*)longDateTime4:(NSDate *)date;

/**返回2014-05-21 省略时分秒*/
+(NSString*)longDateTime5:(NSDate *)date;


+(NSString*)shortDateByTimeStamp:(double)timestamp;

// 1608101230   16年8月10日12：30
+(NSString*)longDateTime8:(NSDate *)date;

/** 返回05-21 19:30 */
+(NSString*)longDateTime82:(NSDate *)date;

/** 根据时间戳返回 NSDateComponents ，从而获得年月日时分秒*/
+(NSDateComponents*)dateComponentByTimeStamp:(double)timestamp;

/** 
 获取字符串（如果目标为数字则强制转为字符串）
 */
+(NSString*)getStrByValue:(id)value;


//+(NSString *)getInterval;

/** 获取数组中的字符串 */
+(NSString*)getStrByArray:(id)array index:(int)index;

/** 获取数字（如果目标为字符串则强制转为数字） */
+(NSNumber*)getNumByValue:(id)value;

+(int)getIntByValue:(id)value;

/** 获取字典键值数据 */
+(NSString*)key:(NSString*)key dict:(NSDictionary *)dict;

/** 获取数据根据键值 */
+(NSArray*)arrayKey:(NSString*)key dict:(NSDictionary*)dict;

/** 获取短日期
 @param key 键名
 @param dict 字典
 */
+(NSString*)shortDateByTimeStampKey:(NSString*)key dict:(NSDictionary*)dict;

/** 判断是否有效的数据变量 */
+(BOOL)isNilByValue:(id)value;

/** 转换目标对象为布尔值
 （如果目标对象为1 返回 TRUE,YES 返回 TRUE, 0 返回 FALSE,NO 返回 FALSE ）
 */
+(BOOL)getBOOLByValue:(id)value;

/**输入的日期字符串形如：@"1992-05-21 13:08:08"*/
+(NSDate *)dateFromString:(NSString *)dateString;


/**输入的日期字符串形如：@"1992-05-21"*/
+(NSDate *)dateFromShortString:(NSString *)dateString;
/**
 iphone 输出如2010年2月25日星期几的时间格式 NSDate
 */
+(NSString*)dateAndWeekFromDate:(NSDate*)today;

/** 返回 2015年12月1日 */
+(NSString*)dateLocalFromDate:(NSDate*)date;


/** 返回短日期 2015.02 */
+(NSString*)shortDateTime:(NSDate *)date;


+(NSString*)year:(NSDate *)date;
+(NSString*)month:(NSDate *)date;
+(NSString*)day:(NSDate *)date;


/**
 处理只舍不入
 比如 float price = 0.126，怎么样才能得到0.12？
 */
+(NSString *)notRounding:( double )price afterPoint:( int )position;

+(BOOL)string:(NSString *)string containtsStr :(NSString *)str;

+(NSString *)string1:(NSString *)string1 removeString2:(NSString *)str;
+(NSString *)string1:(NSString *)string1 removeStringArr:(NSArray *)removeArr;


// inTime 2016-08-09 08:08:08
+(NSArray *)selectedDaysWithLongInTime:(NSString *)inTime outTimes:(NSString *)outTime;

+(NSString *)removeMicrosecond:(NSString *)time;

+(NSString *)subString:(NSString *)str WithStr:(NSString *)withStr;
+(CGFloat)getTimeIntervalTime:(NSString *)time;
+(NSString *)nextDayWithTime:(NSString *)time;
+(NSString *)interceptionString:(NSString *)time str:(NSString *)str;
+(BOOL)checkPhotoNum:(NSString *)phoneNum;
+(BOOL)checkCardID:(NSString *)cardID;
+(BOOL)checkNeedUpdateWithNetVer:(NSString *)netVer;
+(NSString *)returnFloatValue:(NSString *)str;
+(NSDictionary *)getEndTimeInterval:(NSString *)time;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+(NSArray *)sortedUpArr:(NSArray *)array;
+(BOOL)isNotEmpty:(NSString *)text;
+(NSString *)getFloatValue:(NSString *)oldValue length:(int)length;

@end


