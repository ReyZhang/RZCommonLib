//
//  NSDictionary+GetDifferentType.h
//  NewAL
//
//  Created by cameo-app on 15/1/24.
//  Copyright (c) 2015年 ycon. All rights reserved.
//  字典扩展， 处理字典根据key取值的合法性

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSDictionary (GetDifferentType)

-(NSString *)stringForKey:(NSString *)theKey;
- (NSInteger)integerValueForKey:(NSString *)theKey;
- (CGFloat)floatValueForKey:(NSString *)theKey;
-(NSArray *)arrayForKey:(NSString *)theKey;
-(NSDictionary *)dictionaryForKey:(NSString *)theKey;
- (NSArray *)dictionaryToArray;


@end
