//
//  Witness.h
//  GoBoardPro
//
//  Created by ind726 on 03/03/15.
//  Copyright (c) 2015 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AccidentReportSubmit, Report;

@interface Witness : NSManagedObject

@property (nonatomic, retain) NSString * alternatePhone;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * homePhone;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * middleInitial;
@property (nonatomic, retain) NSString * witnessWrittenAccount;
@property (nonatomic, retain) NSString * personTypeId;
@property (nonatomic, retain) AccidentReportSubmit *accidentInfo;
@property (nonatomic, retain) Report *report;

@end
