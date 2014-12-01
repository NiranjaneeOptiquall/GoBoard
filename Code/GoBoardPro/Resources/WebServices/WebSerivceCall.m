 //
//  WebSerivceCall.m
//  GoBoardPro
//
//  Created by ind558 on 10/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "WebSerivceCall.h"
#import "Constants.h"
#import "UtilizationCount.h"
#import "TaskList.h"
#import "TaskResponseTypeValues.h"
#import "ERPCategory.h"
#import "ERPSubcategory.h"
#import "ERPTask.h"

#import "IncidentReportInfo.h"
#import "NatureList.h"
#import "EquipmentList.h"
#import "RequiredField.h"
#import "ConditionList.h"
#import "ActionTakenList.h"
#import "ActivityList.h"

#import "AccidentReportInfo.h"
#import "AbdomenInjuryList.h"
#import "HeadInjuryList.h"
#import "BodyPartInjuryType.h"
#import "CareProvidedType.h"
#import "ArmInjuryList.h"
#import "GeneralInjuryType.h"
#import "LegInjuryList.h"

#import "SurveyList.h"
#import "SurveyQuestions.h"
#import "SurveyResponseTypeValues.h"



@implementation WebSerivceCall

+ (WebSerivceCall *)webServiceObject {
    static WebSerivceCall *object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[WebSerivceCall alloc] init];
    });
    return object;
}


#pragma mark - GetAllData

- (void)getAllData {
    [self callServiceForEmergencyResponsePlan:YES complition:nil];
    [self callServiceForTaskList:YES complition:nil];
    [self callServiceForUtilizationCount:YES complition:nil];
    [self callServiceForIncidentReport:YES complition:nil];
    [self callServiceForAccidentReport:YES complition:nil];
}

#pragma mark - Emergency Response Plan

- (void)callServiceForEmergencyResponsePlan:(BOOL)waitUntilDone complition:(void (^)(void))completion {
    __block BOOL isWSComplete = NO;
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@", ERP_CATEGORY, [[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:ERP_CATEGORY] complition:^(NSDictionary *response) {
        [self deleteAllERPData];
        [self inserAllERPData:[response objectForKey:@"ErpCategories"]];
        if ([gblAppDelegate.managedObjectContext save:nil]) {
            isWSComplete = YES;
        }
        if (completion) {
            completion();
        }
        
    } failure:^(NSError *error, NSDictionary *response) {
        isWSComplete = YES;
        if (completion) {
            completion();
        }
    }];
    if (waitUntilDone) {
        while (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
}

- (void)deleteAllERPData {
    NSFetchRequest * allCategory = [[NSFetchRequest alloc] init];
    [allCategory setEntity:[NSEntityDescription entityForName:@"ERPCategory" inManagedObjectContext:gblAppDelegate.managedObjectContext]];
    [allCategory setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSError * error = nil;
    NSArray * categories = [gblAppDelegate.managedObjectContext executeFetchRequest:allCategory error:&error];
    //error handling goes here
    for (NSManagedObject * cate in categories) {
        [gblAppDelegate.managedObjectContext deleteObject:cate];
    }
    NSError *saveError = nil;
    [gblAppDelegate.managedObjectContext save:&saveError];
}

- (void)inserAllERPData:(NSArray *)aryResponse {
    for (NSDictionary *aDict in aryResponse) {
        ERPCategory *aCategory = [NSEntityDescription insertNewObjectForEntityForName:@"ERPCategory" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        aCategory.title = [aDict objectForKey:@"Title"];
        aCategory.categoryId = [NSString stringWithFormat:@"%ld", (long)[[aDict objectForKey:@"Id"] integerValue]];
        NSMutableSet *subcategories = [NSMutableSet set];
        for (NSDictionary *aDictSubCate in [aDict objectForKey:@"Subcategories"]) {
            ERPSubcategory *aSubCate = [NSEntityDescription insertNewObjectForEntityForName:@"ERPSubcategory" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            aSubCate.title = [aDictSubCate objectForKey:@"Title"];
            aSubCate.subCateId = [NSString stringWithFormat:@"%ld", (long)[[aDictSubCate objectForKey:@"Id"] integerValue]];
            NSMutableSet *taskList = [NSMutableSet set];
            for (NSDictionary *aTask in [aDictSubCate objectForKey:@"Tasks"]) {
                ERPTask *task = [NSEntityDescription insertNewObjectForEntityForName:@"ERPTask" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                task.taskID = [NSString stringWithFormat:@"%ld", (long)[[aTask objectForKey:@"Id"] integerValue]];
                task.task = [aTask objectForKey:@"Description"];
                if (![aTask objectForKey:@"AttachmentLink"] || [[aTask objectForKey:@"AttachmentLink"] isKindOfClass:[NSNull class]]) {
                    task.attachmentLink = @"";
                }
                else {
                    task.attachmentLink = [aTask objectForKey:@"AttachmentLink"];
                }
                
                task.erpTitle = aSubCate;
                [taskList addObject:task];
            }
            aSubCate.erpTasks = taskList;
            aSubCate.erpHeader = aCategory;
            [subcategories addObject:aSubCate];
        }
        aCategory.erpTitles = subcategories;
        [gblAppDelegate.managedObjectContext insertObject:aCategory];
    }
}
#pragma mark - UtilizationCount

- (BOOL)callServiceForUtilizationCount:(BOOL)waitUntilDone complition:(void (^)(void))completion {
    __block BOOL isWSComplete = NO;
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?facilityId=%@&locationId=%@&positionId=%@&userId=%@", UTILIZATION_COUNT, [[[User currentUser] selectedFacility] value], [[[User currentUser] selectedLocation] value], [[[User currentUser] selectedPosition] value], [[User currentUser] userId]] parameters:nil httpMethod:@"GET" complition:^(NSDictionary *response) {
        [self deleteAllCountLocation];
        [self insertAllCountLocation:[response objectForKey:@"Locations"]];
        isWSComplete = YES;
        if (completion) {
            completion();
        }
    } failure:^(NSError *error, NSDictionary *response) {
        isWSComplete = YES;
        if (completion) {
            completion();
        }
    }];
    if (waitUntilDone) {
        while (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
    return isWSComplete;
}

- (void)deleteAllCountLocation {
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"UtilizationCount" inManagedObjectContext:gblAppDelegate.managedObjectContext]];
    [request setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSError * error = nil;
    NSArray * allRecords = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:&error];
    //error handling goes here
    for (NSManagedObject * rec in allRecords) {
        [gblAppDelegate.managedObjectContext deleteObject:rec];
    }
    NSError *saveError = nil;
    [gblAppDelegate.managedObjectContext save:&saveError];
}

- (void)insertAllCountLocation:(NSArray *)arrLocations {
    for (NSDictionary *aDict in arrLocations) {
        UtilizationCount *location = [NSEntityDescription insertNewObjectForEntityForName:@"UtilizationCount" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        location.locationId = [[aDict objectForKey:@"Id"] stringValue];
        location.name = [aDict objectForKey:@"Name"];
        if ([[aDict objectForKey:@"Message"] isKindOfClass:[NSNull class]])
            location.message = @"";
        else
            location.message = [aDict objectForKey:@"Message"];
        if ([[aDict objectForKey:@"LastCount"] isKindOfClass:[NSNull class]])
            location.lastCount = @"0";
        else
            location.lastCount = [[aDict objectForKey:@"LastCount"] stringValue];
        if ([[aDict objectForKey:@"LastCountDateTime"] isKindOfClass:[NSNull class]])
            location.lastCountDateTime = @"";
        else {
            NSString *aStrDate = [[[aDict objectForKey:@"LastCountDateTime"] componentsSeparatedByString:@"."] firstObject];
            location.lastCountDateTime = aStrDate;
        }
        
        location.capacity = [[aDict objectForKey:@"Capacity"] stringValue];
        NSMutableSet *set = [NSMutableSet set];
        if (![[aDict objectForKey:@"Sublocations"] isKindOfClass:[NSNull class]]) {
            for (NSDictionary *aDictSubLoc in [aDict objectForKey:@"Sublocations"]) {
                UtilizationCount *subLoc = [NSEntityDescription insertNewObjectForEntityForName:@"UtilizationCount" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                subLoc.name = [aDictSubLoc objectForKey:@"Name"];
                if ([[aDict objectForKey:@"LastCount"] isKindOfClass:[NSNull class]])
                    subLoc.lastCount = @"0";
                else
                    subLoc.lastCount = [[aDictSubLoc objectForKey:@"LastCount"] stringValue];
                if ([[aDict objectForKey:@"LastCountDateTime"] isKindOfClass:[NSNull class]])
                    subLoc.lastCountDateTime = @"";
                else {
                    NSString *aStrDate = [[[aDict objectForKey:@"LastCountDateTime"] componentsSeparatedByString:@"."] firstObject];
                    subLoc.lastCountDateTime = aStrDate;
                }
                subLoc.locationId = [[aDictSubLoc objectForKey:@"Id"] stringValue];
                subLoc.location = location;
                [set addObject:subLoc];
            }
        }
        location.sublocations = set;
        [gblAppDelegate.managedObjectContext insertObject:location];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}

#pragma mark - Task

- (void)callServiceForTaskList:(BOOL)waitUntilDone complition:(void (^)(void))completion {
    __block BOOL isWSComplete = NO;
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?facilityId=%@&locationId=%@&positionId=%@&userId=%@", TASK, [[[User currentUser] selectedFacility] value], [[[User currentUser] selectedLocation] value], [[[User currentUser] selectedPosition] value], [[User currentUser] userId]] parameters:nil httpMethod:@"GET" complition:^(NSDictionary *response) {
        NSLog(@"%@", response);
        [self deleteAllTask];
        [self insertAllTask:[response objectForKey:@"Tasks"]];
        if (completion) {
            completion();
        }
        isWSComplete = YES;
    } failure:^(NSError *error, NSDictionary *response) {
        isWSComplete = YES;
        if (completion) {
            completion();
        }
    }];
    if (waitUntilDone) {
        while (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
}

- (void)deleteAllTask {
    NSFetchRequest * allTask = [[NSFetchRequest alloc] init];
    [allTask setEntity:[NSEntityDescription entityForName:@"TaskList" inManagedObjectContext:gblAppDelegate.managedObjectContext]];
    [allTask setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSError * error = nil;
    NSArray * tasks = [gblAppDelegate.managedObjectContext executeFetchRequest:allTask error:&error];
    //error handling goes here
    for (NSManagedObject * task in tasks) {
        [gblAppDelegate.managedObjectContext deleteObject:task];
    }
    NSError *saveError = nil;
    [gblAppDelegate.managedObjectContext save:&saveError];
}

- (void)insertAllTask:(NSArray*)aryTask {
    for (NSDictionary *aDict in aryTask) {
        TaskList *aList = [NSEntityDescription insertNewObjectForEntityForName:@"TaskList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        aList.isCompleted = [aDict objectForKey:@"Completed"];
        aList.desc = [aDict objectForKey:@"Description"];
        aList.name = [aDict objectForKey:@"Name"];
        aList.taskId = [[aDict objectForKey:@"Id"] stringValue];
        
        if ([[aDict objectForKey:@"Response"] isKindOfClass:[NSNull class]]) {
            aList.response = @"";
        }
        else {
            aList.response = [aDict objectForKey:@"Response"];
        }
        
        aList.responseType = [aDict objectForKey:@"ResponseType"];
        NSMutableSet *aSet = [NSMutableSet set];
        if (![[aDict objectForKey:@"ResponseTypeValues"] isKindOfClass:[NSNull class]] && [[aDict objectForKey:@"ResponseTypeValues"] count] > 0) {
            for (NSDictionary *dictType in [aDict objectForKey:@"ResponseTypeValues"]) {
                TaskResponseTypeValues *typeValues = [NSEntityDescription insertNewObjectForEntityForName:@"TaskResponseTypeValues" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                typeValues.value = [dictType objectForKey:@"Value"];
                typeValues.code = [dictType objectForKey:@"Code"];
                typeValues.typeId = [[dictType objectForKey:@"Id"] stringValue];
                typeValues.task = aList;
                [aSet addObject:typeValues];
            }
            aList.responseTypeValues = aSet;
        }
        aList.isCommentAreaSupervisor = [aDict objectForKey:@"IsCommentAreaSupervisor"];
        aList.isCommentBuildingSupervisor = [aDict objectForKey:@"IsCommentBuildingSupervisor"];
        aList.isCommentGoBoardGroup = [aDict objectForKey:@"IsCommentGoBoardGroup"];
        aList.isCommentTask = [aDict objectForKey:@"IsCommentTask"];
        aList.isCommentWorkOrder = [aDict objectForKey:@"IsCommentWorkOrder"];
        [gblAppDelegate.managedObjectContext insertObject:aList];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}

#pragma mark - IncidentReport

- (void)callServiceForIncidentReport:(BOOL)waitUntilDone complition:(void(^)(void))complition {
    __block BOOL isWSComplete = NO;
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@", INCIDENT_REPORT_SETUP, [[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:INCIDENT_REPORT_SETUP] complition:^(NSDictionary *response) {
        [self deleteAllIncidentReports];
        [self insertIncidentReportSettings:[response objectForKey:@"IncidentReportSetups"]];
        isWSComplete = YES;
        if (complition)
            complition();
    } failure:^(NSError *error, NSDictionary *response) {
        isWSComplete = YES;
        if (complition)
            complition();
    }];
    if (waitUntilDone) {
        while (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
}

- (void)deleteAllIncidentReports {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"IncidentReportInfo"];
    [request setIncludesPropertyValues:NO];
    NSArray *aryRecords = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    for (NSManagedObject *rec in aryRecords) {
        [gblAppDelegate.managedObjectContext deleteObject:rec];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}

- (void)insertIncidentReportSettings:(NSArray*)arrReports {
    for (NSDictionary *aDict in arrReports) {
        IncidentReportInfo *report = [NSEntityDescription insertNewObjectForEntityForName:@"IncidentReportInfo" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        report.reportType = [aDict objectForKey:@"ReportType"];
        report.instructions = [aDict objectForKey:@"Instructions"];
        report.notificationField1 = [aDict objectForKey:@"NotificationField1"];
        report.notificationField2 = [aDict objectForKey:@"NotificationField2"];
        report.notificationField3 = [aDict objectForKey:@"NotificationField3"];
        report.notificationField4 = [aDict objectForKey:@"NotificationField4"];
        report.showAffiliation = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowAffiliation"] boolValue]];
        report.showGender = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowGender"] boolValue]];
        report.showEmergencyPersonnel = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowEmergencyPersonnel"] boolValue]];
        report.showMemberIdAndDriverLicense = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowMemberIdAndDriverLicense"] boolValue]];
        report.showManagementFollowup = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowManagementFollowup"] boolValue]];
        report.showDateOfBirth = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowDateOfBirth"] boolValue]];
        report.showPhotoIcon = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowPhotoIcon"] boolValue]];
        report.showMinor = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowMinor"] boolValue]];
        report.showConditions = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowConditions"] boolValue]];
        report.showEmployeeId = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowEmployeeId"] boolValue]];
        // Add ActionTaker
        NSMutableSet *actionSet = [NSMutableSet set];
        for (NSDictionary *dict in [aDict objectForKey:@"ActionTakenList"]) {
            ActionTakenList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"ActionTakenList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            obj.actionId = [[dict objectForKey:@"Id"] stringValue];
            obj.name = [dict objectForKey:@"Name"];
            obj.incidentType = report;
            [actionSet addObject:obj];
        }
        report.actionList = actionSet;
        
        NSMutableSet *activitySet = [NSMutableSet set];
        for (NSDictionary *dict in [aDict objectForKey:@"ActivityList"]) {
            ActivityList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"ActivityList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            obj.activityId = [[dict objectForKey:@"Id"] stringValue];
            obj.name = [dict objectForKey:@"Name"];
            obj.incidentType = report;
            [activitySet addObject:obj];
        }
        report.activityList = activitySet;
        
        NSMutableSet *conditionSet = [NSMutableSet set];
        for (NSDictionary *dict in [aDict objectForKey:@"ConditionList"]) {
            ConditionList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"ConditionList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            obj.conditionId = [[dict objectForKey:@"Id"] stringValue];
            obj.name = [dict objectForKey:@"Name"];
            obj.incidentType = report;
            [conditionSet addObject:obj];
        }
        report.conditionList = conditionSet;
        
        NSMutableSet *equipmentSet = [NSMutableSet set];
        for (NSDictionary *dict in [aDict objectForKey:@"EquipmentList"]) {
            EquipmentList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"EquipmentList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            obj.equipmentId = [[dict objectForKey:@"Id"] stringValue];
            obj.name = [dict objectForKey:@"Name"];
            obj.incidentType = report;
            [equipmentSet addObject:obj];
        }
        report.equipmentList = equipmentSet;
        
        NSMutableSet *natureSet = [NSMutableSet set];
        for (NSDictionary *dict in [aDict objectForKey:@"NatureList"]) {
            NatureList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"NatureList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            obj.natureId = [[dict objectForKey:@"Id"] stringValue];
            obj.name = [dict objectForKey:@"Name"];
            obj.incidentType = report;
            [natureSet addObject:obj];
        }
        report.natureList = natureSet;
        
        NSMutableSet *requiredSet = [NSMutableSet set];
        for (NSString *aStr in [aDict objectForKey:@"PersonInvolvedRequiredFields"]) {
            RequiredField *obj = [NSEntityDescription insertNewObjectForEntityForName:@"RequiredField" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            obj.type = REQUIRED_TYPE_PERSON;
            obj.name = aStr;
            obj.incidentType = report;
            [requiredSet addObject:obj];
        }
        for (NSString *aStr in [aDict objectForKey:@"EmergencyResponseRequiredFields"]) {
            RequiredField *obj = [NSEntityDescription insertNewObjectForEntityForName:@"RequiredField" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            obj.type = REQUIRED_TYPE_EMERGENCY;
            obj.name = aStr;
            obj.incidentType = report;
            [requiredSet addObject:obj];
        }
        for (NSString *aStr in [aDict objectForKey:@"WitnessRequiredFields"]) {
            RequiredField *obj = [NSEntityDescription insertNewObjectForEntityForName:@"RequiredField" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            obj.type = REQUIRED_TYPE_WITNESS;
            obj.name = aStr;
            obj.incidentType = report;
            [requiredSet addObject:obj];
        }
        for (NSString *aStr in [aDict objectForKey:@"EmployeeRequiredFields"]) {
            RequiredField *obj = [NSEntityDescription insertNewObjectForEntityForName:@"RequiredField" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            obj.type = REQUIRED_TYPE_EMPLOYEE;
            obj.name = aStr;
            obj.incidentType = report;
            [requiredSet addObject:obj];
        }
        report.requiredFields = requiredSet;
        
        [gblAppDelegate.managedObjectContext insertObject:report];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}


#pragma mark - AccidentReport

- (void)callServiceForAccidentReport:(BOOL)waitUntilDone complition:(void(^)(void))complition {
    __block BOOL isWSComplete = NO;
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@", ACCIDENT_REPORT_SETUP, [[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:ACCIDENT_REPORT_SETUP] complition:^(NSDictionary *response) {
        [self deleteAllAccidentReports];
        [self insertAccidentReportSettings:[response objectForKey:@"AccidentReportSetup"]];
        isWSComplete = YES;
        if (complition)
            complition();
    } failure:^(NSError *error, NSDictionary *response) {
        isWSComplete = YES;
        if (complition)
            complition();
    }];
    if (waitUntilDone) {
        while (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
}

- (void)deleteAllAccidentReports {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AccidentReportInfo"];
    [request setIncludesPropertyValues:NO];
    NSArray *aryRecords = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    for (NSManagedObject *rec in aryRecords) {
        [gblAppDelegate.managedObjectContext deleteObject:rec];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}

- (void)insertAccidentReportSettings:(NSMutableDictionary*)aDict {
    AccidentReportInfo *report = [NSEntityDescription insertNewObjectForEntityForName:@"AccidentReportInfo" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    report.instructions = [aDict objectForKey:@"Instructions"];
    report.notificationField1 = [aDict objectForKey:@"NotificationField1"];
    report.notificationField2 = [aDict objectForKey:@"NotificationField2"];
    report.notificationField3 = [aDict objectForKey:@"NotificationField3"];
    report.notificationField4 = [aDict objectForKey:@"NotificationField4"];
    report.refusedCareStatement = [aDict objectForKey:@"RefusedCareStatement"];
    report.selfCareStatement = [aDict objectForKey:@"SelfCareStatement"];
    report.showAffiliation = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowAffiliation"] boolValue]];
    report.showGender = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowGender"] boolValue]];
    report.showEmergencyPersonnel = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowEmergencyPersonnel"] boolValue]];
    report.showMemberIdAndDriverLicense = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowMemberIdAndDriverLicense"] boolValue]];
    report.showManagementFollowup = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowManagementFollowup"] boolValue]];
    report.showDateOfBirth = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowDateOfBirth"] boolValue]];
    report.showPhotoIcon = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowPhotoIcon"] boolValue]];
    report.showMinor = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowMinor"] boolValue]];
    report.showConditions = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowConditions"] boolValue]];
    report.showEmployeeId = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowEmployeeId"] boolValue]];
    report.showBloodbornePathogens = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowBloodbornePathogens"] boolValue]];
    report.showCommunicationAndNotification = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowCommunicationAndNotification"] boolValue]];
    report.showParticipantSignature = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowParticipantSignature"] boolValue]];
    report.showRefusedSelfCareText = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowRefusedSelfCareText"] boolValue]];
    // Add ActionTaker
    NSMutableSet *actionSet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"ActionTakenList"]) {
        ActionTakenList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"ActionTakenList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.actionId = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.accidentInfo = report;
        [actionSet addObject:obj];
    }
    report.actionList = actionSet;
    
    NSMutableSet *activitySet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"ActivityList"]) {
        ActivityList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"ActivityList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.activityId = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.accidentInfo = report;
        [activitySet addObject:obj];
    }
    report.activityList = activitySet;
    
    NSMutableSet *conditionSet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"ConditionList"]) {
        ConditionList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"ConditionList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.conditionId = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.accidentInfo = report;
        [conditionSet addObject:obj];
    }
    report.conditionList = conditionSet;
    
    NSMutableSet *equipmentSet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"EquipmentList"]) {
        EquipmentList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"EquipmentList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.equipmentId = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.accidentInfo = report;
        [equipmentSet addObject:obj];
    }
    report.equipmentList = equipmentSet;
    
    NSMutableSet *careSet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"CareProvidedList"]) {
        CareProvidedType *obj = [NSEntityDescription insertNewObjectForEntityForName:@"CareProvidedType" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.careProvidedID = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.accidentInfo = report;
        [careSet addObject:obj];
    }
    report.careProviderList = careSet;
    
    
    NSMutableSet *generalInjurySet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"GeneralInjuryTypeList"]) {
        GeneralInjuryType *obj = [NSEntityDescription insertNewObjectForEntityForName:@"GeneralInjuryType" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.typeId = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.accidentInfo = report;
        [generalInjurySet addObject:obj];
    }
    report.generalInjuryType = generalInjurySet;
    
    NSMutableSet *bodyPartSet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"BodyPartInjuryTypeList"]) {
        BodyPartInjuryType *obj = [NSEntityDescription insertNewObjectForEntityForName:@"BodyPartInjuryType" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.typeId = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.accidentInfo = report;
        [bodyPartSet addObject:obj];
    }
    report.bodypartInjuryType = bodyPartSet;
    
    NSMutableSet *headInjurySet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"HeadInjuryLocationList"]) {
        HeadInjuryList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"HeadInjuryList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.value = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.accidentInfo = report;
        [headInjurySet addObject:obj];
    }
    report.headInjuryList = headInjurySet;
    
    NSMutableSet *abdomenInjurySet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"AbdomenInjuryLocationList"]) {
        AbdomenInjuryList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"AbdomenInjuryList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.value = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.accidentInfo = report;
        [abdomenInjurySet addObject:obj];
    }
    report.abdomenInjuryList = abdomenInjurySet;
    
    NSMutableSet *armInjurySet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"ArmInjuryLocationList"]) {
        ArmInjuryList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"ArmInjuryList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.value = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.accidentInfo = report;
        [armInjurySet addObject:obj];
    }
    report.armInjuryList = armInjurySet;
    
    NSMutableSet *legInjurySet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"LegInjuryLocationList"]) {
        LegInjuryList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"LegInjuryList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.value = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.accidentInfo = report;
        [legInjurySet addObject:obj];
    }
    report.legInjuryList = legInjurySet;
    
    
    
    NSMutableSet *requiredSet = [NSMutableSet set];
    for (NSString *aStr in [aDict objectForKey:@"PersonInvolvedRequiredFields"]) {
        RequiredField *obj = [NSEntityDescription insertNewObjectForEntityForName:@"RequiredField" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.type = REQUIRED_TYPE_PERSON;
        obj.name = aStr;
        obj.accidentInfo = report;
        [requiredSet addObject:obj];
    }
    for (NSString *aStr in [aDict objectForKey:@"EmergencyResponseRequiredFields"]) {
        RequiredField *obj = [NSEntityDescription insertNewObjectForEntityForName:@"RequiredField" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.type = REQUIRED_TYPE_EMERGENCY;
        obj.name = aStr;
        obj.accidentInfo = report;
        [requiredSet addObject:obj];
    }
    for (NSString *aStr in [aDict objectForKey:@"FirstAidRequiredFields"]) {
        RequiredField *obj = [NSEntityDescription insertNewObjectForEntityForName:@"RequiredField" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.type = REQUIRED_TYPE_FIRST_AID;
        obj.name = aStr;
        obj.accidentInfo = report;
        [requiredSet addObject:obj];
    }
    for (NSString *aStr in [aDict objectForKey:@"WitnessRequiredFields"]) {
        RequiredField *obj = [NSEntityDescription insertNewObjectForEntityForName:@"RequiredField" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.type = REQUIRED_TYPE_WITNESS;
        obj.name = aStr;
        obj.accidentInfo = report;
        [requiredSet addObject:obj];
    }
    for (NSString *aStr in [aDict objectForKey:@"EmployeeRequiredFields"]) {
        RequiredField *obj = [NSEntityDescription insertNewObjectForEntityForName:@"RequiredField" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.type = REQUIRED_TYPE_EMPLOYEE;
        obj.name = aStr;
        obj.accidentInfo = report;
        [requiredSet addObject:obj];
    }
    report.requiredFields = requiredSet;
    
    [gblAppDelegate.managedObjectContext insertObject:report];
    [gblAppDelegate.managedObjectContext save:nil];
}



#pragma mark - Survey

- (void)callServiceForSurvey:(BOOL)waitUntilDone complition:(void(^)(void))complition {
    __block BOOL isWSComplete = NO;
    NSString *aStrClientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@", SURVEY_SETUP, aStrClientId] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:SURVEY_SETUP] complition:^(NSDictionary *response) {
        [self deleteAllSurveys];
        [self insertSurvey:[response objectForKey:@"Surveys"]];
        isWSComplete = YES;
        if (complition)
            complition();
    } failure:^(NSError *error, NSDictionary *response) {
        isWSComplete = YES;
        NSLog(@"%@", response);
    }];
    if (waitUntilDone) {
        while (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
}


- (void)deleteAllSurveys {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SurveyList"];
    [request setIncludesPropertyValues:NO];
    NSArray *aryRecords = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    for (NSManagedObject *rec in aryRecords) {
        [gblAppDelegate.managedObjectContext deleteObject:rec];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}

- (void)insertSurvey:(NSArray*)array {
    for (NSDictionary *aDict in array) {
        SurveyList *survey = [NSEntityDescription insertNewObjectForEntityForName:@"SurveyList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        survey.surveyId = [[aDict objectForKey:@"Id"] stringValue];
        if (![[aDict objectForKey:@"Instructions"] isKindOfClass:[NSNull class]]) {
            survey.instructions = [aDict objectForKey:@"Instructions"];
        }
        else {
            survey.instructions = @"";
        }
        if (![[aDict objectForKey:@"Link"] isKindOfClass:[NSNull class]]) {
            survey.link = [aDict objectForKey:@"Link"];
        }
        else {
            survey.link = @"";
        }
        survey.name = [aDict objectForKey:@"Name"];
        survey.surveyTypeId = [[aDict objectForKey:@"SurveyTypeId"] stringValue];
        survey.surveyUserTypeId = [[aDict objectForKey:@"SurveyUserTypeId"] stringValue];
        NSMutableSet *aSetQuestions = [NSMutableSet set];
        if (![[aDict objectForKey:@"Questions"] isKindOfClass:[NSNull class]]) {
            for (NSDictionary *dictQuest in [aDict objectForKey:@"Questions"]) {
                SurveyQuestions *aQuestion = [NSEntityDescription insertNewObjectForEntityForName:@"SurveyQuestions" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                aQuestion.questionId = [[dictQuest objectForKey:@"Id"] stringValue];
                aQuestion.question = [dictQuest objectForKey:@"Question"];
                aQuestion.responseType = [dictQuest objectForKey:@"ResponseType"];
                aQuestion.sequence = [dictQuest objectForKey:@"Sequence"];
                NSMutableSet *responseTypeSet = [NSMutableSet set];
                if (![[dictQuest objectForKey:@"ResponseTypeValues"] isKindOfClass:[NSNull class]]) {
                    for (NSDictionary*dictResponseType in [dictQuest objectForKey:@"ResponseTypeValues"]) {
                        SurveyResponseTypeValues *responseType = [NSEntityDescription insertNewObjectForEntityForName:@"SurveyResponseTypeValues" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                        responseType.value = [[dictResponseType objectForKey:@"Id"] stringValue];
                        responseType.name = [dictResponseType objectForKey:@"Name"];
                        responseType.question = aQuestion;
                        [responseTypeSet addObject:responseType];
                    }
                }
                aQuestion.responseList = responseTypeSet;
                aQuestion.survey = survey;
                [aSetQuestions addObject:aQuestion];
            }
        }
        survey.questionList = aSetQuestions;
        [gblAppDelegate.managedObjectContext insertObject:survey];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}

@end
