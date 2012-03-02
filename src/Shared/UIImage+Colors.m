//
//  UIImage+Colors.m
//  MultiBoard
//
//  Created by Ethan Sherbondy on 3/2/12.
//  Copyright (c) 2012 MIT. All rights reserved.
//

#import "UIImage+Colors.h"

@implementation UIImage (Colors)

+ (UIImage *)imageWithUIColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
