//
//  NSString+UtilString.h
//  RZCommon
//
//  Created by Zhang Rey on 6/1/15.
//  Copyright (c) 2015 Zhang Rey. All rights reserved.
//  字符串工具类，包含对字符串的url编码, 校验， html过滤等

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (UtilString)

+ (BOOL)isEmpty:(NSString *)string;
+ (BOOL)isNotEmpty:(NSString *)string;
- (BOOL)isEmpty;
- (BOOL)isNotEmpty;
- (BOOL)isValidEmail;
- (BOOL)isValidNumber;
- (BOOL)isValidSevenToFifteen;
- (BOOL)isValidMoney;
- (BOOL)isValidPhone;
- (BOOL)isValidURL;
- (BOOL)isValidAlphabet;
- (BOOL)isLower;
+ (BOOL)isHtmlEmpty:(NSString *)htmlContent;
+ (NSString *)md5StringForString:(NSString *)str;

- (NSString *)URLEncoded;
- (NSString *)URLDecoded;
- (NSString *)stringTruncateToFit:(CGRect)rect withAttributes:(NSDictionary *)attributes;
- (NSString *)stringByDecodingURLFormat;

- (CGFloat) stringWidthWith:(CGFloat)fontSize;
- (CGFloat) stringWidthWithFont:(UIFont *)font;
- (CGFloat) stringHeightWith:(CGFloat)fontSize width:(CGFloat)width;
- (CGFloat) stringHeightWithFont:(UIFont *)font width:(CGFloat)width;

- (CGSize) stringSizeWithFontSize:(CGFloat)fontSize width:(CGFloat)width;
- (NSString *)stringWithDateFormat:(NSString *)format toFormat:(NSString *)toFormat;
+ (NSString *)filterHTML:(NSString *)content;
- (NSDate *)dateWithDateFormat:(NSString *)format;
- (BOOL)containTheString:(NSString *)str;
// 个人资料的手机号要求变成是数字验证就行
- (BOOL)member_isValidNumber;
/** 千分位 */
+ (NSString *)positiveFormat:(NSString *)text;

- (NSString *)VerticalString;

/*!生成指定大小的二维码*/
- (UIImage *)generateQRCodeWithSize:(CGFloat)size;

@end
