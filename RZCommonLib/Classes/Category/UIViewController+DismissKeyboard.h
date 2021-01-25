//
//  AppDelegate.h
//  HYWCoupon
//
//  Created by reyzhang on 15/9/22.
//  Copyright (c) 2015年 hhkx002. All rights reserved.
//  UIViewController隐藏键盘的扩展， 监听键盘的弹出与关闭事件


#import <UIKit/UIKit.h>

@interface UIViewController (DismissKeyboard)
-(void)setupForDismissKeyboard;
@end
