//
//  FormValidation.m
//  HYWCommonLib
//
//  Created by reyzhang on 2017/3/6.
//  Copyright © 2017年 hhkx002. All rights reserved.
//

#import "FormValidation.h"

@interface FormValidation ()
@property (nonatomic,strong) NSMutableArray *valideArray;
@property (nonatomic,strong) NSMutableArray *errorArray;

@end

@implementation FormValidation

- (id)init {
    if (self = [super init]) {
        self.errorMsg = @[].mutableCopy;
        self.valideArray = @[].mutableCopy; // -- 用来存储所有验证的数据
        self.errorArray = @[].mutableCopy; // -- 扩展errorMsg的数据存储
    }
    return self;
}

// -- 非空验证
- (void) isNotEmpty:(NSString *) textField errorMsg:(NSString *)errorMsg {
    [self Regex:textField pattern:[[self class] notEmptyPattern] errorMsg:errorMsg];
}

// -- 邮箱规则验证
- (void) Email : (NSString *) emailAddress errorMsg:(NSString *)errorMsg {
    [self Regex:emailAddress pattern:[[self class] emailPattern] errorMsg:errorMsg];
}

// -- 必填项验证
- (void) Required : (NSString *) textField errorMsg:(NSString *)errorMsg {
    // -- 创建错误对象时，依赖了valideArray的数量，所以需要先创建错误对象，再添加到验证数组
    NSError *buildError = [self buildErrorWithMsg:errorMsg];
    [self.valideArray addObject:errorMsg];
    if ([textField isEqualToString:@""]) {
        [self.errorMsg addObject:errorMsg];
        [self.errorArray addObject:buildError];
        return;
    }
}

// -- 字母验证
- (void) Alphabet : (NSString *) textField errorMsg:(NSString *)errorMsg
{
    [self Regex:textField pattern:[[self class] alphabetPattern] errorMsg:errorMsg];
}

// -- 网址验证
- (void) WebURL : (NSString *) textField errorMsg:(NSString *)errorMsg {
    [self Regex:textField pattern:[[self class] urlPattern] errorMsg:errorMsg];
}


// -- 电话号码验证
- (void) Phone : (NSString *) textField errorMsg:(NSString *)errorMsg {
    [self Regex:textField pattern:[[self class] CNPhoneNumberPattern] errorMsg:errorMsg];
}


// -- 合法金额验证
- (void) Money : (NSString *) textField errorMsg:(NSString *)errorMsg {
    [self Regex:textField pattern:@"([1-9][\\d]{0,7}|0)(\\.[\\d]{1,2})?" errorMsg:errorMsg];
}

// -- 数字验证，不带小数位
- (void) Number : (NSString *) textField errorMsg:(NSString *)errorMsg {
    [self Regex:textField pattern:[[self class] numberPattern] errorMsg:errorMsg];
}

// -- 是否相等
- (void) Equal : (id) from to:(id) to errorMsg:(NSString *)errorMsg {
    // -- 创建错误对象时，依赖了valideArray的数量，所以需要先创建错误对象，再添加到验证数组
    NSError *buildError = [self buildErrorWithMsg:errorMsg];
    [self.valideArray addObject:errorMsg];
    
    if (![from isEqual:to]) {
        [self.errorMsg addObject:errorMsg];
        [self.errorArray addObject:buildError];
        return;
    }
}


// -- 比较是否大于 如果from>to 则返回 NSOrderedDescending
- (void) GreaterThan:(id)from to:(id)to errorMsg:(NSString *)errorMsg {
    // -- 创建错误对象时，依赖了valideArray的数量，所以需要先创建错误对象，再添加到验证数组
    NSError *buildError = [self buildErrorWithMsg:errorMsg];
    [self.valideArray addObject:errorMsg];
    // -- 字符串的判断
    if ([from isKindOfClass:[NSString class]] && [to isKindOfClass:[NSString class]]) {
//        if ([from compare:to] == NSOrderedDescending) {
//            [self.errorMsg addObject:errorMsg];
//            [self.errorArray addObject:buildError];
//            return;
//        }
        if (!([from integerValue] > [to integerValue])) {
            [self.errorMsg addObject:errorMsg];
            [self.errorArray addObject:buildError];
            return;
        }
    }else if ([from isKindOfClass:[NSNumber class]] && [to isKindOfClass:[NSNumber class]]) { //值类型判断
        if ([(NSNumber *)from integerValue] > [(NSNumber *)to integerValue]) {
            [self.errorMsg addObject:errorMsg];
            [self.errorArray addObject:buildError];
            return;
        }
    }
}

// -- 比较是否大于等于
- (void)greaterThanOrEqual:(id)from  to:(id)to errorMsg:(NSString *)errorMsg {
    // -- 创建错误对象时，依赖了valideArray的数量，所以需要先创建错误对象，再添加到验证数组
    NSError *buildError = [self buildErrorWithMsg:errorMsg];
    [self.valideArray addObject:errorMsg];
    
    // -- 字符串的判断
    if ([from isKindOfClass:[NSString class]] && [to isKindOfClass:[NSString class]]) {
        if ([from compare:to] != NSOrderedAscending) { // -- 包含 NSOrderedDescending， NSOrderedSame
            [self.errorMsg addObject:errorMsg];
            [self.errorArray addObject:buildError];
            return;
        }
    }else if ([from isKindOfClass:[NSNumber class]] && [to isKindOfClass:[NSNumber class]]) { //值类型判断
        if ([(NSNumber *)from integerValue] >= [(NSNumber *)to integerValue]) {
            [self.errorMsg addObject:errorMsg];
            [self.errorArray addObject:buildError];
            return;
        }
    }
}


// -- 比较是否小于 如果 from < to 则返回 NSOrderedAscending
- (void) LessThan:(id)from to:(id)to errorMsg:(NSString *)errorMsg {
    // -- 创建错误对象时，依赖了valideArray的数量，所以需要先创建错误对象，再添加到验证数组
    NSError *buildError = [self buildErrorWithMsg:errorMsg];
    [self.valideArray addObject:errorMsg];
    
    // -- 字符串的判断
    if ([from isKindOfClass:[NSString class]] && [to isKindOfClass:[NSString class]]) {
        if ([from compare:to] == NSOrderedAscending) {
            [self.errorMsg addObject:errorMsg];
            [self.errorArray addObject:buildError];
            return;
        }
    }else if ([from isKindOfClass:[NSNumber class]] && [to isKindOfClass:[NSNumber class]]) { //值类型判断
        if ([(NSNumber *)from integerValue] < [(NSNumber *)to integerValue]) {
            [self.errorMsg addObject:errorMsg];
            [self.errorArray addObject:buildError];
            return;
        }
    }
}

// -- 比较是否小于等于
- (void) LessThanOrEqual:(id)from to:(id)to errorMsg:(NSString *)errorMsg {
    // -- 创建错误对象时，依赖了valideArray的数量，所以需要先创建错误对象，再添加到验证数组
    NSError *buildError = [self buildErrorWithMsg:errorMsg];
    [self.valideArray addObject:errorMsg];
    
    // -- 字符串的判断
    if ([from isKindOfClass:[NSString class]] && [to isKindOfClass:[NSString class]]) {
        if ([from compare:to] != NSOrderedDescending) { // -- 包含 NSOrderedAscending， NSOrderedSame
            [self.errorMsg addObject:errorMsg];
            [self.errorArray addObject:buildError];
            return;
        }
    }else if ([from isKindOfClass:[NSNumber class]] && [to isKindOfClass:[NSNumber class]]) { //值类型判断
        if ([(NSNumber *)from integerValue] <= [(NSNumber *)to integerValue]) {
            [self.errorMsg addObject:errorMsg];
            [self.errorArray addObject:buildError];
            return;
        }
    }
}



// -- 通过正则来验证
- (void)Regex: (id) textField pattern:(NSString *)pattern errorMsg:(NSString *)errorMsg {
    
    // -- 创建错误对象时，依赖了valideArray的数量，所以需要先创建错误对象，再添加到验证数组
    NSError *buildError = [self buildErrorWithMsg:errorMsg];
    [self.valideArray addObject:errorMsg];
    
    if (textField == [NSNull null] || textField ==nil || [textField length] == 0) {
        [self.errorMsg addObject:errorMsg];
        [self.errorArray addObject:buildError];
        return;
    }
    if (pattern.length == 0) {
        return;
    }
//    NSAssert(pattern.length > 0, @"must be provides pattern");
    
    NSError *error;
    NSString *input_str = (NSString *)textField;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        [self.errorMsg addObject:errorMsg];
        [self.errorArray addObject:buildError];
        return;
    }
    
    if (regex != nil) {
        
        NSArray *match = [regex matchesInString:input_str
                                        options:NSMatchingReportCompletion
                                          range:NSMakeRange(0, [input_str length])];
        
        // -- 未匹配到
        if (match.count == 0) {
            [self.errorMsg addObject:errorMsg];
            [self.errorArray addObject:buildError];
            return;
        }else {
            if (pattern == [FormValidation notEmptyPattern]) // -- 如果是非空，只有找到匹配项就返回
                return;
            // -- 如果匹配，判断匹配后的结果是否是原字符相同 reyzhang
            NSRange inputRange = NSMakeRange(0, input_str.length);
            NSTextCheckingResult *firstObj = match[0];
            if (firstObj.range.location  == inputRange.location && firstObj.range.length == inputRange.length) {
                return;
            }else {
                [self.errorMsg addObject:errorMsg];
                [self.errorArray addObject:buildError];
                return;
            }
        }
        
    }
}


- (NSError *)buildErrorWithMsg:(NSString *)msg {
    NSDictionary *userInfo = @{
                               @"index":@(self.valideArray.count), // -- 索引位置
                               @"message":msg ?: @"",
                               };
    NSError *error = [NSError errorWithDomain:@"" code:120 userInfo:userInfo];
    return error;
}


// -- 开始验证
- (BOOL) isValid {
    return !(self.errorMsg.count > 0);
}

/*!
 当前错误所在所有验证数据源的位置索引，非错误列表中的索引位置
 */
- (NSInteger)indexOfError {
    NSInteger index = -1;
    // -- 检查到当前有错误信息，并且错误信息的数组，与错误对象的数组数量一致
    if (self.errorMsg.count >0 &&
        self.errorArray.count == self.errorMsg.count) {
        NSError *error = (NSError *)self.errorArray[0];
        NSDictionary *userInfo = (NSDictionary *)error.userInfo;
        index = (userInfo ? [userInfo[@"index"] integerValue] : -1);
    }
    return index;
}

/*!
 清空缓存的错误信息及验证信息
 */
- (void)clearAll {
    [self.valideArray removeAllObjects];
    [self.errorArray removeAllObjects];
    [self.errorMsg removeAllObjects];
}


+ (BOOL)Regex:(NSString *)str pattern:(NSString *)pattern {
    if (str.length > 0) {
        NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        return [regexTest evaluateWithObject:str];
        
    }
    return NO;
}

@end



@implementation FormValidation (pattern)

+ (NSString *)anyPattern {
    return @".*";
}

+ (NSString *)notEmptyPattern {
    return @"[^\\s*]*";
}

+ (NSString *)emailPattern {
    return @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
}

+ (NSString *)urlPattern{
    return @"((http|ftp|https)://)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?";
}

+ (NSString *)alphabetPattern{
    return @"[a-zA-Z]+";
}
+ (NSString *)floatNumberPattern{
    return @"([1-9]\\d*|0)(\\.\\d{1,6})?";
}
+ (NSString *)numberPattern{
    return @"[1-9]\\d*";
}

+ (NSString *)CNPhoneNumberPattern{
    return @"[1][35789][0-9]{9}";
}

+ (NSString *)CNCharacterPattern {
    return @"[\u4e00-\u9fa5]";
}


+ (NSString *)passportPattern {
    return @"1[45][0-9]{7}|G[0-9]{8}|E[0-9]{8}|P[0-9]{7}|S[0-9]{7,8}|D[0-9]+";
}

+ (NSString *)HKMac_passportPattern {
    return @"[HMhm]{1}([0-9]{10}|[0-9]{8})";
}

+ (NSString *)TW_passportPattern {
    return @"[0-9]{8}|[0-9]{10}";
}

/*!
 6-20数字字母组合
 */
+ (NSString *)sixToTwentyPasswordPattern {
    return @"(?!^[0-9]*$)(?!^[a-zA-Z]*$)^([a-zA-Z0-9]{6,20})$";
}
@end



