//
//  BodyPartInjuryType.h
//  GoBoardPro
//
//  Created by ind558 on 24/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AccidentReportInfo;

@interface BodyPartInjuryType : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * typeId;
@property (nonatomic, retain) AccidentReportInfo *accidentInfo;

@end
