//
//  UtilizationCount.m
//  GoBoardPro
//
//  Created by ind558 on 18/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "UtilizationCount.h"
#import "UtilizationCount.h"


@implementation UtilizationCount

@dynamic locationId;
@dynamic name;
@dynamic capacity;
@dynamic lastCount;
@dynamic lastCountDateTime;
@dynamic message;
@dynamic sublocations;
@dynamic location;

@synthesize originalCount, originalMessage, isCountRemainSame, isUpdateAvailable;

- (void)setInitialValues {
    self.originalMessage = self.message;
    self.originalCount = [self.lastCount integerValue];
    self.isCountRemainSame = NO;
    self.isUpdateAvailable = NO;
}

@end
