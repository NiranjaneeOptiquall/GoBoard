//
//  InjuryDetail.h
//  GoBoardPro
//
//  Created by ind726 on 24/03/15.
//  Copyright (c) 2015 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AccidentPerson;

@interface InjuryDetail : NSManagedObject

@property (nonatomic, retain) NSString * actionTakenId;
@property (nonatomic, retain) NSString * bodyPartInjuredId;
@property (nonatomic, retain) NSString * bodyPartInjuryTypeId;
@property (nonatomic, retain) NSString * generalInjuryOther;
@property (nonatomic, retain) NSString * generalInjuryTypeId;
@property (nonatomic, retain) NSString * natureId;
@property (nonatomic, retain) NSString * bodyPartInjuredLocation;
@property (nonatomic, retain) AccidentPerson *accidentPerson;

@end
