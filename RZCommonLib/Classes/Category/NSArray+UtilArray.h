//
//  NSArray+UtilArray.h
//  RZCommon
//
//  Created by Zhang Rey on 6/1/15.
//  Copyright (c) 2015 Zhang Rey. All rights reserved.
//  NSArray扩展， 包含对NSArray的是否为空，是否包含某个对象的判断

#import <Foundation/Foundation.h>

@interface NSArray (UtilArray)

+ (BOOL)hasValues:(NSArray *)array;
+ (BOOL)isEmpty:(NSArray *)array;

- (BOOL)containsObjectsFromArray:(NSArray *)array;

/**
 *  根据传递的数据及key判断数组中是否有key值相同的对象
 *
 *  @param obj 对象
 *  @param key 判断依据的key
 *
 *  @return 返回是否包含
 */
- (BOOL)containsObject:(id)obj forKey:(NSString *)key;

/**
 *  根据传递的value及key，获取数组中key及value相同的对象
 *
 *  @param obj 对象
 *  @param key 判断依据的key
 *
 *  @return 返回是否包含
 */
- (id)GetObjectByValue:(id)obj andKey:(NSString *)key;


/*!
 @method swizzleMethod:withMethod:error:
 @abstract 对实例方法进行替换
 @param oldSelector 想要替换的方法
 @param newSelector 实际替换为的方法
 @param error 替换过程中出现的错误，如果没有错误为nil
 */
+ (BOOL)swizzleMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector error:(NSError **)error;

- (id)swizzleObjectAtIndex:(NSUInteger)index;
@end
