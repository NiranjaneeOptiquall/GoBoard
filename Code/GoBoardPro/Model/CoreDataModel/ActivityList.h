//
//  ActivityList.h
//  GoBoardPro
//
//  Created by ind558 on 24/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IncidentReportInfo;
@class  AccidentReportInfo;

@interface ActivityList : NSManagedObject

@property (nonatomic, retain) NSString * activityId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) IncidentReportInfo *incidentType;
@property (nonatomic, retain) AccidentReportInfo *accidentInfo;

@end
