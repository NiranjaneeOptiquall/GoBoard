//
//  AdminTaskListViewController.m
//  GoBoardPro
//
//  Created by ind558 on 13/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "AdminTaskListViewController.h"

@implementation AdminTaskListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchFacilities];
    selectedFacility = [[User currentUser] selectedFacility];
    selectedLocation = [[[User currentUser] mutArrSelectedPositions] firstObject];
    [self fetchLocation];
    _txtFacility.text = selectedFacility.name;
    _txtLocation.text = selectedLocation.name;
    mutArrTaskList = [[NSMutableArray alloc] init];
    [self GetAdminTask];
}

- (void)GetAdminTask {
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?facilityId=%@&locationId=%@", ADMIN_TASK_LIST, selectedFacility.value, selectedLocation.value] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:ADMIN_TASK_LIST] complition:^(NSDictionary *response) {
        mutArrTaskList = [response objectForKey:@"TaskList"];
        if ([mutArrTaskList count] == 0) {
            [_lblNoRecords setHidden:NO];
        }
        else {
            [_lblNoRecords setHidden:YES];
        }
        [_tblTaskList reloadData];
    } failure:^(NSError *error, NSDictionary *response) {
        [_lblNoRecords setHidden:NO];
    }];
}

- (void)fetchFacilities {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UserFacility"];
    [request setPropertiesToFetch:@[@"name", @"value"]];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [request setSortDescriptors:@[sortByName]];
    aryFacilities = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
}

- (void)fetchLocation {
    NSFetchRequest *requestLoc = [[NSFetchRequest alloc] initWithEntityName:@"UserLocation"];
    
    NSPredicate *predicateLoc = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"facility.value", selectedFacility.value];
    [requestLoc setPredicate:predicateLoc];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [requestLoc setSortDescriptors:@[sortByName]];
    [requestLoc setPropertiesToFetch:@[@"name", @"value"]];
    aryLocation = [gblAppDelegate.managedObjectContext executeFetchRequest:requestLoc error:nil];
    requestLoc = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [mutArrTaskList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[mutArrTaskList objectAtIndex:section] objectForKey:@"Tasks"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *position = (UILabel*)[aCell.contentView viewWithTag:2];
    if (indexPath.row == 0) {
        [position setText:[[mutArrTaskList objectAtIndex:indexPath.section] objectForKey:@"Position"]];
    }
    else {
        [position setText:@""];
    }
    
    NSDictionary *aDict = [[[mutArrTaskList objectAtIndex:indexPath.section] objectForKey:@"Tasks"] objectAtIndex:indexPath.row];
    UILabel *aLblTask = (UILabel*)[aCell.contentView viewWithTag:3];
    [aLblTask setText:[aDict objectForKey:@"Name"]];
    UILabel *aLblFrequency = (UILabel*)[aCell.contentView viewWithTag:4];
    [aLblFrequency setText:[aDict objectForKey:@"Frequency"]];
    [aCell setBackgroundColor:[UIColor clearColor]];
    [aCell.contentView setBackgroundColor:[UIColor clearColor]];
    return aCell;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_txtFacility]) {
        DropDownPopOver *dropDown = (DropDownPopOver *)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        [dropDown setDelegate:self];
        [dropDown showDropDownWith:aryFacilities view:_txtFacility key:@"name"];
    }
    else if ([textField isEqual:_txtLocation]) {
        DropDownPopOver *dropDown = (DropDownPopOver *)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        [dropDown setDelegate:self];
        [dropDown showDropDownWith:aryLocation view:_txtLocation key:@"name"];
    }
    return NO;
}

- (void)dropDownControllerDidSelectValue:(id)value atIndex:(NSInteger)index sender:(id)sender {
    if ([sender isEqual:_txtFacility]) {
        selectedFacility = value;
        _txtLocation.text = @"";
        selectedLocation = nil;
        [self fetchLocation];
    }
    else {
        selectedLocation = value;
        [self GetAdminTask];
    }
    [sender setText:[value valueForKey:@"name"]];
}

@end
