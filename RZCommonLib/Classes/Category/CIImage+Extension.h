//
//  CIImage+Extension.h
//  01-生成二维码
//
//  Created by xiaomage on 15/12/25.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import <UIKit/UIKit.h>

@interface CIImage (Extension)

- (UIImage *)createNonInterpolatedWithSize:(CGFloat)size;

@end
