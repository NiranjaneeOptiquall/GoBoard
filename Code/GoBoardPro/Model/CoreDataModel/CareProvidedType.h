//
//  CareProvidedType.h
//  GoBoardPro
//
//  Created by ind558 on 24/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AccidentReportInfo;

@interface CareProvidedType : NSManagedObject

@property (nonatomic, retain) NSString * careProvidedID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) AccidentReportInfo *accidentInfo;

@end
