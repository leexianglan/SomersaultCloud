//
//  StringHelper.m
//  CaoPanBao
//
//  Created by lxl on 14-5-8.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import "WHStringHelper.h"
//#import "NSDate-Extensions.h"

@implementation WHStringHelper
#pragma mark - date util
+(NSString*)prefixDate:(int)value{
    return  value<10?[NSString stringWithFormat:@"0%d",value]:[NSString stringWithFormat:@"%d",value];
}

+(NSString*)timeDate:(NSDateComponents*)date{
    NSString* hours=[self prefixDate:(int)date.hour];
    NSString* mins=[self prefixDate:(int)date.minute];
    NSString* sec=[self prefixDate:(int)date.second];
    
    NSString* dd=[NSString stringWithFormat:@"%@:%@:%@",hours,mins,sec];
    return dd;
}

+(NSString*)shortDate:(NSDateComponents*)date{
    NSString* month=[self prefixDate:(int)date.month];
    NSString* day=[self prefixDate:(int)date.day];
    NSString* hours=[self prefixDate:(int)date.hour];
    NSString* mins=[self prefixDate:(int)date.minute];
    NSString* sec=[self prefixDate:(int)date.second];
    
    NSString* dd=[NSString stringWithFormat:@"%@-%@ %@:%@:%@",month,day,hours,mins,sec];
    return dd;
}

+(NSString*)longDateTime:(NSDateComponents*)date{
    NSString* year=[self prefixDate:(int)date.year];
    NSString* month=[self prefixDate:(int)date.month];
    NSString* day=[self prefixDate:(int)date.day];
    NSString* hours=[self prefixDate:(int)date.hour];
    NSString* mins=[self prefixDate:(int)date.minute];
//    NSString* sec=[self prefixDate:date.second];
    
    NSString* dd=[NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hours,mins];
    return dd;
}

+(NSString*)longDateTime2:(NSDateComponents*)date{
    NSString* year=[self prefixDate:(int)date.year];
    NSString* month=[self prefixDate:(int)date.month];
    NSString* day=[self prefixDate:(int)date.day];
    NSString* hours=[self prefixDate:(int)date.hour];
    NSString* mins=[self prefixDate:(int)date.minute];
    NSString* sec=[self prefixDate:(int)date.second];
    
    NSString* dd=[NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",year,month,day,hours,mins,sec];
    return dd;
}



+(NSString *)longDateTimeTime:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:date];
    
    NSString* timeString=[WHStringHelper longDateTimeTime2:components];
    
    return timeString;
}

+(NSString*)longDateTimeTime2:(NSDateComponents*)date{
    NSString* year=[self prefixDate:(int)date.year];
    NSString* month=[self prefixDate:(int)date.month];
    NSString* day=[self prefixDate:(int)date.day];
    NSString* hours=[self prefixDate:(int)date.hour];
    NSString* mins=[self prefixDate:(int)date.minute];
    NSString* sec=[self prefixDate:(int)date.second];
    
    NSString* dd=[NSString stringWithFormat:@"%@%@%@_%@%@%@",year,month,day,hours,mins,sec];
    return dd;
}


+(NSString*)longDateTime3:(NSDate *)date
{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:date];
    
    NSString* timeString=[WHStringHelper longDateTime2:components];

    return timeString;
    
}

+(NSString*)longDateTime7:(NSDate *)date
{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:date];
    
    NSString* timeString=[WHStringHelper longDateTime:components];
    
    return timeString;
    
}

+(NSString *)hourOfDate:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:date];
    NSString* hours=[NSString stringWithFormat:@"%d", (int)components.hour];
    return hours;
}

+(NSString*)longDateTime17:(NSDate *)date
{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:date];
    
    

    NSString* month=[self prefixDate:(int)components.month];
    NSString* day=[self prefixDate:(int)components.day];
    
    return [NSString stringWithFormat:@"%@/%@", month, day];
    
}

+(NSString*)longDateTime117:(NSDate *)date
{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:date];
    
    return [NSString stringWithFormat:@"%d.%d", (int)components.month, (int)components.day];
    
}


+(NSString*)longDateTime127:(NSDate *)date
{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:date];
    
    return [NSString stringWithFormat:@"%d月%d日", (int)components.month, (int)components.day];
    
}

+(NSString*)longDateTime137:(NSDate *)date
{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:date];
    
    return [NSString stringWithFormat:@"%@-%@ %@:%@",[self prefixDate:(int)components.month], [self prefixDate:(int)components.day], [self prefixDate:(int)components.hour], [self prefixDate:(int)components.minute]];
    
}

+(NSString*)longDateTime81:(NSDateComponents*)date{
    NSString* year=[self prefixDate:(int)date.year];
    if (year.length == 4) {
        year = [year substringFromIndex:2];
    }
    NSString* month=[self prefixDate:(int)date.month];
    NSString* day=[self prefixDate:(int)date.day];
    NSString* hours=[self prefixDate:(int)date.hour];
    NSString* mins=[self prefixDate:(int)date.minute];
    //    NSString* sec=[self prefixDate:date.second];
    
    NSString* dd=[NSString stringWithFormat:@"%@%@%@%@%@",year,month,day,hours,mins];
    return dd;
}

+(NSString*)longDateTime82:(NSDate *)date{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:date];
    NSString* month=[self prefixDate:(int)components.month];
    NSString* day=[self prefixDate:(int)components.day];
    NSString* hours=[self prefixDate:(int)components.hour];
    NSString* mins=[self prefixDate:(int)components.minute];
    //    NSString* sec=[self prefixDate:date.second];
    
    NSString* dd=[NSString stringWithFormat:@"%@-%@ %@:%@",month,day,hours,mins];
    return dd;
}

// 1608101230   16年8月10日12：30
+(NSString*)longDateTime8:(NSDate *)date
{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:date];
    
    NSString* timeString=[WHStringHelper longDateTime81:components];
    
    return timeString;
    
}

+(NSString*)longDateTime4:(NSDate *)date
{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:date];
    
    NSString* year=[self prefixDate:(int)components.year];
    NSString* month=[self prefixDate:(int)components.month];
    NSString* day=[self prefixDate:(int)components.day];
    NSString* hours=@"00";
    NSString* mins=@"00";
    NSString* sec=@"00";
    
    NSString* dd=[NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",year,month,day,hours,mins,sec];

    return dd;

}

+(NSString*)dateLocalFromDate:(NSDate*)date
{
    if (!date) {
        return @"";
    }
    NSDateComponents *components = [[NSCalendar currentCalendar] components:kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:date];
    
    NSString* year=[self prefixDate:(int)components.year];
    NSString* month=[self prefixDate:(int)components.month];
    NSString* day=[self prefixDate:(int)components.day];
    
    NSString* dd=[NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
    
    return dd;
}

+(NSString*)longDateTime5:(NSDate *)date
{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:date];
    
    NSString* year=[self prefixDate:(int)components.year];
    NSString* month=[self prefixDate:(int)components.month];
    NSString* day=[self prefixDate:(int)components.day];
    
    NSString* dd=[NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    
    return dd;
    
}

+(NSString*)year:(NSDate *)date
{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:date];
    
    NSString* year=[self prefixDate:(int)components.year];
    
    NSString* dd=[NSString stringWithFormat:@"%@",year];
    
    return dd;
    
}

+(NSString*)month:(NSDate *)date
{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:date];
    
    NSString* month=[self prefixDate:(int)components.month];
    
    NSString* dd=[NSString stringWithFormat:@"%@",month];
    
    return dd;
    
}

+(NSString*)day:(NSDate *)date
{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:date];
    

    NSString* day=[self prefixDate:(int)components.day];
    
    NSString* dd=[NSString stringWithFormat:@"%@",day];
    
    return dd;
    
}




/** 返回短日期 2015.02 */
+(NSString*)shortDateTime:(NSDate *)date
{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:date];
    
    NSString* year=[self prefixDate:(int)components.year];
    NSString* month=[self prefixDate:(int)components.month];
    
    NSString* dd=[NSString stringWithFormat:@"%@.%@",year,month];
    
    return dd;
    
}

+(NSDateComponents*)dateComponentByTimeStamp:(double)timestamp{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:confromTimesp];
    return components;
}

+(NSString*)shortDateByTimeStamp:(double)timestamp{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:confromTimesp];
    return [self shortDate:components];
}

+(NSDate*)dateByTimeStamp:(double)timestamp{
   return [NSDate dateWithTimeIntervalSince1970:timestamp];
}

#pragma string helper

+(NSString*)getStrByNum:(NSNumber*)val{
    if(val)
        return [val stringValue];
    else
        return nil;
}

+(NSString*)getStrByStr:(NSString*)str{
    if(str)
        return str;
    else
        return nil;
}

+(NSString*)getStrByValue:(id)value{
    if(!value)
        return nil;
    
    if([value isKindOfClass:[NSString class]])
    {
        return [self getStrByStr:value];
    }
    else if([value isKindOfClass:[NSNumber class]])
    {
        return [self getStrByNum:value];
    }
    
    return nil;
}

+(NSString*)getStrByArray:(id)array index:(int)index{
     id obj= [array objectAtIndex:index];
    return [WHStringHelper getStrByValue:obj];
}

+(NSNumber*)getNumByValue:(id)value{
    NSNumber* result=nil;
    
    if(!value)
        return nil;
    
    if([value isKindOfClass:[NSString class]])
    {
        result=[NSNumber numberWithInt:[value intValue]];
    }
    
    if([value isKindOfClass:[NSNumber class]])
    {
        result=value;
    }
    
    return result;
}

+(int)getIntByValue:(id)value{
    id obj=[self getNumByValue:value];
    if(!obj)
        return 0;
    
    return [obj intValue];
}


+(NSString*)key:(NSString*)key dict:(NSDictionary *)dict{
    if([dict isKindOfClass:[NSNull class]])
        return nil;
    
    if(!dict)
        return nil;
        
    id result=[dict objectForKey:key];
    if([result isKindOfClass:[NSNumber class]])
    {
        result=[result stringValue];
    }
    return result;
}

+(NSArray*)arrayKey:(NSString*)key dict:(NSDictionary*)dict{
    id result=[dict objectForKey:key];
    return result;
}

+(NSString*)shortDateByTimeStampKey:(NSString*)key dict:(NSDictionary*)dict
{
    NSString* result=nil;
    result=[dict objectForKey:key];
    
    if(result)
    {
        result=[WHStringHelper shortDateByTimeStamp:[result doubleValue]];
    }
    
    return result;
}

+(BOOL)isNilByValue:(id)value{
    BOOL isNil=NO;
    
    if(value==nil)
        return YES;
    
    if([value isKindOfClass:[NSNull class]])
        return YES;
    
    Class clsJKArray= NSClassFromString(@"JKArray");
    
    if([value isKindOfClass:clsJKArray])
    {
        if([(NSArray *)value count]==0)
            isNil= YES;
    }
    
    Class clsJKDictionary=NSClassFromString(@"JKDictionary");
    if([value isKindOfClass:clsJKDictionary])
    {
        if([[value allKeys] count]==0)
            isNil= YES;
    }
    
    if([value isKindOfClass:[NSDictionary class]])
    {
        if([[value allKeys] count]==0)
            isNil= YES;
    }
    
    if([value isKindOfClass:[NSArray class]])
    {
        if([(NSArray *)value count]==0)
            isNil= YES;
    }
    
    
    return isNil;
}

+(BOOL)getBOOLByValue:(id)value{
    NSString* str=[WHStringHelper getStrByValue:value];
    if(!str)
        return NO;
    
    
    if([str isEqualToString:@"1"])
        return YES;
    
    else if([str isEqualToString:@"0"])
        return NO;
    
    else if([str isEqualToString:@"YES"])
        return YES;
    
    else if ([str isEqualToString:@"NO"])
        return NO;
    
    return NO;
}

/**输入的日期字符串形如：@"1992-05-21 13:08:08"*/
+(NSDate *)dateFromString:(NSString *)dateString{
    
    if (!dateString || [dateString isEqualToString:@""]) {
        return [NSDate date];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}

/**输入的日期字符串形如：@"1992-05-21"*/
+(NSDate *)dateFromShortString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}

/**
 iphone 输出如2010年2月25日星期几的时间格式 NSDate
 */
+(NSString*)dateAndWeekFromDate:(NSDate*)today{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    
//    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:(kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay | kCFCalendarUnitWeekday) fromDate:today];
    
    NSDictionary* week=@{
                         @"0": @"一",
                         @"1": @"二",
                         @"2": @"三",
                         @"3": @"四",
                         @"4": @"五",
                         @"5": @"六",
                         @"6": @"日"
                         };
    
    NSString* key= [NSString stringWithFormat:@"%d", [self weekDayWithDate:today]];/// fffIntToStr([self weekDayWithDate:today]);
    
    NSString *timeString = [NSString stringWithFormat:@"%d-%d-%d 星期%@",(int)[components year],(int)[components month], (int)[components day], week[key]];
    
    return timeString;
}

/***
 ***根据日期计算周几
 ****/
+(int)weekDayWithDate:(NSDate *)fromdate{
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    
//    NSDate *fromdate=[dateFormatter dateFromString:date];
    
    
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    NSDateComponents *weekDayComponents = [gregorian components:kCFCalendarUnitWeekday|kCFCalendarUnitWeekday fromDate:fromdate];
    
    NSInteger mDay = [weekDayComponents weekday];
    
//    [dateFormatter release];
    
//    NSString *week=@"";
    int week=0;
    
    switch (mDay) {
            
        case 0:{
            
//            week=@"日";
            week=5;
            break;
            
        }
            
        case 1:{
            
//            week=@"日";
            week=6;
            break;
            
        }
            
        case 2:{
            
//            week=@"一";
            week=0;
            break;
            
        }
            
        case 3:{
            
//            week=@"二";
            week=1;
            break;
            
        }
            
        case 4:{
            
//            week=@"三";
            week=2;
            break;
            
        }
            
        case 5:{
            
//            week=@"四";
            week=3;
            break;
            
        }
            
        case 6:{
            
//            week=@"五";
            week=4;
            break;
            
        }
            
        case 7:{
            
//            week=@"六";
            week=5;
            break;
            
        }
            
        default:{
            
            break;
            
        }
            
    };
    
    return week;
    
}

/**
 处理只舍不入
 比如 float price = 0.126，怎么样才能得到0.12？
 */
+(NSString *)notRounding:( double )price afterPoint:( int )position{
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness: NO  raiseOnOverflow: NO  raiseOnUnderflow: NO  raiseOnDivideByZero: NO ];
    
    NSDecimalNumber *ouncesDecimal;
    
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return  [NSString stringWithFormat: @"%@" ,roundedOunces];
    
}
//+(NSString*)removeLastString:(NSString *)lastString orginString:(NSMutableString *)orginString{
//    if(orginString.length>0)
//    {
//        NSString* str= [orginString substringFromIndex:[orginString length]-1];
//        
//        if([str isEqualToString:@","])
//        {
//            NSRange range;
//            range.length=1;
//            range.location=[orginString length]-1;
//            [orginString deleteCharactersInRange:range];
//        }
//    }
//    
//    return orginString;
//}

+(BOOL)string:(NSString *)string containtsStr :(NSString *)str{
    if (!string || !str ) {
        return NO;
    }
    if ([string rangeOfString:str].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+(NSString *)string1:(NSString *)string1 removeString2:(NSString *)str{
    if (!string1) {
        return nil;
    }
    if (!str) {
        return string1;
    }
    return [[NSMutableString stringWithString:string1] stringByReplacingOccurrencesOfString:str withString:@""];
}

+(NSString *)string1:(NSString *)string1 removeStringArr:(NSArray *)removeArr{
    if (!string1) {
        return nil;
    }
    if (!removeArr) {
        return string1;
    }
    NSString *result = string1;
    for (NSString *str in removeArr) {
        result = [WHStringHelper string1:result removeString2:str];
    }
    return result;
}




// inTime 2016-08-09 08:08:08
//+(NSArray *)selectedDaysWithLongInTime:(NSString *)inTime outTimes:(NSString *)outTime{
//
//    if (!inTime || !outTime) {
//        return @[];
//    }
//
//    NSArray *inArr = [inTime componentsSeparatedByString:@" "];
//    inTime = inArr[0];
//    NSArray *outArr = [outTime componentsSeparatedByString:@" "];
//    outTime = outArr[0];
//
//    NSMutableArray *result = [NSMutableArray array];
//
//    NSDate *inDate = [WHStringHelper dateFromShortString:inTime];
//    NSDate *outDate = [WHStringHelper dateFromShortString:outTime];
//    [result addObject:[NSString stringWithFormat:@"%@",[WHStringHelper longDateTime5:inDate]]];
//    int outDay = [outDate getTimeInt];
//    NSDate *nextDate = [inDate dateByAddingTimeInterval:24 * 3600];
//    int nextDay = [nextDate getTimeInt];
//    while (nextDay < outDay) {
//        NSString *nextStr =[NSString stringWithFormat:@"%@",[WHStringHelper longDateTime5:nextDate]];
//        [result addObject:nextStr];
//        nextDate = [nextDate dateByAddingTimeInterval:24*3600];
//        nextDay = [nextDate getTimeInt];
//    }
//
//    return result;
//}

//+(NSString *)getInterval{
//    double time = [[NSDate date] timeIntervalSince1970];
//    return [NSString stringWithFormat:@"%@_%.f_%d", kkkConfig.userId,time, arc4random()%100];
//}

+(NSString *)removeMicrosecond:(NSString *)time{
    NSString *result = @"";
    if (!time) {
        return result;
    }
    NSArray *timeArr = [time componentsSeparatedByString:@"."];
    result = timeArr[0];
    return result;
}

+(BOOL)checkPhotoNum:(NSString *)phoneNum{
    if (!phoneNum) {
        return NO;
    }
    NSString *num = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *numPre = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", num];
    return [numPre evaluateWithObject:phoneNum];
}

+(BOOL)checkCardID:(NSString *)cardID{
    NSString *regex = @"[0-9]{17}[[0-9],0-9xX]";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:cardID];
}


+(NSString *)subString:(NSString *)str WithStr:(NSString *)withStr{
    NSString *result = @"";
    if (!str) {
        return result;
    }
    if (!withStr) {
        return str;
    }
    NSArray *timeArr = [str componentsSeparatedByString:withStr];
    result = timeArr[0];
    return result;
}


+(CGFloat)getTimeIntervalTime:(NSString *)time{
    if (!time) {
        return 0;
    }
    double timeS = [[WHStringHelper dateFromString:time] timeIntervalSinceNow];
    return timeS;
}


+(NSString *)interceptionString:(NSString *)time str:(NSString *)str{
    NSString *result = @"";
    if (!time) {
        return result;
    }
    NSArray *timeArr = [time componentsSeparatedByString:str];
    result = timeArr[0];
    return result;
}


+(NSString *)nextDayWithTime:(NSString *)time{
    if (!time) {
        return @"";
    }
    NSString *next = [WHStringHelper longDateTime5:[[WHStringHelper dateFromShortString:time] dateByAddingTimeInterval:-1 *24*3600]];
    return next ? next :@"";
}


+(BOOL)checkNeedUpdateWithNetVer:(NSString *)netVer{
    NSString *ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (!netVer || !ver) {
        return NO;
    }
    netVer = [netVer stringByReplacingOccurrencesOfString:@"." withString:@""];
    ver = [ver stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (netVer.length == ver.length) {
        if ([netVer intValue] == [ver intValue]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"brightness"];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"brightness"];
        }
        return [netVer intValue] > [ver intValue];
    }else{
        int length = (int)netVer.length;
        for (int i = length; i < 5; i++) {
            netVer = [NSString stringWithFormat:@"%@0", netVer];
        }
        length = (int)ver.length;
        for (int i = length; i < 5; i++) {
            ver = [NSString stringWithFormat:@"%@0", ver];
        }
        
        if ([netVer intValue] == [ver intValue]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"brightness"];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"brightness"];
        }
        
        return [netVer intValue] > [ver intValue];
    }
}

+(NSString *)returnFloatValue:(NSString *)str{
    if (!str) {
        return @"0.0";
    }
    if ([str floatValue] != 0) {
        int intValue = [str intValue] *100;
        float fValue = [str floatValue]*100+0.2;
        float errValue = fabsf(fValue - intValue);
        if ((int)errValue % 10 > 0) {
            return [NSString stringWithFormat:@"%.2f", [str floatValue]];
        }
        return [NSString stringWithFormat:@"%.1f", [str floatValue]];
        
    }
    return @"0.0";
}


+(NSDictionary *)getEndTimeInterval:(NSString *)time{
    NSDictionary *dic = nil;
    if (time) {
        time = [WHStringHelper removeMicrosecond:time];
        NSDate *date = [WHStringHelper dateFromString:time];
        double errInterval = [date timeIntervalSinceNow];
        if (errInterval <= 0) {
            return dic;
        }
        NSString *day = [self prefixDate:(int)(errInterval/60/60/24)];
        NSString *hour = [self prefixDate:((int)(errInterval/60/60)%24)];
        NSString *min = [self prefixDate:(int)(errInterval/60)%60];
        NSString *sec = [self prefixDate:(int)errInterval%60];
        dic = @{@"day":day,@"hour":hour,@"min":min,@"sec":sec};
    }
    return dic;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


+(NSArray *)sortedUpArr:(NSArray *)array{
    if (!array) {
        return @[];
    }
    return [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 intValue] > [obj2 intValue];
    }];
}

+(BOOL)isNotEmpty:(NSString *)text{
    return (text && ![text isEqualToString:@""]);
}

+(NSString *)getFloatValue:(NSString *)oldValue length:(int)length{
    if (!oldValue) {
        return @"0";
    }
    oldValue = [NSString stringWithFormat:@"%@", oldValue];
    if (length > 2) {
        length = 2;
    }else if (length <= 0){
        return [NSString stringWithFormat:@"%d", [oldValue intValue]];
    }
    NSArray *arr = [oldValue componentsSeparatedByString:@"."];
    if (arr.count == 2) {
        NSString *string = arr[1];
        if (string.length == 1) {
            oldValue = [oldValue stringByAppendingString:@"0"];
        }
        if (string.length > 2) {
            oldValue = [[arr[0] stringByAppendingString:@"."] stringByAppendingString:[string substringToIndex:length]];
        }
    }else{
        oldValue = [oldValue stringByAppendingString:@"."];
        for (int i = 0; i < length; i++) {
            oldValue = [oldValue stringByAppendingString:@"0"];
        }
    }
    return oldValue;
}



@end


