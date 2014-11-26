//
//  EmergencyPersonnel.h
//  GoBoardPro
//
//  Created by ind558 on 26/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AccidentReportSubmit, Report;

@interface EmergencyPersonnel : NSManagedObject

@property (nonatomic, retain) NSString * additionalInformation;
@property (nonatomic, retain) NSString * badgeNumber;
@property (nonatomic, retain) NSString * caseNumber;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * middileInitial;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * time911Arrival;
@property (nonatomic, retain) NSString * time911Called;
@property (nonatomic, retain) NSString * time911Departure;
@property (nonatomic, retain) Report *report;
@property (nonatomic, retain) AccidentReportSubmit *accidentInfo;

@end
