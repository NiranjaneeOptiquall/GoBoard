//
//  InjuryDetail.h
//  GoBoardPro
//
//  Created by ind558 on 26/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AccidentPerson;

@interface InjuryDetail : NSManagedObject

@property (nonatomic, retain) NSString * natureOfInjury;
@property (nonatomic, retain) NSString * injuryType;
@property (nonatomic, retain) NSString * bodyPartInjury;
@property (nonatomic, retain) NSString * bodyPartInjured;
@property (nonatomic, retain) NSString * otherInjuryText;
@property (nonatomic, retain) NSString * actionTakenId;
@property (nonatomic, retain) AccidentPerson *accidentPerson;

@end
