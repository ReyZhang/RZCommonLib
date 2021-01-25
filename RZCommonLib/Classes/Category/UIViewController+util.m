//
//  UIViewController+util.m
//  HYWCoupon
//
//  Created by reyzhang on 15/9/24.
//  Copyright (c) 2015年 hhkx002. All rights reserved.
//  控制器工具扩展  reyzhang

#import "UIViewController+util.h"

@implementation UIViewController (util)


///根据storyboard来创建控制器实例
+ (instancetype)createInstanceWithStoryboardName:(NSString *)storyboardName {
    NSAssert(storyboardName.length > 0, @"");
    
    NSString *className = [NSString stringWithCString:object_getClassName(self) encoding:NSUTF8StringEncoding];
    UIStoryboard *sb= [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *viewController =  [sb instantiateViewControllerWithIdentifier:className];
    if (viewController == nil ) {
        Class class = NSClassFromString(className);
        viewController = [[class alloc] init];
    }
    
    return viewController;
}

///根据storyboard来创建控制器实例
+ (instancetype)createInstance {
    return [self createInstanceWithStoryboardName:@"Main"];
}

- (void)hideNavigationBarBottomLine {
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }
}

@end
