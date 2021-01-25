//
//  NSDictionary+GetDifferentType.m
//  NewAL
//
//  Created by cameo-app on 15/1/24.
//  Copyright (c) 2015年 ycon. All rights reserved.
//

#import "NSDictionary+GetDifferentType.h"
#import "NSString+UtilString.h"

@implementation NSDictionary (GetDifferentType)
-(NSString *)stringForKey:(NSString *)theKey
{
    if (!self) {
        return @"";
    }
    
    id val = [self objectForKey:theKey];
    if (val == [NSNull null]) {
        return @"";
    }
    
    if (!val) {
        return @"";
    }
    
    NSString * theNewStr =[NSString stringWithFormat:@"%@",[self objectForKey:theKey]];
    if ([theNewStr isEqualToString:@"<null>"]) {
        return @"";
    }
    if ([theNewStr isEqualToString:@"<NULL>"]) {
        return @"";
    }
    if ([theNewStr isEqualToString:@"NULL"]) {
        return @"";
    }
    if ([theNewStr isEqualToString:@"null"]) {
        return @"";
    }
    if ([theNewStr isEqualToString:@"(null)"]) {
        return @"";
    }
    return theNewStr;
}

- (NSInteger)integerValueForKey:(NSString *)theKey {
    NSString *value = [self stringForKey:theKey];
    if (value.length > 0) {
        if ([value isValidNumber]) {
            return [value integerValue];
        }
    }
    return 0;
}

- (CGFloat)floatValueForKey:(NSString *)theKey {
    NSString *value = [self stringForKey:theKey];
    if (value.length > 0) {
        if ([value isValidMoney]) {
            return [value doubleValue];
        }
    }
    return 0;
}

-(NSDictionary *)dictionaryForKey:(NSString *)theKey
{
    NSDictionary * theNewDic =[self objectForKey:theKey];
    if ([[theNewDic class]isSubclassOfClass:[NSDictionary class]]) {
        return theNewDic;
    }
    else
    {
        return @{};
    }
}
-(NSArray *)arrayForKey:(NSString *)theKey
{
    NSArray * array =[self objectForKey:theKey];
    if ([[array class]isSubclassOfClass:[NSArray class]]) {
        return array;
    }
    else{
        return @[];
    }
}
- (NSArray *)dictionaryToArray
{
    NSMutableArray * mutableArray = [[NSMutableArray alloc]init];
    NSArray * keysArray = [self allKeys];
    for (int i = 0; i<[keysArray count]; i++) {
        [mutableArray addObject:[self dictionaryForKey:[keysArray objectAtIndex:i]]];
    }
    NSArray * array = [[NSArray alloc]initWithArray:mutableArray];
    return array;
}


@end
