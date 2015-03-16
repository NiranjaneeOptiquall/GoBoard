//
//  UtilizationCount.m
//  GoBoardPro
//
//  Created by ind726 on 13/03/15.
//  Copyright (c) 2015 IndiaNIC. All rights reserved.
//

#import "UtilizationCount.h"
#import "UtilizationCount.h"


@implementation UtilizationCount


@synthesize originalCount, originalMessage, isCountRemainSame, isUpdateAvailable;

- (void)setInitialValues {
    self.originalMessage = self.message;
    self.originalCount = [self.lastCount integerValue];
    self.isCountRemainSame = NO;
    self.isUpdateAvailable = NO;
}

@dynamic capacity;
@dynamic lastCount;
@dynamic lastCountDateTime;
@dynamic locationId;
@dynamic message;
@dynamic name;
@dynamic sequence;
@dynamic location;
@dynamic sublocations;

@end
