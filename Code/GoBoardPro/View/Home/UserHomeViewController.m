//
//  UserHomeViewController.m
//  GoBoardPro
//
//  Created by ind558 on 23/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "UserHomeViewController.h"
#import "GuestFormViewController.h"
#import "ERPHistory.h"
#import "ERPHistoryTask.h"
#import "SubmitCountUser.h"
#import "SubmitUtilizationCount.h"
#import "SubmittedTask.h"
#import "Report.h"
#import "Person.h"
#import "EmergencyPersonnel.h"
#import "Witness.h"
#import "AccidentReportSubmit.h"
#import "AccidentPerson.h"
#import "InjuryDetail.h"

@interface UserHomeViewController ()

@end

@implementation UserHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![[User currentUser] isAdmin]) {
        [_btnTools setHidden:YES];
        CGPoint center = _btnSurvey.center;
        center.x = self.view.center.x;
        [_btnSurvey setCenter:center];
    }
    [_lblWelcomeUser setText:[NSString stringWithFormat:@"Welcome %@ %@", [[User currentUser] firstName], [[User currentUser] lastName]]];
    [_lblPendingCount.layer setCornerRadius:5.0];
    [_lblPendingCount.layer setBorderWidth:1.0];
    [_lblPendingCount setClipsToBounds:YES];
    [_lblPendingCount.layer setBorderColor:[UIColor whiteColor].CGColor];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getSyncCount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"userSurvey"]) {
        GuestFormViewController *forms = (GuestFormViewController*)[segue destinationViewController];
        forms.guestFormType = 5;
    }
    else if([[segue identifier] isEqualToString:@"userForms"]) {
        GuestFormViewController *forms = (GuestFormViewController*)[segue destinationViewController];
        forms.guestFormType = 4;
    }
    
//
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender  {
//    if ([identifier isEqualToString:@"Incident"] || [identifier isEqualToString:@"Graphs"] || [identifier isEqualToString:@"Tools"]) {
//        alert(@"", @"This section is under development");
//        return NO;
//    }
    return YES;
}

- (IBAction)btnStartSyncCount:(id)sender {
    if (syncCount > 0) {
        [self performSync];
    }
}

- (IBAction)unwindBackToHomeScreen:(UIStoryboardSegue*)segue {
    
}


#pragma mark - Sync Methods

- (void)getSyncCount {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ERPHistory"];
    syncCount = [gblAppDelegate.managedObjectContext countForFetchRequest:request error:nil];
    request = [[NSFetchRequest alloc] initWithEntityName:@"SubmitCountUser"];
    syncCount += [gblAppDelegate.managedObjectContext countForFetchRequest:request error:nil];
    request = [[NSFetchRequest alloc] initWithEntityName:@"Report"];
    syncCount += [gblAppDelegate.managedObjectContext countForFetchRequest:request error:nil];
    request = [[NSFetchRequest alloc] initWithEntityName:@"AccidentReportSubmit"];
    syncCount += [gblAppDelegate.managedObjectContext countForFetchRequest:request error:nil];
    if (syncCount == 0) {
        [_lblPendingCount setHidden:YES];
    }
    else {
        [_lblPendingCount setHidden:NO];
    }
    [_lblPendingCount setText:[NSString stringWithFormat:@"%ld", (long)syncCount]];
}

- (void)performSync {
    [gblAppDelegate showActivityIndicator];
    gblAppDelegate.shouldHideActivityIndicator = NO;
    BOOL isSyncError = NO;
    isSyncError = [self syncERPHistory];
    if (!isSyncError)
        isSyncError = [self syncUtilizationCount];
    if (!isSyncError)
        [self syncSubmittedTask];
    if (!isSyncError)
        [self syncIncidentReport];
    if (!isSyncError) {
        alert(@"", @"All data are Synchronised with server.");
    }
    [self getSyncCount];
    gblAppDelegate.shouldHideActivityIndicator = YES;
    [gblAppDelegate hideActivityIndicator];
}

- (BOOL)syncERPHistory {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ERPHistory"];
    NSArray *arrErpHistory = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    isErrorOccurred = NO;
    __block BOOL isHistorySaved = NO;
    for (ERPHistory *history in arrErpHistory) {
        NSMutableArray *aryTask = [NSMutableArray array];
        isHistorySaved = NO;
        for (ERPHistoryTask *task in history.taskList) {
            NSDictionary *dict = @{@"ErpTaskId":task.erpTaskId, @"Completed":task.completed};
            [aryTask addObject:dict];
        }
        NSDictionary *aDict = @{@"UserId":history.userId, @"FacilityId":history.facilityId, @"LocationId":history.locationId, @"ErpSubcategoryId":history.erpSubcategoryId, @"StartDateTime":history.startDateTime, @"EndDateTime":history.endDateTime, @"Tasks":aryTask};
        [gblAppDelegate callWebService:ERP_HISTORY parameters:aDict httpMethod:[SERVICE_HTTP_METHOD objectForKey:ERP_HISTORY] complition:^(NSDictionary *response) {
            [gblAppDelegate.managedObjectContext deleteObject:history];
            isHistorySaved = YES;
        } failure:^(NSError *error, NSDictionary *response) {
            isHistorySaved = YES;
            isErrorOccurred = YES;
            alert(@"", [response objectForKey:@"ErrorMessage"]);
        }];
        while (!isHistorySaved) {
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
        }
        if (isErrorOccurred) {
            break;
        }
    }
    [gblAppDelegate.managedObjectContext save:nil];
    return isErrorOccurred;
}

- (BOOL)syncUtilizationCount {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SubmitCountUser"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"countLocation.@count > 0"];
    [request setPredicate:predicate];
    NSArray *aryOfflineData = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    isErrorOccurred = NO;
    __block BOOL isSingleDataSaved = NO;
    for (SubmitCountUser *user in aryOfflineData) {
        isSingleDataSaved = NO;
        NSMutableArray *mutArrLocations = [NSMutableArray array];
        for (SubmitUtilizationCount *location in [user.countLocation allObjects]) {
            [mutArrLocations addObject:[self getPostLocation:location]];
        }
        NSDictionary *aDict = @{@"FacilityId":user.facilityId, @"LocationId":user.locationId, @"PositionId":user.positionId, @"UserId":user.userId, @"Locations":mutArrLocations};
        [gblAppDelegate callWebService:UTILIZATION_COUNT parameters:aDict httpMethod:@"POST" complition:^(NSDictionary *response) {
            [gblAppDelegate.managedObjectContext deleteObject:user];
            isSingleDataSaved = YES;
        } failure:^(NSError *error, NSDictionary *response) {
            isSingleDataSaved = YES;
            isErrorOccurred = YES;
            alert(@"", [response objectForKey:@"ErrorMessage"]);
        }];
        while (!isSingleDataSaved) {
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
        }
        if (isErrorOccurred) {
            break;
        }
    }
    [gblAppDelegate.managedObjectContext save:nil];
    return isErrorOccurred;
}

- (NSDictionary *)getPostLocation:(SubmitUtilizationCount*)location {
    
    NSMutableDictionary *aDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:location.message, @"Message", location.lastCount, @"LastCount", location.lastCountDateTime, @"LastCountDateTime", location.capacity, @"Capacity", location.name, @"Name", location.locationId, @"Id", nil];
    NSMutableArray *subLocations = [NSMutableArray array];
    for (SubmitUtilizationCount *subLocation in [location.sublocations allObjects]) {
        [subLocations addObject:@{@"Id": subLocation.locationId, @"Name": subLocation.name, @"LastCount" : subLocation.lastCount, @"LastCountDateTime":subLocation.lastCountDateTime}];
    }
    if ([subLocations count] > 0) {
        [aDict setObject:subLocations forKey:@"Sublocations"];
    }
    return aDict;
}


- (BOOL)syncSubmittedTask {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SubmitCountUser"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"submittedTask.@count > 0"];
    [request setPredicate:predicate];
    NSArray *aryOfflineData = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    isErrorOccurred = NO;
    __block BOOL isSingleDataSaved = NO;
    for (SubmitCountUser *user in aryOfflineData) {
        isSingleDataSaved = NO;
        NSMutableArray *mutArrTask = [NSMutableArray array];
        for (SubmittedTask *task in [user.submittedTask allObjects]) {
            [mutArrTask addObject:@{@"Id": task.taskId, @"Response":task.response, @"ResponseType":task.responseType, @"Comment":task.comment, @"IsCommentTask": task.isCommentTask, @"IsCommentGoBoardGroup":task.isCommentGoBoardGroup, @"IsCommentBuildingSupervisor":task.isCommentBuildingSupervisor, @"IsCommentAreaSupervisor":task.isCommentAreaSupervisor, @"IsCommentWorkOrder":task.isCommentWorkOrder}];
        }
        NSDictionary *aDict = @{@"FacilityId":user.facilityId, @"LocationId":user.locationId, @"PositionId":user.positionId, @"UserId":user.userId, @"Locations":mutArrTask};
        [gblAppDelegate callWebService:TASK parameters:aDict httpMethod:@"POST" complition:^(NSDictionary *response) {
            [gblAppDelegate.managedObjectContext deleteObject:user];
            isSingleDataSaved = YES;
        } failure:^(NSError *error, NSDictionary *response) {
            isSingleDataSaved = YES;
            isErrorOccurred = YES;
            alert(@"", [response objectForKey:@"ErrorMessage"]);
        }];
        while (!isSingleDataSaved) {
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
        }
        if (isErrorOccurred) {
            break;
        }
    }
    [gblAppDelegate.managedObjectContext save:nil];
    return isErrorOccurred;
}


- (BOOL)syncIncidentReport {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Report"];
    NSArray *aryOfflineData = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    isErrorOccurred = NO;
    __block BOOL isSingleDataSaved = NO;
    for (Report *aReport in aryOfflineData) {
        isSingleDataSaved = NO;
        NSMutableArray *mutArrPerson = [NSMutableArray array];
        for (Person *obj in [aReport.persons allObjects]) {
            NSString *memberId = @"", *employeeId = @"";
            if ([obj.personTypeID integerValue] == 3) {
                employeeId = obj.memberId;
            }
            else {
                memberId = obj.memberId;
            }
            NSString *aStrPhoto = @"";
            if (obj.personPhoto) {
                aStrPhoto = [obj.personPhoto base64EncodedStringWithOptions:0];
            }
            
            NSDictionary *aDict = @{@"FirstName": obj.firstName, @"MiddleInitial":obj.middleInitial, @"LastName":obj.lastName, @"PrimaryPhone":obj.primaryPhone, @"AlternatePhone":obj.alternatePhone, @"Email":obj.email, @"Address1":obj.streetAddress, @"Address2":obj.apartmentNumber, @"City":obj.city, @"State":obj.state, @"Zip": obj.zip, @"AffiliationTypeId":obj.affiliationTypeID, @"GenderTypeId":obj.genderTypeID, @"PersonTypeId":obj.personTypeID, @"GuestOfFirstName":obj.guestOfFirstName, @"GuestOfMiddleInitial":obj.guestOfMiddleInitial, @"GuestOfLastName": obj.guestOfLastName, @"IsMinor":obj.minor, @"EmployeeTitle":obj.employeeTitle, @"EmployeId":employeeId, @"MemberId":memberId, @"DateOfBirth":obj.dateOfBirth, @"OccuredDuringBusinessHours":obj.duringWorkHours, @"PersonPhoto":aStrPhoto};
            [mutArrPerson addObject:aDict];
        }
        
        NSMutableArray *mutArrEmergency = [NSMutableArray array];
        for (EmergencyPersonnel *obj in [aReport.emergencyPersonnels allObjects]) {
            NSDictionary *aDict = @{@"FirstName":obj.firstName, @"MiddleInitial":obj.middileInitial, @"LastName":obj.lastName, @"Phone":obj.phone, @"AdditionalInformation":obj.additionalInformation, @"CaseNumber":obj.caseNumber, @"BadgeNumber":obj.badgeNumber, @"Time911Called":obj.time911Called, @"ArrivalTime":obj.time911Arrival, @"DepartureTime":obj.time911Departure};
            [mutArrEmergency addObject:aDict];
        }
        
        NSMutableArray *mutArrWitness = [NSMutableArray array];
        for (Witness *obj in [aReport.witnesses allObjects]) {
            NSDictionary *aDict = @{@"FirstName":obj.firstName, @"MiddleInitial":obj.middleInitial, @"LastName":obj.lastName, @"HomePhone":obj.homePhone, @"AlternatePhone":obj.alternatePhone, @"Email":obj.email, @"IncidentDescription":obj.witnessWrittenAccount};
            [mutArrWitness addObject:aDict];
        }
        
        NSDictionary *aDict = @{@"IncidentDate":aReport.dateOfIncident, @"FacilityId":aReport.facilityId, @"LocationId":aReport.locationId, @"IncidentDescription":aReport.incidentDesc, @"IsNotificationField1Selected":aReport.isNotification1Selected, @"IsNotificationField2Selected":aReport.isNotification2Selected, @"IsNotificationField3Selected":aReport.isNotification3Selected, @"IsNotificationField4Selected":aReport.isNotification4Selected, @"EmployeeFirstName":aReport.employeeFirstName, @"EmployeeMiddleInitial": aReport.employeeMiddleInitial, @"EmployeeLastName":aReport.employeeLastName, @"EmployeeHomePhone":aReport.employeeHomePhone, @"EmployeeAlternatePhone":aReport.employeeAlternatePhone, @"EmployeeEmail":aReport.employeeEmail, @"ReportFilerAccount":aReport.reportFilerAccount, @"ManagementFollowupDate":aReport.managementFollowUpDate, @"AdditionalInformation": aReport.additionalInfo, @"ManagementFollowupCallMadeType":aReport.followUpCallType, @"ActivityTypeId": aReport.activityTypeID, @"EquipmentTypeId": aReport.equipmentTypeID, @"NatureId": aReport.natureId, @"ActionTakenId": aReport.actionId, @"ConditionId": aReport.conditionTypeID, @"PersonsInvolved":mutArrPerson, @"EmergencyPersonnel":mutArrEmergency, @"Witnesses":mutArrWitness};
        [gblAppDelegate callWebService:INCIDENT_REPORT_POST parameters:aDict httpMethod:[SERVICE_HTTP_METHOD objectForKey:INCIDENT_REPORT_POST] complition:^(NSDictionary *response) {
            [gblAppDelegate.managedObjectContext deleteObject:aReport];
            isSingleDataSaved = YES;
        } failure:^(NSError *error, NSDictionary *response) {
            isSingleDataSaved = YES;
            isErrorOccurred = YES;
            alert(@"", [response objectForKey:@"ErrorMessage"]);
        }];
        while (!isSingleDataSaved) {
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
        }
        if (isErrorOccurred) {
            break;
        }
    }
    [gblAppDelegate.managedObjectContext save:nil];
    return isErrorOccurred;
}

- (BOOL)syncAccidentReport {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AccidentReportSubmit"];
    NSArray *aryOfflineData = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    isErrorOccurred = NO;
    __block BOOL isSingleDataSaved = NO;
    for (AccidentReportSubmit *aReport in aryOfflineData) {
        isSingleDataSaved = NO;
        NSMutableArray *mutArrPerson = [NSMutableArray array];
        for (AccidentPerson *obj in [aReport.accidentPerson allObjects]) {
            NSString *memberId = @"", *employeeId = @"";
            if ([obj.personTypeID integerValue] == 3) {
                employeeId = obj.memberId;
            }
            else {
                memberId = obj.memberId;
            }
            NSString *aStrPhoto = @"";
            if (obj.personPhoto) {
                aStrPhoto = [obj.personPhoto base64EncodedStringWithOptions:0];
            }
            NSString *strSignature = @"";
            if (obj.participantSignature) {
                strSignature = [obj.participantSignature base64EncodedStringWithOptions:0];
            }

            
            NSMutableArray *injuryList = [NSMutableArray array];
            for (InjuryDetail *aInjury in obj.injuryList.allObjects) {
                NSDictionary *aDict = @{@"NatureId":aInjury.natureId, @"GeneralInjuryTypeId":aInjury.generalInjuryTypeId, @"GeneralInjuryOther":aInjury.generalInjuryOther, @"BodyPartInjuryTypeId":aInjury.bodyPartInjuryTypeId, @"BodyPartInjuredId":aInjury.bodyPartInjuredId, @"ActionTakenId":aInjury.actionTakenId};
                [injuryList addObject:aDict];
            }
            
            NSDictionary *aDict = @{@"FirstName": obj.firstName, @"MiddleInitial":obj.middleInitial, @"LastName":obj.lastName, @"PrimaryPhone":obj.primaryPhone, @"AlternatePhone":obj.alternatePhone, @"Email":obj.email, @"Address1":obj.streetAddress, @"Address2":obj.apartmentNumber, @"City":obj.city, @"State":obj.state, @"Zip": obj.zip, @"AffiliationTypeId":obj.affiliationTypeID, @"GenderTypeId":obj.genderTypeID, @"PersonTypeId":obj.personTypeID, @"GuestOfFirstName":obj.guestOfFirstName, @"GuestOfMiddleInitial":obj.guestOfMiddleInitial, @"GuestOfLastName": obj.guestOfLastName, @"IsMinor":obj.minor, @"EmployeeTitle":obj.employeeTitle, @"EmployeId":employeeId, @"MemberId":memberId, @"DateOfBirth":obj.dateOfBirth, @"PersonPhoto":aStrPhoto, @"FirstAidFirstName":obj.firstAidFirstName, @"FirstAidMiddleInitial":obj.firstAidMiddleInitial, @"FirstAidLastName":obj.firstAidLastName, @"FirstAidPosition":obj.firstAidPosition, @"ActivityTypeId":obj.activityTypeID, @"EquipmentTypeId":obj.equipmentTypeID, @"ConditionId":obj.conditionTypeID, @"":obj.conditionTypeID, @"PersonSignature":strSignature, @"PersonName":obj.participantName, @"BloodbornePathogenTypeId":obj.bloodBornePathogenType, @"StaffMemberWrittenAccount":obj.staffMemberWrittenAccount, @"WasBloodOrBodilyFluidPresent":obj.wasBloodPresent, @"WasBloodCleanupRequired":obj.bloodCleanUpRequired, @"WasCaregiverExposedToBlood":obj.wasExposedToBlood, @"OccuredDuringBusinessHours":obj.duringWorkHours, @"Injuries":injuryList};
            [mutArrPerson addObject:aDict];
        }
        
        NSMutableArray *mutArrEmergency = [NSMutableArray array];
        for (EmergencyPersonnel *obj in [aReport.emergencyPersonnels allObjects]) {
            NSDictionary *aDict = @{@"FirstName":obj.firstName, @"MiddleInitial":obj.middileInitial, @"LastName":obj.lastName, @"Phone":obj.phone, @"AdditionalInformation":obj.additionalInformation, @"CaseNumber":obj.caseNumber, @"BadgeNumber":obj.badgeNumber, @"Time911Called":obj.time911Called, @"ArrivalTime":obj.time911Arrival, @"DepartureTime":obj.time911Departure};
            [mutArrEmergency addObject:aDict];
        }
        
        NSMutableArray *mutArrWitness = [NSMutableArray array];
        for (Witness *obj in [aReport.witnesses allObjects]) {
            NSDictionary *aDict = @{@"FirstName":obj.firstName, @"MiddleInitial":obj.middleInitial, @"LastName":obj.lastName, @"HomePhone":obj.homePhone, @"AlternatePhone":obj.alternatePhone, @"Email":obj.email, @"IncidentDescription":obj.witnessWrittenAccount};
            [mutArrWitness addObject:aDict];
        }


#warning missing this commented line
//@"ReportFilerAccount":aReport.reportFilerAccount,
        NSDictionary *aDict = @{@"AccidentDate":aReport.dateOfIncident, @"FacilityId":aReport.facilityId, @"LocationId":aReport.locationId, @"AccidentDescription":aReport.accidentDesc, @"IsNotificationField1Selected":aReport.isNotification1Selected, @"IsNotificationField2Selected":aReport.isNotification2Selected, @"IsNotificationField3Selected":aReport.isNotification3Selected, @"IsNotificationField4Selected":aReport.isNotification4Selected, @"EmployeeFirstName":aReport.employeeFirstName, @"EmployeeMiddleInitial": aReport.employeeMiddleInitial, @"EmployeeLastName":aReport.employeeLastName, @"EmployeeHomePhone":aReport.employeeHomePhone, @"EmployeeAlternatePhone":aReport.employeeAlternatePhone, @"EmployeeEmail":aReport.employeeEmail, @"AdditionalInformation": aReport.additionalInfo, @"PersonsInvolved":mutArrPerson, @"EmergencyPersonnel":mutArrEmergency, @"Witnesses":mutArrWitness};
        [gblAppDelegate callWebService:ACCIDENT_REPORT_POST parameters:aDict httpMethod:[SERVICE_HTTP_METHOD objectForKey:ACCIDENT_REPORT_POST] complition:^(NSDictionary *response) {
            [gblAppDelegate.managedObjectContext deleteObject:aReport];
            isSingleDataSaved = YES;
        } failure:^(NSError *error, NSDictionary *response) {
            isSingleDataSaved = YES;
            isErrorOccurred = YES;
            alert(@"", [response objectForKey:@"ErrorMessage"]);
        }];
        while (!isSingleDataSaved) {
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
        }
        if (isErrorOccurred) {
            break;
        }
    }
    [gblAppDelegate.managedObjectContext save:nil];
    return isErrorOccurred;
}

@end
