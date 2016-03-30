//
//  UIColor+HexToRGB.m
//  iNICApp
//
//  Created by ind558 on 09/10/13.
//  Copyright (c) 2013 IndiaNIC. All rights reserved.
//

#import "UIColor+HexToRGB.h"

@implementation UIColor (HexToRGB)

+ (UIColor *)colorWithHexCodeString:(NSString*)hexCode {
    
    if (hexCode!=nil) {
        const char *cStr = [hexCode cStringUsingEncoding:NSASCIIStringEncoding];
        long x = strtol(cStr+1, NULL, 16);
        return [UIColor colorWithHex:(UInt32)x alpha:1.0];
    }
    else
       return [UIColor clearColor];
    
}

+ (UIColor *)colorWithHex:(UInt32)col alpha:(float)alpha{
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString*)hexCode alpha:(float)alpha {
    const char *cStr = [hexCode cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [UIColor colorWithHex:x alpha:alpha];
}

+ (UIColor *)darkColorWithHexCodeString:(NSString*)hexCode {
    const char *cStr = [hexCode cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    UIColor *c = [UIColor colorWithHex:x alpha:1.0];
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.1, 0.0)
                               green:MAX(g - 0.1, 0.0)
                                blue:MAX(b - 0.1, 0.0)
                               alpha:a];
    return nil;
}

+ (UIColor *)darkerColorWithHexCodeString:(NSString*)hexCode {
    const char *cStr = [hexCode cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    UIColor *c = [UIColor colorWithHex:x alpha:1.0];
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.2, 0.0)
                               green:MAX(g - 0.2, 0.0)
                                blue:MAX(b - 0.2, 0.0)
                               alpha:a];
    return nil;
}

@end
