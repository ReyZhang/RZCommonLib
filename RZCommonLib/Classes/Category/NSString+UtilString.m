//
//  NSString+UtilString.m
//  RZCommon
//
//  Created by Zhang Rey on 6/1/15.
//  Copyright (c) 2015 Zhang Rey. All rights reserved.
//

#import "NSString+UtilString.h"
#define APPFont(s) [UIFont fontWithName:@"MicrosoftYaHei" size:s]
#include <ctype.h>
#import <CommonCrypto/CommonDigest.h>
#import "sys/utsname.h"
#import "CIImage+Extension.h"

@implementation NSString (UtilString)


+ (BOOL)isEmpty:(NSString *)string
{
    if (!string || [string isKindOfClass:[NSNull class]] ||
        ![string isKindOfClass:[NSString class]] || [string isEqualToString:@""]) {
        return YES;
    }
    
    if (![[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isNotEmpty:(NSString *)string
{
    return ![NSString isEmpty:string];
}


- (BOOL)isEmpty {
    if (!self || [self isKindOfClass:[NSNull class]] || ![self isKindOfClass:[NSString class]] // -- nil及类型判断
        || [self isEqualToString:@""]) { // nsstring
        return YES;
    }
    
    if (![[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        return YES;
    }
    if (self.length == 0) {
        return YES;
    }
    
    return NO;
}
- (BOOL)isNotEmpty {
    return ![self isEmpty];
}

- (BOOL)isValidEmail
{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"] evaluateWithObject:self];
}

- (BOOL)isValidNumber
{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"(-)?[0-9]+"] evaluateWithObject:self];
}

- (BOOL)member_isValidNumber
{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[0-9]+"] evaluateWithObject:self];
}

- (BOOL)isValidSevenToFifteen {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[\\d]{7,15}"] evaluateWithObject:self];
}

- (BOOL)isValidMoney {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"([1-9][\\d]{0,7}|0)(\\.[\\d]{1,2})?"] evaluateWithObject:self];
}

- (BOOL)isValidPhone
{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[1][3578][0-9]{9}"] evaluateWithObject:self];
}

- (BOOL)isValidURL {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?"] evaluateWithObject:self];
}


- (BOOL)isValidAlphabet
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [self isEqualToString:filtered];
   // return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z]+"] evaluateWithObject:self];
}

- (BOOL)isLower {
    BOOL flag = NO;
    const char *ch = [self cStringUsingEncoding:NSASCIIStringEncoding];
    for (int i = 0; i < strlen(ch); i++) {
        if (islower(ch[i])) {
            flag = YES;
            break;
        }
    }
    return flag;
}


+ (BOOL)isHtmlEmpty:(NSString *)htmlContent {
    NSString * regex = @"[(&nbsp;)\\s]+";
    NSPredicate * predicator = [NSPredicate predicateWithFormat:@"%@ MATCHES %@",htmlContent, regex];
    
    return [predicator evaluateWithObject:self];
}


+ (NSString *)md5StringForString:(NSString *)str {
    
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *resultStr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [resultStr appendFormat:@"%02x", result[i]];
    }
    
    
    
    return resultStr;
}


/**
 *  Encodes the URL
 *
 *  @return the URL encoded
 *
 */
- (NSString *)URLEncoded
{
    NSString * lastPathComponent = [[NSURL URLWithString:self] lastPathComponent];
    
    if ([NSString isEmpty:lastPathComponent]) {
        return self;
    }
    
    NSRange lastPathComponentRange = [[self URLDecoded:self] rangeOfString:lastPathComponent options:NSBackwardsSearch];
    NSRange urlRange = NSMakeRange(lastPathComponentRange.location + 1, self.length - lastPathComponentRange.location - 1);
    
    if (urlRange.length > 1) {
        NSString * substringToEncode = [self substringWithRange:urlRange];
        NSString * substringEncoded = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef) substringToEncode, NULL, CFSTR("!*'();:@&=+$,/?%#[]\" "), kCFStringEncodingUTF8));
        
        return [NSString stringWithFormat:@"%@%@", [self substringToIndex:urlRange.location], substringEncoded];
    }
    
    return self;
}

/**
 *  Decodes the URL
 *
 *  @return the URL decoded
 *
 */
- (NSString *)URLDecoded
{
    return (NSString *) CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (CFStringRef) self, CFSTR(""), kCFStringEncodingUTF8));
}

- (NSString *)URLDecoded:(NSString *)string
{
    return (NSString *) CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (CFStringRef) string, CFSTR(""), kCFStringEncodingUTF8));
}

- (NSString *)stringTruncateToFit:(CGRect)rect withAttributes:(NSDictionary *)attributes {
    NSString *result = [self copy];
    CGSize maxSize = CGSizeMake(rect.size.width, FLT_MAX);
    
    CGRect boundingRect = [result boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    CGSize size = boundingRect.size;
    
    if (rect.size.height < size.height) {
        while (rect.size.height < size.height) {
            result = [result substringToIndex:result.length - 1];
            CGRect boundingRect = [result boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
            size = boundingRect.size;
        }
    }
    
    return result;
}

- (NSString *)stringByDecodingURLFormat {
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}


- (CGFloat) stringWidthWith:(CGFloat)fontSize {
    UIFont *font = APPFont(fontSize);
    CGSize size = [self sizeWithAttributes:@{NSFontAttributeName:font}];
    return size.width;
}

- (CGFloat) stringWidthWithFont:(UIFont *)font {
    CGSize size = [self sizeWithAttributes:@{NSFontAttributeName:font}];
    return size.width;
}

- (CGFloat) stringHeightWith:(CGFloat)fontSize width:(CGFloat)width {
    UIFont *font = APPFont(fontSize);
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:style} context:nil];
    return rect.size.height;
    
}

- (CGFloat) stringHeightWithFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:style} context:nil];
    return rect.size.height;
}


- (CGSize) stringSizeWithFontSize:(CGFloat)fontSize width:(CGFloat)width {
    UIFont *font = APPFont(fontSize);
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:style} context:nil];
    return rect.size;

}





- (NSString *)stringWithDateFormat:(NSString *)format toFormat:(NSString *)toFormat{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    NSDate *date = [formatter dateFromString:self];
    formatter.dateFormat = toFormat;
    NSString *date_str = [formatter stringFromDate:date];
    return date_str;
}


+ (NSString *)filterHTML:(NSString *)content {
    if (content && content.length > 0) {
        NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*/?>"
                                                                                        options:0
                                                                                          error:nil];
        
        content =[regularExpretion stringByReplacingMatchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length) withTemplate:@""];
        return  content;
    }
    return @"";
}

- (NSDate *)dateWithDateFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    NSDate *date = [formatter dateFromString:self];

    return date;
}

- (BOOL)containTheString:(NSString *)str
{
    NSRange range = [self rangeOfString:str];
    return range.length > 0;
}

#pragma mark - 千分位
+ (NSString *)positiveFormat:(NSString *)text
{
    if(!text || [text floatValue] == 0){
        return @"0.00";
    }
    if (text.floatValue < 1000) {
        return  [NSString stringWithFormat:@"%.2f",text.floatValue];
    };
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@",###.00;"];
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[text doubleValue]]];
}

- (NSString *)VerticalString{
    NSMutableString * str = [[NSMutableString alloc] initWithString:self];
    NSInteger count = str.length;
    for (int i = 1; i < count; i ++) {
        [str insertString:@"\n" atIndex:i*2 - 1];
    }
    return str;
}

/*!生成指定大小的二维码*/
- (UIImage *)generateQRCodeWithSize:(CGFloat)size {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认设置
    [filter setDefaults];
    // 3.设置数据
    NSData *infoData = [self dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:infoData forKeyPath:@"inputMessage"];
    // 4.生成二维码
    CIImage *outputImage = [filter outputImage];
    UIImage *image   = [outputImage createNonInterpolatedWithSize:size];
    return image;
}

@end
