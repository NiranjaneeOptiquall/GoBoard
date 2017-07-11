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
#import "Emergency.h"
#import "InjuryDetail.h"
#import "SubmitFormAndSurvey.h"
#import "QuestionDetails.h"
#import "Memoboard.h"
#import "DailyLog.h"
#import "EmergencyPersonnelIncident.h"
#import "TeamLog.h"
#import "TeamSubLog.h"
#import "TeamLogTrace.h"
#import "LoginViewController.h"

#import "DailyLogViewController.h"

@interface UserHomeViewController ()
{
    NSDictionary *dictReq;
    NSMutableArray *moduleArr;
}
@end

@implementation UserHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![[User currentUser] isAdmin]) {
        [_btnTools setHidden:YES];
        [_btnSurvey setCenter:CGPointMake(self.view.center.x, _btnSurvey.center.y)];
    }
    
    moduleArr = [NSMutableArray new];
    for (NSDictionary * tempDic in gblAppDelegate.mutArrHomeMenus) {
        if (([tempDic[@"IsActive"] boolValue] && [tempDic[@"IsAccessAllowed"] boolValue])) {
            [moduleArr addObject:tempDic];
        }
    }
    NSLog(@"%@",moduleArr);
    [_lblWelcomeUser setText:[NSString stringWithFormat:@"Welcome %@ %@", [[User currentUser] firstName], [[User currentUser] lastName]]];
    
    [_lblPendingCount.layer setCornerRadius:5.0];
    [_lblPendingCount.layer setBorderWidth:1.0];
    [_lblPendingCount setClipsToBounds:YES];
    [_lblPendingCount.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [_lblMemoCount.layer setCornerRadius:5.0];
    [_lblMemoCount.layer setBorderWidth:1.0];
    [_lblMemoCount setClipsToBounds:YES];
    [_lblMemoCount.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [self.lblVersion setText:[NSString stringWithFormat:@"v%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    
    self.intUnreadLogCount += gblAppDelegate.teamLogCountAfterLogin;

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_lblWelcomeUser setText:[NSString stringWithFormat:@"Welcome %@ %@", [[User currentUser] firstName], [[User currentUser] lastName]]];
    
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
 //   [self callWebserviceToUpdateTeamLog];

    

   [self callWebserviceForMissedTaskNotification];

    self.allowMemoWSCall = YES;

   [self callWebserviceToUpdateCountOnDashboard];
   [self callWebserviceToUpdateMemo];
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.allowMemoWSCall = NO;

    [super viewDidDisappear:animated];
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
    else if ([[segue identifier] isEqualToString:@"DailyLog"])
    {
        DailyLogViewController *aVCObj= (DailyLogViewController *)segue.destinationViewController;
        aVCObj.boolISWSCallNeeded = self.boolUpdateTeamLog;
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
- (IBAction)signOutClicked:(id)sender {
    NSLog(@"%@ %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"syncCount"],[[NSUserDefaults standardUserDefaults]valueForKey:@"signOutMsg"]);
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"signOutMsg"]isEqualToString:@"YES"] || [[[NSUserDefaults standardUserDefaults]valueForKey:@"syncCount"] intValue] >0) {
        [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"signOutMsg"];
        UIAlertView * alertMsg=[[UIAlertView alloc]initWithTitle:@"" message:@"You have an incomplete Form/Survey. Are you sure you want to Sign Out?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alertMsg show];
    }
    else{
        [self webserviceCallForUserLogOff];

        LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
       [self.navigationController pushViewController:loginVC animated:NO];
    }
}
-(void)webserviceCallForUserLogOff{
    
//    NSDictionary *aDict = @{@"userId":[[User currentUser] userId], @"logoutType": @1};
//
//    [gblAppDelegate callWebService:USER_SERVICE parameters:aDict httpMethod:@"POST" complition:^(NSDictionary *response) {
//      //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:@"Incident Report has been submitted successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//      //  [alert show];
//    } failure:^(NSError *error, NSDictionary *response) {
////[self saveIncidentToOffline:aDict completed:YES];
//    }];

    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?userId=%@",USER_LOGIN,[[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:USER_LOGIN] complition:^(NSDictionary *response) {
        
    }failure:^(NSError *error, NSDictionary *response) {
        
    }];
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //Code for OK button
    }
    if (buttonIndex == 1)
    {
        [self webserviceCallForUserLogOff];
        //Code for download button
        LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:loginVC animated:NO];    }
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return [gblAppDelegate.mutArrHomeMenus count];
    return [moduleArr count];
}


- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *aCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    __weak UIImageView *aImvIcon = (UIImageView*)[aCell.contentView viewWithTag:2];
    __weak UILabel *aLblMenu = (UILabel*)[aCell.contentView viewWithTag:3];
    __weak UILabel *aLblBadge = (UILabel*)[aCell.contentView viewWithTag:4];
    aImvIcon.image = nil;
    [aLblBadge setHidden:YES];
    aLblMenu.text = @"";
//    __weak NSDictionary *aDict = [gblAppDelegate.mutArrHomeMenus objectAtIndex:indexPath.item];
     __weak NSDictionary *aDict = [moduleArr objectAtIndex:indexPath.item];
    NSLog(@"%@",aDict);
 //   if ([aDict[@"IsActive"] boolValue] && [aDict[@"IsAccessAllowed"] boolValue]) {
        if ([aDict[@"SystemModule"] integerValue] != 8 && [aDict[@"SystemModule"] integerValue] != 9 && [aDict[@"SystemModule"] integerValue] != 10) {
            aImvIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"menu_%ld.png", (long)[aDict[@"SystemModule"] integerValue]]];
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
            else if ([aDict[@"SystemModule"] integerValue] == 14 && self.intUnreadLogCount > 0) {
                count = self.intUnreadLogCount;
            }
            else if ([aDict[@"SystemModule"] integerValue] == 2 && self.intFormInProgressCount > 0) {
                count = self.intFormInProgressCount;
            }
            else if ([aDict[@"SystemModule"] integerValue] == 12 && self.intSurveyInProgressCount > 0) {
                count = self.intSurveyInProgressCount;
            }
            else if ([aDict[@"SystemModule"] integerValue] == 0){
               count = self.intTaskCount;
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
   // }
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
//__weak NSDictionary *aDict = [gblAppDelegate.mutArrHomeMenus objectAtIndex:indexPath.item];
    __weak NSDictionary *aDict =  [moduleArr objectAtIndex:indexPath.item];

    if ([aDict[@"IsActive"] boolValue] && [aDict[@"IsAccessAllowed"] boolValue])
    {
        if ([aDict[@"SystemModule"] integerValue] != 8 && [aDict[@"SystemModule"] integerValue] != 9 && [aDict[@"SystemModule"] integerValue] != 10) {
            [self performSegueWithIdentifier:segues[[aDict[@"SystemModule"] integerValue]] sender:nil];
        }
    }
//    else{
//         alert(@"", @"We’re sorry.  You do not have permission to access this area.  Please see your system administrator.");
//    }
}


#pragma mark - Sync Methods

- (void)getSyncCount {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ERPHistory"];
    syncCount = [gblAppDelegate.managedObjectContext countForFetchRequest:request error:nil];
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"SubmitCountUser"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"userId == %@",[User currentUser].userId]];
    syncCount += [gblAppDelegate.managedObjectContext countForFetchRequest:request error:nil];
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"Report"];
   // [request setPredicate:[NSPredicate predicateWithFormat:@"isCompleted == 1"]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"(userId MATCHES[cd] %@) AND isCompleted == 1" ,[User currentUser].userId]];
    syncCount += [gblAppDelegate.managedObjectContext countForFetchRequest:request error:nil];
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"AccidentReportSubmit"];
  //  [request setPredicate:[NSPredicate predicateWithFormat:@"isCompleted == 1"]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"(userId MATCHES[cd] %@) AND isCompleted == 1",[User currentUser].userId]];
    syncCount += [gblAppDelegate.managedObjectContext countForFetchRequest:request error:nil];
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"SubmitFormAndSurvey"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"(userId MATCHES[cd] %@) OR userId == '' ",[User currentUser].userId]];
    syncCount += [gblAppDelegate.managedObjectContext countForFetchRequest:request error:nil];
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"TeamLog"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"userId ==[cd] %@ AND (shouldSync == 1 OR (ANY teamSubLog.shouldSync == 1))",[[User currentUser]userId]]];
    syncCount += [gblAppDelegate.managedObjectContext countForFetchRequest:request error:nil];

    if (syncCount == 0) {
        [_lblPendingCount setHidden:YES];
    }
    else {
        [_lblPendingCount setHidden:NO];
    }
    [_lblPendingCount setText:[NSString stringWithFormat:@"%ld", (long)syncCount]];
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld", (long)syncCount] forKey:@"syncCount"];
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
        isSyncError = [self syncAccidentReport];
    if (!isSyncError)
        isSyncError = [self syncSurveysAndForms];
    if (!isSyncError)
        isSyncError = [self syncTeamLog];

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
            [mutArrTask addObject:@{@"Id": task.taskId, @"Response":task.response, @"ResponseType":task.responseType, @"Comment":task.comment, @"IsCommentTask": task.isCommentTask, @"IsCommentGoBoardGroup":task.isCommentGoBoardGroup, @"IsCommentBuildingSupervisor":task.isCommentBuildingSupervisor, @"IsCommentAreaSupervisor":task.isCommentAreaSupervisor, @"IsCommentWorkOrder":task.isCommentWorkOrder,@"Completed":@"true"}];
        }
        NSDictionary *aDict = @{@"UserId":user.userId, @"Tasks":mutArrTask};
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userId ==[cd] %@) AND isCompleted == 1" ,[User currentUser].userId];
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
                if (obj.memberId==nil) {
                    employeeId = @"";
                }
                else
                    employeeId = obj.memberId;
            }
            else {
                if (obj.memberId==nil) {
                    memberId = @"";
                }
                else
                    memberId = obj.memberId;
            }
            NSString *aStrPhoto = @"";
            if (obj.personPhoto) {
                aStrPhoto = [obj.personPhoto base64EncodedStringWithOptions:0];
            }
        
            NSMutableArray *mutArrEmergency = [NSMutableArray array];
            for (EmergencyPersonnelIncident *objEmergency in obj.emergencyPersonnelIncident) {
            
                id time911Called, timeArrival, timeDeparture;
                if ([objEmergency.time911Called isEqualToString:@""]) {
                    time911Called = [NSNull null];
                }
                else {
                    time911Called = objEmergency.time911Called;
                }
                
                if ([objEmergency.time911Arrival isEqualToString:@""]) {
                    timeArrival = [NSNull null];
                }
                else {
                    timeArrival = objEmergency.time911Arrival;
                }
                
                if ([objEmergency.time911Departure isEqualToString:@""]) {
                    timeDeparture = [NSNull null];
                }
                else {
                    timeDeparture = objEmergency.time911Departure;
                }
                NSDictionary *aDict = @{@"FirstName":objEmergency.firstName, @"MiddleInitial":objEmergency.middleInitial, @"LastName":objEmergency.lastName, @"Phone":objEmergency.phone, @"AdditionalInformation":objEmergency.additionalInformation, @"CaseNumber":objEmergency.caseNumber, @"BadgeNumber":objEmergency.badgeNumber, @"Time911Called":time911Called, @"ArrivalTime":timeArrival, @"DepartureTime":timeDeparture};
                [mutArrEmergency addObject:aDict];
            }
            
            NSDictionary *aDict = @{@"FirstName": obj.firstName, @"MiddleInitial":obj.middleInitial, @"LastName":obj.lastName, @"PrimaryPhone":obj.primaryPhone, @"AlternatePhone":obj.alternatePhone, @"Email":obj.email, @"Address1":obj.streetAddress, @"Address2":obj.apartmentNumber, @"City":obj.city, @"State":obj.state, @"Zip": obj.zip, @"AffiliationTypeId":obj.affiliationTypeID, @"GenderTypeId":obj.genderTypeID, @"PersonTypeId":obj.personTypeID, @"GuestOfFirstName":obj.guestOfFirstName, @"GuestOfMiddleInitial":obj.guestOfMiddleInitial, @"GuestOfLastName": obj.guestOfLastName, @"IsMinor":obj.minor, @"EmployeeTitle":obj.employeeTitle, @"EmployeId":employeeId, @"MemberId":memberId, @"DateOfBirth":obj.dateOfBirth, @"OccuredDuringBusinessHours":obj.duringWorkHours, @"PersonPhoto":aStrPhoto, @"EmergencyPersonnel" : mutArrEmergency,@"NatureId" : obj.natureId, @"ActionTakenId" : obj.actionTakenId, @"ActivityTypeId" : obj.activityTypeId,@"EquipmentTypeId" : obj.equipmentTypeId,@"ConditionId" : obj.conditionId};
            [mutArrPerson addObject:aDict];
        }
        
        NSMutableArray *mutArrEmergency = [NSMutableArray array];

        
        NSMutableArray *mutArrWitness = [NSMutableArray array];
        for (Witness *obj in [aReport.witnesses allObjects]) {
            NSDictionary *aDict = @{@"FirstName":obj.firstName, @"MiddleInitial":obj.middleInitial, @"LastName":obj.lastName, @"HomePhone":obj.homePhone, @"AlternatePhone":obj.alternatePhone, @"Email":obj.email, @"IncidentDescription":obj.witnessWrittenAccount, @"PersonTypeId" : obj.personTypeId};
            [mutArrWitness addObject:aDict];
        }
        
        NSDictionary *aDict = @{@"ReportType" : aReport.reportType,@"IncidentDate":aReport.dateOfIncident, @"FacilityId":aReport.facilityId, @"LocationId":aReport.locationId, @"IncidentDescription":aReport.incidentDesc, @"IsNotificationField1Selected":aReport.isNotification1Selected, @"IsNotificationField2Selected":aReport.isNotification2Selected, @"IsNotificationField3Selected":aReport.isNotification3Selected, @"IsNotificationField4Selected":aReport.isNotification4Selected, @"EmployeeFirstName":aReport.employeeFirstName, @"EmployeeMiddleInitial": aReport.employeeMiddleInitial, @"EmployeeLastName":aReport.employeeLastName, @"EmployeeHomePhone":aReport.employeeHomePhone, @"EmployeeAlternatePhone":aReport.employeeAlternatePhone, @"EmployeeEmail":aReport.employeeEmail, @"ReportFilerAccount":aReport.reportFilerAccount, @"ManagementFollowupDate":aReport.managementFollowUpDate, @"AdditionalInformation": aReport.additionalInfo, @"ManagementFollowupCallMadeType":aReport.followUpCallType,@"PersonsInvolved":mutArrPerson, @"EmergencyPersonnel":mutArrEmergency, @"Witnesses":mutArrWitness};
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userId MATCHES[cd] %@) AND isCompleted == 1" ,[User currentUser].userId];
    [request setPredicate:predicate];
    NSArray *aryOfflineData = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    isErrorOccurred = NO;
    __block BOOL isSingleDataSaved = NO;
    for (AccidentReportSubmit *aReport in aryOfflineData) {
        isSingleDataSaved = NO;
        NSMutableArray *mutArrPerson = [NSMutableArray array];
        for (AccidentPerson *obj in [aReport.accidentPerson allObjects]) {
            
            NSString *memberId = @"", *employeeId = @"", *guestId = @"";
            if ([obj.personTypeID integerValue] == 3) {
                employeeId = obj.memberId;
            }else if ([obj.personTypeID integerValue] == 2)
                guestId = obj.guestId;
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

            
            NSMutableArray *mutArrEmergencyPersonnel = [NSMutableArray array];
            for (Emergency *aEmegency in obj.emergency.allObjects) {
                id time911Called, timeArrival, timeDeparture;
                if ([aEmegency.time911Called isEqualToString:@""]) {
                    time911Called = [NSNull null];
                }
                else {
                    time911Called = aEmegency.time911Called;
                }
                
                if ([aEmegency.time911Arrival isEqualToString:@""]) {
                    timeArrival = [NSNull null];
                }
                else {
                    timeArrival = aEmegency.time911Arrival;
                }
                
                if ([aEmegency.time911Departure isEqualToString:@""]) {
                    timeDeparture = [NSNull null];
                }
                else {
                    timeDeparture = aEmegency.time911Departure;
                }
                NSDictionary *aDict = @{@"FirstName":aEmegency.firstName, @"MiddleInitial":aEmegency.middileInitial, @"LastName":aEmegency.lastName, @"Phone":aEmegency.phone, @"AdditionalInformation":aEmegency.additionalInformation, @"CaseNumber":aEmegency.caseNumber, @"BadgeNumber":aEmegency.badgeNumber, @"Time911Called":time911Called, @"ArrivalTime":timeArrival, @"DepartureTime":timeDeparture};
                [mutArrEmergencyPersonnel addObject:aDict];
            }
            
            
            
            NSMutableArray *injuryList = [NSMutableArray array];
            for (InjuryDetail *aInjury in obj.injuryList.allObjects) {
                NSDictionary *aDict = @{@"NatureId":aInjury.natureId, @"GeneralInjuryTypeId":aInjury.generalInjuryTypeId, @"GeneralInjuryOther":aInjury.generalInjuryOther, @"BodyPartInjuryTypeId":aInjury.bodyPartInjuryTypeId, @"BodyPartInjuredId":aInjury.bodyPartInjuredId, @"ActionTakenId":aInjury.actionTakenId,@"BodyPartInjuredLocation":aInjury.bodyPartInjuredLocation};
                [injuryList addObject:aDict];
            }
            
            NSDictionary *aDict = @{@"FirstName": obj.firstName, @"MiddleInitial":obj.middleInitial, @"LastName":obj.lastName, @"PrimaryPhone":obj.primaryPhone, @"AlternatePhone":obj.alternatePhone, @"Email":obj.email, @"Address1":obj.streetAddress, @"Address2":obj.apartmentNumber, @"City":obj.city, @"State":obj.state, @"Zip": obj.zip, @"AffiliationTypeId":obj.affiliationTypeID, @"GenderTypeId":obj.genderTypeID, @"PersonTypeId":obj.personTypeID, @"GuestOfFirstName":obj.guestOfFirstName, @"GuestOfMiddleInitial":obj.guestOfMiddleInitial, @"GuestOfLastName": obj.guestOfLastName, @"IsMinor":obj.minor, @"EmployeeTitle":obj.employeeTitle, @"EmployeId":employeeId, @"MemberId":memberId, @"DateOfBirth":obj.dateOfBirth, @"PersonPhoto":aStrPhoto, @"FirstAidFirstName":obj.firstAidFirstName, @"FirstAidMiddleInitial":obj.firstAidMiddleInitial, @"FirstAidLastName":obj.firstAidLastName, @"FirstAidPosition":obj.firstAidPosition, @"ActivityTypeId":obj.activityTypeID, @"EquipmentTypeId":obj.equipmentTypeID, @"ConditionId":obj.conditionTypeID, @"":obj.conditionTypeID, @"PersonSignature":strSignature, @"PersonName":obj.participantName, @"BloodbornePathogenTypeId":obj.bloodBornePathogenType, @"StaffMemberWrittenAccount":obj.staffMemberWrittenAccount, @"WasBloodOrBodilyFluidPresent":obj.wasBloodPresent, @"WasBloodCleanupRequired":obj.bloodCleanUpRequired, @"WasCaregiverExposedToBlood":obj.wasExposedToBlood, @"OccuredDuringBusinessHours":obj.duringWorkHours, @"Injuries":injuryList , @"EmergencyPersonnel" : mutArrEmergencyPersonnel};
            [mutArrPerson addObject:aDict];
        }
        
        NSMutableArray *mutArrEmergency = [NSMutableArray array];
        
        NSMutableArray *mutArrWitness = [NSMutableArray array];
        for (Witness *obj in [aReport.witnesses allObjects]) {
            NSDictionary *aDict = @{@"FirstName":obj.firstName, @"MiddleInitial":obj.middleInitial, @"LastName":obj.lastName, @"HomePhone":obj.homePhone, @"AlternatePhone":obj.alternatePhone, @"Email":obj.email, @"IncidentDescription":obj.witnessWrittenAccount , @"PersonTypeId" : obj.personTypeId};
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userId MATCHES[cd] %@) OR userId == '' ",[User currentUser].userId];
    [request setPredicate:predicate];
    NSArray *aryOfflineData = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    isErrorOccurred = NO;
    __block BOOL isSingleDataSaved = NO;
    for (SubmitFormAndSurvey *record in aryOfflineData) {
        
        isSingleDataSaved = NO;

        NSMutableArray *mutArrReq = [NSMutableArray array];
        for (QuestionDetails *obj in record.questionList.allObjects) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:obj.questionId forKey:@"QuestionId"];
            [dict setObject:obj.questionText forKey:@"QuestionText"];
            [dict setObject:obj.responseText forKey:@"ResponseText"];
            if ([obj.detailImageVideoText isEqualToString:@"(null)"]) {
                
            }
            else{
                [dict setObject:obj.detailImageVideoText forKey:@"UploadFileResponseData"];

            }
            //chetan kasundra
            // put the nil condition particulary for textbox,date,time,checkbox,numeric field in survey and form screen because all this field not set the ResponseID when user submit the form in offline mode.Before application is crash after putting this conditon crash was solve.
            if (obj.responseId == nil)
            {
                [dict setObject:[NSNull null] forKey:@"ResponseId"];
            }
            else
            {
                [dict setObject:obj.responseId forKey:@"ResponseId"];
            }
            [mutArrReq addObject:dict];
        }
        NSString *strIDKeyName, *strIsInProgress,*strWebServiceName = @"";
        if ([record.type isEqualToString:@"2"]) {
            strIDKeyName = @"FormId";
            strWebServiceName = FORM_HISTORY_POST;
            [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"SyncDoneForms"];

        }
        else {
            strIDKeyName = @"SurveyId";
            strWebServiceName = SURVEY_HISTORY_POST;
            [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"SyncDoneSurveys"];

        }
        strIsInProgress=record.isInProgressId;
        if ([strIsInProgress isEqualToString:@"1"]) {
        dictReq =  @{@"UserId":record.userId, strIDKeyName:record.typeId, @"Details":mutArrReq, @"ClientId":record.clientId,@"IsInProgress":@1,@"CurrentHistoryHeaderId":record.headerId};
        }
        else{
           dictReq =  @{@"UserId":record.userId, strIDKeyName:record.typeId, @"Details":mutArrReq, @"ClientId":record.clientId,@"IsInProgress":@0,@"CurrentHistoryHeaderId":record.headerId};
        }

        
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

-(BOOL)syncDailyLog{
    

  

    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"TeamLog"];
    NSPredicate *predicateOne = [NSPredicate predicateWithFormat:@"userId ==[cd] %@ AND shouldSync == 1",[[User currentUser]userId]];
    
    [request setPredicate:predicateOne];
    NSArray *aArrTeamLogOne = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    
//    NSPredicate *predicateTwo = [NSPredicate predicateWithFormat:@"userId ==[cd] %@ AND ANY teamSubLog.shouldSync == 1",[[User currentUser]userId]];
//    [request setPredicate:predicateTwo];
//    NSArray *aArrTeamLogTwo = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    
    __block BOOL isSingleDataSaved = NO;
    
    for (TeamLog *aTeamLogObj in aArrTeamLogOne) {
        
        isSingleDataSaved = NO;
        NSString *aParamDate = [gblAppDelegate getUTCDate:aTeamLogObj.date];
      
        NSDictionary *aDictParams = @{@"Id":@"0",
                                      @"FacilityId":aTeamLogObj.facilityId,
                                      @"PositionId":@"",
                                      @"IsTeamLog":[NSNumber numberWithBool:NO],
                                      @"IsAlwaysVisible":[NSNumber numberWithBool:NO],
                                      @"Date":aParamDate,
                                      @"UserId":[[User currentUser] userId],
                                      @"DailyLogDetails":@[
                                              @{@"Id":@"0",
                                                @"Date":aParamDate,
                                                @"Description":aTeamLogObj.desc,
                                                @"IncludeInEndOfDayReport":[NSNumber numberWithBool:NO],
                                                @"UserId":[[User currentUser]userId],
                                                @"UserName":aTeamLogObj.username
                                                }
                                              ]
                                      };
        [gblAppDelegate callWebService:TEAM_LOG parameters:aDictParams httpMethod:@"POST" complition:^(NSDictionary *response) {
            if ([response[@"Success"]boolValue]) {
                aTeamLogObj.shouldSync = [NSNumber numberWithBool:NO];
                aTeamLogObj.teamLogId = response[@"Id"];
                
                NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"TeamLogTrace"];
                [request setPredicate:[NSPredicate predicateWithFormat:@"userId==[cd]%@",[[User currentUser]userId]]];
                NSArray *aArrLogs = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
                TeamLogTrace *aTeamLogTraceObj;
                if (aArrLogs.count>0) {
                    aTeamLogTraceObj = aArrLogs[0];
                    
                }
                else
                    aTeamLogTraceObj = (TeamLogTrace *)[NSEntityDescription
                                                        insertNewObjectForEntityForName:@"TeamLogTrace" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                
                aTeamLogTraceObj.userId= aTeamLogObj.userId;
                aTeamLogTraceObj.byuserId = aTeamLogObj.userId;
                aTeamLogTraceObj.date = aTeamLogObj.date;
                aTeamLogTraceObj.teamLogId  = aTeamLogObj.teamLogId;
                [gblAppDelegate.managedObjectContext save:nil];

            }
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
    
    
    return isErrorOccurred;

    
}
- (BOOL)syncTeamLog
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"TeamLog"];
    NSPredicate *predicateOne = [NSPredicate predicateWithFormat:@"userId ==[cd] %@ AND shouldSync == 1",[[User currentUser]userId]];
    
    
    [request setPredicate:predicateOne];
    NSArray *aArrTeamLogOne = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    
    NSPredicate *predicateTwo = [NSPredicate predicateWithFormat:@"userId ==[cd] %@ AND ANY teamSubLog.shouldSync == 1",[[User currentUser]userId]];
    [request setPredicate:predicateTwo];
    NSArray *aArrTeamLogTwo = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];

    __block BOOL isSingleDataSaved = NO;

    for (TeamLog *aTeamLogObj in aArrTeamLogOne) {
        
         isSingleDataSaved = NO;
        NSString *aParamDate = [gblAppDelegate getUTCDate:aTeamLogObj.date];

        NSMutableDictionary *aMutDicParam = [NSMutableDictionary dictionary];
        NSMutableArray *aArrayTeamSubLog = [NSMutableArray array];
      
        aMutDicParam[@"FacilityId"] = aTeamLogObj.facilityId;
        aMutDicParam[@"PositionId"] = aTeamLogObj.positionId;
        if ([aTeamLogObj.isTeamLog isEqualToString:@"1"]) {
              aMutDicParam[@"IsTeamLog"] = [NSNumber numberWithBool:YES];
        }
        else{
              aMutDicParam[@"IsTeamLog"] = [NSNumber numberWithBool:NO];
        }
      
        aMutDicParam[@"IsAlwaysVisible"] = [NSNumber numberWithBool:NO];
        aMutDicParam[@"Date"] = aParamDate;
        aMutDicParam[@"UserId"] = aTeamLogObj.userId;

        [aArrayTeamSubLog addObject:@{@"Id":@"0",
                                     @"Date":aParamDate,
                                     @"Description":aTeamLogObj.desc,
                                     @"IncludeInEndOfDayReport":[NSNumber numberWithBool:NO],
                                     @"UserId":[[User currentUser]userId],
                                      @"UserName":aTeamLogObj.username

                                      }];
        NSNumber * isteamLog;
        
        if ([aTeamLogObj.isTeamLog isEqualToString:@"1"]) {
         isteamLog=[NSNumber numberWithBool:YES];
        }
        else{
            isteamLog=[NSNumber numberWithBool:NO];
        }
        
        NSDictionary *aDictParams = @{@"Id":@"0",
                                      @"FacilityId":aTeamLogObj.facilityId,
                                      @"PositionId":aTeamLogObj.positionId,
                                      @"IsTeamLog":isteamLog,
                                      @"IsAlwaysVisible":[NSNumber numberWithBool:NO],
                                      @"Date":aParamDate,
                                      @"UserId":aTeamLogObj.userId,
                                      @"DailyLogDetails":aArrayTeamSubLog
                                      };
        
        [gblAppDelegate callWebService:TEAM_LOG parameters:aDictParams httpMethod:@"POST" complition:^(NSDictionary *response) {
            if ([response[@"Success"]boolValue]) {
                aTeamLogObj.shouldSync = [NSNumber numberWithBool:NO];
                aTeamLogObj.teamLogId = response[@"Id"];
                
                NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"TeamLogTrace"];
                [request setPredicate:[NSPredicate predicateWithFormat:@"userId==[cd]%@",[[User currentUser]userId]]];
                NSArray *aArrLogs = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
                TeamLogTrace *aTeamLogTraceObj;
                if (aArrLogs.count>0) {
                    aTeamLogTraceObj = aArrLogs[0];
                   
                }
                else
                    aTeamLogTraceObj = (TeamLogTrace *)[NSEntityDescription
                                                        insertNewObjectForEntityForName:@"TeamLogTrace" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                
                aTeamLogTraceObj.userId= aTeamLogObj.userId;
                aTeamLogTraceObj.byuserId = aTeamLogObj.userId;
                aTeamLogTraceObj.date = aTeamLogObj.date;
                aTeamLogTraceObj.teamLogId  = aTeamLogObj.teamLogId;
                [gblAppDelegate.managedObjectContext save:nil];
                
            }
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
    
    for (TeamLog *aTeamLogObj in aArrTeamLogTwo) {
        
        isSingleDataSaved = NO;
        
        for (TeamSubLog *aTeamSubLogObj  in aTeamLogObj.teamSubLog.allObjects)
        {
            if (aTeamSubLogObj.shouldSync.integerValue==1) {
                NSMutableDictionary *aMutDict = [NSMutableDictionary dictionary];
                
                NSString *aParamDateLog = [gblAppDelegate getUTCDate:aTeamSubLogObj.date];
                
                
                aMutDict[@"Id"] = @"0";
                aMutDict[@"Date"] = aParamDateLog;
                aMutDict[@"Description"]=aTeamSubLogObj.desc;
                aMutDict[@"FacilityId"] = aTeamLogObj.facilityId;
                aMutDict[@"PositionId"] = aTeamLogObj.positionId;
                aMutDict[@"UserId"] = aTeamLogObj.userId;
                aMutDict[@"IsAlwaysVisible"] = [NSNumber numberWithBool:NO];
                aMutDict[@"DailyLogHeaderId"] = aTeamLogObj.teamLogId;
                aMutDict[@"UserName"] = aTeamLogObj.username;

                [gblAppDelegate callWebService:POSTCOMMENTS parameters:aMutDict httpMethod:@"POST" complition:^(NSDictionary *response) {
                    
                    if ([response[@"Success"]boolValue]) {
                        aTeamSubLogObj.shouldSync = [NSNumber numberWithBool:NO];
                        [gblAppDelegate.managedObjectContext save:nil];
                    }
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
        }
    }
    
    return isErrorOccurred;
}
#pragma - mark UpdateMemo

-(void)callWebserviceToUpdateCountOnDashboard
{

    
    [[WebSerivceCall webServiceObject]callServiceForDashboardCount:NO  complition:^(NSDictionary *aDict){

  //  intUnreadMemoCount=[[[NSUserDefaults standardUserDefaults] valueForKey:@"MemoToalCount"]integerValue];
    self.intUnreadLogCount = [[[NSUserDefaults standardUserDefaults] valueForKey:@"TeamLogCount"]integerValue];
    self.intFormInProgressCount = [[[NSUserDefaults standardUserDefaults] valueForKey:@"FormToalCount"]integerValue];
    self.intSurveyInProgressCount = [[[NSUserDefaults standardUserDefaults] valueForKey:@"SurveyToalCount"]integerValue];
        NSLog(@"%ld",[[[NSUserDefaults standardUserDefaults] valueForKey:@"TaskToalCount"]integerValue]);
    self.intTaskCount = [[[NSUserDefaults standardUserDefaults] valueForKey:@"TaskToalCount"]integerValue];
        if (self.intUnreadLogCount>0) {
            self.boolUpdateTeamLog  = YES;
        }
        if (self.intFormInProgressCount>0) {
            self.boolUpdateFormInProgress  = YES;
        }
        if (self.intSurveyInProgressCount>0) {
            self.boolUpdateSurveyInProgress  = YES;
        }

        if (self.allowMemoWSCall) {
            
            [self.cvMenuGrid reloadData];

        }
        
        
      
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(120.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.allowMemoWSCall) {
//                    [[WebSerivceCall webServiceObject]callServiceForDashboardCount:NO  complition:^(NSDictionary *aDict){
//                    }];
                [self callWebserviceToUpdateCountOnDashboard];
                 }
            });
    
    }];
    
    
    
    
    
  
}

#pragma - mark UpdateMemo

-(void)callWebserviceToUpdateMemo
{
    [[WebSerivceCall webServiceObject]callServiceForMemos:NO complition:^{
        
        intUnreadMemoCount = [[gblAppDelegate.mutArrMemoList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IsRead == 0"]] count];
        [self.cvMenuGrid reloadData];
     //   NSLog(@"MemoUpdated");
        if (self.allowMemoWSCall) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self callWebserviceToUpdateMemo];
         //       [self callWebserviceToUpdateTeamLog];
                
            });
        }
        
    }];
    
}


-(void)callWebserviceForMissedTaskNotification
{
    //HomeScreenModules?userId=5797&clientId=148
    
    
[gblAppDelegate callAsynchronousWebService:[NSString stringWithFormat:@"HomeScreenModules?userId=%@&clientId=%@",[[User currentUser]userId],[[User currentUser] clientId]] parameters:nil httpMethod:@"POST" complition:^(NSDictionary *response) {
    
} failure:^(NSError *error, NSDictionary *response) {
    
   // [self callWebserviceForMissedTaskNotification];
    
}];
  

}

#pragma - mark UpdateMemo

-(void)callWebserviceToUpdateTeamLog
{
    [[WebSerivceCall webServiceObject]callServiceForTeamLogInBackground:NO complition:^(NSDictionary *aDict){
        
    //    NSLog(@"%@",aDict);
        self.intUnreadLogCount = [[aDict valueForKey:@"TeamLogCount"]integerValue];
        self.intFormInProgressCount = [[aDict valueForKey:@"TeamLogCount"]integerValue];
        self.intSurveyInProgressCount = [[aDict valueForKey:@"TeamLogCount"]integerValue];
        if (self.intUnreadLogCount>0) {
            self.boolUpdateTeamLog  = YES;
        }
        if (self.intFormInProgressCount>0) {
            self.boolUpdateFormInProgress  = YES;
        }
        if (self.intSurveyInProgressCount>0) {
            self.boolUpdateSurveyInProgress  = YES;
        }
        [self.cvMenuGrid reloadData];
        
     //   NSLog(@"Team Log Updated");
        
        
    }];
}



@end
