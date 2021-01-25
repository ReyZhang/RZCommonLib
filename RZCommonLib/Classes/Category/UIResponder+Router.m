//
//  AppDelegate.h
//  HYWCoupon
//
//  Created by reyzhang on 15/9/22.
//  Copyright (c) 2015年 hhkx002. All rights reserved.
//  子视图事件路由的封装 reyzhang

#import "UIResponder+Router.h"

@implementation UIResponder (Router)

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}

@end
