//
//  NSObject+utils.m
//  HYWCommonLib
//
//  Created by hhkx002 on 16/3/21.
//  Copyright © 2016年 hhkx002. All rights reserved.
//

#import "NSObject+utils.h"

@implementation NSObject (utils)

- (BOOL)isNullOrEmpty {
    if (self == nil) {
        return YES;
    }
    
    if (self == [NSNull null]) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        return  ((NSString *)self).length == 0 ;
    }
    
    if ([self isKindOfClass:[NSArray class]]) {
        return ((NSArray *)self).count == 0;
    }
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        return ((NSDictionary *)self).count == 0;
    }
    
    return NO;
}

@end
