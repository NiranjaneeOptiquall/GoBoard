//
//  ActionTakenList.h
//  GoBoardPro
//
//  Created by ind726 on 25/02/15.
//  Copyright (c) 2015 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AccidentReportInfo, IncidentReportInfo;

@interface ActionTakenList : NSManagedObject

@property (nonatomic, retain) NSString * actionId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sequence;
@property (nonatomic, retain) NSString * emergencyPersonnel;
@property (nonatomic, retain) AccidentReportInfo *accidentInfo;
@property (nonatomic, retain) IncidentReportInfo *incidentType;

@end
