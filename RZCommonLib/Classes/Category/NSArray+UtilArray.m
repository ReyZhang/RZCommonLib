//
//  NSArray+UtilArray.m
//  RZCommon
//
//  Created by Zhang Rey on 6/1/15.
//  Copyright (c) 2015 Zhang Rey. All rights reserved.
//

#import "NSArray+UtilArray.h"
#import <objc/runtime.h>


@implementation NSArray (UtilArray)

+ (BOOL)hasValues:(NSArray *)array{
    return (id)[NSNull null] != array && array && [array count] > 0;
}

+ (BOOL)isEmpty:(NSArray *)array{
    return (id)[NSNull null] == array || !array || [array count] == 0;
}

- (BOOL)containsObjectsFromArray:(NSArray *)array{
    BOOL contain = NO;
    for (id object in array) {
        contain = [self containsObject:object];
        if(contain) break;
    }
    return contain;
}

- (BOOL)containsObject:(id)obj forKey:(NSString *)key {
    BOOL flag = NO;
    id value = obj;
    if ([obj isKindOfClass:[NSDictionary class]]) {
        value = obj[key];
    }
    
    for (id _selfobj  in self) {
        if ([value isEqual:_selfobj[key]]) {
            flag = YES;
            break;
        }
    }
    return flag;
}

- (id)GetObjectByValue:(id)obj andKey:(NSString *)key{
    id retValue;
    id value = obj;
    if ([obj isKindOfClass:[NSDictionary class]]) {
        value = obj[key];
    }
    
    for (id _selfobj  in self) {

        if ([value isKindOfClass:[NSString class]]) {
            if ([value isEqualToString:[_selfobj stringForKey:key]]) {
                retValue = _selfobj;
                break;
            }
        }else {
            if ([value isEqual:_selfobj[key]]) {
                retValue = _selfobj;
                break;
            }
        }
        
    }
    return retValue;
}




+ (BOOL)swizzleMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector error:(NSError **)error
{
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    if (!originalMethod) {
        NSString *string = [NSString stringWithFormat:@" %@ 类没有找到 %@ 方法",NSStringFromClass([self class]),NSStringFromSelector(originalSelector)];
//        *error = [NSError errorWithDomain:@"NSCocoaErrorDomain" code:-1 userInfo:[NSDictionary dictionaryWithObject:string forKey:NSLocalizedDescriptionKey]];
        return NO;
    }
    
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    if (!swizzledMethod) {
        NSString *string = [NSString stringWithFormat:@" %@ 类没有找到 %@ 方法",NSStringFromClass([self class]),NSStringFromSelector(swizzledSelector)];
//        *error = [NSError errorWithDomain:@"NSCocoaErrorDomain" code:-1 userInfo:[NSDictionary dictionaryWithObject:string forKey:NSLocalizedDescriptionKey]];
        return NO;
    }
    
    if (class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
    return YES;
}


+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool
        {
//            [objc_getClass("__NSArrayI") swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(swizzleObjectAtIndex:) error:nil];
//            [objc_getClass("__NSArrayM") swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(swizzleObjectAtIndex:) error:nil];
        };
    });
}

- (id)swizzleObjectAtIndex:(NSUInteger)index
{
    if (index < self.count)
    {
        return [self swizzleObjectAtIndex:index];
    }
    NSLog(@"%@ 越界",self);
    return nil;//越界返回为nil
}




@end
