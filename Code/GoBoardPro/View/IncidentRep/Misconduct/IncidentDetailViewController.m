//
//  MisconductIncidentViewController.m
//  GoBoardPro
//
//  Created by ind558 on 25/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "IncidentDetailViewController.h"
#import "EmergencyPersonnelView.h"
#import "IncidentPersonalInformation.h"
#import "WitnessView.h"
#import "Report.h"
#import "Person.h"
#import "Witness.h"
#import "EmergencyPersonnel.h"

#define MISCONDUCT  @"misconduct"
#define CUSTOMER_SERVICE    @"customerservice"
#define OTHER   @"other"

@interface IncidentDetailViewController ()

@end

@implementation IncidentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchIncidentSetupInfo];
    [self fetchFacilities];
    [_txtLocation setEnabled:NO];
    [_vwEmergencyPersonnel setBackgroundColor:[UIColor clearColor]];
    [_vwAfterPersonalInfo setBackgroundColor:[UIColor clearColor]];
    mutArrIncidentPerson = [[NSMutableArray alloc] init];
    mutArrEmergencyPersonnel = [[NSMutableArray alloc] init];
    mutArrWitnessView = [[NSMutableArray alloc] init];
    [self viewSetup];
    [self addIncidentPersonalInformationViews];
    if ([reportSetupInfo.showEmergencyPersonnel boolValue]) {
        [self addEmergencyPersonnel];
    }
    [self addWitnessView];
    if ([reportSetupInfo.showManagementFollowup boolValue]) {
        [self addActionTakenView];
    }
    [self btnNotificationTapped:_btnNone];
    if (_incidentType == 2) {
        _lblIncidentTitle.text = @"Customer Service Incident Report";
        [_imvIncidentIcon setImage:[UIImage imageNamed:@"customer_service.png"]];
        [_lblAdditonInfo setText:@"Action Taken and Additional Information"];
    }
    else if (_incidentType == 3) {
        _lblIncidentTitle.text = @"Other Incident Report";
        [_imvIncidentIcon setImage:[UIImage imageNamed:@"other_incidents.png"]];
    }
    _isUpdate = NO;
}

- (void)viewSetup {
    [_btn911Called setTitle:reportSetupInfo.notificationField1 forState:UIControlStateNormal];
    [_btnPoliceCalled setTitle:reportSetupInfo.notificationField2 forState:UIControlStateNormal];
    [_btnManager setTitle:reportSetupInfo.notificationField3 forState:UIControlStateNormal];
    [_btnNone setTitle:reportSetupInfo.notificationField4 forState:UIControlStateNormal];
    _lblInstruction.text = reportSetupInfo.instructions;
    
    if (![reportSetupInfo.showConditions boolValue]) {
        [_vwConditions setHidden:YES];
        CGRect frame = _vwNatureOfIncident.frame;
        frame.origin.y = _vwConditions.frame.origin.y;
        _vwNatureOfIncident.frame = frame;
        
        frame = _vwAfterPersonalInfo.frame;
        frame.size.height = CGRectGetMaxY(_vwNatureOfIncident.frame);
        _vwAfterPersonalInfo.frame = frame;
    }
    if (![reportSetupInfo.showEmergencyPersonnel boolValue]) {
        CGRect frame = _vwEmergencyPersonnel.frame;
        frame.size = CGSizeZero;
        _vwEmergencyPersonnel.frame = frame;
        [_vwEmergencyPersonnel setHidden:YES];
    }
    if (![reportSetupInfo.showManagementFollowup boolValue]) {
        [_vwManagementFollowUp setHidden:YES];
        CGRect frame = _vwSubmit.frame;
        frame.origin.y = _vwManagementFollowUp.frame.origin.y;
        _vwSubmit.frame = frame;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"type", REQUIRED_TYPE_EMPLOYEE];
    NSArray *fields = [[reportSetupInfo.requiredFields allObjects] filteredArrayUsingPredicate:predicate];
    NSArray *aryFields = [fields valueForKeyPath:@"name"];
    if ([aryFields containsObject:@"firstName"]) [_markerEmpFName setHidden:NO];
    if ([aryFields containsObject:@"middleInital"]) [_markerEmpMI setHidden:NO];
    if ([aryFields containsObject:@"lastName"]) [_markerEmpLName setHidden:NO];
    if ([aryFields containsObject:@"phone"]) [_markerEmpPhone setHidden:NO];
    if ([aryFields containsObject:@"alternatePhone"]) [_markerEmpAltPhone setHidden:NO];
    if ([aryFields containsObject:@"email"]) [_markerEmpEmail setHidden:NO];
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
    
}

#pragma mark - IBActions and Selectors

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    _isUpdate = YES;
    if ([object isKindOfClass:[IncidentPersonalInformation class]]) {
        NSInteger index = [mutArrIncidentPerson indexOfObject:object];
        float previousMaxY = CGRectGetMaxY([object frame]);
        for (NSInteger i = index+1; i < [mutArrIncidentPerson count]; i++) {
            IncidentPersonalInformation *obj = mutArrIncidentPerson[i];
            CGRect frame = obj.frame;
            frame.origin.y = previousMaxY;
            obj.frame = frame;
            previousMaxY = CGRectGetMaxY(frame);
        }
        CGRect frame = _vwPersonalInfo.frame;
        frame.size.height = previousMaxY;
        _vwPersonalInfo.frame = frame;
        
        frame = _vwAfterPersonalInfo.frame;
        frame.origin.y = CGRectGetMaxY(_vwPersonalInfo.frame);
        _vwAfterPersonalInfo.frame = frame;
        
        frame = _vwEmergencyPersonnel.frame;
        frame.origin.y = CGRectGetMaxY(_vwAfterPersonalInfo.frame);
        _vwEmergencyPersonnel.frame = frame;
        frame = _vwWitnesses.frame;
        frame.origin.y = CGRectGetMaxY(_vwEmergencyPersonnel.frame);
        _vwWitnesses.frame = frame;
        frame = _vwEmployeeInfo.frame;
        frame.origin.y = CGRectGetMaxY(_vwWitnesses.frame);
        _vwEmployeeInfo.frame = frame;
        [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
    }
}

- (IBAction)btnAddEmergencyPersonnelTapped:(id)sender {
    [self addEmergencyPersonnel];
}

- (IBAction)btnAddPersonTapped:(id)sender {
    [self addIncidentPersonalInformationViews];
}

- (IBAction)btnAddWitnessTapped:(id)sender {
    [self addWitnessView];
}

- (IBAction)btnFollowUpCallTapped:(UIButton *)sender {
    _isUpdate = YES;
    intFollowUpCallType = sender.tag;
    [_btnYesCall setSelected:NO];
    [_btnNoCall setSelected:NO];
    [_btnCallNotReq setSelected:NO];
    [sender setSelected:YES];
}

- (IBAction)btnNotificationTapped:(UIButton *)sender {
//    [_btn911Called setSelected:NO];
//    [_btnPoliceCalled setSelected:NO];
//    [_btnManager setSelected:NO];
//    [_btnNone setSelected:NO];
    _isUpdate = YES;
    [sender setSelected:![sender isSelected]];
}

- (IBAction)btnSubmitTapped:(id)sender {
    if (![self checkValidation]) {
        return;
    }
    
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *incidentDate = [aFormatter dateFromString:_txtDateOfIncident.text];
    NSDate *managementFollowupDate = [aFormatter dateFromString:_txtManagementFollowUp.text];
    [aFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *aStrDate = [NSString stringWithFormat:@"%@ %@", [aFormatter stringFromDate:incidentDate], _txtTimeOfIncident.text];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"name", _txtActivity.text];
    NSArray *ary = [[reportSetupInfo.activityList allObjects] filteredArrayUsingPredicate:predicate];
    NSString *activityTypeID = [[ary firstObject] valueForKey:@"activityId"];
    if (!activityTypeID) activityTypeID = @"";
    
    
    predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"name", _txtEquipment.text];
    ary = [[reportSetupInfo.equipmentList allObjects] filteredArrayUsingPredicate:predicate];
    NSString *equipmentTypeID = [[ary firstObject] valueForKey:@"equipmentId"];
    if (!equipmentTypeID) equipmentTypeID = @"";
    
    
    predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"name", _txtWeather.text];
    ary = [[reportSetupInfo.conditionList allObjects] filteredArrayUsingPredicate:predicate];
    NSString* conditionTypeID = [[ary firstObject] valueForKey:@"conditionId"];
    if (!conditionTypeID) conditionTypeID = @"";
    
    predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"name", _txtActionTaken.text];
    ary = [[reportSetupInfo.actionList allObjects] filteredArrayUsingPredicate:predicate];
    NSString* actionId = [[ary firstObject] valueForKey:@"actionId"];
    if (!actionId) actionId = @"";
    
    predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"name", _txtChooseIncident.text];
    ary = [[reportSetupInfo.natureList allObjects] filteredArrayUsingPredicate:predicate];
    NSString* natureId = [[ary firstObject] valueForKey:@"natureId"];
    if (!natureId) natureId = @"";
    
    NSMutableArray *mutArrPersons = [NSMutableArray array];
    for (IncidentPersonalInformation *vwPerson in mutArrIncidentPerson) {
        NSString *strDob = @"";
        
        if (vwPerson.txtDob.text.length > 0) {
            [aFormatter setDateFormat:@"MM/dd/yyyy"];
            NSDate *aDob = [aFormatter dateFromString:vwPerson.txtDob.text];
            [aFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            strDob = [aFormatter stringFromDate:aDob];
        }
        NSString *memberId = @"", *employeeId = @"";
        if (vwPerson.intPersonInvolved == 3) {
            employeeId = vwPerson.txtMemberId.text;
        }
        else {
            memberId = vwPerson.txtMemberId.text;
        }
        NSString *strPhoto = @"";
        if (vwPerson.imgIncidentPerson) {
            strPhoto = [UIImageJPEGRepresentation(vwPerson.imgIncidentPerson, 1.0) base64EncodedStringWithOptions:0];
        }
        NSDictionary *aDict = @{@"FirstName": vwPerson.txtFirstName.trimText, @"MiddleInitial":vwPerson.txtMi.trimText, @"LastName":vwPerson.txtLastName.trimText, @"PrimaryPhone":vwPerson.txtHomePhone.text, @"AlternatePhone":vwPerson.txtAlternatePhone.text, @"Email":vwPerson.txtEmailAddress.text, @"Address1":vwPerson.txtStreetAddress.trimText, @"Address2":vwPerson.txtAppartment.trimText, @"City":vwPerson.txtCity.trimText, @"State":vwPerson.txtState.trimText, @"Zip": vwPerson.txtZip.text, @"AffiliationTypeId":[NSString stringWithFormat:@"%ld", (long)vwPerson.intAffiliationType], @"GenderTypeId":[NSString stringWithFormat:@"%ld", (long)vwPerson.intGenderType], @"PersonTypeId":[NSString stringWithFormat:@"%ld", (long)vwPerson.intPersonInvolved], @"GuestOfFirstName":vwPerson.txtGuestFName.text, @"GuestOfMiddleInitial":vwPerson.txtGuestMI.text, @"GuestOfLastName": vwPerson.txtguestLName.text, @"IsMinor":(vwPerson.btnMinor.isSelected) ? @"true" : @"false", @"EmployeeTitle":vwPerson.txtEmployeePosition.text, @"EmployeId":employeeId, @"MemberId":memberId, @"OccuredDuringBusinessHours":(vwPerson.btnEmployeeOnWork.isSelected) ? @"true" : @"false", @"DateOfBirth":strDob, @"PersonPhoto":strPhoto};
//        aPerson.duringWorkHours = (vwPerson.btnEmployeeOnWork.isSelected) ? @"true" : @"false";
        
        [mutArrPersons addObject:aDict];
    }
    
    NSMutableArray *mutArrEmergency = [NSMutableArray array];
    for (EmergencyPersonnelView *vwEmergency in mutArrEmergencyPersonnel) {
        NSDictionary *aDict = @{@"FirstName":vwEmergency.txtFirstName.text, @"MiddleInitial":vwEmergency.txtMI.text, @"LastName":vwEmergency.txtLastName.text, @"Phone":vwEmergency.txtPhone.text, @"AdditionalInformation":vwEmergency.txvAdditionalInfo.text, @"CaseNumber":vwEmergency.txtCaseNo.text, @"BadgeNumber":vwEmergency.txtBadge.text, @"Time911Called":vwEmergency.txtTime911Called.text, @"ArrivalTime":vwEmergency.txtTimeOfArrival.text, @"DepartureTime":vwEmergency.txtTimeOfDeparture.text};
        [mutArrEmergency addObject:aDict];
    }
    
    NSMutableArray *mutArrWitness = [NSMutableArray array];
    for (WitnessView *vwWitness in mutArrWitnessView) {
        NSDictionary *aDict = @{@"FirstName":vwWitness.txtWitnessFName.text, @"MiddleInitial":vwWitness.txtWitnessMI.text, @"LastName":vwWitness.txtWitnessLName.text, @"HomePhone":vwWitness.txtWitnessHomePhone.text, @"AlternatePhone":vwWitness.txtWitnessAlternatePhone.text, @"Email":vwWitness.txtWitnessEmailAddress.text, @"IncidentDescription":vwWitness.txvDescIncident.text};
        [mutArrWitness addObject:aDict];
    }
    NSString *strFollowUpDate = [aFormatter stringFromDate:managementFollowupDate];
    if (!strFollowUpDate) strFollowUpDate = @"";
    NSDictionary *aDict = @{@"IncidentDate":aStrDate, @"FacilityId":selectedFacility.value, @"LocationId":selectedLocation.value, @"IncidentDescription":_txvIncidentDesc.text, @"IsNotificationField1Selected":(_btn911Called.isSelected) ? @"true":@"false", @"IsNotificationField2Selected":(_btnPoliceCalled.isSelected) ? @"true":@"false", @"IsNotificationField3Selected":(_btnManager.isSelected) ? @"true":@"false", @"IsNotificationField4Selected":(_btnNone.isSelected) ? @"true":@"false", @"EmployeeFirstName":_txtEmpFName.trimText, @"EmployeeMiddleInitial": _txtEmpMI.trimText, @"EmployeeLastName":_txtEmpLName.trimText, @"EmployeeHomePhone":_txtEmpHomePhone.trimText, @"EmployeeAlternatePhone":_txtEmpAlternatePhone.text, @"EmployeeEmail":_txtEmpEmail.text, @"ReportFilerAccount":_txtReportAccount.text, @"ManagementFollowupDate":strFollowUpDate, @"AdditionalInformation": _txvAdditionalInfo.text, @"ManagementFollowupCallMadeType":[NSString stringWithFormat:@"%ld",(long)intFollowUpCallType], @"ActivityTypeId": activityTypeID, @"EquipmentTypeId": equipmentTypeID, @"NatureId": natureId, @"ActionTakenId": actionId, @"ConditionId": conditionTypeID, @"PersonsInvolved":mutArrPersons, @"EmergencyPersonnel":mutArrEmergency, @"Witnesses":mutArrWitness};

    [gblAppDelegate callWebService:INCIDENT_REPORT_POST parameters:aDict httpMethod:[SERVICE_HTTP_METHOD objectForKey:INCIDENT_REPORT_POST] complition:^(NSDictionary *response) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:@"Incident Report has been submitted successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    } failure:^(NSError *error, NSDictionary *response) {
        [self saveIncidentToOffline:aDict];
    }];
}



- (IBAction)btnBackTapped:(id)sender {
    [self.view endEditing:YES];
    if (_isUpdate) {
        [[[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:@"Do you want to save your information? If you press “Back” you will lose all entered information, do you want to proceed?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil] show];
    }
    else {
        for (IncidentPersonalInformation *vw in mutArrIncidentPerson) {
            [vw removeObserver:self forKeyPath:@"frame"];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        for (IncidentPersonalInformation *vw in mutArrIncidentPerson) {
            [vw removeObserver:self forKeyPath:@"frame"];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - CoreData Methods

- (void)fetchIncidentSetupInfo {
    NSString *type = @"";
    switch (_incidentType) {
        case 1:
            type = MISCONDUCT;
            break;
        case 2:
            type = CUSTOMER_SERVICE;
            break;
        case 3:
            type = OTHER;
            break;
        default:
            break;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"IncidentReportInfo"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"reportType", type];
    [request setPredicate:predicate];
    NSArray *array = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    if ([array count] > 0) {
        reportSetupInfo = [array firstObject];
    }
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


- (void)saveIncidentToOffline:(NSDictionary*)aDict {
    Report *aReport = [NSEntityDescription insertNewObjectForEntityForName:@"Report" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    aReport.dateOfIncident = [aDict objectForKey:@"IncidentDate"];
    aReport.facilityId = [aDict objectForKey:@"FacilityId"];
    aReport.locationId = [aDict objectForKey:@"LocationId"];
    aReport.incidentDesc = [aDict objectForKey:@"IncidentDescription"];
    aReport.isNotification1Selected = [aDict objectForKey:@"IsNotificationField1Selected"];
    aReport.isNotification2Selected = [aDict objectForKey:@"IsNotificationField2Selected"];
    aReport.isNotification3Selected = [aDict objectForKey:@"IsNotificationField3Selected"];
    aReport.isNotification4Selected = [aDict objectForKey:@"IsNotificationField4Selected"];
    aReport.employeeFirstName = [aDict objectForKey:@"EmployeeFirstName"];
    aReport.employeeMiddleInitial = [aDict objectForKey:@"EmployeeMiddleInitial"];
    aReport.employeeLastName = [aDict objectForKey:@"EmployeeLastName"];
    aReport.employeeHomePhone = [aDict objectForKey:@"EmployeeHomePhone"];
    aReport.employeeAlternatePhone = [aDict objectForKey:@"EmployeeAlternatePhone"];
    aReport.employeeEmail = [aDict objectForKey:@"EmployeeEmail"];
    aReport.reportFilerAccount = [aDict objectForKey:@"ReportFilerAccount"];
    aReport.managementFollowUpDate = [aDict objectForKey:@"ManagementFollowupDate"];
    aReport.additionalInfo = [aDict objectForKey:@"AdditionalInformation"];
    aReport.followUpCallType = [aDict objectForKey:@"ManagementFollowupCallMadeType"];
    
    aReport.activityTypeID = [aDict objectForKey:@"ActivityTypeId"];
    aReport.equipmentTypeID = [aDict objectForKey:@"EquipmentTypeId"];
    aReport.natureId = [aDict objectForKey:@"NatureId"];
    aReport.actionId = [aDict objectForKey:@"ActionTakenId"];
    aReport.conditionTypeID = [aDict objectForKey:@"ConditionId"];
    
    NSMutableSet *personSet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"PersonsInvolved"]) {
        Person *aPerson = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        aPerson.firstName = [dict objectForKey:@"FirstName"];
        aPerson.middleInitial = [dict objectForKey:@"MiddleInitial"];
        aPerson.lastName = [dict objectForKey:@"LastName"];
        aPerson.primaryPhone = [dict objectForKey:@"PrimaryPhone"];
        aPerson.alternatePhone = [dict objectForKey:@"AlternatePhone"];
        aPerson.email = [dict objectForKey:@"Email"];
        aPerson.streetAddress = [dict objectForKey:@"Address1"];
        aPerson.apartmentNumber = [dict objectForKey:@"Address2"];
        aPerson.city = [dict objectForKey:@"City"];
        aPerson.state = [dict objectForKey:@"State"];
        aPerson.zip = [dict objectForKey:@"Zip"];
        aPerson.employeeTitle = [dict objectForKey:@"EmployeeTitle"];
        aPerson.memberId =  ([[dict objectForKey:@"PersonTypeId"] intValue] == 3) ? [dict objectForKey:@"EmployeId"] : [dict objectForKey:@"MemberId"];
        aPerson.dateOfBirth = [dict objectForKey:@"DateOfBirth"];
        aPerson.affiliationTypeID = [dict objectForKey:@"AffiliationTypeId"];
        aPerson.genderTypeID = [dict objectForKey:@"GenderTypeId"];
        aPerson.personTypeID = [dict objectForKey:@"PersonTypeId"];
        aPerson.duringWorkHours = [dict objectForKey:@"OccuredDuringBusinessHours"];

        aPerson.guestOfFirstName = [aDict objectForKey:@"GuestOfFirstName"];
        aPerson.guestOfMiddleInitial = [aDict objectForKey:@"GuestOfMiddleInitial"];
        aPerson.guestOfLastName = [aDict objectForKey:@"GuestOfLastName"];
        
        if (![[aDict objectForKey:@"PersonPhoto"] isEqualToString:@""]) {
            aPerson.personPhoto = [[aDict objectForKey:@"PersonPhoto"] base64EncodedDataWithOptions:0];
        }
        aPerson.minor = [aDict objectForKey:@"IsMinor"];
        //        aPerson.duringWorkHours = (vwPerson.btnEmployeeOnWork.isSelected) ? @"true" : @"false";
        aPerson.report = aReport;
        [personSet addObject:aPerson];
    }
    aReport.persons = personSet;
    
    NSMutableSet *emergencySet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"EmergencyPersonnel"]) {
        EmergencyPersonnel *aEmergencyPersonnel = [NSEntityDescription insertNewObjectForEntityForName:@"EmergencyPersonnel" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        aEmergencyPersonnel.firstName = [dict objectForKey:@"FirstName"];
        aEmergencyPersonnel.middileInitial = [dict objectForKey:@"MiddleInitial"];
        aEmergencyPersonnel.lastName = [dict objectForKey:@"LastName"];
        aEmergencyPersonnel.phone = [dict objectForKey:@"Phone"];
        aEmergencyPersonnel.additionalInformation = [dict objectForKey:@"AdditionalInformation"];
        aEmergencyPersonnel.caseNumber = [dict objectForKey:@"CaseNumber"];
        aEmergencyPersonnel.badgeNumber = [dict objectForKey:@"BadgeNumber"];
        aEmergencyPersonnel.time911Called = [dict objectForKey:@"Time911Called"];
        aEmergencyPersonnel.time911Arrival = [dict objectForKey:@"ArrivalTime"];
        aEmergencyPersonnel.time911Departure = [dict objectForKey:@"DepartureTime"];
        aEmergencyPersonnel.report = aReport;
        [emergencySet addObject:aEmergencyPersonnel];
    }
    aReport.emergencyPersonnels = emergencySet;
    
    NSMutableSet *witnessSet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"Witnesses"]) {
        Witness *aWitness = [NSEntityDescription insertNewObjectForEntityForName:@"Witness" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        aWitness.firstName = [dict objectForKey:@"FirstName"];
        aWitness.middleInitial = [dict objectForKey:@"MiddleInitial"];
        aWitness.lastName = [dict objectForKey:@"LastName"];
        aWitness.homePhone = [dict objectForKey:@"HomePhone"];
        aWitness.alternatePhone = [dict objectForKey:@"AlternatePhone"];
        aWitness.email = [dict objectForKey:@"Email"];
        aWitness.witnessWrittenAccount = [dict objectForKey:@"IncidentDescription"];
        aWitness.report = aReport;
        [witnessSet addObject:aWitness];
    }
    aReport.witnesses = witnessSet;
    
    
    [gblAppDelegate.managedObjectContext insertedObjects];
    if ([gblAppDelegate.managedObjectContext save:nil]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:@"Incident Report has been submitted successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
}

#pragma mark - Methods

- (void)addIncidentPersonalInformationViews {
    IncidentPersonalInformation *personalInfoView = (IncidentPersonalInformation*)[[[NSBundle mainBundle] loadNibNamed:@"IncidentPersonalInformation" owner:self options:nil] firstObject];
    personalInfoView.isCapturePhotoVisible = [reportSetupInfo.showPhotoIcon boolValue];
    personalInfoView.isAffiliationVisible = [reportSetupInfo.showAffiliation boolValue];
    personalInfoView.isMemberIdVisible = [reportSetupInfo.showMemberIdAndDriverLicense boolValue];
    personalInfoView.isDOBVisible = [reportSetupInfo.showDateOfBirth boolValue];
    personalInfoView.isGenderVisible = [reportSetupInfo.showGender boolValue];
    personalInfoView.isMinorVisible = [reportSetupInfo.showMinor boolValue];
    personalInfoView.isMinorVisible = [reportSetupInfo.showEmployeeId boolValue];
    [personalInfoView callInitialActions];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"type", REQUIRED_TYPE_PERSON];
    NSArray *fields = [[reportSetupInfo.requiredFields allObjects] filteredArrayUsingPredicate:predicate];
    NSArray *aryFields = [fields valueForKeyPath:@"name"];
    [personalInfoView setRequiredFields:aryFields];
    [personalInfoView setBackgroundColor:[UIColor clearColor]];
    CGRect frame = personalInfoView.frame;
    frame.origin.y = totalPersonCount * frame.size.height;
    personalInfoView.frame = frame;
    [personalInfoView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [_vwPersonalInfo addSubview:personalInfoView];
    totalPersonCount ++;
    [mutArrIncidentPerson addObject:personalInfoView];
    
    frame = _vwPersonalInfo.frame;
    frame.size.height = CGRectGetMaxY(personalInfoView.frame);
    _vwPersonalInfo.frame = frame;
    
    frame = _vwAfterPersonalInfo.frame;
    frame.origin.y = CGRectGetMaxY(_vwPersonalInfo.frame);
    _vwAfterPersonalInfo.frame = frame;
    
    frame = _vwEmergencyPersonnel.frame;
    frame.origin.y = CGRectGetMaxY(_vwAfterPersonalInfo.frame);
    _vwEmergencyPersonnel.frame = frame;
    frame = _vwWitnesses.frame;
    frame.origin.y = CGRectGetMaxY(_vwEmergencyPersonnel.frame);
    _vwWitnesses.frame = frame;
    frame = _vwEmployeeInfo.frame;
    frame.origin.y = CGRectGetMaxY(_vwWitnesses.frame);
    _vwEmployeeInfo.frame = frame;
    [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
}

- (void)addEmergencyPersonnel {
    EmergencyPersonnelView *objEmergency = (EmergencyPersonnelView*)[[[NSBundle mainBundle] loadNibNamed:@"EmergencyPersonnelView" owner:self options:nil] firstObject];
    [objEmergency setBackgroundColor:[UIColor clearColor]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"type", REQUIRED_TYPE_EMERGENCY];
    NSArray *fields = [[reportSetupInfo.requiredFields allObjects] filteredArrayUsingPredicate:predicate];
    NSArray *aryFields = [fields valueForKeyPath:@"name"];
    [objEmergency setRequiredFields:aryFields];
    CGRect frame = objEmergency.frame;
    frame.origin.y = totalEmergencyPersonnelCount * frame.size.height;
    objEmergency.frame = frame;
    [_vwEmergencyPersonnel addSubview:objEmergency];
    totalEmergencyPersonnelCount ++;
    [mutArrEmergencyPersonnel addObject:objEmergency];
    frame = _btnAddEmergency.frame;
    frame.origin.y = CGRectGetMaxY(objEmergency.frame);
    _btnAddEmergency.frame = frame;
    
    frame = _vwEmergencyPersonnel.frame;
    frame.size.height = CGRectGetMaxY(_btnAddEmergency.frame);
    _vwEmergencyPersonnel.frame = frame;
    
    frame = _vwWitnesses.frame;
    frame.origin.y = CGRectGetMaxY(_vwEmergencyPersonnel.frame);
    _vwWitnesses.frame = frame;
    frame = _vwEmployeeInfo.frame;
    frame.origin.y = CGRectGetMaxY(_vwWitnesses.frame);
    _vwEmployeeInfo.frame = frame;
    [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
}

- (void)addWitnessView {
    WitnessView *aWitnessView = (WitnessView*)[[[NSBundle mainBundle] loadNibNamed:@"WitnessView" owner:self options:nil] firstObject];
    [aWitnessView setBackgroundColor:[UIColor clearColor]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"type", REQUIRED_TYPE_WITNESS];
    NSArray *fields = [[reportSetupInfo.requiredFields allObjects] filteredArrayUsingPredicate:predicate];
    NSArray *aryFields = [fields valueForKeyPath:@"name"];
    [aWitnessView setRequiredFields:aryFields];
    CGRect frame = aWitnessView.frame;
    frame.origin.y = totalWitnessCount * frame.size.height;
    aWitnessView.frame = frame;
    [_vwWitnesses addSubview:aWitnessView];
    [mutArrWitnessView addObject:aWitnessView];
    totalWitnessCount ++;
    frame = _vwWitnesses.frame;
    frame.size.height = CGRectGetMaxY(aWitnessView.frame);
    _vwWitnesses.frame = frame;
    frame = _vwEmployeeInfo.frame;
    frame.origin.y = CGRectGetMaxY(_vwWitnesses.frame);
    _vwEmployeeInfo.frame = frame;
    [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
}

- (void)addActionTakenView {
    if (_incidentType == 1) {
        actionTaken = (IncidentActionTaken*)[[[NSBundle mainBundle] loadNibNamed:@"IncidentActionTaken" owner:self options:nil]firstObject];
        CGRect frame = actionTaken.frame;
        frame.origin.y = _vwSubmit.frame.origin.y;
        actionTaken.frame = frame;
        [_vwEmployeeInfo addSubview:actionTaken];
        frame = _vwSubmit.frame;
        frame.origin.y = CGRectGetMaxY(actionTaken.frame);
        _vwSubmit.frame = frame;
        
        frame = _vwEmployeeInfo.frame;
        frame.size.height = CGRectGetMaxY(_vwSubmit.frame);
        _vwEmployeeInfo.frame = frame;
        [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
    }
}


- (BOOL)checkValidation {
    BOOL success = YES;
    if ([_txtDateOfIncident isTextFieldBlank] || [_txtTimeOfIncident isTextFieldBlank] || [_txtFacility isTextFieldBlank] || [_txtLocation isTextFieldBlank]) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if (![self validateIncidentPersonal]) {
        return NO;
    }
//    else if ([_txtActivity isTextFieldBlank]) {
//        success = NO;
//        alert(@"", MSG_REQUIRED_FIELDS);
//    }
//    else if ([reportSetupInfo.showConditions boolValue] && ([_txtWeather isTextFieldBlank] || [_txtEquipment isTextFieldBlank])) {
//        success = NO;
//        alert(@"", MSG_REQUIRED_FIELDS);
//    }
    else if (![self validateEmergencyPersonnel]) {
        return NO;
    }
    else if (![self validateWitnessView]) {
        return NO;
    }
    else if (![self validateEmployeeView]) {
        return NO;
    }
    return success;
}

- (BOOL)validateIncidentPersonal {
    for (IncidentPersonalInformation *person in mutArrIncidentPerson) {
        if (![person isPersonalInfoValidationSuccess]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)validateEmergencyPersonnel {
    for (EmergencyPersonnelView *emergency in mutArrEmergencyPersonnel) {
        if (![emergency isEmergencyPersonnelValidationSucceed]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)validateWitnessView {
    for (WitnessView *witness in mutArrWitnessView) {
        if (![witness isWitnessViewValidationSuccess]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)validateEmployeeView {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"type", REQUIRED_TYPE_WITNESS];
    NSArray *fields = [[reportSetupInfo.requiredFields allObjects] filteredArrayUsingPredicate:predicate];
    NSArray *aryFields = [fields valueForKeyPath:@"name"];
    BOOL success = YES;
    if ([aryFields containsObject:@"firstName"] && [_txtEmpFName isTextFieldBlank]) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if ([aryFields containsObject:@"middleInital"] && [_txtEmpMI isTextFieldBlank]) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if ([aryFields containsObject:@"lastName"] && [_txtEmpLName isTextFieldBlank]) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if ([aryFields containsObject:@"phone"] && [_txtEmpHomePhone isTextFieldBlank]) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if (![_txtEmpHomePhone.text isValidPhoneNumber]) {
        success = NO;
        [_txtEmpHomePhone becomeFirstResponder];
        alert(@"", @"Please enter witness's valid home phone number");
    }
    else if (![_txtEmpAlternatePhone.text isValidPhoneNumber]) {
        success = NO;
        [_txtEmpAlternatePhone becomeFirstResponder];
        alert(@"", @"Please enter witness's valid alternate phone number");
    }
    else if ([aryFields containsObject:@"email"] && [_txtEmpEmail isTextFieldBlank]) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if (![gblAppDelegate validateEmail:[_txtEmpEmail text]]) {
        success = NO;
        [_txtEmpEmail becomeFirstResponder];
        alert(@"", @"Please enter witness's valid email address");
    }
    return success;
}

- (void)setKeepViewInFrame:(UIView*)vw {
    CGPoint point = [vw.superview convertPoint:vw.frame.origin toView:_scrlMainView];
    if (point.y <_scrlMainView.contentOffset.y || point.y > _scrlMainView.contentOffset.y + _scrlMainView.frame.size.height) {
        [_scrlMainView setContentOffset:CGPointMake(_scrlMainView.contentOffset.x, point.y - 50) animated:NO];
    }
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL allowEditing = YES;
    _isUpdate = YES;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    if ([textField isEqual:_txtDateOfIncident]) {
        [self setKeepViewInFrame:textField];
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_PAST_ONLY option:DATE_SELECTION_DATE_ONLY updateField:textField];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtTimeOfIncident]) {
        [self setKeepViewInFrame:textField];
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_PAST_ONLY option:DATE_SELECTION_TIME_ONLY updateField:textField];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtFacility]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:aryFacilities view:textField key:@"name"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtLocation]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:aryLocation view:textField key:@"name"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtActivity]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        NSArray *ary = [[reportSetupInfo.activityList allObjects] sortedArrayUsingDescriptors:@[sort]];
        [dropDown showDropDownWith:ary view:textField key:@"name"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtWeather]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        NSArray *ary = [[reportSetupInfo.conditionList allObjects] sortedArrayUsingDescriptors:@[sort]];
        [dropDown showDropDownWith:ary view:textField key:@"name"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtEquipment]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        NSArray *ary = [[reportSetupInfo.equipmentList allObjects] sortedArrayUsingDescriptors:@[sort]];
        [dropDown showDropDownWith:ary view:textField key:@"name"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtChooseIncident]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        NSArray *ary = [[reportSetupInfo.natureList allObjects] sortedArrayUsingDescriptors:@[sort]];
        [dropDown showDropDownWith:ary view:textField key:@"name"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtActionTaken]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        NSArray *ary = [[reportSetupInfo.actionList allObjects] sortedArrayUsingDescriptors:@[sort]];
        [dropDown showDropDownWith:ary view:textField key:@"name"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtManagementFollowUp]) {
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_PAST_ONLY option:DATE_SELECTION_DATE_ONLY updateField:textField];
        allowEditing = NO;
    }
    return allowEditing;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if ([string isEqualToString:@""]) {
        if ([textField isEqual:_txtEmpHomePhone] || [textField isEqual:_txtEmpAlternatePhone]) {
            if (textField.text.length == 5) {
                NSString *aStr = [textField.text substringWithRange:NSMakeRange(1, 2)];
                textField.text = aStr;
                return NO;
            }
            else if (textField.text.length == 7) {
                NSString *aStr = [textField.text substringWithRange:NSMakeRange(0, 5)];
                textField.text = aStr;
                return NO;
            }
            else if (textField.text.length == 11) {
                NSString *aStr = [textField.text substringWithRange:NSMakeRange(0, 9)];
                textField.text = aStr;
                return NO;
            }
        }
        return YES;
    }
    if ([textField isEqual:_txtEmpHomePhone] || [textField isEqual:_txtEmpAlternatePhone]) {
        NSCharacterSet *numericCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        if ([string rangeOfCharacterFromSet:numericCharacterSet].location == NSNotFound) {
            return NO;
        }
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 14) {
            return NO;
        }
        NSString *aStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (aStr.length == 3) {
            aStr = [NSString stringWithFormat:@"(%@)", aStr];
            textField.text = aStr;
            return NO;
        }
        else if (aStr.length == 6) {
            aStr = [NSString stringWithFormat:@"%@ %@",textField.text, string];
            textField.text = aStr;
            return NO;
        }
        else if (aStr.length == 10) {
            aStr = [NSString stringWithFormat:@"%@-%@",textField.text, string];
            textField.text = aStr;
            return NO;
        }
    }
    if ([_txtEmpMI isEqual:textField]) {
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 5) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    _isUpdate = YES;
    if ([textView isEqual:_txvIncidentDesc])
        [_lblIncidentDesc setHidden:YES];
    else if ([textView isEqual:_txtReportAccount])
        [_lblReportFilerPlaceHolder setHidden:YES];
    else if ([textView isEqual:_txvAdditionalInfo])
        [_lblAdditonInfo setHidden:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text length] == 0) {
        if ([textView isEqual:_txvIncidentDesc])
            [_lblIncidentDesc setHidden:NO];
        else if ([textView isEqual:_txtReportAccount])
            [_lblReportFilerPlaceHolder setHidden:NO];
        else if ([textView isEqual:_txvAdditionalInfo])
            [_lblAdditonInfo setHidden:NO];
    }
}

#pragma mark - DropDownValueDelegate

- (void)dropDownControllerDidSelectValue:(id)value atIndex:(NSInteger)index sender:(id)sender {
    if ([sender isEqual:_txtFacility]) {
        [_txtLocation setEnabled:YES];
        if (![selectedFacility isEqual:value]) {
            selectedFacility = value;
            selectedLocation = nil;
            [_txtLocation setText:@""];
            [self fetchLocation];
        }
    }
    else if ([sender isEqual:_txtLocation]) {
        selectedLocation = value;
    }
    [sender setText:[value valueForKey:@"name"]];
}





@end
