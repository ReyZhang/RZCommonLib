//
//  AppVersion.h
//  HYWCoupon
//
//  Created by reyzhang on 15/10/19.
//  Copyright (c) 2015年 hhkx002. All rights reserved.
//  应用版本相关的操作，主要是用来检查版本更新 reyzhang

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface AppVersion : NSObject <UIAlertViewDelegate>

///单例创建对象实例
+ (instancetype)sharedVersion;

- (void)setAppId:(NSString *)AppId;

///取设备中的应用当前的版本号
- (NSString *)deviceVersion;

///取Appstore线上版本号及其他信息
- (void)onlineVersion:(void(^)(NSDictionary *result, NSError *error))block ;

////检查版本更新
- (void)checkUpdate;

@end
