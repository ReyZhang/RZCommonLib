//
//  FormValidation.h
//  HYWCommonLib
//
//  Created by reyzhang on 2017/3/6.
//  Copyright © 2017年 hhkx002. All rights reserved.
//  表单验证封装

#import <Foundation/Foundation.h>

@interface FormValidation : NSObject

// -- 错误消息数组
@property (nonatomic,strong) NSMutableArray *errorMsg;

// -- 非空验证
- (void) isNotEmpty:(NSString *) textField errorMsg:(NSString *)errorMsg;

// -- 邮箱规则验证
- (void) Email : (NSString *) emailAddress errorMsg:(NSString *)errorMsg;

// -- 必填项验证
- (void) Required : (NSString *) textField errorMsg:(NSString *)errorMsg;


// -- 字母验证
- (void) Alphabet : (NSString *) textField errorMsg:(NSString *)errorMsg;

// -- 网址验证
- (void) WebURL : (NSString *) textField errorMsg:(NSString *)errorMsg;


// -- 电话号码验证
- (void) Phone : (NSString *) textField errorMsg:(NSString *)errorMsg;


// -- 合法金额验证
- (void) Money : (NSString *) textField errorMsg:(NSString *)errorMsg;

// -- 数字验证，不带小数位
- (void) Number : (NSString *) textField errorMsg:(NSString *)errorMsg;

// -- 是否相等
- (void) Equal : (id) from to:(id) to errorMsg:(NSString *)errorMsg;

// -- 比较是否大于
- (void) GreaterThan:(id)from to:(id)to errorMsg:(NSString *)errorMsg;

// -- 比较是否大于等于
- (void)greaterThanOrEqual:(id)from  to:(id)to errorMsg:(NSString *)errorMsg;

// -- 比较是否小于
- (void) LessThan:(id)from to:(id)to errorMsg:(NSString *)errorMsg;

// -- 比较是否小于等于
- (void) LessThanOrEqual:(id)from to:(id)to errorMsg:(NSString *)errorMsg;

// -- 通过正则来验证
- (void)Regex: (id) textField pattern:(NSString *)pattern errorMsg:(NSString *)errorMsg;

// -- 开始验证
- (BOOL) isValid;

/*!
 当前错误所在所有验证数据源的位置索引，非错误列表中的索引位置
 */
- (NSInteger)indexOfError;

/*!
 清空缓存的错误信息及验证信息
 */
- (void)clearAll;

+ (BOOL)Regex:(NSString *)str pattern:(NSString *)pattern;

@end


/**正则表达式字符扩展**/
@interface FormValidation (pattern)

// -- 任意字符 可空
+ (NSString *)anyPattern;

// -- 非空
+ (NSString *)notEmptyPattern;

// -- email
+ (NSString *)emailPattern;


// -- weburl
+ (NSString *)urlPattern;

// -- 字母
+ (NSString *)alphabetPattern;

// -- 浮点数字
+ (NSString *)floatNumberPattern;

// -- 数字
+ (NSString *)numberPattern;

// -- 中国手机号
+ (NSString *)CNPhoneNumberPattern;

// -- 中文汉字字符
+ (NSString *)CNCharacterPattern;

// -- 护照
+ (NSString *)passportPattern;

// -- 港澳通行证
+ (NSString *)HKMac_passportPattern;

// -- 台湾通行证
+ (NSString *)TW_passportPattern;

/*!
 6-20数字字母组合
 */
+ (NSString *)sixToTwentyPasswordPattern;

@end



