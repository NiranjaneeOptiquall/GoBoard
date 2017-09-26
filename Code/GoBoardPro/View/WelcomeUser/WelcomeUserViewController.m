//
//  WelcomeUserViewController.m
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "WelcomeUserViewController.h"
#import "MyApplication.h"
#import "LoginViewController.h"

@interface WelcomeUserViewController ()
{
    int serviceCallCount;
    MyApplication *app;
    BOOL islogedout;
}
@end

@implementation WelcomeUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    flag = @"FirstTime";
    aryLocation  = [[NSMutableArray alloc]init];
    aryPositionId = [[NSMutableArray alloc]init];
    serviceCallCount=2;
   //    [_lblUserName setText:[NSString stringWithFormat:@"Welcome %@ %@", [[User currentUser] firstName], [[User currentUser] lastName]]];
    islogedout = false;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DataUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetTimeInterval:)
                                                 name:@"updateAtFacility"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUpdatedData:)
                                                 name:@"DataUpdated"
                                               object:nil];
    [_txtLocation setEnabled:NO];
    [_txtPosition setEnabled:NO];
    [self getUserFacilities];
    [self.lblVersion setText:[NSString stringWithFormat:@"v%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];

    // Do any additional setup after loading the view.
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DataUpdated" object:nil];
}
-(void)handleUpdatedData:(NSNotification *)notification {
    
    [self automaticLogout];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self resetTimer];
    NSLog(@"%@",[[User currentUser] userStatusCheck]);
    
    if (![[User currentUser] isAcceptedTermsAndConditions]) {
        [_lblAcceptTerms setHidden:NO];
        [_vwFacility setHidden:YES];
    }
    else if (![[[User currentUser] userStatusCheck] isEqualToString:@"Active"]){
        [_lblAcceptTerms setHidden:NO];
        [_vwFacility setHidden:YES];
    }
    else {
        [_lblAcceptTerms setHidden:YES];
        [_vwFacility setHidden:NO];
    }

    
      [_lblUserName setText:[NSString stringWithFormat:@"Welcome %@ %@", [[User currentUser] firstName], [[User currentUser] lastName]]];
}
-(void)resetTimeInterval:(NSNotification *)notification {
    
    [self resetTimer];
    
}
-(void)resetTimer{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"istouch"]isEqualToString:@"no"] || [[[NSUserDefaults standardUserDefaults]valueForKey:@"istouch"]isEqualToString:@"yes"]) {
        if (self.idleTimer) {
            [self.idleTimer invalidate];
        }
        NSTimeInterval timeInterval = [[[User currentUser]AutomaticLogoutTime] doubleValue]*60;
        //NSTimeInterval timeInterval = 30;
        if (timeInterval > 0) {
            self.idleTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(idleTimerExceeded) userInfo:nil repeats:NO] ;
        }
    }
}
- (void)idleTimerExceeded {
    [self webserviceCallForUserLogOff];

    [self automaticLogout];
}
-(void)automaticLogout{
    
    if (!islogedout) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Alert"
                                      message:@"You have been logged out due to inactivity. Please login again."
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
                                 LoginViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"reload"
                                                                                     object:self];
                                 islogedout = true;
                                 [self.navigationController pushViewController:loginView animated:NO];
                                 
                             }];
        
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)btnBack:(UIButton *)sender {
    [self webserviceCallForUserLogOff];
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

#pragma mark - IBActions

- (IBAction)btnSubmitTapped:(id)sender {
   // [[NSUserDefaults standardUserDefaults] setObject:_txtFacility.text forKey:@"facilityId"];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"facilityId"]);
    if ([_txtFacility isTextFieldBlank] || [[[User currentUser] mutArrSelectedLocations] count] == 0 || [[[User currentUser] mutArrSelectedPositions] count] == 0) {
        alert(@"", MSG_REQUIRED_FIELDS);
        return;
    }
    [[User currentUser] setSelectedFacility:selectedFacility];    
    [gblAppDelegate showActivityIndicator];
    gblAppDelegate.shouldHideActivityIndicator = NO;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    UIButton * btnSubmit = [[UIButton alloc]init];
    btnSubmit.selected = NO;
    [[WebSerivceCall webServiceObject] getAllData];

    NSMutableArray*moduleArr = [NSMutableArray new];
    for (NSDictionary * tempDic in gblAppDelegate.mutArrHomeMenus) {
        if (([tempDic[@"IsActive"] boolValue] && [tempDic[@"IsAccessAllowed"] boolValue])) {
            [moduleArr addObject:tempDic];
        }
    }
    NSLog(@"%@",moduleArr);
    if (moduleArr.count == 0) {
   
    alert(@"", @"We’re sorry. You do not have permission to access this area. Please see your system administrator.");
      
          }
    else{
        [self performSegueWithIdentifier:@"welcomeToUserHome" sender:nil];
   }

 
}

- (IBAction)btnUpdateProfileTapped:(id)sender {
}

#pragma mark - Methods

- (void)getUserFacilities {
    if ([gblAppDelegate isNetworkReachable]) {
        [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@",USER_FACILITY, [[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:USER_FACILITY] complition:^(NSDictionary *response) {
             NSLog(@"%@",response);
            [self deleteAllFacilities];
           
            NSArray *aryFacility = [response objectForKey:@"Facilities"];

            
            for (NSDictionary *aDict in aryFacility) {
                UserFacility *facility = [NSEntityDescription insertNewObjectForEntityForName:@"UserFacility" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                facility.name = [aDict objectForKey:@"Name"];
                facility.value = [NSString stringWithFormat:@"%ld", (long)[[aDict objectForKey:@"Id"] integerValue]];
                
                
                NSMutableSet *locations = [NSMutableSet set];
                for (NSDictionary *aDictLoc in [aDict objectForKey:@"Locations"]) {
                    UserLocation1 *location = [NSEntityDescription insertNewObjectForEntityForName:@"UserLocation1" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                    location.name = [aDictLoc objectForKey:@"Name"];
                    location.value = [NSString stringWithFormat:@"%ld", (long)[[aDictLoc objectForKey:@"Id"] integerValue]];
                    location.facility = facility;
                    [locations addObject:location];
                }
                facility.locations1 = locations;
                
                
                NSMutableSet *positions = [NSMutableSet set];
                for (NSDictionary *aDictPos in [aDict objectForKey:@"Positions"]) {
                    UserPosition *position = [NSEntityDescription insertNewObjectForEntityForName:@"UserPosition" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                    position.name = [aDictPos objectForKey:@"Name"];
                    position.value = [NSString stringWithFormat:@"%ld", (long)[[aDictPos objectForKey:@"Id"] integerValue]];
                    NSLog(@"%@",position.value);
                NSMutableSet *locations = [NSMutableSet set];
             
                    for (NSDictionary *aDictLoc in [aDictPos objectForKey:@"Locations"]) {
                    UserLocation *location = [NSEntityDescription insertNewObjectForEntityForName:@"UserLocation" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                    location.name = [aDictLoc objectForKey:@"Name"];
                    location.value = [NSString stringWithFormat:@"%ld", (long)[[aDictLoc objectForKey:@"Id"] integerValue]];
                    location.position = position;
                    [locations addObject:location];
                }
                    position.locations = locations;
                    position.facility = facility;
                    [positions addObject:position];
                }
                facility.positions = positions;
                [gblAppDelegate.managedObjectContext insertObject:facility];
                
            }
            NSError *error = nil;
            if (![gblAppDelegate.managedObjectContext save:&error]) {
                
            }
            else {
                [self fetchFacilities];
            }
            
        } failure:^(NSError *error, NSDictionary *response) {
            if (serviceCallCount == 0) {
                NSLog(@"%d",serviceCallCount);
            }else{
                serviceCallCount=serviceCallCount-1;
                     [self getUserFacilities];
            }
       
            
        }];
    }
    else {
        
        if (serviceCallCount == 0) {
            NSLog(@"%d",serviceCallCount);

        }else{
            serviceCallCount=serviceCallCount-1;
            [self getUserFacilities];
        }
    }
}

- (void)deleteAllFacilities {
    NSFetchRequest * allFacilities = [[NSFetchRequest alloc] init];
    [allFacilities setEntity:[NSEntityDescription entityForName:@"UserFacility" inManagedObjectContext:gblAppDelegate.managedObjectContext]];
    [allFacilities setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSError * error = nil;
    NSArray * facility = [gblAppDelegate.managedObjectContext executeFetchRequest:allFacilities error:&error];
    //error handling goes here
    for (NSManagedObject * fac in facility) {
        [gblAppDelegate.managedObjectContext deleteObject:fac];
    }
    NSError *saveError = nil;
    [gblAppDelegate.managedObjectContext save:&saveError];
}

- (void)fetchFacilities {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UserFacility"];
    [request setPropertiesToFetch:@[@"name", @"value"]];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [request setSortDescriptors:@[sortByName]];
     aryFacilities = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    
   /* if ([aryFacilities count]>0)
    {
        selectedFacility = [aryFacilities objectAtIndex:0];
        _txtFacility.text=selectedFacility.name;
        [[[User currentUser] mutArrSelectedPositions] removeAllObjects];
        [[[User currentUser] mutArrSelectedLocations] removeAllObjects];
        [self fetchPositionAndLocation];
        if ([aryLocation count]>0)
        {
            NSManagedObject *object=[aryLocation objectAtIndex:0];
            [[[User currentUser] mutArrSelectedLocations] addObject:object];
        }
        [_tblLocation reloadData];
        [_tblPosition reloadData];
    }*/
    
}

- (void)fetchPositionAndLocation {
//    NSFetchRequest *requestLoc = [[NSFetchRequest alloc] initWithEntityName:@"UserLocation"];
//    
//    NSPredicate *predicateLoc = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"facility.value", selectedFacility.value];
//    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"facilityId"]);
//    [requestLoc setPredicate:predicateLoc];
//    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
//    [requestLoc setSortDescriptors:@[sortByName]];
//    [requestLoc setPropertiesToFetch:@[@"name", @"value"]];
//    aryLocation = [gblAppDelegate.managedObjectContext executeFetchRequest:requestLoc error:nil];
//    requestLoc = nil;
    
    aryLocation  = [[NSMutableArray alloc]init];
    [[NSUserDefaults standardUserDefaults] setObject:selectedFacility.value forKey:@"facilityId"];

    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];

    NSFetchRequest *requestPos = [[NSFetchRequest alloc] initWithEntityName:@"UserPosition"];
    NSPredicate *predicatePos = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"facility.value", selectedFacility.value];
    [requestPos setPredicate:predicatePos];
    [requestPos setSortDescriptors:@[sortByName]];
    [requestPos setPropertiesToFetch:@[@"name", @"value"]];
    aryPositions = [gblAppDelegate.managedObjectContext executeFetchRequest:requestPos error:nil];
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if ([tableView isEqual:_tblLocation]) {
        rows = [aryLocation count];
    }
    else {
        rows = [aryPositions count];
    }
    return rows;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSManagedObject *obj = nil;
    UIImageView *imgView = (UIImageView*)[aCell.contentView viewWithTag:2];
    UILabel *aLblName = (UILabel*)[aCell.contentView viewWithTag:3];
    if ([tableView isEqual:_tblLocation]) {
        obj = [aryLocation objectAtIndex:indexPath.row];
        if ([[[User currentUser] mutArrSelectedLocations] containsObject:obj]) {
            [imgView setImage:[UIImage imageNamed:@"selected_check_box.png"]];
        }
        else {
            [imgView setImage:[UIImage imageNamed:@"check_box.png"]];
        }
    }
    else {
        obj = [aryPositions objectAtIndex:indexPath.row];
        if ([[[User currentUser] mutArrSelectedPositions] containsObject:obj]) {
            [imgView setImage:[UIImage imageNamed:@"selected_check_box.png"]];
        }
        else {
            [imgView setImage:[UIImage imageNamed:@"check_box.png"]];
            
        }
    }
    
    aLblName.text = [obj valueForKey:@"name"];
    [aCell setBackgroundColor:[UIColor clearColor]];
    return aCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *obj = nil;
    if ([tableView isEqual:_tblLocation]) {
        obj = [aryLocation objectAtIndex:indexPath.row];
        if ([[[User currentUser] mutArrSelectedLocations] containsObject:obj]) {
            [[[User currentUser] mutArrSelectedLocations] removeObject:obj];
        }
        else {
            [[[User currentUser] mutArrSelectedLocations] addObject:obj];
        }
    }
    else {
        
        obj = [aryPositions objectAtIndex:indexPath.row];
        if ([[[User currentUser] mutArrSelectedPositions] containsObject:obj]) {
            [[[User currentUser] mutArrSelectedPositions] removeObject:obj];
        }
        else {
            [[[User currentUser] mutArrSelectedPositions] addObject:obj];
        }
        
    
        
        NSManagedObject *obj = nil;
        obj = [aryPositions objectAtIndex:indexPath.row];
        if ([aryPositionId containsObject:[obj valueForKey:@"value"]]) {
            [aryPositionId removeObject:[obj valueForKey:@"value"]];

        }
        else{
            [aryPositionId addObject:[obj valueForKey:@"value"]];

        }
        [self getLocationUnderPosition:aryPositionId];
//
//        
//        NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
//        
//        NSFetchRequest *requestPos = [[NSFetchRequest alloc] initWithEntityName:@"UserLocation"];
//        NSPredicate *predicatePos = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"position.value", [obj valueForKey:@"value"]];
//        [requestPos setPredicate:predicatePos];
//        [requestPos setSortDescriptors:@[sortByName]];
//        [requestPos setPropertiesToFetch:@[@"name", @"value"]];
//        NSArray * tempArr = [NSArray new];
//        tempArr = [gblAppDelegate.managedObjectContext executeFetchRequest:requestPos error:nil];
//        
//        for (id entity in tempArr){
//            BOOL hasDuplicate = [[aryLocation filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", [entity valueForKey:@"name"]]] count] > 0;
//            if (!hasDuplicate){
//                [aryLocation addObject:entity];
//            }
//        }
//        NSLog(@"%@",aryLocation);
//    [_tblLocation reloadData];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)getLocationUnderPosition:(NSMutableArray*)aryPositionId{
//    NSManagedObject *obj = nil;
//    obj = [aryPositions objectAtIndex:indexPath.row];
    aryLocation  = [[NSMutableArray alloc]init];

    NSArray * tempArr = [NSArray new];

    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    NSFetchRequest *requestPos = [[NSFetchRequest alloc] initWithEntityName:@"UserLocation"];
    for (id positionId in aryPositionId) {
        NSPredicate *predicatePos = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"position.value", positionId];
        [requestPos setPredicate:predicatePos];
        [requestPos setSortDescriptors:@[sortByName]];
        [requestPos setPropertiesToFetch:@[@"name", @"value"]];
        tempArr = [gblAppDelegate.managedObjectContext executeFetchRequest:requestPos error:nil];
        for (id entity in tempArr){
            BOOL hasDuplicate = [[aryLocation filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", [entity valueForKey:@"name"]]] count] > 0;
            if (!hasDuplicate){
                [aryLocation addObject:entity];
            }
        }

    }
[aryLocation sortUsingDescriptors:[NSArray arrayWithObject:sortByName]];
        NSLog(@"%@",aryLocation);
    [_tblLocation reloadData];

}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  
    DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
    dropDown.delegate = self;
    if ([textField isEqual:_txtFacility]) {
        [dropDown showDropDownWith:aryFacilities view:textField key:@"name"];
    }
    else if ([textField isEqual:_txtLocation]) {
        [dropDown showDropDownWith:aryLocation view:textField key:@"name"];
    }
    else if ([textField isEqual:_txtPosition]) {
        [dropDown showDropDownWith:aryPositions view:textField key:@"name"];
    }
    return NO;
}
- (void)dropDownControllerDidSelectValue:(id)value atIndex:(NSInteger)index sender:(id)sender {
    [sender setText:[value valueForKey:@"name"]];
    if ([sender isEqual:_txtFacility]) {
        if (![selectedFacility isEqual:value]) {
              aryPositionId = [[NSMutableArray alloc]init];
            selectedFacility = value;
            [[[User currentUser] mutArrSelectedPositions] removeAllObjects];
            [[[User currentUser] mutArrSelectedLocations] removeAllObjects];
            [self fetchPositionAndLocation];
            [_tblLocation reloadData];
            [_tblPosition reloadData];
        }
    }
}
@end
