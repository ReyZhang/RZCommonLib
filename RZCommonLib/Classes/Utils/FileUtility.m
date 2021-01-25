//
//  FileUtility.h
//  HYWCoupon
//
//  Created by reyzhang on 15/9/25.
//  Copyright (c) 2015年 hhkx002. All rights reserved.
//  文件工具类 reyzhang

#import "FileUtility.h"
#import <UIKit/UIKit.h>

@implementation FileUtility


///获取缓存路径
+ (NSString *)cachePath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = paths[0];
    return [NSString stringWithFormat:@"%@/%@",path,fileName];
}
///将image流写入到文件
+ (BOOL)imageCacheToPath:(NSString *)path imageData:(NSData *)imageData {
   return [imageData writeToFile:path atomically:YES];
}


///从物理文件中读取并返回image对象
+ (id)imageDataFromPath:(NSString *)path {
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (exist) {
        UIImage *img = [UIImage imageWithContentsOfFile:path];
        if (img) {
            return img;
        }
    }
    return [NSNull null];
}

@end
