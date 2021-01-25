//
//  UIImageView+download.m
//  HYWCoupon
//
//  Created by hhkx002 on 15/9/25.
//  Copyright (c) 2015年 hhkx002. All rights reserved.
//

#import "UIImageView+download.h"
#import "FileUtility.h"
#import <objc/runtime.h>

static const void *HttpRequestImageKey = &HttpRequestImageKey;

@implementation UIImageView (download)

- (NSString *)imageTag{
    return objc_getAssociatedObject(self, HttpRequestImageKey);
}

- (void)setImageTag:(NSString *)imageTag {
    objc_setAssociatedObject(self, HttpRequestImageKey, imageTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

////异步下载图片资源
- (void)setImage:(NSString *)urlString placeHolder:(UIImage *)placeHolder {
    
    self.imageTag = urlString;
    
    if (placeHolder) {
        self.image = placeHolder;
    }
    
    if (urlString.length ==0) {
        return;
    }
    
    ///处理缓存的文件名
    NSString *cacheFileName = [urlString stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    ///得到缓存路径
    NSString *cachePath = [FileUtility cachePath:cacheFileName];
    ///从缓存中读取image,如果找到直接返回
    id cacheImage = [FileUtility imageDataFromPath:cachePath];
    if (cacheImage != [NSNull null]) {
        self.image = (UIImage *)cacheImage;
        return;
    }
    
    ///如果没有找到重新请求
    NSURL *imageURL = [NSURL URLWithString:urlString];
//    NSURLRequest *request =[NSURLRequest requestWithURL:imageURL];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:imageData];
            ///加tag防止图片错位更新
            if (image && [self.imageTag isEqualToString:[imageURL absoluteString]]) {
                self.image = image;
                [FileUtility imageCacheToPath:cachePath imageData:imageData];
            }else{
                NSLog(@"error when download");
            }
            
        });
    });
    
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//                               if (error !=nil) {
//                                   NSLog(@"image download error");
//                               }else {
//                                   ////同步线程，更新UI
//                                   dispatch_async(dispatch_get_main_queue(), ^{
//                                       UIImage *image = [UIImage imageWithData:data];
//                                       
//                                       ///加tag防止图片错位更新
//                                       if (image && [self.imageTag isEqualToString:[imageURL absoluteString]]) {
//                                           self.image = image;
//                                           [FileUtility imageCacheToPath:cachePath imageData:data];
//                                       }else{
//                                           NSLog(@"error when download:%@", error);
//                                       }
//                                   });
//                                   
//                                   
//                               }
//    }];
    
}



////异步下载图片资源
- (void)setImageContent:(NSString *)urlString placeHolder:(UIImage *)placeHolder {
    
    self.imageTag = urlString;
    
    if (placeHolder) {
        self.image = placeHolder;
    }
    
    if (urlString.length ==0) {
        return;
    }
    
    ///处理缓存的文件名
    NSString *cacheFileName = [urlString stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    ///得到缓存路径
    NSString *cachePath = [FileUtility cachePath:cacheFileName];
    
    ///如果没有找到重新请求
    NSURL *imageURL = [NSURL URLWithString:urlString];
    //    NSURLRequest *request =[NSURLRequest requestWithURL:imageURL];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:imageData];
            ///加tag防止图片错位更新
            if (image && [self.imageTag isEqualToString:[imageURL absoluteString]]) {
                self.image = image;
                [FileUtility imageCacheToPath:cachePath imageData:imageData];
            }else{
                NSLog(@"error when download");
            }
            
        });
    });
}

@end
