//
//  AccidentReportInfo.h
//  GoBoardPro
//
//  Created by ind558 on 24/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AbdomenInjuryList, ActionTakenList, ActivityList, ArmInjuryList, BodyPartInjuryType, CareProvidedType, ConditionList, EquipmentList, GeneralInjuryType, HeadInjuryList, LegInjuryList, RequiredField;

@interface AccidentReportInfo : NSManagedObject

@property (nonatomic, retain) NSString * notificationField2;
@property (nonatomic, retain) NSNumber * showEmergencyPersonnel;
@property (nonatomic, retain) NSNumber * showRefusedSelfCareText;
@property (nonatomic, retain) NSNumber * showGender;
@property (nonatomic, retain) NSNumber * showAffiliation;
@property (nonatomic, retain) NSString * notificationField4;
@property (nonatomic, retain) NSString * notificationField3;
@property (nonatomic, retain) NSString * notificationField1;
@property (nonatomic, retain) NSString * selfCareStatement;
@property (nonatomic, retain) NSString * refusedCareStatement;
@property (nonatomic, retain) NSNumber * showCommunicationAndNotification;
@property (nonatomic, retain) NSNumber * showParticipantSignature;
@property (nonatomic, retain) NSNumber * showConditions;
@property (nonatomic, retain) NSNumber * showEmployeeId;
@property (nonatomic, retain) NSNumber * showMemberIdAndDriverLicense;
@property (nonatomic, retain) NSNumber * showBloodbornePathogens;
@property (nonatomic, retain) NSNumber * showMinor;
@property (nonatomic, retain) NSNumber * showPhotoIcon;
@property (nonatomic, retain) NSNumber * showDateOfBirth;
@property (nonatomic, retain) NSNumber * showManagementFollowup;
@property (nonatomic, retain) NSString * instructions;
@property (nonatomic, retain) NSSet *actionList;
@property (nonatomic, retain) NSSet *activityList;
@property (nonatomic, retain) NSSet *conditionList;
@property (nonatomic, retain) NSSet *equipmentList;
@property (nonatomic, retain) NSSet *careProviderList;
@property (nonatomic, retain) NSSet *generalInjuryType;
@property (nonatomic, retain) NSSet *bodypartInjuryType;
@property (nonatomic, retain) NSSet *headInjuryList;
@property (nonatomic, retain) NSSet *abdomenInjuryList;
@property (nonatomic, retain) NSSet *armInjuryList;
@property (nonatomic, retain) NSSet *legInjuryList;
@property (nonatomic, retain) NSSet *requiredFields;
@end

@interface AccidentReportInfo (CoreDataGeneratedAccessors)

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

- (void)addCareProviderListObject:(CareProvidedType *)value;
- (void)removeCareProviderListObject:(CareProvidedType *)value;
- (void)addCareProviderList:(NSSet *)values;
- (void)removeCareProviderList:(NSSet *)values;

- (void)addGeneralInjuryTypeObject:(GeneralInjuryType *)value;
- (void)removeGeneralInjuryTypeObject:(GeneralInjuryType *)value;
- (void)addGeneralInjuryType:(NSSet *)values;
- (void)removeGeneralInjuryType:(NSSet *)values;

- (void)addBodypartInjuryTypeObject:(BodyPartInjuryType *)value;
- (void)removeBodypartInjuryTypeObject:(BodyPartInjuryType *)value;
- (void)addBodypartInjuryType:(NSSet *)values;
- (void)removeBodypartInjuryType:(NSSet *)values;

- (void)addHeadInjuryListObject:(HeadInjuryList *)value;
- (void)removeHeadInjuryListObject:(HeadInjuryList *)value;
- (void)addHeadInjuryList:(NSSet *)values;
- (void)removeHeadInjuryList:(NSSet *)values;

- (void)addAbdomenInjuryListObject:(AbdomenInjuryList *)value;
- (void)removeAbdomenInjuryListObject:(AbdomenInjuryList *)value;
- (void)addAbdomenInjuryList:(NSSet *)values;
- (void)removeAbdomenInjuryList:(NSSet *)values;

- (void)addArmInjuryListObject:(ArmInjuryList *)value;
- (void)removeArmInjuryListObject:(ArmInjuryList *)value;
- (void)addArmInjuryList:(NSSet *)values;
- (void)removeArmInjuryList:(NSSet *)values;

- (void)addLegInjuryListObject:(LegInjuryList *)value;
- (void)removeLegInjuryListObject:(LegInjuryList *)value;
- (void)addLegInjuryList:(NSSet *)values;
- (void)removeLegInjuryList:(NSSet *)values;

- (void)addRequiredFieldsObject:(RequiredField *)value;
- (void)removeRequiredFieldsObject:(RequiredField *)value;
- (void)addRequiredFields:(NSSet *)values;
- (void)removeRequiredFields:(NSSet *)values;

@end
