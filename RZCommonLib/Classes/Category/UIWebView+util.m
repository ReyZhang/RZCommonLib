//
//  UIWebView+util.m
//  RZCommon
//
//  Created by Zhang Rey on 6/8/15.
//  Copyright (c) 2015 Zhang Rey. All rights reserved.
//

#import "UIWebView+util.h"

@implementation UIWebView (util)


-(void)forbidPullDown {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    self.scrollView.bounces = NO;
#else
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *) subview).bounces = NO;
        }
    }
    
#endif
}
@end
