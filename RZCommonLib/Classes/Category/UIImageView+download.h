//
//  UIImageView+download.h
//  HYWCoupon
//
//  Created by hhkx002 on 15/9/25.
//  Copyright (c) 2015年 hhkx002. All rights reserved.
//  UIImage扩展， 异步下载网络图片，并缓存本地cache目录

#import <UIKit/UIKit.h>

@interface UIImageView (download)
@property NSString *imageTag;
- (void)setImage:(NSString *)urlString placeHolder:(UIImage *)placeHolder;
- (void)setImageContent:(NSString *)urlString placeHolder:(UIImage *)placeHolder;


@end
