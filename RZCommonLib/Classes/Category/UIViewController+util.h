//
//  UIViewController+util.h
//  HYWCoupon
//
//  Created by hhkx002 on 15/9/24.
//  Copyright (c) 2015年 hhkx002. All rights reserved.
//  UIViewController 工具扩展， 包含通过storyboard创建实例，判断返回的json是否合法

#import <UIKit/UIKit.h>

@interface UIViewController (util)<UIAlertViewDelegate>


///根据storyboard来创建控制器实例
+ (instancetype)createInstanceWithStoryboardName:(NSString *)storyboardName;

///根据storyboard来创建控制器实例
+ (instancetype)createInstance;

///隐藏navigationbar底部的线
- (void)hideNavigationBarBottomLine;

@end
