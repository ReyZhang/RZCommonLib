//
//  AttributtedStringBuilder.h
//  RZCommon
//
//  Created by Zhang Rey on 6/1/15.
//  Copyright (c) 2015 Zhang Rey. All rights reserved.
//  建造者模式

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*!
 *  Builder created in order to facilitate the creation of NSAttributedStrings
 *  Call new first, and call any instance method available in this class. Call [getAttributedStringWithString] in order to build the NSAttributedString
 *  Example:
 *  @code [[[[AttributtedStringBuilder new] fontWithSize:14] textColor:EDZONE_TINT_COLOR] getAttributedStringWithString:Localized(@"Forgot your password?", nil)]
 */
@interface AttributtedStringBuilder : NSObject

- (NSAttributedString *)getAttributedStringWithString:(NSString *)string;

#pragma mark - BUILDERS

- (instancetype)systemFontOfSize:(CGFloat)size;
- (instancetype)lightSystemFontOfSize:(CGFloat)size;
- (instancetype)boldSystemFontOfSize:(CGFloat)size;
- (instancetype)font:(UIFont *)font; ///设置字体
- (instancetype)letterPressEffect;
- (instancetype)textColor:(UIColor *)color;  ///设置文本颜色
- (instancetype)fontWithSize:(NSUInteger)size; ///设置字体大小
- (instancetype)shadow:(NSShadow *)shadow; ///设置阴影
- (instancetype)strikethrough; ///设置删除线
- (instancetype)underline; ///设置下划线
- (instancetype)lineSpacing:(CGFloat)spacing; ////设置行间距
- (instancetype)graphSpacing:(CGFloat)spacing;
@end
