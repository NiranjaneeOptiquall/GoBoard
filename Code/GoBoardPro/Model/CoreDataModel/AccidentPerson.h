//
//  AccidentPerson.h
//  GoBoardPro
//
//  Created by ind558 on 28/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AccidentReportSubmit, InjuryDetail;

@interface AccidentPerson : NSManagedObject

@property (nonatomic, retain) NSString * activityTypeID;
@property (nonatomic, retain) NSString * affiliationTypeID;
@property (nonatomic, retain) NSString * alternatePhone;
@property (nonatomic, retain) NSString * apartmentNumber;
@property (nonatomic, retain) NSString * bloodBornePathogenType;
@property (nonatomic, retain) NSString * bloodCleanUpRequired;
@property (nonatomic, retain) NSString * careProvidedBy;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * conditionTypeID;
@property (nonatomic, retain) NSString * dateOfBirth;
@property (nonatomic, retain) NSString * duringWorkHours;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * employeeTitle;
@property (nonatomic, retain) NSString * equipmentTypeID;
@property (nonatomic, retain) NSString * firstAidFirstName;
@property (nonatomic, retain) NSString * firstAidLastName;
@property (nonatomic, retain) NSString * firstAidMiddleInitial;
@property (nonatomic, retain) NSString * firstAidPosition;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * genderTypeID;
@property (nonatomic, retain) NSString * guestOfFirstName;
@property (nonatomic, retain) NSString * guestOfLastName;
@property (nonatomic, retain) NSString * guestOfMiddleInitial;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * memberId;
@property (nonatomic, retain) NSString * middleInitial;
@property (nonatomic, retain) NSString * minor;
@property (nonatomic, retain) NSString * participantName;
@property (nonatomic, retain) NSData * participantSignature;
@property (nonatomic, retain) NSString * personTypeID;
@property (nonatomic, retain) NSString * primaryPhone;
@property (nonatomic, retain) NSString * staffMemberWrittenAccount;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * streetAddress;
@property (nonatomic, retain) NSString * wasBloodPresent;
@property (nonatomic, retain) NSString * wasExposedToBlood;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSData * personPhoto;
@property (nonatomic, retain) AccidentReportSubmit *accidentInfo;
@property (nonatomic, retain) NSSet *injuryList;
@end

@interface AccidentPerson (CoreDataGeneratedAccessors)

- (void)addInjuryListObject:(InjuryDetail *)value;
- (void)removeInjuryListObject:(InjuryDetail *)value;
- (void)addInjuryList:(NSSet *)values;
- (void)removeInjuryList:(NSSet *)values;

@end
