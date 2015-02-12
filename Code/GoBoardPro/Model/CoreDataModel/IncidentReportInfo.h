//
//  IncidentReportInfo.h
//  GoBoardPro
//
//  Created by ind726 on 12/02/15.
//  Copyright (c) 2015 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ActionTakenList, ActivityList, ConditionList, EquipmentList, NatureList, RequiredField;

@interface IncidentReportInfo : NSManagedObject

@property (nonatomic, retain) NSString * affiliation1;
@property (nonatomic, retain) NSString * affiliation2;
@property (nonatomic, retain) NSString * affiliation3;
@property (nonatomic, retain) NSString * affiliation4;
@property (nonatomic, retain) NSString * affiliation5;
@property (nonatomic, retain) NSString * affiliation6;
@property (nonatomic, retain) NSString * instructions;
@property (nonatomic, retain) NSString * notificationField1;
@property (nonatomic, retain) NSString * notificationField1Color;
@property (nonatomic, retain) NSString * notificationField2;
@property (nonatomic, retain) NSString * notificationField2Color;
@property (nonatomic, retain) NSString * notificationField3;
@property (nonatomic, retain) NSString * notificationField3Color;
@property (nonatomic, retain) NSString * notificationField4;
@property (nonatomic, retain) NSString * notificationField4Color;
@property (nonatomic, retain) NSString * personInvolved1;
@property (nonatomic, retain) NSString * personInvolved2;
@property (nonatomic, retain) NSString * personInvolved3;
@property (nonatomic, retain) NSString * reportType;
@property (nonatomic, retain) NSNumber * showAffiliation;
@property (nonatomic, retain) NSNumber * showConditions;
@property (nonatomic, retain) NSNumber * showDateOfBirth;
@property (nonatomic, retain) NSNumber * showEmergencyPersonnel;
@property (nonatomic, retain) NSNumber * showEmployeeId;
@property (nonatomic, retain) NSNumber * showGender;
@property (nonatomic, retain) NSNumber * showManagementFollowup;
@property (nonatomic, retain) NSNumber * showMemberIdAndDriverLicense;
@property (nonatomic, retain) NSNumber * showMinor;
@property (nonatomic, retain) NSNumber * showPhotoIcon;
@property (nonatomic, retain) NSNumber * showGuestId;
@property (nonatomic, retain) NSSet *actionList;
@property (nonatomic, retain) NSSet *activityList;
@property (nonatomic, retain) NSSet *conditionList;
@property (nonatomic, retain) NSSet *equipmentList;
@property (nonatomic, retain) NSSet *natureList;
@property (nonatomic, retain) NSSet *requiredFields;
@end

@interface IncidentReportInfo (CoreDataGeneratedAccessors)

- (void)addActionListObject:(ActionTakenList *)value;
- (void)removeActionListObject:(ActionTakenList *)value;
- (void)addActionList:(NSSet *)values;
- (void)removeActionList:(NSSet *)values;

- (void)addActivityListObject:(ActivityList *)value;
- (void)removeActivityListObject:(ActivityList *)value;
- (void)addActivityList:(NSSet *)values;
- (void)removeActivityList:(NSSet *)values;

- (void)addConditionListObject:(ConditionList *)value;
- (void)removeConditionListObject:(ConditionList *)value;
- (void)addConditionList:(NSSet *)values;
- (void)removeConditionList:(NSSet *)values;

- (void)addEquipmentListObject:(EquipmentList *)value;
- (void)removeEquipmentListObject:(EquipmentList *)value;
- (void)addEquipmentList:(NSSet *)values;
- (void)removeEquipmentList:(NSSet *)values;

- (void)addNatureListObject:(NatureList *)value;
- (void)removeNatureListObject:(NatureList *)value;
- (void)addNatureList:(NSSet *)values;
- (void)removeNatureList:(NSSet *)values;

- (void)addRequiredFieldsObject:(RequiredField *)value;
- (void)removeRequiredFieldsObject:(RequiredField *)value;
- (void)addRequiredFields:(NSSet *)values;
- (void)removeRequiredFields:(NSSet *)values;

@end
