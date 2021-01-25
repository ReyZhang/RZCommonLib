//
//  UIImage+LK.m
//  SeeYouV2
//
//  Created by upin on 13-7-2.
//  Copyright (c) 2013年 灵感方舟. All rights reserved.
//

#import "UIImage+LK.h"
#import "FileUtility.h"
#import <AVFoundation/AVFoundation.h>

@implementation UIImage (LK)
+ (UIImage *)middleStretchableImageWithKey:(NSString *)key {
    UIImage *image = [UIImage imageNamed:key];
    return [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
}


//缩放
+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
//剪切
+(UIImage *)imageWithImage:(UIImage *)image cutToRect:(CGRect)newRect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, newRect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    return smallImage;
}
//等比缩放
+(UIImage *)imageWithImage:(UIImage *)image ratioToSize:(CGSize)newSize
{
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    float verticalRadio = newSize.height/height;
    float horizontalRadio = newSize.width/width;
    float radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    width = width*radio;
    height = height*radio;
    
    return [self imageWithImage:image scaledToSize:CGSizeMake(width,height)];
}
//按最短边 等比压缩
+(UIImage *)imageWithImage:(UIImage *)image ratioCompressToSize:(CGSize)newSize
{
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    if(width < newSize.width && height < newSize.height)
    {
        return image;
    }
    else
    {
        return [self imageWithImage:image ratioToSize:newSize];
    }
}
#pragma mark 添加圆角
+(UIImage *)imageWithImage:(UIImage *)image roundRect:(CGSize)size
{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, (uint32_t)kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, 5, 5);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    UIImage* image2 =  [UIImage imageWithCGImage:imageMasked];
    CGContextRelease(context);
    CGImageRelease(imageMasked);
    CGColorSpaceRelease(colorSpace);
    return image2;
}
+(UIImage *)imageWithData2:(NSData *)data scale:(CGFloat)scale
{
    return [UIImage imageWithCGImage:[UIImage imageWithData:data].CGImage scale:scale orientation:UIImageOrientationUp];
}
//添加圆角
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw,fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+(UIImage *)imageWithImage:(UIImage *)image darkValue:(float)darkValue
{
    return [UIImage imageWithImage:image pixelOperationBlock:^(UInt8 *redRef, UInt8 *greenRef, UInt8 *blueRef) {
        *redRef = *redRef * darkValue;
        *greenRef = *greenRef * darkValue;
        *blueRef = *blueRef * darkValue;
    }];
}
// 图片处理 0 半灰色  1 灰度   2 深棕色    3 反色
+(UIImage *)imageWithImage:(UIImage *)image grayLevelType:(UIImageGrayLevelType)type{
    return [UIImage imageWithImage:image pixelOperationBlock:^(UInt8 *redRef, UInt8 *greenRef, UInt8 *blueRef) {
        
        UInt8 red = * redRef , green = * greenRef , blue = * blueRef;
        switch (type) {
            case 0:
                *redRef = red * 0.5;
                *greenRef = green * 0.5;
                *blueRef = blue * 0.5;
                break;
            case 1://モノクロ
            {
                //輝度計算
                UInt8 brightness = (77 * red + 28 * green + 151 * blue) / 256;
                *redRef = brightness;
                *greenRef = brightness;
                *blueRef = brightness;
            }
                break;
            case 2://セピア
                *redRef = red;
                *greenRef = green * 0.7;
                *blueRef = blue * 0.4;
                break;
                
            case 3://色反転
                *redRef = 255 - red;
                *greenRef = 255 - green;
                *blueRef = 255 - blue;
                break;
        }
        
    }];
}
+(UIImage *)imageWithImage:(UIImage *)image pixelOperationBlock:(void(^)(UInt8 *redRef, UInt8 *greenRef, UInt8 *blueRef))block
{
    if(block == nil)
        return image;
    
    CGImageRef  imageRef = image.CGImage;
    if(imageRef == NULL)
        return nil;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    // ピクセルを構成するRGB各要素が何ビットで構成されている
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    
    // ピクセル全体は何ビットで構成されているか
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    // 画像の横1ライン分のデータが、何バイトで構成されているか
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    // 画像の色空間
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    
    // 画像のBitmap情報
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    // 画像がピクセル間の補完をしているか
    bool shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    
    // 表示装置によって補正をしているか
    CGColorRenderingIntent intent = CGImageGetRenderingIntent(imageRef);
    
    // 画像のデータプロバイダを取得する
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    
    // データプロバイダから画像のbitmap生データ取得
    CFDataRef   data = CGDataProviderCopyData(dataProvider);
    UInt8* buffer = (UInt8*)CFDataGetBytePtr(data);
    
    // 1ピクセルずつ画像を処理
    NSUInteger  x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8*  tmp;
            tmp = buffer + y * bytesPerRow + x * 4; // RGBAの4つ値をもっているので、1ピクセルごとに*4してずらす
            
            // RGB値を取得
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            
            block(&red,&green,&blue);
            
            *(tmp + 0) = red;
            *(tmp + 1) = green;
            *(tmp + 2) = blue;
        }
    }
    
    // 効果を与えたデータ生成
    CFDataRef   effectedData;
    effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    
    // 効果を与えたデータプロバイダを生成
    CGDataProviderRef   effectedDataProvider;
    effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    // 画像を生成
    CGImageRef  effectedCgImage;
    UIImage*    effectedImage;
    effectedCgImage = CGImageCreate(
                                    width, height,
                                    bitsPerComponent, bitsPerPixel, bytesPerRow,
                                    colorSpace, bitmapInfo, effectedDataProvider,
                                    NULL, shouldInterpolate, intent);
    effectedImage = [UIImage imageWithCGImage:effectedCgImage];
    
    // データの解放
    CGImageRelease(effectedCgImage);
    CFRelease(effectedDataProvider);
    CFRelease(effectedData);
    CFRelease(data);
    
    return effectedImage;
}

//讨厌警告
-(id)diskImageDataBySearchingAllPathsForKey:(id)key{return nil;}


///根据颜色值来创建图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect  = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context  = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    ////填充颜色
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    UIImage *img = [self imageWithColor:color size:CGSizeMake(1, 1)];
    return img;
}

+ (CGSize )parseFileName:(NSString *)absoluteString {
    NSString *fileName = [absoluteString lastPathComponent]; ////取路径中的最后一个元素
    if ([fileName rangeOfString:@"thumb"].location != NSNotFound || [fileName rangeOfString:@"real"].location != NSNotFound) {
        NSArray *components = [fileName componentsSeparatedByString:@"_"];
        return CGSizeMake([components[1] floatValue], [components[2] floatValue]);
    }
    
    return CGSizeZero;
}


////获取网络图片的大小

+(CGSize)downloadImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        return CGSizeZero;
    
    NSString* absoluteString = URL.absoluteString;
//    CGSize imgSize = [self parseFileName:absoluteString];
    
    ////如果取到的Size 不为空，直接返回
//    if (!CGSizeEqualToSize(imgSize, CGSizeZero)) {
//        return imgSize;
//    }
    
    NSString *cacheFileName = [absoluteString stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    ///得到缓存路径
    NSString *cachePath = [FileUtility cachePath:cacheFileName];
    ///从缓存中读取image,如果找到直接返回
    id cacheImage = [FileUtility imageDataFromPath:cachePath];
    if (cacheImage != [NSNull null]) {
        UIImage *img = (UIImage *)cacheImage;
        return  img.size;
    }

    
    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
//    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
//    if([pathExtendsion isEqualToString:@"png"]){
//        size =  [self downloadPNGImageSizeWithRequest:request];
//    }
//    else if([pathExtendsion isEqual:@"gif"])
//    {
//        size =  [self downloadGIFImageSizeWithRequest:request];
//    }
//    else{
//        size = [self downloadJPGImageSizeWithRequest:request];
//    }
    if(CGSizeEqualToSize(CGSizeZero, size))
    {
        NSData* data = [NSData dataWithContentsOfURL:URL];
        UIImage* image = [UIImage imageWithData:data];
        if(image)
        {
            [FileUtility imageCacheToPath:cachePath imageData:data];
            size = image.size;
        }
    }
    return size;
}
+(CGSize)downloadPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
+(CGSize)downloadGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
+(CGSize)downloadJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}
+ (UIImage *)orientaionImage:(UIImage *)theImage{
    if (theImage.imageOrientation == UIImageOrientationUp) return theImage;
    UIGraphicsBeginImageContextWithOptions(theImage.size, NO, theImage.scale);
    [theImage drawInRect:(CGRect){0, 0, theImage.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}



/**
 传入需要的占位图尺寸 获取占位图
 
 @param size 需要的站位图尺寸
 @return 占位图
 */
+ (UIImage *)placeholderImageWithSize:(CGSize)size splitLine:(BOOL)splitLine {
    
    // 占位图的背景色
    UIColor *backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:1];
    // 中间LOGO图片
    UIImage *image = [UIImage imageNamed:@"placeholder"];
    // 根据占位图需要的尺寸 计算 中间LOGO的宽高
    CGFloat logoWH = (size.width > size.height ? size.height : size.width)-(splitLine ? 10 : 0);
    CGSize logoSize = CGSizeMake(logoWH, logoWH);
    // 打开上下文
    UIGraphicsBeginImageContextWithOptions(size,0, [UIScreen mainScreen].scale);
    // 绘图
    [backgroundColor set];
    UIRectFill(CGRectMake(0,0, size.width, size.height));
    
    if (splitLine) {
        [[UIColor whiteColor] set];
        UIRectFill(CGRectMake(0, 0, size.width, 5));
        UIRectFill(CGRectMake(0, size.height-5, size.width, 5));
    }
   
    
    CGFloat imageX = (size.width / 2) - (logoSize.width / 2);
    CGFloat imageY = (size.height / 2) - (logoSize.height / 2);
    [image drawInRect:CGRectMake(imageX, imageY, logoSize.width, logoSize.height)];
    UIImage *resImage =UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return resImage;
    
}


/**
 获取视频的第一帧
 
 @param videoUrl 视频本地的路径
 @return 返回视频的第一帧Image
 */
+ (UIImage *)getVideoPreViewImage:(NSURL *)videoUrl
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL: videoUrl options:nil];
    AVAssetImageGenerator *assetGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}


/**
 拼接图片
 
 @param img1 图片1
 @param img2 图片2
 @param location 图片2相对于图片1的左上角位置
 @return 拼接后的图片
 */
+ (UIImage *)spliceImg1:(UIImage *)img1 img2:(UIImage *)img2 img2Rect:(CGRect)rect {
    
    //    CGSize size1 = img1.size;
//    CGSize size2 = img2.size;
    
    UIGraphicsBeginImageContextWithOptions(img1.size, NO, [[UIScreen mainScreen] scale]);
    [img1 drawInRect:CGRectMake(0, 0, img1.size.width, img1.size.height)];
    
    //    [img2 drawInRect:CGRectMake((size1.width-size2.width)/2.0, (size1.height-size2.height)/2.0, size2.width, size2.height)];
    //    [img2 drawInRect:CGRectMake(size1.width/4.0, size1.height/2.5, size1.width/2, size1.width/2)];
    [img2 drawInRect:rect];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
}

@end
