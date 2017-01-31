//
//  UIColor+HexToRGB.h
//  iNICApp
//
//  Created by ind558 on 09/10/13.
//  Copyright (c) 2013 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexToRGB)

+ (UIColor *)colorWithHexCodeString:(NSString*)hexCode;
+ (UIColor *)darkColorWithHexCodeString:(NSString*)hexCode;
+ (UIColor *)darkerColorWithHexCodeString:(NSString*)hexCode;
+ (UIColor *)colorWithHexString:(NSString*)hexCode alpha:(float)alpha;
@end
