//
//  NSString+Validations.m
//  GoBoardPro
//
//  Created by ind558 on 17/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "NSString+Validations.h"

@implementation NSString (Validations)

- (NSString *)trimString {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isNumbersOnly {
    NSString *regex = @"^(?:|0|[1-9]\\d*)(?:\\.\\d*)?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isSuccess = [predicate evaluateWithObject:self];
    return isSuccess;
}

//chatacter you need will be in [ ], ? indicates that the expression before it is optional, { } indiactes the limit or range of expression before it and \\s indicates space
- (BOOL)isValidPhoneNumber {
    if ([self isEqualToString:@""]) {
        return YES;
    }
    NSString *regex = @"[+]?[(]?[0-9]{3}[)]?[-\\s]?[0-9]{3}[-\\s]?[0-9]{4,9}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isSuccess = [predicate evaluateWithObject:self];
    return isSuccess;
}


// Password validation conditions are:
// "Atleast 1 digit" specifies with: (?=.*\\d)
// "Atleast 1 alphabate" specifies with: (?=.*[a-z])
// "Atleast 1 Capital letter" specifiec with: (?=.*[A-Z])
// Must be atleast 8 char and not longer than 16 char specifies with : .{8,16}
// Regex starts with ^ and ends with $

- (BOOL)isValidPassword {
    if ([self isEqualToString:@""]) {
        return NO;
    }
    NSString *regex = @"^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,16}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isSuccess = [predicate evaluateWithObject:self];
    return isSuccess;
}

@end
