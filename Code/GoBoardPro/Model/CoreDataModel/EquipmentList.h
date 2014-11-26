//
//  EquipmentList.h
//  GoBoardPro
//
//  Created by ind558 on 24/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IncidentReportInfo;

@interface EquipmentList : NSManagedObject

@property (nonatomic, retain) NSString * equipmentId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) IncidentReportInfo *incidentType;
@property (nonatomic, retain) NSManagedObject *accidentInfo;

@end