//
//  CareProvidedType.h
//  GoBoardPro
//
//  Created by ind726 on 04/02/15.
//  Copyright (c) 2015 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AccidentReportInfo;

@interface CareProvidedType : NSManagedObject

@property (nonatomic, retain) NSString * careProvidedID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * refusedCare;
@property (nonatomic, retain) NSString * selfCare;
@property (nonatomic, retain) NSString * firstAid;
@property (nonatomic, retain) NSString * emergencyPersonnel;
@property (nonatomic, retain) NSString * emergencyResponse;
@property (nonatomic, retain) NSString * sequence;
@property (nonatomic, retain) AccidentReportInfo *accidentInfo;

@end
