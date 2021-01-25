//
//  AppVersion.h
//  HYWCoupon
//
//  Created by reyzhang on 15/10/19.
//  Copyright (c) 2015年 hhkx002. All rights reserved.
//  应用版本相关的操作，主要是用来检查版本更新 reyzhang

#import "AppVersion.h"


@implementation AppVersion {
    NSString *_trackViewUrl;
    NSString *_AppId;
}

///单例创建对象实例
+ (instancetype)sharedVersion {
    static AppVersion *_instance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if (_instance == nil) {
            _instance = [[AppVersion alloc] init];
        }
    });
    return _instance;
}

- (void)setAppId:(NSString *)AppId {
    NSParameterAssert(_AppId.length == 0);
    _AppId = AppId;
}


///取设备中的应用当前的版本号
- (NSString *)deviceVersion {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    id shortVersion  = [info objectForKey:@"CFBundleShortVersionString"];
    if (shortVersion) {
        return shortVersion;
    }
    return @"";
}

///取Appstore线上版本号
- (void)onlineVersion:(void(^)(NSDictionary *result, NSError *error))block {
    NSString *lookup = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@",_AppId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:lookup]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            block(nil,connectionError); //// 请求错误
            return;
        }
        if (data == nil) {
             block(nil,nil);
            return;
        }
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            block(nil,error); ////类型转换失败的错误
            return;
        }
        if (dict != nil) {
            NSInteger resultCount = [[dict objectForKey:@"resultCount"] integerValue];
            if (resultCount == 1) {
                NSArray *resultArray = [dict objectForKey:@"results"];
                NSDictionary *resultDict = [resultArray objectAtIndex:0];
                if (resultDict) {
                    block(resultDict,nil); ////回调
                }
            }
        }
    }];
}

////检查版本更新
- (void)checkUpdate {
//    NSAssert(_AppId.length > 0 , @"必须要提供AppId");
    if ([_AppId isEqualToString:@""])
        return;
    __weak __typeof(self) weakSelf = self;
    ///先检查线上版本号
    [self onlineVersion:^(NSDictionary *result, NSError *error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        ///如果没有错误
        if (!error) {
            NSString *onlineVersion = result[@"version"];
            ///如果线上版本号不与本机应用版本号相同，说明有了新版本。显示提示信息
            if ([self compareVersion:[self deviceVersion] to:onlineVersion] == -1) {// [onlineVersion compare:[self deviceVersion]] == NSOrderedDescending
                NSString *appName = result[@"trackName"];
                strongSelf->_trackViewUrl     = result[@"trackViewUrl"];
                
                NSString *title = [NSString stringWithFormat:@"检查更新: %@",appName];
                NSString *msg = [NSString stringWithFormat:@"发现新版本(%@), 是否更新?",onlineVersion];
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"立即更新", nil];
//                alertView.tag = 1000;
//                [alertView show];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle: title message: msg preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle: @"暂不" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击取消");
                }]];
                
                [alertController addAction:[UIAlertAction actionWithTitle: @"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_trackViewUrl]];
                    NSLog(@"点击确认");
                }]];
                
                UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
                alertController.popoverPresentationController.sourceView = rootVC.view;
                alertController.popoverPresentationController.sourceRect = rootVC.view.bounds;
                if (rootVC) {
                    [rootVC presentViewController:alertController animated:YES completion:nil];
                }else{
                    
                }
            }
            
        }////end error
    }];
}

/**
 https://www.jianshu.com/p/e82da78e5117
 比较两个版本号的大小
 
 @param v1 第一个版本号
 @param v2 第二个版本号
 @return 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
 */
- (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2 {
    // 都为空，相等，返回0
    if (!v1 && !v2) {
        return 0;
    }
    
    // v1为空，v2不为空，返回-1
    if (!v1 && v2) {
        return -1;
    }
    
    // v2为空，v1不为空，返回1
    if (v1 && !v2) {
        return 1;
    }
    
    // 获取版本号字段
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
    // 取字段最少的，进行循环比较
    NSInteger smallCount = (v1Array.count > v2Array.count) ? v2Array.count : v1Array.count;
    
    for (int i = 0; i < smallCount; i++) {
        NSInteger value1 = [[v1Array objectAtIndex:i] integerValue];
        NSInteger value2 = [[v2Array objectAtIndex:i] integerValue];
        if (value1 > value2) {
            // v1版本字段大于v2版本字段，返回1
            return 1;
        } else if (value1 < value2) {
            // v2版本字段大于v1版本字段，返回-1
            return -1;
        }
        
        // 版本相等，继续循环。
    }
    
    // 版本可比较字段相等，则字段多的版本高于字段少的版本。
    if (v1Array.count > v2Array.count) {
        return 1;
    } else if (v1Array.count < v2Array.count) {
        return -1;
    } else {
        return 0;
    }
    return 0;
}


#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    ////点击的“立即更新”按钮
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_trackViewUrl]];
    }
}



@end
