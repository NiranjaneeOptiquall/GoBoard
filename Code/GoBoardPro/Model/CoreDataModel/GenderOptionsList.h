//
//  GenderOptionsList.h
//  GoBoardPro
//
//  Created by Optiquall Solutions on 12/02/18.
//  Copyright © 2018 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AccidentReportInfo,IncidentReportInfo;

@interface GenderOptionsList : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, assign) NSString * isShow;
@property (nonatomic, retain) AccidentReportInfo *accidentInfo;
@property (nonatomic, retain) IncidentReportInfo *incidentType;

@end
