//
//  WelcomeUserViewController.m
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "WelcomeUserViewController.h"

@interface WelcomeUserViewController ()

@end

@implementation WelcomeUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [_lblUserName setText:[NSString stringWithFormat:@"Welcome %@ %@", [[User currentUser] firstName], [[User currentUser] lastName]]];
    [_txtLocation setEnabled:NO];
    [_txtPosition setEnabled:NO];
    [self getUserFacilities];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_lblUserName setText:[NSString stringWithFormat:@"Welcome %@ %@", [[User currentUser] firstName], [[User currentUser] lastName]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBActions

- (IBAction)btnSubmitTapped:(id)sender {
    if ([_txtFacility isTextFieldBlank] || [_txtLocation isTextFieldBlank] || [_txtPosition isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        return;
    }
    [[User currentUser] setSelectedFacility:selectedFacility];
    [[User currentUser] setSelectedLocation:selectedLocation];
    [[User currentUser] setSelectedPosition:selectedPosition];
    
//    [gblAppDelegate showActivityIndicator];
//    gblAppDelegate.shouldHideActivityIndicator = NO;
//    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
//    [[WebSerivceCall webServiceObject] getAllData];
//    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
//    gblAppDelegate.shouldHideActivityIndicator = YES;
//    [gblAppDelegate hideActivityIndicator];
    
    [self performSegueWithIdentifier:@"welcomeToUserHome" sender:nil];
}

- (IBAction)btnUpdateProfileTapped:(id)sender {
}

#pragma mark - Methods

- (void)getUserFacilities {
    if ([gblAppDelegate isNetworkReachable]) {
        [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@",USER_FACILITY, [[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:USER_FACILITY] complition:^(NSDictionary *response) {
            [self deleteAllFacilities];
        
            NSArray *aryFacility = [response objectForKey:@"Facilities"];

            for (NSDictionary *aDict in aryFacility) {
                UserFacility *facility = [NSEntityDescription insertNewObjectForEntityForName:@"UserFacility" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                facility.name = [aDict objectForKey:@"Name"];
                facility.value = [NSString stringWithFormat:@"%ld", (long)[[aDict objectForKey:@"Id"] integerValue]];
                NSMutableSet *locations = [NSMutableSet set];
                for (NSDictionary *aDictLoc in [aDict objectForKey:@"Locations"]) {
                    UserLocation *location = [NSEntityDescription insertNewObjectForEntityForName:@"UserLocation" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                    location.name = [aDictLoc objectForKey:@"Name"];
                    location.value = [NSString stringWithFormat:@"%ld", (long)[[aDictLoc objectForKey:@"Id"] integerValue]];
                    location.facility = facility;
                    [locations addObject:location];
                }
                facility.locations = locations;
                
                NSMutableSet *positions = [NSMutableSet set];
                for (NSDictionary *aDictPos in [aDict objectForKey:@"Positions"]) {
                    UserPosition *position = [NSEntityDescription insertNewObjectForEntityForName:@"UserPosition" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                    position.name = [aDictPos objectForKey:@"Name"];
                    position.value = [NSString stringWithFormat:@"%ld", (long)[[aDictPos objectForKey:@"Id"] integerValue]];
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
            alert(@"", [response objectForKey:@"ErrorMessage"]);
        }];
    }
    else {
        [self fetchFacilities];
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
}

- (void)fetchPositionAndLocation {
    NSFetchRequest *requestLoc = [[NSFetchRequest alloc] initWithEntityName:@"UserLocation"];
    
    NSPredicate *predicateLoc = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"facility.value", selectedFacility.value];
    [requestLoc setPredicate:predicateLoc];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [requestLoc setSortDescriptors:@[sortByName]];
    [requestLoc setPropertiesToFetch:@[@"name", @"value"]];
    aryLocation = [gblAppDelegate.managedObjectContext executeFetchRequest:requestLoc error:nil];
    requestLoc = nil;
    
    NSFetchRequest *requestPos = [[NSFetchRequest alloc] initWithEntityName:@"UserPosition"];
    NSPredicate *predicatePos = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"facility.value", selectedFacility.value];
    [requestPos setPredicate:predicatePos];
    [requestPos setSortDescriptors:@[sortByName]];
    [requestPos setPropertiesToFetch:@[@"name", @"value"]];
    aryPositions = [gblAppDelegate.managedObjectContext executeFetchRequest:requestPos error:nil];
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
        [_txtLocation setEnabled:YES];
        [_txtPosition setEnabled:YES];
        if (![selectedFacility isEqual:value]) {
            selectedFacility = value;
            selectedPosition = nil;
            selectedLocation = nil;
            [_txtLocation setText:@""];
            [_txtPosition setText:@""];
            [self fetchPositionAndLocation];
        }
    }
    else if ([sender isEqual:_txtPosition]) {
        selectedPosition = value;
    }
    else if ([sender isEqual:_txtLocation]) {
        selectedLocation = value;
    }
}
@end
