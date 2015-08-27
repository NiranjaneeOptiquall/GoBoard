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
#import "LeftArmInjuryList.h"
#import "GeneralInjuryType.h"
#import "LegInjuryList.h"
#import "LeftLegInjuryList.h"

#import "SurveyList.h"
#import "SurveyQuestions.h"
#import "SurveyResponseTypeValues.h"
#import "FormsList.h"



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

- (void)getAllData
{
    [self callServiceForHomeSetup:YES complition:nil];
    [self callServiceForEmergencyResponsePlan:YES complition:nil];
    [self callServiceForTaskList:YES complition:nil];
    [self callServiceForUtilizationCount:YES complition:nil];
    [self callServiceForIncidentReport:YES complition:nil];
    [self callServiceForAccidentReport:YES complition:nil];
    [self callServiceForMemos:YES complition:nil];
    [self callServiceForForms:YES complition:nil];
    //[self callServiceForSop:YES complition:nil];
    [self callServiceForSurvey:YES complition:nil];
   
}

#pragma mark - HOME Setup

- (void)callServiceForHomeSetup:(BOOL)waitUntilDone complition:(void (^)(void))completion {
    __block BOOL isWSComplete = NO;
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?userId=%@", HOME_SCREEN_MODULES, [[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:HOME_SCREEN_MODULES] complition:^(NSDictionary *response) {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"Position" ascending:YES];
        gblAppDelegate.mutArrHomeMenus = [response objectForKey:@"Modules"];
        [gblAppDelegate.mutArrHomeMenus sortUsingDescriptors:@[sort]];
        int Pos = 0;
        for (int i = 0; i < gblAppDelegate.mutArrHomeMenus.count; i++) {
            int currentPos = [[gblAppDelegate.mutArrHomeMenus[i] objectForKey:@"Position"] intValue];
            int differance = currentPos - Pos;
            if (differance > 1) {
                for (int j = 0; j < differance-1; j++) {
                    [gblAppDelegate.mutArrHomeMenus insertObject:@{@"IsActive":[NSNumber numberWithBool:NO], @"Position":[NSNumber numberWithInt:Pos+1]} atIndex:i];
                    Pos++;
                    i++;
                }
            }
            Pos = currentPos;
        }
        
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


#pragma mark - Sop

-(void)callServiceForSop:(BOOL)waitUntilDone complition:(void(^)(void))completion {
    
    __block BOOL isWSComplete = NO;
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@",SOP_CATEGORY,[[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:SOP_CATEGORY] complition:^(NSDictionary *response) {
        
        
        [self inserAllSopData:response];
        isWSComplete = YES;
        
        if (completion) {
            completion();
        }
        
        
    } failure:^(NSError *error, NSDictionary *response){
        isWSComplete = YES;
        
        if (completion) {
            completion();
        }
        
    }];
    
    if (waitUntilDone) {
        if (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
    
}


-(void)inserAllSopData:(NSDictionary *)aDictSop
{
    
    NSString *strDocumentPath = [NSString stringWithFormat:@"%@",gblAppDelegate.applicationDocumentsDirectory.path];
    NSString *strSopFilePath = [strDocumentPath stringByAppendingPathComponent:@"SopCategory.txt"];
    NSString *aStrJSON = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:aDictSop options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    [aStrJSON writeToFile:strSopFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark - Emergency Response Plan

- (void)callServiceForEmergencyResponsePlan:(BOOL)waitUntilDone complition:(void (^)(void))completion {
    __block BOOL isWSComplete = NO;
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@", ERP_CATEGORY, [[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:ERP_CATEGORY] complition:^(NSDictionary *response) {
        if ([response objectForKey:@"ErpCategories"] != [NSNull null]) {
            [self deleteAllERPData];
            [self inserAllERPData:[response objectForKey:@"ErpCategories"]];
        }
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
//    NSString *strPositionIds = [[[[User currentUser] mutArrSelectedPositions] valueForKey:@"value"] componentsJoinedByString:@","];
//    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?facilityId=%@&positionIds=%@", UTILIZATION_COUNT, [[[User currentUser] selectedFacility] value], strPositionIds] parameters:nil httpMethod:@"GET" complition:^(NSDictionary *response) {
//        [self deleteAllCountLocation];
//        [self insertAllCountLocation:[response objectForKey:@"Locations"]];
//        isWSComplete = YES;
//        if (completion) {
//            completion();
//        }
//    } failure:^(NSError *error, NSDictionary *response) {
//        isWSComplete = YES;
//        if (completion) {
//            completion();
//        }
//    }];
    
                //PositionID Removed
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?facilityId=%@", UTILIZATION_COUNT, [[[User currentUser] selectedFacility] value]] parameters:nil httpMethod:@"GET" complition:^(NSDictionary *response) {
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
        location.sequence = [aDict objectForKey:@"Sequence"];
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
                subLoc.sequence = [aDictSubLoc objectForKey:@"Sequence"];
                if ([[aDictSubLoc objectForKey:@"LastCount"] isKindOfClass:[NSNull class]])
                    subLoc.lastCount = @"0";
                else
                    subLoc.lastCount = [[aDictSubLoc objectForKey:@"LastCount"] stringValue];
                if ([[aDictSubLoc objectForKey:@"LastCountDateTime"] isKindOfClass:[NSNull class]])
                    subLoc.lastCountDateTime = @"";
                else {
                    NSString *aStrDate = [[[aDictSubLoc objectForKey:@"LastCountDateTime"] componentsSeparatedByString:@"."] firstObject];
                    subLoc.lastCountDateTime = aStrDate;
                }
                subLoc.locationId = [[aDictSubLoc objectForKey:@"Id"] stringValue];
                subLoc.location = location;
                [set addObject:subLoc];
            }
        }
        location.sublocations = [NSOrderedSet orderedSetWithArray:set.allObjects];
        [gblAppDelegate.managedObjectContext insertObject:location];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}

#pragma mark - Task

- (void)callServiceForTaskList:(BOOL)waitUntilDone complition:(void (^)(void))completion {
    __block BOOL isWSComplete = NO;

    NSString *strLocationIds = [[[[User currentUser] mutArrSelectedLocations] valueForKey:@"value"] componentsJoinedByString:@","];
    NSString *strPositionIds = [[[[User currentUser] mutArrSelectedPositions] valueForKey:@"value"] componentsJoinedByString:@","];
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?facilityId=%@&locationIds=%@&positionIds=%@&userId=%@", TASK, [[[User currentUser] selectedFacility] value], strLocationIds, strPositionIds, [[User currentUser] userId]] parameters:nil httpMethod:@"GET" complition:^(NSDictionary *response) {
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
        aList.sequence = [aDict objectForKey:@"Sequence"];
        aList.location = [aDict objectForKey:@"Location"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        
        NSDate *aDate = [formatter dateFromString:[[aDict[@"TaskDateTime"] componentsSeparatedByString:@"."] firstObject]];
        aList.taskDateTime = aDate;
        
        NSDate *aDateExpirationTime = [formatter dateFromString:[[aDict[@"ExpirationTime"] componentsSeparatedByString:@"."] firstObject]];
        aList.expirationTime = aDateExpirationTime;
       
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
    NSLog(@"%@",[NSString stringWithFormat:@"%@/%@", INCIDENT_REPORT_SETUP, [[User currentUser] userId]]);
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@", INCIDENT_REPORT_SETUP, [[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:INCIDENT_REPORT_SETUP] complition:^(NSDictionary *response) {
        [self deleteAllIncidentReports];
        [self insertIncidentReportSettings:[response objectForKey:@"IncidentReportSetup"]];
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
        if ([[aDict objectForKey:@"Instructions"] isKindOfClass:[NSNull class]]) {
            report.instructions = @"";
        }
        else {
            report.instructions = [aDict objectForKey:@"Instructions"];
        }
            
        
        report.notificationField1 = [aDict objectForKey:@"NotificationField1"];
        report.notificationField2 = [aDict objectForKey:@"NotificationField2"];
        report.notificationField3 = [aDict objectForKey:@"NotificationField3"];
        report.notificationField4 = [aDict objectForKey:@"NotificationField4"];
        report.notificationField1Color = [aDict objectForKey:@"NotificationField1Color"];
        report.notificationField2Color = [aDict objectForKey:@"NotificationField2Color"];
        report.notificationField3Color = [aDict objectForKey:@"NotificationField3Color"];
        report.notificationField4Color = [aDict objectForKey:@"NotificationField4Color"];
        report.personInvolved1 = [aDict objectForKey:@"PersonInvolved1"];
        report.personInvolved2 = [aDict objectForKey:@"PersonInvolved2"];
        report.personInvolved3 = [aDict objectForKey:@"PersonInvolved3"];
        
        report.affiliation1 = [aDict objectForKey:@"Affiliation1"];
        report.affiliation2 = [aDict objectForKey:@"Affiliation2"];
        report.affiliation3 = [aDict objectForKey:@"Affiliation3"];
        report.affiliation4 = [aDict objectForKey:@"Affiliation4"];
        report.affiliation5 = [aDict objectForKey:@"Affiliation5"];
        report.affiliation6 = [aDict objectForKey:@"Affiliation6"];
        report.showAffiliation = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowAffiliation"] boolValue]];
        report.showGender = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowGender"] boolValue]];
        report.showEmergencyPersonnel = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowEmergencyPersonnel"] boolValue]];
        report.showMemberIdAndDriverLicense = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowMemberId"] boolValue]];
        report.showManagementFollowup = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowManagementFollowup"] boolValue]];
        report.showDateOfBirth = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowDateOfBirth"] boolValue]];
        report.showPhotoIcon = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowPhotoIcon"] boolValue]];
        report.showMinor = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowMinor"] boolValue]];
        report.showConditions = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowConditions"] boolValue]];
        report.showEmployeeId = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowEmployeeId"] boolValue]];
        report.showGuestId = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowGuestId"] boolValue]];
        report.showNotificationField1 = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowNotificationField1"] boolValue]];
        report.showNotificationField2 = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowNotificationField2"] boolValue]];
        report.showNotificationField3 = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowNotificationField3"] boolValue]];
        report.showNotificationField4 = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowNotificationField4"] boolValue]];
        
        report.notificationField1Alert = [NSNumber numberWithBool:[[aDict objectForKey:@"NotificationField1Alert"] boolValue]];
        report.notificationField2Alert = [NSNumber numberWithBool:[[aDict objectForKey:@"NotificationField2Alert"] boolValue]];
        report.notificationField3Alert = [NSNumber numberWithBool:[[aDict objectForKey:@"NotificationField3Alert"] boolValue]];
        report.notificationField4Alert = [NSNumber numberWithBool:[[aDict objectForKey:@"NotificationField4Alert"] boolValue]];
        
        // Add ActionTaker
        NSMutableSet *actionSet = [NSMutableSet set];
        for (NSDictionary *dict in [aDict objectForKey:@"ActionTakenList"]) {
            ActionTakenList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"ActionTakenList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            obj.actionId = [[dict objectForKey:@"Id"] stringValue];
            obj.name = [dict objectForKey:@"Name"];
            obj.emergencyPersonnel = [[dict objectForKey:@"EmergencyPersonnel"] stringValue];
            obj.sequence=[[dict objectForKey:@"Sequence"] stringValue];
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
            obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
            [activitySet addObject:obj];
        }
        report.activityList = activitySet;
        
        NSMutableSet *conditionSet = [NSMutableSet set];
        for (NSDictionary *dict in [aDict objectForKey:@"ConditionList"]) {
            ConditionList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"ConditionList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            obj.conditionId = [[dict objectForKey:@"Id"] stringValue];
            obj.name = [dict objectForKey:@"Name"];
            obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
            obj.incidentType = report;
            [conditionSet addObject:obj];
        }
        report.conditionList = conditionSet;
        
        NSMutableSet *equipmentSet = [NSMutableSet set];
        for (NSDictionary *dict in [aDict objectForKey:@"EquipmentList"]) {
            EquipmentList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"EquipmentList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            obj.equipmentId = [[dict objectForKey:@"Id"] stringValue];
            obj.name = [dict objectForKey:@"Name"];
            obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
            obj.incidentType = report;
            [equipmentSet addObject:obj];
        }
        report.equipmentList = equipmentSet;
        
        NSMutableSet *natureSet = [NSMutableSet set];
        for (NSDictionary *dict in [aDict objectForKey:@"NatureList"]) {
            NatureList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"NatureList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            obj.natureId = [[dict objectForKey:@"Id"] stringValue];
            obj.name = [dict objectForKey:@"Name"];
            obj.sequence=[[dict objectForKey:@"Sequence"] stringValue];
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
    if ([[aDict objectForKey:@"Instructions"] isKindOfClass:[NSNull class]]) {
        report.instructions = @"";
    }
    else {
        report.instructions = [aDict objectForKey:@"Instructions"];
    }
    report.notificationField1 = [aDict objectForKey:@"NotificationField1"];
    report.notificationField2 = [aDict objectForKey:@"NotificationField2"];
    report.notificationField3 = [aDict objectForKey:@"NotificationField3"];
    report.notificationField4 = [aDict objectForKey:@"NotificationField4"];
    report.notificationField1Color = [aDict objectForKey:@"NotificationField1Color"];
    report.notificationField2Color = [aDict objectForKey:@"NotificationField2Color"];
    report.notificationField3Color = [aDict objectForKey:@"NotificationField3Color"];
    report.notificationField4Color = [aDict objectForKey:@"NotificationField4Color"];
    report.personInvolved1 = [aDict objectForKey:@"PersonInvolved1"];
    report.personInvolved2 = [aDict objectForKey:@"PersonInvolved2"];
    report.personInvolved3 = [aDict objectForKey:@"PersonInvolved3"];
    
    report.affiliation1 = [aDict objectForKey:@"Affiliation1"];
    report.affiliation2 = [aDict objectForKey:@"Affiliation2"];
    report.affiliation3 = [aDict objectForKey:@"Affiliation3"];
    report.affiliation4 = [aDict objectForKey:@"Affiliation4"];
    report.affiliation5 = [aDict objectForKey:@"Affiliation5"];
    report.affiliation6 = [aDict objectForKey:@"Affiliation6"];

    report.refusedCareStatement = [aDict objectForKey:@"RefusedCareStatement"];
    report.selfCareStatement = [aDict objectForKey:@"SelfCareStatement"];
    report.showAffiliation = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowAffiliation"] boolValue]];
    report.showGender = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowGender"] boolValue]];
    report.showEmergencyPersonnel = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowEmergencyPersonnel"] boolValue]];
    report.showMemberIdAndDriverLicense = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowMemberId"] boolValue]];
    report.showManagementFollowup = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowManagementFollowup"] boolValue]];
    report.showDateOfBirth = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowDateOfBirth"] boolValue]];
    report.showPhotoIcon = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowPhotoIcon"] boolValue]];
    report.showMinor = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowMinor"] boolValue]];
    report.showNotificationField1 =  [NSNumber numberWithBool:[[aDict objectForKey:@"ShowNotificationField1"] boolValue]];
    report.showNotificationField2 =  [NSNumber numberWithBool:[[aDict objectForKey:@"ShowNotificationField2"] boolValue]];
    report.showNotificationField3 =  [NSNumber numberWithBool:[[aDict objectForKey:@"ShowNotificationField3"] boolValue]];
    report.showNotificationField4 =  [NSNumber numberWithBool:[[aDict objectForKey:@"ShowNotificationField4"] boolValue]];
    
    report.notificationField1Alert = [NSNumber numberWithBool:[[aDict objectForKey:@"NotificationField1Alert"] boolValue]];
    report.notificationField2Alert = [NSNumber numberWithBool:[[aDict objectForKey:@"NotificationField2Alert"] boolValue]];
    report.notificationField3Alert = [NSNumber numberWithBool:[[aDict objectForKey:@"NotificationField3Alert"] boolValue]];
    report.notificationField4Alert = [NSNumber numberWithBool:[[aDict objectForKey:@"NotificationField4Alert"] boolValue]];
    
    report.showConditions = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowConditions"] boolValue]];
    report.showEmployeeId = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowEmployeeId"] boolValue]];
    report.showBloodbornePathogens = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowBloodbornePathogens"] boolValue]];
    report.showCommunicationAndNotification = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowCommunicationAndNotification"] boolValue]];
    report.showParticipantSignature = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowParticipantSignature"] boolValue]];
    report.showRefusedSelfCareText = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowRefusedCareText"] boolValue]];
    report.showSelfCareText = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowSelfCareText"] boolValue]];
    report.showGuestId = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowGuestId"] boolValue]];
    // Add ActionTaker
    NSMutableSet *actionSet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"ActionTakenList"]) {
        ActionTakenList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"ActionTakenList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.actionId = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [actionSet addObject:obj];
    }
    report.actionList = actionSet;
    
    NSMutableSet *activitySet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"ActivityList"]) {
        ActivityList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"ActivityList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.activityId = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [activitySet addObject:obj];
    }
    report.activityList = activitySet;
    
    NSMutableSet *conditionSet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"ConditionList"]) {
        ConditionList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"ConditionList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.conditionId = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [conditionSet addObject:obj];
    }
    report.conditionList = conditionSet;
    
    NSMutableSet *equipmentSet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"EquipmentList"]) {
        EquipmentList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"EquipmentList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.equipmentId = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [equipmentSet addObject:obj];
    }
    report.equipmentList = equipmentSet;
    
    NSMutableSet *careSet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"CareProvidedList"]) {
        CareProvidedType *obj = [NSEntityDescription insertNewObjectForEntityForName:@"CareProvidedType" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.careProvidedID = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.refusedCare = [[dict objectForKey:@"RefusedCare"] stringValue];
        obj.selfCare = [[dict objectForKey:@"SelfCare"] stringValue];
        obj.firstAid = [[dict objectForKey:@"FirstAid"] stringValue];
        obj.emergencyPersonnel = [[dict objectForKey:@"EmergencyPersonnel"] stringValue];
        obj.emergencyResponse = [[dict objectForKey:@"EmergencyResponse"] stringValue];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [careSet addObject:obj];
    }
    report.careProviderList = careSet;
    
    
    NSMutableSet *generalInjurySet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"GeneralInjuryTypeList"]) {
        GeneralInjuryType *obj = [NSEntityDescription insertNewObjectForEntityForName:@"GeneralInjuryType" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.typeId = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [generalInjurySet addObject:obj];
    }
    report.generalInjuryType = generalInjurySet;
    
    NSMutableSet *bodyPartSet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"BodyPartInjuryTypeList"]) {
        BodyPartInjuryType *obj = [NSEntityDescription insertNewObjectForEntityForName:@"BodyPartInjuryType" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.typeId = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [bodyPartSet addObject:obj];
    }
    report.bodypartInjuryType = bodyPartSet;
    
    NSMutableSet *headInjurySet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"HeadInjuryLocationList"]) {
        HeadInjuryList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"HeadInjuryList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.value = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [headInjurySet addObject:obj];
    }
    report.headInjuryList = headInjurySet;
    
    NSMutableSet *abdomenInjurySet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"AbdomenInjuryLocationList"]) {
        AbdomenInjuryList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"AbdomenInjuryList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.value = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [abdomenInjurySet addObject:obj];
    }
    report.abdomenInjuryList = abdomenInjurySet;
    
    NSMutableSet *rightArmInjurySet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"RightArmInjuryLocationList"]) {
        ArmInjuryList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"RightArmInjuryList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.value = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [rightArmInjurySet addObject:obj];
    }
    report.rightArmInjuryList = rightArmInjurySet;
    
    
    NSMutableSet *leftArmInjurySet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"LeftArmInjuryLocationList"]) {
        LeftArmInjuryList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"LeftArmInjuryList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        
        obj.value = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [leftArmInjurySet addObject:obj];
    }
    report.leftArmInjuryList = leftArmInjurySet;
    
    NSMutableSet *rightLegInjurySet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"RightLegInjuryLocationList"]) {
        LegInjuryList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"RightLegInjuryList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.value = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [rightLegInjurySet addObject:obj];
    }
    report.rightLegInjuryList = rightLegInjurySet;
    
    NSMutableSet *leftLegInjurySet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"LeftLegInjuryLocationList"]) {
        LeftLegInjuryList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"LeftLegInjuryList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.value = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [leftLegInjurySet addObject:obj];
    }
    report.leftLegInjuryList = leftLegInjurySet;
    
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
    NSString *strUserId = @"";
    if ([User checkUserExist]) {
        strUserId = [[User currentUser] userId];
    }
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?ClientId=%@&UserId=%@", SURVEY_SETUP, aStrClientId, strUserId] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:SURVEY_SETUP] complition:^(NSDictionary *response) {
        [self deleteAllSurveys];
        [self insertSurvey:[response objectForKey:@"Surveys"]];
        isWSComplete = YES;
        if (complition)
            complition();
    } failure:^(NSError *error, NSDictionary *response) {
        isWSComplete = YES;
        if (complition)
            complition();
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
        survey.typeId = [[aDict objectForKey:@"SurveyTypeId"] stringValue];
        survey.userTypeId = [[aDict objectForKey:@"SurveyUserTypeId"] stringValue];
        survey.sequence=[aDict objectForKey:@"Sequence"];
        NSMutableSet *aSetQuestions = [NSMutableSet set];
        if (![[aDict objectForKey:@"Questions"] isKindOfClass:[NSNull class]]) {
            for (NSDictionary *dictQuest in [aDict objectForKey:@"Questions"]) {
                SurveyQuestions *aQuestion = [NSEntityDescription insertNewObjectForEntityForName:@"SurveyQuestions" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                aQuestion.questionId = [[dictQuest objectForKey:@"Id"] stringValue];
                aQuestion.question = [dictQuest objectForKey:@"Question"];
                aQuestion.responseType = [dictQuest objectForKey:@"ResponseType"];
                aQuestion.sequence = [dictQuest objectForKey:@"Sequence"];
                NSMutableSet *responseTypeSet = [NSMutableSet set];
                if (![[dictQuest objectForKey:@"Responses"] isKindOfClass:[NSNull class]]) {
                    for (NSDictionary*dictResponseType in [dictQuest objectForKey:@"Responses"]) {
                        SurveyResponseTypeValues *responseType = [NSEntityDescription insertNewObjectForEntityForName:@"SurveyResponseTypeValues" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                        responseType.value = [[dictResponseType objectForKey:@"Id"] stringValue];
                        responseType.name = [dictResponseType objectForKey:@"Name"];
                        responseType.sequence = [[dictResponseType objectForKey:@"Sequence"] stringValue];
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



#pragma mark - Forms

- (void)callServiceForForms:(BOOL)waitUntilDone complition:(void(^)(void))complition {
    __block BOOL isWSComplete = NO;
    NSString *aStrClientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
    NSString *strUserId = @"";
    if ([User checkUserExist]) {
        strUserId = [[User currentUser] userId];
    }
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?ClientId=%@&UserId=%@", FORM_SETUP, aStrClientId, strUserId] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:FORM_SETUP] complition:^(NSDictionary *response) {
        [self deleteAllForms];
        [self insertForms:[response objectForKey:@"Forms"]];
        isWSComplete = YES;
        if (complition)
            complition();
    } failure:^(NSError *error, NSDictionary *response) {
        isWSComplete = YES;
        if (complition)
            complition();
        NSLog(@"%@", response);
    }];
    if (waitUntilDone) {
        while (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
}


- (void)deleteAllForms {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"FormsList"];
    [request setIncludesPropertyValues:NO];
    NSArray *aryRecords = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    for (NSManagedObject *rec in aryRecords) {
        [gblAppDelegate.managedObjectContext deleteObject:rec];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}

- (void)insertForms:(NSArray*)array {
    for (NSDictionary *aDict in array) {
        FormsList *form = [NSEntityDescription insertNewObjectForEntityForName:@"FormsList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        form.formId = [[aDict objectForKey:@"Id"] stringValue];
        if (![[aDict objectForKey:@"Instructions"] isKindOfClass:[NSNull class]]) {
            form.instructions = [aDict objectForKey:@"Instructions"];
        }
        else {
            form.instructions = @"";
        }
        if (![[aDict objectForKey:@"Link"] isKindOfClass:[NSNull class]]) {
            form.link = [aDict objectForKey:@"Link"];
        }
        else {
            form.link = @"";
        }
        form.name = [aDict objectForKey:@"Name"];
        form.typeId = [[aDict objectForKey:@"FormTypeId"] stringValue];
        form.userTypeId = [[aDict objectForKey:@"FormUserTypeId"] stringValue];
        form.sequence=[aDict objectForKey:@"Sequence"] ;
        NSMutableSet *aSetQuestions = [NSMutableSet set];
        if (![[aDict objectForKey:@"Questions"] isKindOfClass:[NSNull class]]) {
            for (NSDictionary *dictQuest in [aDict objectForKey:@"Questions"]) {
                SurveyQuestions *aQuestion = [NSEntityDescription insertNewObjectForEntityForName:@"SurveyQuestions" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                aQuestion.questionId = [[dictQuest objectForKey:@"Id"] stringValue];
                aQuestion.question = [dictQuest objectForKey:@"Question"];
                aQuestion.responseType = [dictQuest objectForKey:@"ResponseType"];
                aQuestion.sequence = [dictQuest objectForKey:@"Sequence"];
                NSMutableSet *responseTypeSet = [NSMutableSet set];
                if (![[dictQuest objectForKey:@"Responses"] isKindOfClass:[NSNull class]]) {
                    for (NSDictionary*dictResponseType in [dictQuest objectForKey:@"Responses"]) {
                        SurveyResponseTypeValues *responseType = [NSEntityDescription insertNewObjectForEntityForName:@"SurveyResponseTypeValues" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                        responseType.value = [[dictResponseType objectForKey:@"Id"] stringValue];
                        responseType.name = [dictResponseType objectForKey:@"Name"];
                        responseType.sequence = [[dictResponseType objectForKey:@"Sequence"] stringValue];
                        responseType.question = aQuestion;
                        [responseTypeSet addObject:responseType];
                    }
                }
                aQuestion.responseList = responseTypeSet;
                aQuestion.formList = form;
                [aSetQuestions addObject:aQuestion];
            }
        }
        form.questionList = aSetQuestions;
        [gblAppDelegate.managedObjectContext insertObject:form];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}



#pragma mark - MemoBoard

- (void)callServiceForMemos:(BOOL)waitUntilDone complition:(void (^)(void))completion {
    __block BOOL isWSComplete = NO;
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?userId=%@", MEMO, [[User currentUser] userId]] parameters:nil httpMethod:@"GET" complition:^(NSDictionary *response) {
        gblAppDelegate.mutArrMemoList = [response objectForKey:@"Memos"];
        isWSComplete = YES;
        if (completion)
            completion();
    } failure:^(NSError *error, NSDictionary *response) {
        isWSComplete = YES;
        if (completion)
            completion();
        
    }];
    if (waitUntilDone) {
        while (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
}
@end
