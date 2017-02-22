//
//  ViewController.m
//  GoBoardPro
//
//  Created by ind558 on 22/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "LoginViewController.h"
#import "GuestFormViewController.h"
#import "DailyLog.h"
#import "Reachability.h"
#import <Raygun4iOS/Raygun.h>
@interface LoginViewController ()

@end

@implementation LoginViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lblGuestFormCount.hidden=YES;
    _lblGuestSurveyCount.hidden=YES;
    _lblGuestSugessionCount.hidden=YES;

    _lblGuestFormCount.layer.cornerRadius=5.0;
    _lblGuestFormCount.layer.borderWidth=1.0;
    _lblGuestFormCount.layer.borderColor=[UIColor whiteColor].CGColor;
    _lblGuestFormCount.layer.masksToBounds=YES;

    _lblGuestSurveyCount.layer.cornerRadius=5.0;
    _lblGuestSurveyCount.layer.borderWidth=1.0;
    _lblGuestSurveyCount.layer.borderColor=[UIColor whiteColor].CGColor;
    _lblGuestSurveyCount.layer.masksToBounds=YES;

    _lblGuestSugessionCount.layer.cornerRadius=5.0;
    _lblGuestSugessionCount.layer.borderWidth=1.0;
    _lblGuestSugessionCount.layer.borderColor=[UIColor whiteColor].CGColor;
    _lblGuestSugessionCount.layer.masksToBounds=YES;
    
     [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"backFromGuestUserListView"];
    
    _txtGuestName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientName"];
    [_lblVersionNumber setText:[NSString stringWithFormat:@"v%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(defaultsSettingsChanged) name:NSUserDefaultsDidChangeNotification object:nil];
    [self initialUIConfig];
    gblAppDelegate.shouldHideActivityIndicator = NO;
    [self checkAppVersions];
    gblAppDelegate.shouldHideActivityIndicator = YES;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _txtUserId.text = @"";
    _txtPassword.text = @"";
    gblAppDelegate.mutArrMemoList = nil;
    gblAppDelegate.mutArrHomeMenus = nil;
    [User destroyCurrentUser];
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"backFromGuestUserListView"] isEqualToString:@"YES"]) {
         [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"backFromGuestUserListView"];
    
            [self btnGuestSignInTapped:_btnUserSignIn];
       
    }
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [_txtUserId resignFirstResponder];
    [_txtPassword resignFirstResponder];
    GuestFormViewController *guestForm = (GuestFormViewController*)[segue destinationViewController];
    if ([[segue identifier] isEqualToString:@"takeASurvey"]) {
        guestForm.guestFormType = 1;
    }
    else if ([[segue identifier] isEqualToString:@"makeSuggestion"]) {
        guestForm.guestFormType = 3;
    }
    else if ([[segue identifier] isEqualToString:@"completeForm"]) {
        guestForm.guestFormType = 2;
    }
}

#pragma mark - IBActions & Selectors

- (IBAction)btnGuestSignInTapped:(UIButton *)sender {
    
    [self callServiceForGuestUserDashboardCount:YES complition:^(NSDictionary * aDict){
        if ([[aDict objectForKey:@"Success"] boolValue]) {
            NSString * strFormCount=[NSString stringWithFormat:@"%@",[[aDict valueForKey:@"DashboardCount"] valueForKey:@"FormInprogressCount"]];
                NSString * strSurveyCount=[NSString stringWithFormat:@"%@",[[aDict valueForKey:@"DashboardCount"] valueForKey:@"SurveyInprogressCount"]];
                NSString * strSugessionCount=[NSString stringWithFormat:@"%@",[[aDict valueForKey:@"DashboardCount"] valueForKey:@"SuggestionInprogressCount"]];
            if (![strSurveyCount isEqualToString:@"0"]) {
                _lblGuestSurveyCount.hidden=NO;
                _lblGuestSurveyCount.text=strSurveyCount;
            }
            else
            {
                _lblGuestSurveyCount.hidden=YES;
                
            }
            if (![strFormCount isEqualToString:@"0"]) {
                _lblGuestFormCount.hidden=NO;
                _lblGuestFormCount.text=strFormCount;
                
                
            }
            else
            {
                _lblGuestFormCount.hidden=YES;
                
            }
            if (![strSugessionCount isEqualToString:@"0"]) {
                _lblGuestSugessionCount.hidden=NO;
                _lblGuestSugessionCount.text=strSugessionCount;
                
                
            }
            else
            {
                _lblGuestSugessionCount.hidden=YES;
                
            }

        }
        
    }];

    
    
    if (![sender isSelected]) {
        [sender setSelected:YES];
        [_btnUserSignIn setSelected:NO];
        [_imvGuestIndicator setHidden:NO];
        [_imvUserIndicator setHidden:YES];
        [_vwUserSignIn setHidden:YES];
        [_vwGuestSignIn setHidden:NO];
        
        [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"isGuest"];
    }
}

- (IBAction)btnUserSignInTapped:(UIButton*)sender {
    

    
    
    
    if (![sender isSelected]) {
        [sender setSelected:YES];
        [_btnGuestSignIn setSelected:NO];
        [_imvUserIndicator setHidden:NO];
        [_imvGuestIndicator setHidden:YES];
        [_vwGuestSignIn setHidden:YES];
        [_vwUserSignIn setHidden:NO];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isGuest"];
    }
}
#pragma mark Reachability

- (BOOL)isNetworkReachable {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];//[Reachability reachabilityWithHostName:@"http://www.google.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if (remoteHostStatus == NotReachable) {
        return NO;
    }
    return YES;
}

#pragma mark - GuestUserDashboard Count

-(void)callServiceForGuestUserDashboardCount:(BOOL)waitUntilDone complition:(void(^)(NSDictionary * aDict))complition
{
    __block BOOL isWSComplete = NO;
    
    NSMutableArray *arrOfPosition = [NSMutableArray new];
    
    // NSString *aStrFacilityID = [[User currentUser]selectedFacility].value;
    
    // NSString *aStrUserID = [[User currentUser]userId];
    
    NSMutableArray *arr=  [[User currentUser]mutArrSelectedPositions];
    
    //  NSString *aStrClientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
    
    NSString * isAdmin;
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"IsAdmin"] integerValue] == 0) {
        isAdmin= @"False";
    }
    else{
        isAdmin= @"True";
    }
    
    for (UserPosition *p in arr) {
        
        [arrOfPosition addObject:p.value];
    }
    //  int clientId, int? userId, int facilityId,  string positionIds,bool isAdmin
    NSString *strUrl =[NSString stringWithFormat:@"HomeScreenModules?clientId=%@&userId=%@&facilityId=0&positionIds=0&isAdmin=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"],[[User currentUser]userId],isAdmin];
    
    
    
    [gblAppDelegate callWebService:strUrl parameters:nil httpMethod:@"GET" complition:^(NSDictionary *response) {
        
        
//        [[NSUserDefaults standardUserDefaults]setInteger:[[[response valueForKey:@"DashboardCount"] valueForKey:@"FormInprogressCount"]integerValue] forKey:@"GuestFormToalCount"];
//        [[NSUserDefaults standardUserDefaults]setInteger:[[[response valueForKey:@"DashboardCount"] valueForKey:@"SurveyInprogressCount"]integerValue] forKey:@"GuestSurveyToalCount"];
//        [ [NSUserDefaults standardUserDefaults]setInteger:[[[response valueForKey:@"DashboardCount"] valueForKey:@"TeamLogCount"]integerValue] forKey:@"GuestSurveyToalCount"];
        
        
        isWSComplete = YES;
        if (complition)
            complition(response);
    } failure:^(NSError *error, NSDictionary *response) {
        isWSComplete = YES;
        if (complition)
            complition(response);
        
    }];
    if (waitUntilDone) {
        while (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
    
    
}
- (IBAction)btnSignInTapped:(id)sender {
    _btnSignInTapped.userInteractionEnabled=NO;
    if ([_txtUserId isTextFieldBlank]) {
        alert(@"Login", @"Please enter a Username");
        return;
    }
    else if ([_txtPassword isTextFieldBlank]) {
        alert(@"Login", @"Please enter a Password");
        return;
    }
    else if (![_txtPassword.text isValidPassword]) {
        alert(@"Login", @"Password must be between 8-16 characters with the use of both upper- and lower-case letters (case sensitivity) and inclusion of one or more numerical digits");
        return;
    }
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?userName=%@&password=%@",USER_LOGIN,_txtUserId.trimText, _txtPassword.text] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:USER_LOGIN] complition:^(NSDictionary *response) {
        _btnSignInTapped.userInteractionEnabled=YES;

        User *currentUser = [User currentUser];
        currentUser.firstName = nil;
        currentUser.lastName = nil;
        currentUser.middleInitials = nil;
        currentUser.email = nil;
        currentUser.phone = nil;
        currentUser.mobile = nil;
        currentUser.userId = nil;
        currentUser.clientId = nil;
        currentUser.clientName = nil;
        currentUser.termsAndConditions = nil;
        currentUser.selectedFacility = nil;
        currentUser.username = nil;
        
        currentUser.username = self.txtUserId.text;
       
        currentUser.firstName = [response objectForKey:@"FirstName"];
        if ([[response objectForKey:@"MiddleInitial"] isKindOfClass:[NSNull class]]) {
            currentUser.middleInitials = @"";
        }
        else {
            currentUser.middleInitials = [response objectForKey:@"MiddleInitial"];
        }
        currentUser.termsAndConditions = [response objectForKey:@"TermsAndConditions"];
        currentUser.isAcceptedTermsAndConditions = [[response objectForKey:@"AcceptedTermsAndConditions"] boolValue];
        currentUser.lastName = [response objectForKey:@"LastName"];
        if ([[response objectForKey:@"Mobile"] isKindOfClass:[NSNull class]]) {
            currentUser.mobile = @"";
        }
        else {
            currentUser.mobile = [response objectForKey:@"Mobile"];
        }
        if ([[response objectForKey:@"Phone"] isKindOfClass:[NSNull class]]) {
            currentUser.phone = @"";
        }
        else {
            currentUser.phone = [response objectForKey:@"Phone"];
        }
        currentUser.email = [response objectForKey:@"Email"];
        
        currentUser.clientName = [response objectForKey:@"ClientName"];
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"oldeClient"] isEqualToString:[response objectForKey:@"ClientName"]]) {
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isFirstTimeDataSurveyDone"] isEqualToString:@"YES"]){
                
                [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"isSameClientSurvey"];

            }
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isFirstTimeDataFormDone"] isEqualToString:@"YES"]){
                
                [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"isSameClientForm"];

            }


        }
        else{
            [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"isFirstTimeDataSurveyDone"];
            [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"isFirstTimeDataFormDone"];

                  [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"isSameClientForm"];
                  [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"isSameClientSurvey"];
          
        }
        [[NSUserDefaults standardUserDefaults]setValue:[response objectForKey:@"IsAdmin"] forKey:@"IsAdmin"];

        [[NSUserDefaults standardUserDefaults]setValue:currentUser.clientName forKey:@"oldeClient"];
        
        currentUser.userId = [NSString stringWithFormat:@"%ld",(long)[[response objectForKey:@"Id"] integerValue]];
        currentUser.clientId = [NSString stringWithFormat:@"%ld",(long)[[response objectForKey:@"ClientId"] integerValue]];
        currentUser.isAdmin = [[response objectForKey:@"IsAdmin"] boolValue];
        NSString *prevUserId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        if (prevUserId) {
            if (![prevUserId isEqualToString:currentUser.userId]) {
                [self deleteAllDailyLogData];
            }
        }

        [[Raygun sharedReporter] identify:[NSString stringWithFormat:@"%@ %@",[User currentUser].firstName , [User currentUser].lastName]];
        
        [[NSUserDefaults standardUserDefaults] setObject:currentUser.userId forKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] setObject:currentUser.clientId forKey:@"clientId"];
        [[NSUserDefaults standardUserDefaults] setObject:currentUser.clientName forKey:@"clientName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        _txtGuestName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientName"];

//            if (currentUser.isAdmin) {
//                [self performSegueWithIdentifier:@"loginToHome" sender:nil];
//            }
//            else {
                [self performSegueWithIdentifier:@"loginToWelcome" sender:nil];
//            }
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    } failure:^(NSError *error, NSDictionary *response) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        alert(@"", [response objectForKeyedSubscript:@"ErrorMessage"]);
        _btnSignInTapped.userInteractionEnabled=YES;

    }];
}

- (void)deleteAllDailyLogData {
    NSFetchRequest * allRecords = [[NSFetchRequest alloc] init];
    [allRecords setEntity:[NSEntityDescription entityForName:@"DailyLog" inManagedObjectContext:gblAppDelegate.managedObjectContext]];
    [allRecords setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSError * error = nil;
    NSArray * records = [gblAppDelegate.managedObjectContext executeFetchRequest:allRecords error:&error];
    //error handling goes here
    for (NSManagedObject * rec in records) {
        [gblAppDelegate.managedObjectContext deleteObject:rec];
    }
    NSError *saveError = nil;
    [gblAppDelegate.managedObjectContext save:&saveError];
}

- (IBAction)btnForgotPasswordTapped:(id)sender {
}

- (IBAction)btnSignUpTapped:(id)sender {
}
- (IBAction)btnTakeASurveyTapped:(id)sender {
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"isSurvey"];
    [[NSUserDefaults standardUserDefaults]setObject:@"no" forKey:@"isForm"];
    [[NSUserDefaults standardUserDefaults]setObject:@"no" forKey:@"isSuggestion"];

}

- (IBAction)btnMakeASuggestionTapped:(id)sender {
    [[NSUserDefaults standardUserDefaults]setObject:@"no" forKey:@"isSurvey"];
    [[NSUserDefaults standardUserDefaults]setObject:@"no" forKey:@"isForm"];
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"isSuggestion"];

    [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"fromSuveyViewC"];
    [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"fromInProgress"];
    [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"fromSugestionViewC"];
    
}

- (IBAction)btnCompleteAFormTapped:(id)sender {
    [[NSUserDefaults standardUserDefaults]setObject:@"no" forKey:@"isSurvey"];
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"isForm"];
    [[NSUserDefaults standardUserDefaults]setObject:@"no" forKey:@"isSuggestion"];

}

- (IBAction)unwindBackToLoginScreen:(UIStoryboardSegue*)segue {
    
}

#pragma mark - Methods

// Delete all records from all tables in database.
- (void)resetLocalDatabaseForNewUser {
    NSError * error;
    NSURL * storeURL = [[gblAppDelegate.managedObjectContext persistentStoreCoordinator] URLForPersistentStore:[[[gblAppDelegate.managedObjectContext persistentStoreCoordinator] persistentStores] lastObject]];
    [gblAppDelegate.managedObjectContext lock];
    [gblAppDelegate.managedObjectContext reset];//to drop pending changes
    //delete the store from the current managedObjectContext
    if ([[gblAppDelegate.managedObjectContext persistentStoreCoordinator] removePersistentStore: [[[gblAppDelegate.managedObjectContext persistentStoreCoordinator] persistentStores] lastObject] error:&error])
    {
        // remove the file containing the data
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
        //recreate the store like in the  appDelegate method
        [[[gblAppDelegate managedObjectContext] persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options: @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error];
    }    
    [gblAppDelegate.managedObjectContext unlock];
}

- (void)initialUIConfig {
    [_btnGuestSignIn setSelected:NO];
    [_imvGuestIndicator setHidden:YES];
    [_vwGuestSignIn setHidden:YES];
    [_btnUserSignIn setSelected:YES];
    [_imvUserIndicator setHidden:NO];
    [_vwUserSignIn setHidden:NO];
}

-(void)checkAppVersions
{
    
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@",APPVERSION] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:APPVERSION] complition:^(NSDictionary *response)
    {
        
        NSArray *arryCurrentVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] componentsSeparatedByString:@"."];
        NSArray *arryNewVersion = [[response objectForKey:@"Version"] componentsSeparatedByString:@"."];
        
        NSMutableString *mutbStr = [[NSMutableString alloc]init];
        
        for (NSString *str in arryCurrentVersion){
            [mutbStr appendString:str];
        }
        
        NSInteger currentVersion = [mutbStr integerValue];
        
        mutbStr = [[NSMutableString alloc]init];
        
        for (NSString *str in arryNewVersion){
            [mutbStr appendString:str];
        }
        
        NSInteger newVersion = [mutbStr integerValue];
        
        
        if ( currentVersion < newVersion){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:MSG_NEWVERSION delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
            alert.delegate = self;
            [alert show];
        }
    
    } failure:^(NSError *error, NSDictionary *response) {
    }];
    
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:_txtGuestName]) {
        [textField resignFirstResponder];
    }
    else if ([textField isEqual:_txtUserId]) {
        [_txtPassword becomeFirstResponder];
    }
    else {
        [self btnSignInTapped:nil];
    }
    
    return YES;
}


- (void)defaultsSettingsChanged {
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:@"SettingsIsProduction"];
    if (value != gblAppDelegate.isProduction) {
        gblAppDelegate.isProduction = value;
        [self.navigationController popToViewController:self animated:YES];
    }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NSURL *aAppUrl = [NSURL URLWithString:ITUENS_APPLINK];
        
        if ([[UIApplication sharedApplication] canOpenURL:aAppUrl])
        {
            [[UIApplication sharedApplication] openURL:aAppUrl];
        }
    }
}

@end
