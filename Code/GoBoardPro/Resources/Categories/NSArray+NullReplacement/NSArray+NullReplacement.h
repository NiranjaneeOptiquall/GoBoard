//
//  NSArray+NullReplacement.h
//  GoBoardPro
//
//  Created by E2M183 on 2/19/16.
//  Copyright © 2016 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (NullReplacement)
- (NSMutableArray *)arrayByReplacingNullsWithBlanks;
@end
