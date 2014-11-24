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

@end
