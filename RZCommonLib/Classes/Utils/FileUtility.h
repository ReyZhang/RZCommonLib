//
//  FileUtility.h
//  HYWCoupon
//
//  Created by reyzhang on 15/9/25.
//  Copyright (c) 2015年 hhkx002. All rights reserved.
//  文件工具类，实现文件本地缓存 reyzhang

#import <Foundation/Foundation.h>

@interface FileUtility : NSObject

///获取缓存路径
+ (NSString *)cachePath:(NSString *)fileName;
///将image流写入到文件
+ (BOOL)imageCacheToPath:(NSString *)path imageData:(NSData *)data;
///从物理文件中读取并返回image对象
+ (id)imageDataFromPath:(NSString *)path;


@end
