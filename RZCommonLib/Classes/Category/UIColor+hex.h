//
//  UIColor+hex.h
//  HYWCoupon
//
//  Created by reyzhang on 15/9/23.
//  Copyright (c) 2015年 hhkx002. All rights reserved.
//  UIColor的扩展，根据十六进制色值返回uicolor实例

#import <UIKit/UIKit.h>

@interface UIColor (hex)
+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
+ (NSString *) hexFromUIColor: (UIColor*) color;
@end
