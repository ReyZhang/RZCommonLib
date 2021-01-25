//
//  UIImage+LK.h
//  SeeYouV2
//
//  Created by upin on 13-7-2.
//  Copyright (c) 2013年 灵感方舟. All rights reserved.
//  UIImage的扩展，包含对图片的缩放，剪切，等比缩放，加圆角，获取网络图片大小

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    UIImageGrayLevelTypeHalfGray    = 0,
    UIImageGrayLevelTypeGrayLevel   = 1,
    UIImageGrayLevelTypeDarkBrown   = 2,
    UIImageGrayLevelTypeInverse     = 3
} UIImageGrayLevelType;

@interface UIImage (LK)
+ (UIImage *)middleStretchableImageWithKey:(NSString *)key;

///缩放图片
+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
///剪切
+(UIImage*)imageWithImage:(UIImage*)image cutToRect:(CGRect)newRect;

///等比缩放
+(UIImage*)imageWithImage:(UIImage *)image ratioToSize:(CGSize)newSize;
///添加圆角
+(UIImage*)imageWithImage:(UIImage*)image roundRect:(CGSize)size;
///按最短边 等比压缩
+(UIImage*)imageWithImage:(UIImage *)image ratioCompressToSize:(CGSize)newSize;

+(UIImage *)imageWithData2:(NSData *)data scale:(CGFloat)scale;

//拍照后重绘-解决方向问题
+ (UIImage *)orientaionImage:(UIImage *)theImage;

// 图片处理 0 半灰色  1 灰度   2 深棕色    3 反色
+(UIImage*)imageWithImage:(UIImage*)image grayLevelType:(UIImageGrayLevelType)type;

//色值 变暗多少 0.0 - 1.0
+(UIImage*)imageWithImage:(UIImage*)image darkValue:(float)darkValue;


+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color;


/** 
    获取网络图片的Size, 先通过文件头来获取图片大小 
    如果失败 会下载完整的图片Data 来计算大小 所以最好别放在主线程
    如果你有使用SDWebImage就会先看下 SDWebImage有缓存过改图片没有
    支持文件头大小的格式 png、gif、jpg   http://www.cocoachina.com/bbs/read.php?tid=165823
 */
+(CGSize)downloadImageSizeWithURL:(id)imageURL;


/**
 传入需要的占位图尺寸 获取占位图
 
 @param size 需要的站位图尺寸
 @return 占位图
 */
+ (UIImage *)placeholderImageWithSize:(CGSize)size splitLine:(BOOL)splitLine;

/**
 获取视频的第一帧
 
 @param videoUrl 视频本地的路径
 @return 返回视频的第一帧Image
 */
+ (UIImage *)getVideoPreViewImage:(NSURL *)videoUrl;

/**
 拼接图片
 
 @param img1 图片1
 @param img2 图片2
 @param location 图片2相对于图片1的左上角位置
 @return 拼接后的图片
 */
+ (UIImage *)spliceImg1:(UIImage *)img1 img2:(UIImage *)img2 img2Rect:(CGRect)rect;
@end
