//
//  NSString+Validations.h
//  GoBoardPro
//
//  Created by ind558 on 17/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validations)
- (NSString *)trimString;
- (BOOL)isNumbersOnly;
- (BOOL)isValidPhoneNumber;
- (BOOL)isValidPassword;
@end
