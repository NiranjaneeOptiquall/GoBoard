//
//  Report.h
//  GoBoardPro
//
//  Created by ind558 on 22/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EmergencyPersonnel, Person, Witness;

@interface Report : NSManagedObject

@property (nonatomic, retain) NSString * actionId;
@property (nonatomic, retain) NSString * activityTypeID;
@property (nonatomic, retain) NSString * additionalInfo;
@property (nonatomic, retain) NSString * conditionTypeID;
@property (nonatomic, retain) NSString * dateOfIncident;
@property (nonatomic, retain) NSString * employeeAlternatePhone;
@property (nonatomic, retain) NSString * employeeEmail;
@property (nonatomic, retain) NSString * employeeFirstName;
@property (nonatomic, retain) NSString * employeeHomePhone;
@property (nonatomic, retain) NSString * employeeLastName;
@property (nonatomic, retain) NSString * employeeMiddleInitial;
@property (nonatomic, retain) NSString * equipmentTypeID;
@property (nonatomic, retain) NSString * facilityId;
@property (nonatomic, retain) NSString * followUpCallType;
@property (nonatomic, retain) NSString * incidentDesc;
@property (nonatomic, retain) NSString * isNotification1Selected;
@property (nonatomic, retain) NSString * isNotification2Selected;
@property (nonatomic, retain) NSString * isNotification3Selected;
@property (nonatomic, retain) NSString * isNotification4Selected;
@property (nonatomic, retain) NSString * locationId;
@property (nonatomic, retain) NSString * managementFollowUpDate;
@property (nonatomic, retain) NSString * natureId;
@property (nonatomic, retain) NSString * reportFilerAccount;
@property (nonatomic, retain) NSNumber * isCompleted;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSNumber * incidentType;
@property (nonatomic, retain) NSSet *emergencyPersonnels;
@property (nonatomic, retain) NSSet *persons;
@property (nonatomic, retain) NSSet *witnesses;
@end

@interface Report (CoreDataGeneratedAccessors)

- (void)addEmergencyPersonnelsObject:(EmergencyPersonnel *)value;
- (void)removeEmergencyPersonnelsObject:(EmergencyPersonnel *)value;
- (void)addEmergencyPersonnels:(NSSet *)values;
- (void)removeEmergencyPersonnels:(NSSet *)values;

- (void)addPersonsObject:(Person *)value;
- (void)removePersonsObject:(Person *)value;
- (void)addPersons:(NSSet *)values;
- (void)removePersons:(NSSet *)values;

- (void)addWitnessesObject:(Witness *)value;
- (void)removeWitnessesObject:(Witness *)value;
- (void)addWitnesses:(NSSet *)values;
- (void)removeWitnesses:(NSSet *)values;

@end
