//
//  NatureList.h
//  GoBoardPro
//
//  Created by ind558 on 20/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IncidentReportInfo;

@interface NatureList : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * natureId;
@property (nonatomic, retain) IncidentReportInfo *incidentType;

@end
