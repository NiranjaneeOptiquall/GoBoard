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
#import "SubmitFormAndSurvey.h"
#import "QuestionDetails.h"
#import "Memoboard.h"
#import "DailyLog.h"

@interface UserHomeViewController ()

@end

@implementation UserHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![[User currentUser] isAdmin]) {
        [_btnTools setHidden:YES];
        [_btnSurvey setCenter:CGPointMake(self.view.center.x, _btnSurvey.center.y)];
    }
    [_lblWelcomeUser setText:[NSString stringWithFormat:@"Welcome %@ %@", [[User currentUser] firstName], [[User currentUser] lastName]]];
    
    [_lblPendingCount.layer setCornerRadius:5.0];
    [_lblPendingCount.layer setBorderWidth:1.0];
    [_lblPendingCount setClipsToBounds:YES];
    [_lblPendingCount.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [_lblMemoCount.layer setCornerRadius:5.0];
    [_lblMemoCount.layer setBorderWidth:1.0];
    [_lblMemoCount setClipsToBounds:YES];
    [_lblMemoCount.layer setBorderColor:[UIColor whiteColor].CGColor];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    intUnreadMemoCount = [[gblAppDelegate.mutArrMemoList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IsRead == 0"]] count];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userId MATCHES[cd] %@) AND isCompleted = 0", [[User currentUser] userId]];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AccidentReportSubmit"];
    [request setPredicate:predicate];
    intPendingAccidentReport = [gblAppDelegate.managedObjectContext countForFetchRequest:request error:nil];
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"Report"];
    [request setPredicate:predicate];
    intPendingIncidentReport = [gblAppDelegate.managedObjectContext countForFetchRequest:request error:nil];
    
    [_cvMenuGrid reloadData];
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

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [gblAppDelegate.mutArrHomeMenus count];
}


- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *aCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    __weak UIImageView *aImvIcon = (UIImageView*)[aCell.contentView viewWithTag:2];
    __weak UILabel *aLblMenu = (UILabel*)[aCell.contentView viewWithTag:3];
    __weak UILabel *aLblBadge = (UILabel*)[aCell.contentView viewWithTag:4];
    aImvIcon.image = nil;
    [aLblBadge setHidden:YES];
    aLblMenu.text = @"";
    __weak NSDictionary *aDict = [gblAppDelegate.mutArrHomeMenus objectAtIndex:indexPath.item];
    if ([aDict[@"IsActive"] boolValue]) {
        if ([aDict[@"SystemModule"] integerValue] != 8 && [aDict[@"SystemModule"] integerValue] != 9 && [aDict[@"SystemModule"] integerValue] != 10) {
            aImvIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"menu_%ld", (long)[aDict[@"SystemModule"] integerValue]]];
            aLblMenu.text = aDict[@"Name"];
            NSInteger count = 0;
            
            if ([aDict[@"SystemModule"] integerValue] == 5 && intPendingIncidentReport > 0) {
                count = intPendingIncidentReport;
            }
            else if ([aDict[@"SystemModule"] integerValue] == 11 && intPendingAccidentReport > 0) {
                count = intPendingAccidentReport;
            }
            else if ([aDict[@"SystemModule"] integerValue] == 15 && intUnreadMemoCount > 0) {
                count = intUnreadMemoCount;
            }
            if (count > 0) {
                aLblBadge.text = [NSString stringWithFormat:@"%ld", (long)count];
                [aLblBadge.layer setCornerRadius:5.0];
                [aLblBadge.layer setBorderWidth:1.0];
                [aLblBadge setClipsToBounds:YES];
                [aLblBadge.layer setBorderColor:[UIColor whiteColor].CGColor];
                [aLblBadge setHidden:NO];
            }
        }
    }
    [aCell setBackgroundColor:[UIColor clearColor]];
    return aCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NAME = SystemModule
//    Tasks = 0
//    Counts = 1
//    Forms = 2
//    Graphs = 3
//    ERP = 4
//    Incident = 5
//    SOPs = 6
//    Tools = 7
//    Account = 8
//    User = 9
//    Client = 10
//    Accident = 11
//    Survey = 12
//    EOD = 13
//    Log = 14
//    Memos = 15
    NSArray *segues = @[@"Tasks", @"Counts", @"userForms", @"Graphs", @"ERP", @"Incident", @"SOPs", @"Tools", @"", @"", @"", @"Accident", @"userSurvey", @"EOD", @"DailyLog", @"Memos"];
    __weak NSDictionary *aDict = [gblAppDelegate.mutArrHomeMenus objectAtIndex:indexPath.item];
    if ([aDict[@"IsActive"] boolValue]) {
        if ([aDict[@"SystemModule"] integerValue] != 8 && [aDict[@"SystemModule"] integerValue] != 9 && [aDict[@"SystemModule"] integerValue] != 10) {
            [self performSegueWithIdentifier:segues[[aDict[@"SystemModule"] integerValue]] sender:nil];
        }
    }
}


#pragma mark - Sync Methods

- (void)getSyncCount {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ERPHistory"];
    syncCount = [gblAppDelegate.managedObjectContext countForFetchRequest:request error:nil];
    request = [[NSFetchRequest alloc] initWithEntityName:@"SubmitCountUser"];
    syncCount += [gblAppDelegate.managedObjectContext countForFetchRequest:request error:nil];
    request = [[NSFetchRequest alloc] initWithEntityName:@"Report"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"isCompleted == 1"]];
    syncCount += [gblAppDelegate.managedObjectContext countForFetchRequest:request error:nil];
    request = [[NSFetchRequest alloc] initWithEntityName:@"AccidentReportSubmit"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"isCompleted == 1"]];
    syncCount += [gblAppDelegate.managedObjectContext countForFetchRequest:request error:nil];
    request = [[NSFetchRequest alloc] initWithEntityName:@"SubmitFormAndSurvey"];
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
        isSyncError = [self syncSubmittedTask];
    if (!isSyncError)
        isSyncError = [self syncIncidentReport];
    if (!isSyncError)
        isSyncError = [self syncSurveysAndForms];
    if (!isSyncError) {
        alert(@"", @"All data is synchronized with the server.");
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
        NSDictionary *aDict = @{@"UserId":history.userId, @"FacilityId":history.facilityId, @"ErpSubcategoryId":history.erpSubcategoryId, @"StartDateTime":history.startDateTime, @"EndDateTime":history.endDateTime, @"Tasks":aryTask};
        [gblAppDelegate callWebService:ERP_HISTORY parameters:aDict httpMethod:[SERVICE_HTTP_METHOD objectForKey:ERP_HISTORY] complition:^(NSDictionary *response) {
            [gblAppDelegate.managedObjectContext deleteObject:history];
            isHistorySaved = YES;
        } failure:^(NSError *error, NSDictionary *response) {
            isHistorySaved = YES;
            isErrorOccurred = YES;
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
        NSDictionary *aDict = @{@"UserId":user.userId, @"Locations":mutArrLocations};
        [gblAppDelegate callWebService:UTILIZATION_COUNT parameters:aDict httpMethod:@"POST" complition:^(NSDictionary *response) {
            [gblAppDelegate.managedObjectContext deleteObject:user];
            isSingleDataSaved = YES;
        } failure:^(NSError *error, NSDictionary *response) {
            isSingleDataSaved = YES;
            isErrorOccurred = YES;
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
        NSDictionary *aDict = @{@"UserId":user.userId, @"Locations":mutArrTask};
        [gblAppDelegate callWebService:TASK parameters:aDict httpMethod:@"POST" complition:^(NSDictionary *response) {
            [gblAppDelegate.managedObjectContext deleteObject:user];
            isSingleDataSaved = YES;
        } failure:^(NSError *error, NSDictionary *response) {
            isSingleDataSaved = YES;
            isErrorOccurred = YES;
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isCompleted == 1"];
    [request setPredicate:predicate];
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isCompleted == 1"];
    [request setPredicate:predicate];
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

        NSDictionary *aDict = @{@"AccidentDate":aReport.dateOfIncident, @"FacilityId":aReport.facilityId, @"LocationId":aReport.locationId, @"AccidentDescription":aReport.accidentDesc, @"IsNotificationField1Selected":aReport.isNotification1Selected, @"IsNotificationField2Selected":aReport.isNotification2Selected, @"IsNotificationField3Selected":aReport.isNotification3Selected, @"IsNotificationField4Selected":aReport.isNotification4Selected, @"EmployeeFirstName":aReport.employeeFirstName, @"EmployeeMiddleInitial": aReport.employeeMiddleInitial, @"EmployeeLastName":aReport.employeeLastName, @"EmployeeHomePhone":aReport.employeeHomePhone, @"EmployeeAlternatePhone":aReport.employeeAlternatePhone, @"EmployeeEmail":aReport.employeeEmail, @"AdditionalInformation": aReport.additionalInfo, @"PersonsInvolved":mutArrPerson, @"EmergencyPersonnel":mutArrEmergency, @"Witnesses":mutArrWitness, @"ReportFilerAccount":aReport.reportFilerAccount};
        [gblAppDelegate callWebService:ACCIDENT_REPORT_POST parameters:aDict httpMethod:[SERVICE_HTTP_METHOD objectForKey:ACCIDENT_REPORT_POST] complition:^(NSDictionary *response) {
            [gblAppDelegate.managedObjectContext deleteObject:aReport];
            isSingleDataSaved = YES;
        } failure:^(NSError *error, NSDictionary *response) {
            isSingleDataSaved = YES;
            isErrorOccurred = YES;
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


- (BOOL)syncSurveysAndForms {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SubmitFormAndSurvey"];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type MATCHES[cd] %@", @"2"];
//    [request setPredicate:predicate];
    NSArray *aryOfflineData = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    isErrorOccurred = NO;
    __block BOOL isSingleDataSaved = NO;
    for (SubmitFormAndSurvey *record in aryOfflineData) {
        NSMutableArray *mutArrReq = [NSMutableArray array];
        for (QuestionDetails *obj in record.questionList.allObjects) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:obj.questionId forKey:@"QuestionId"];
            [dict setObject:obj.questionText forKey:@"QuestionText"];
            [dict setObject:obj.responseText forKey:@"ResponseText"];
            [dict setObject:obj.responseId forKey:@"ResponseId"];
            [mutArrReq addObject:dict];
        }
        NSString *strIDKeyName, *strWebServiceName = @"";
        if ([record.type isEqualToString:@"2"]) {
            strIDKeyName = @"FormId";
            strWebServiceName = FORM_HISTORY_POST;
        }
        else {
            strIDKeyName = @"SurveyId";
            strWebServiceName = SURVEY_HISTORY_POST;
        }
        NSDictionary *dictReq = @{@"UserId":record.userId, strIDKeyName:record.typeId, @"Details":mutArrReq, @"ClientId":record.clientId};
        [gblAppDelegate callWebService:strWebServiceName parameters:dictReq httpMethod:[SERVICE_HTTP_METHOD objectForKey:strWebServiceName] complition:^(NSDictionary *response) {
            [gblAppDelegate.managedObjectContext deleteObject:record];
            isSingleDataSaved = YES;
        } failure:^(NSError *error, NSDictionary *response) {
            isSingleDataSaved = YES;
            isErrorOccurred = YES;
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
