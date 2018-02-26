//
//  LJUtil.m
//  MyUtil
//
//  Created by ljie on 2016/8/4.
//  Copyright © 2017年 ljie. All rights reserved.
//

#import "LJUtil.h"

@implementation LJUtil

//当前语言是中文还是英文
+ (BOOL)currentLanguageIsChinese {
    //获取当前系统语言
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    if ([preferredLang hasPrefix:@"zh"]) {
        return YES;
    } else {
        return NO;
    }
}

//获取字符串首字母(传入汉字字符串, 返回大写拼音首字母)
//传入英文shangHai，返回的是将首字母改为大写Shanghai，传入的是汉字上海，返回的则是Shang Hai，中间有空格
+ (NSString *)getFirstLetterFromString:(NSString *)aString {
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *strPinYin = [str capitalizedString];
    //获取并返回首字母为大写的字符串
    return strPinYin;
}

+ (UIColor *)hexStringToColor:(NSString *)stringToConvert {
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return [UIColor blackColor];
    
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6)
        return [UIColor blackColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((CGFloat) r / 255.0f)
                           green:((CGFloat) g / 255.0f)
                            blue:((CGFloat) b / 255.0f)
                           alpha:1.0f];
}

+ (UIColor *)colorWithHexNumber:(NSUInteger)hexColor {
    CGFloat r = ((hexColor >> 16) & 0xFF) / 255.0f;
    CGFloat g = ((hexColor >> 8) & 0xFF) / 255.0f;
    CGFloat b = (hexColor & 0xFF) / 255.0f;
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0f];
}

//计算两个日期之间的天数
+ (NSInteger)getDaysFromNowToEnd:(NSDate *)endDate {
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *beginDate = [NSDate date];
    
    //取两个日期对象的时间间隔：
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
    NSTimeInterval time = [endDate timeIntervalSinceDate:beginDate];
    
    int days=((int)time)/(3600*24);
    int a = ((int)time)%(3600*24);
    if (a == 0) {
        return days;//只取到天数
    } else {
        if (a > 0) {//未来
            return days+1;
        } else {//过去
            return days;
        }
    }
}

//获取当前时间字符串 时间戳
+ (NSString *)getNowDateTimeString {
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    NSLog(@"时间戳%@", timeString);
    return timeString;
}

//0点的今天时间戳
+ (NSString *)getZeroWithTimeInterverl {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@ 00:00:00", today]];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", [date timeIntervalSince1970]];//转为字符型
    
    NSLog(@"时间戳%@", timeString);
    return timeString;
}

//某天0点的时间戳
+ (NSString *)getZeroTimeInterverlWithDateStr:(NSString *)dateStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@ 00:00:00", dateStr]];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", [date timeIntervalSince1970]];//转为字符型
    
    NSLog(@"时间戳%@", timeString);
    return timeString;
}

//获取当前的时间
+ (NSString*)getCurrentTimes {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY.MM.dd HH:mm"];
    
    //当前时间,
    NSDate *datenow = [NSDate date];
    
    //将date按formatter格式转成string
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"当前时间 =  %@",currentTimeString);
    return currentTimeString;
}

//将时间点转化成日历形式
- (NSDate *)getCustomDateWithHour:(NSInteger)hour {
    //获取当前时间
    NSDate * destinationDateNow = [NSDate date];
    
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    currentComps = [currentCalendar components:unitFlags fromDate:destinationDateNow];
    
    //设置当前的时间点
    
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    
    [resultComps setYear:[currentComps year]];
    
    [resultComps setMonth:[currentComps month]];
    
    [resultComps setDay:[currentComps day]];
    
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
    
}

//获取时间段
+ (NSString *)getTheTimeBucket {
    NSDate * currentDate = [NSDate date];
    
    if ([currentDate compare:[[[LJUtil alloc] init] getCustomDateWithHour:0]] == NSOrderedDescending && [currentDate compare:[[[LJUtil alloc] init] getCustomDateWithHour:9]] == NSOrderedAscending) {
        return NSLocalizedString(@"morning", nil);
        
    } else if ([currentDate compare:[[[LJUtil alloc] init] getCustomDateWithHour:9]] == NSOrderedDescending && [currentDate compare:[[[LJUtil alloc] init] getCustomDateWithHour:11]] == NSOrderedAscending) {
        return NSLocalizedString(@"a.m", nil);
        
    } else if ([currentDate compare:[[[LJUtil alloc] init] getCustomDateWithHour:11]] == NSOrderedDescending && [currentDate compare:[[[LJUtil alloc] init] getCustomDateWithHour:13]] == NSOrderedAscending) {
        return  NSLocalizedString(@"midday", nil);

    } else if ([currentDate compare:[[[LJUtil alloc] init] getCustomDateWithHour:13]] == NSOrderedDescending && [currentDate compare:[[[LJUtil alloc] init] getCustomDateWithHour:18]] == NSOrderedAscending) {
        return NSLocalizedString(@"p.m", nil);
    } else {
        return NSLocalizedString(@"night", nil);
    }
}

//时间戳转为时间字符串
+ (NSString *)timeInterverlToDateStr:(NSString *)timeStr {
    //timeStr时间戳
    NSTimeInterval time=[timeStr doubleValue];//因为时差问题要加8小时 == 28800 sec
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSLog(@"date:%@",[detaildate description]);
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

//获取当前日期的n天前或n天后
//n为负数，为n天前，n为正数为n天后
+ (NSString *)getNDay:(NSInteger)n dateType:(NSString *)dateType {
    NSDate *nowDate = [NSDate date];
    NSDate *theDate;
    
    if (n != 0) {
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow: oneDay*n ];//initWithTimeIntervalSinceNow是从现在往前后推的秒数
    } else {
        theDate = nowDate;
    }
    
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:dateType];
    NSString *the_date_str = [date_formatter stringFromDate:theDate];
    
    return the_date_str;
}


//字符串转size 自适应高度
+ (CGSize)initWithSize:(CGSize)size string:(NSString *)string font:(NSInteger)font {
    NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:font]};
    CGSize sizes = [string boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return sizes;
}


#pragma mark - yty
/**
 时间戳转时间字符串
 
 @param timeInterval 时间戳
 @param formatter 时间格式
 @return <#return value description#>
 */
+ (NSString *)dateWithTimeInterval:(NSInteger)timeInterval formatter:(NSString *)formatter {
    formatter = formatter.length == 0 ? @"YYYY-MM-dd HH:mm" : formatter;
    NSTimeInterval time=timeInterval;
    NSDate * detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:formatter];
    NSString * currentDateStr = [dateFormatter stringFromDate:detaildate];
    return currentDateStr;
}

+ (NSDate *)getNowDate
{
    NSDate * temp_date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: temp_date];
    NSDate *localeDate = [temp_date  dateByAddingTimeInterval: interval];
    return localeDate;
}

+ (NSString *)getNowDateString
{
    NSString * now_date = [NSString stringWithFormat:@"%@",[self getNowDate]];
    NSArray * date_arr = [now_date componentsSeparatedByString:@" "];
    now_date = [NSString stringWithFormat:@"%@ %@",date_arr.firstObject,date_arr[1]];
    return now_date;
}



@end
