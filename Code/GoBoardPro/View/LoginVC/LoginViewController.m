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

@interface LoginViewController ()

@end

@implementation LoginViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    _txtGuestName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientName"];
    
    [_lblVersionNumber setText:[NSString stringWithFormat:@"v%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    [self initialUIConfig];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _txtUserId.text = @"";
    _txtPassword.text = @"";
    [User destroyCurrentUser];
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
    if (![sender isSelected]) {
        [sender setSelected:YES];
        [_btnUserSignIn setSelected:NO];
        [_imvGuestIndicator setHidden:NO];
        [_imvUserIndicator setHidden:YES];
        [_vwUserSignIn setHidden:YES];
        [_vwGuestSignIn setHidden:NO];
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
    }
}

- (IBAction)btnSignInTapped:(id)sender {
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
        
        User *currentUser = [User currentUser];
        currentUser.firstName = [response objectForKey:@"FirstName"];
        currentUser.middleInitials = [response objectForKey:@"MiddleInitial"];
        currentUser.lastName = [response objectForKey:@"LastName"];
        currentUser.mobile = [response objectForKey:@"Mobile"];
        currentUser.phone = [response objectForKey:@"Phone"];
        currentUser.Email = [response objectForKey:@"Email"];
        currentUser.clientName = [response objectForKey:@"ClientName"];
        currentUser.userId = [NSString stringWithFormat:@"%ld",(long)[[response objectForKey:@"Id"] integerValue]];
        currentUser.clientId = [NSString stringWithFormat:@"%ld",(long)[[response objectForKey:@"ClientId"] integerValue]];
        currentUser.isAdmin = [[response objectForKey:@"IsAdmin"] boolValue];
        NSString *prevUserId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        if (prevUserId) {
            if (![prevUserId isEqualToString:currentUser.userId]) {
                [self deleteAllDailyLogData];
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:currentUser.userId forKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] setObject:currentUser.clientId forKey:@"clientId"];
        [[NSUserDefaults standardUserDefaults] setObject:currentUser.clientName forKey:@"clientName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
//            if (currentUser.isAdmin) {
//                [self performSegueWithIdentifier:@"loginToHome" sender:nil];
//            }
//            else {
                [self performSegueWithIdentifier:@"loginToWelcome" sender:nil];
//            }
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    } failure:^(NSError *error, NSDictionary *response) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
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
}

- (IBAction)btnMakeASuggestionTapped:(id)sender {
}

- (IBAction)btnCompleteAFormTapped:(id)sender {
}

- (IBAction)unwindBackToLoginScreen:(UIStoryboardSegue*)segue {
    
}

#pragma mark - Methods

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

#pragma mark - UITextField Delegate

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



@end
