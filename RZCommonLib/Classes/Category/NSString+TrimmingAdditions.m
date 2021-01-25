//
//  NSString+TrimmingAdditions.m
//  RZCommon
//
//  Created by Zhang Rey on 6/1/15.
//  Copyright (c) 2015 Zhang Rey. All rights reserved.
//

#import "NSString+TrimmingAdditions.h"

@implementation NSString (TrimmingAdditions)

- (NSString *)removeAllWhitespaces{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)stringByTrimmingTrailingSpaces{
    return [self stringByTrimmingTrailingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)stringByTrimmingLeadingSpaces{
    return [self stringByTrimmingLeadingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    
    for (; location < length; location++) {
        if (![characterSet characterIsMember:charBuffer[location]]) {
            break;
        }
    }
    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    
    for (; length > 0; length--) {
        if (![characterSet characterIsMember:charBuffer[length - 1]]) {
            break;
        }
    }
    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}


- (NSString *)stringByTrimmingHTML {
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return [s stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
}

@end
