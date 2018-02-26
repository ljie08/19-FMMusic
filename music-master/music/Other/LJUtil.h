//
//  LJUtil.h
//  MyUtil
//
//  Created by ljie on 2016/8/4.
//  Copyright © 2017年 ljie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LJUtil : NSObject

//当前语言是中文还是英文
+ (BOOL)currentLanguageIsChinese;

//获取字符串首字母(传入汉字字符串, 返回大写拼音首字母)
//传入英文shangHai，返回的是将首字母改为大写Shanghai，传入的是汉字上海，返回的则是Shang Hai，中间有空格
+ (NSString *)getFirstLetterFromString:(NSString *)aString;

//#333333格式颜色
+ (UIColor *)hexStringToColor:(NSString *)stringToConvert;

+ (UIColor *)colorWithHexNumber:(NSUInteger)hexColor;

//计算两个日期之间的天数
+ (NSInteger)getDaysFromNowToEnd:(NSDate *)endDate;

//获取当前时间字符串 时间戳
+ (NSString *)getNowDateTimeString;

//0点的今天时间戳
+ (NSString *)getZeroWithTimeInterverl;

//某天0点的时间戳
+ (NSString *)getZeroTimeInterverlWithDateStr:(NSString *)dateStr;

//获取当前的时间
+ (NSString*)getCurrentTimes;

//时间戳转为时间字符串
+ (NSString *)timeInterverlToDateStr:(NSString *)timeStr;

//获取时间段
+ (NSString *)getTheTimeBucket;

//获取前n天
+ (NSString *)getNDay:(NSInteger)n dateType:(NSString *)dateType;

//字符串转size 自适应高度
+ (CGSize)initWithSize:(CGSize)size string:(NSString *)string font:(NSInteger)font;

@end
