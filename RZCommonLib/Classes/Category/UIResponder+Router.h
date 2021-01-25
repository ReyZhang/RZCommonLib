//
//  AppDelegate.h
//  HYWCoupon
//
//  Created by reyzhang on 15/9/22.
//  Copyright (c) 2015年 hhkx002. All rights reserved.
//  UIResponder扩展， 事件路由

#import <UIKit/UIKit.h>

@interface UIResponder (Router)

/**
 *  发送一个路由器消息, 对eventName感兴趣的 UIResponsder 可以对消息进行处理
 *
 *  @param eventName 发生的事件名称
 *  @param userInfo  传递消息时, 携带的数据, 数据传递过程中, 会有新的数据添加
 *
 */
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo;

@end
