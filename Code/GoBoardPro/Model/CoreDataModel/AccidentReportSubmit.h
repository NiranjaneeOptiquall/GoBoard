//
//  AccidentReportSubmit.h
//  GoBoardPro
//
//  Created by ind558 on 28/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AccidentPerson, EmergencyPersonnel, Witness;

@interface AccidentReportSubmit : NSManagedObject

@property (nonatomic, retain) NSString * accidentDesc;
@property (nonatomic, retain) NSString * additionalInfo;
@property (nonatomic, retain) NSString * dateOfIncident;
@property (nonatomic, retain) NSString * employeeAlternatePhone;
@property (nonatomic, retain) NSString * employeeEmail;
@property (nonatomic, retain) NSString * employeeFirstName;
@property (nonatomic, retain) NSString * employeeHomePhone;
@property (nonatomic, retain) NSString * employeeLastName;
@property (nonatomic, retain) NSString * employeeMiddleInitial;
@property (nonatomic, retain) NSString * facilityId;
@property (nonatomic, retain) NSString * isAdminstrationSelected;
@property (nonatomic, retain) NSString * isAllSupervisorSelected;
@property (nonatomic, retain) NSString * isNotification1Selected;
@property (nonatomic, retain) NSString * isNotification2Selected;
@property (nonatomic, retain) NSString * isNotification3Selected;
@property (nonatomic, retain) NSString * isNotification4Selected;
@property (nonatomic, retain) NSString * isRiskManagementSelected;
@property (nonatomic, retain) NSString * locationId;
@property (nonatomic, retain) NSString * reportFilerAccount;
@property (nonatomic, retain) NSSet *accidentPerson;
@property (nonatomic, retain) NSSet *emergencyPersonnels;
@property (nonatomic, retain) NSSet *witnesses;
@end

@interface AccidentReportSubmit (CoreDataGeneratedAccessors)

- (void)addAccidentPersonObject:(AccidentPerson *)value;
- (void)removeAccidentPersonObject:(AccidentPerson *)value;
- (void)addAccidentPerson:(NSSet *)values;
- (void)removeAccidentPerson:(NSSet *)values;

- (void)addEmergencyPersonnelsObject:(EmergencyPersonnel *)value;
- (void)removeEmergencyPersonnelsObject:(EmergencyPersonnel *)value;
- (void)addEmergencyPersonnels:(NSSet *)values;
- (void)removeEmergencyPersonnels:(NSSet *)values;

- (void)addWitnessesObject:(Witness *)value;
- (void)removeWitnessesObject:(Witness *)value;
- (void)addWitnesses:(NSSet *)values;
- (void)removeWitnesses:(NSSet *)values;

@end
