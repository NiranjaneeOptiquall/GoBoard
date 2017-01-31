//
//  AccidentReportInfo.h
//  GoBoardPro
//
//  Created by ind726 on 26/02/15.
//  Copyright (c) 2015 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AbdomenInjuryList, ActionTakenList, ActivityList, ArmInjuryList, BodyPartInjuryType, CareProvidedType, ConditionList, EquipmentList, GeneralInjuryType, HeadInjuryList, LeftArmInjuryList, LeftLegInjuryList, LegInjuryList, RequiredField;

@interface AccidentReportInfo : NSManagedObject

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
@property (nonatomic, retain) NSString * refusedCareStatement;
@property (nonatomic, retain) NSString * selfCareStatement;
@property (nonatomic, retain) NSNumber * showAffiliation;
@property (nonatomic, retain) NSNumber * showBloodbornePathogens;
@property (nonatomic, retain) NSNumber * showCommunicationAndNotification;
@property (nonatomic, retain) NSNumber * showConditions;
@property (nonatomic, retain) NSNumber * showDateOfBirth;
@property (nonatomic, retain) NSNumber * showEmergencyPersonnel;
@property (nonatomic, retain) NSNumber * showEmployeeId;
@property (nonatomic, retain) NSNumber * showGender;
@property (nonatomic, retain) NSNumber * showGuestId;
@property (nonatomic, retain) NSNumber * showManagementFollowup;
@property (nonatomic, retain) NSNumber * showMemberIdAndDriverLicense;
@property (nonatomic, retain) NSNumber * showMinor;
@property (nonatomic, retain) NSNumber * showNotificationField1;
@property (nonatomic, retain) NSNumber * showNotificationField2;
@property (nonatomic, retain) NSNumber * showNotificationField3;
@property (nonatomic, retain) NSNumber * showNotificationField4;
@property (nonatomic, retain) NSNumber * showParticipantSignature;
@property (nonatomic, retain) NSNumber * showPhotoIcon;
@property (nonatomic, retain) NSNumber * showRefusedSelfCareText;
@property (nonatomic, retain) NSNumber * showSelfCareText;
@property (nonatomic, retain) NSNumber * notificationField1Alert;
@property (nonatomic, retain) NSNumber * notificationField2Alert;
@property (nonatomic, retain) NSNumber * notificationField3Alert;
@property (nonatomic, retain) NSNumber * notificationField4Alert;
@property (nonatomic, retain) NSSet *abdomenInjuryList;
@property (nonatomic, retain) NSSet *actionList;
@property (nonatomic, retain) NSSet *activityList;
@property (nonatomic, retain) NSSet *bodypartInjuryType;
@property (nonatomic, retain) NSSet *careProviderList;
@property (nonatomic, retain) NSSet *conditionList;
@property (nonatomic, retain) NSSet *equipmentList;
@property (nonatomic, retain) NSSet *generalInjuryType;
@property (nonatomic, retain) NSSet *headInjuryList;
@property (nonatomic, retain) NSSet *leftArmInjuryList;
@property (nonatomic, retain) NSSet *leftLegInjuryList;
@property (nonatomic, retain) NSSet *requiredFields;
@property (nonatomic, retain) NSSet *rightArmInjuryList;
@property (nonatomic, retain) NSSet *rightLegInjuryList;
@end

@interface AccidentReportInfo (CoreDataGeneratedAccessors)

- (void)addAbdomenInjuryListObject:(AbdomenInjuryList *)value;
- (void)removeAbdomenInjuryListObject:(AbdomenInjuryList *)value;
- (void)addAbdomenInjuryList:(NSSet *)values;
- (void)removeAbdomenInjuryList:(NSSet *)values;

- (void)addActionListObject:(ActionTakenList *)value;
- (void)removeActionListObject:(ActionTakenList *)value;
- (void)addActionList:(NSSet *)values;
- (void)removeActionList:(NSSet *)values;

- (void)addActivityListObject:(ActivityList *)value;
- (void)removeActivityListObject:(ActivityList *)value;
- (void)addActivityList:(NSSet *)values;
- (void)removeActivityList:(NSSet *)values;

- (void)addBodypartInjuryTypeObject:(BodyPartInjuryType *)value;
- (void)removeBodypartInjuryTypeObject:(BodyPartInjuryType *)value;
- (void)addBodypartInjuryType:(NSSet *)values;
- (void)removeBodypartInjuryType:(NSSet *)values;

- (void)addCareProviderListObject:(CareProvidedType *)value;
- (void)removeCareProviderListObject:(CareProvidedType *)value;
- (void)addCareProviderList:(NSSet *)values;
- (void)removeCareProviderList:(NSSet *)values;

- (void)addConditionListObject:(ConditionList *)value;
- (void)removeConditionListObject:(ConditionList *)value;
- (void)addConditionList:(NSSet *)values;
- (void)removeConditionList:(NSSet *)values;

- (void)addEquipmentListObject:(EquipmentList *)value;
- (void)removeEquipmentListObject:(EquipmentList *)value;
- (void)addEquipmentList:(NSSet *)values;
- (void)removeEquipmentList:(NSSet *)values;

- (void)addGeneralInjuryTypeObject:(GeneralInjuryType *)value;
- (void)removeGeneralInjuryTypeObject:(GeneralInjuryType *)value;
- (void)addGeneralInjuryType:(NSSet *)values;
- (void)removeGeneralInjuryType:(NSSet *)values;

- (void)addHeadInjuryListObject:(HeadInjuryList *)value;
- (void)removeHeadInjuryListObject:(HeadInjuryList *)value;
- (void)addHeadInjuryList:(NSSet *)values;
- (void)removeHeadInjuryList:(NSSet *)values;

- (void)addLeftArmInjuryListObject:(LeftArmInjuryList *)value;
- (void)removeLeftArmInjuryListObject:(LeftArmInjuryList *)value;
- (void)addLeftArmInjuryList:(NSSet *)values;
- (void)removeLeftArmInjuryList:(NSSet *)values;

- (void)addLeftLegInjuryListObject:(LeftLegInjuryList *)value;
- (void)removeLeftLegInjuryListObject:(LeftLegInjuryList *)value;
- (void)addLeftLegInjuryList:(NSSet *)values;
- (void)removeLeftLegInjuryList:(NSSet *)values;

- (void)addRequiredFieldsObject:(RequiredField *)value;
- (void)removeRequiredFieldsObject:(RequiredField *)value;
- (void)addRequiredFields:(NSSet *)values;
- (void)removeRequiredFields:(NSSet *)values;

- (void)addRightArmInjuryListObject:(ArmInjuryList *)value;
- (void)removeRightArmInjuryListObject:(ArmInjuryList *)value;
- (void)addRightArmInjuryList:(NSSet *)values;
- (void)removeRightArmInjuryList:(NSSet *)values;

- (void)addRightLegInjuryListObject:(LegInjuryList *)value;
- (void)removeRightLegInjuryListObject:(LegInjuryList *)value;
- (void)addRightLegInjuryList:(NSSet *)values;
- (void)removeRightLegInjuryList:(NSSet *)values;

@end
