
//
//  NSArray+NullReplacement.m
//  GoBoardPro
//
//  Created by E2M183 on 2/19/16.
//  Copyright © 2016 IndiaNIC. All rights reserved.
//

#import "NSArray+NullReplacement.h"
#import "NSDictionary+NullReplacement.h"
@implementation NSArray (NullReplacement)

- (NSMutableArray *)arrayByReplacingNullsWithBlanks  {
    NSMutableArray *replaced = [self mutableCopy];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    for (int idx = 0; idx < [replaced count]; idx++) {
        id object = [replaced objectAtIndex:idx];
        if (object == nul) [replaced replaceObjectAtIndex:idx withObject:blank];
        else if ([object isKindOfClass:[NSDictionary class]]) [replaced replaceObjectAtIndex:idx withObject:[object dictionaryByReplacingNullsWithBlanks]];
        else if ([object isKindOfClass:[NSArray class]]) [replaced replaceObjectAtIndex:idx withObject:[object arrayByReplacingNullsWithBlanks]];
    }
    return [NSMutableArray arrayWithArray:replaced];
}

@end
