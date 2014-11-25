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
    if (![reportSetupInfo.showPhotoIcon boolValue]) {
        [_btnCapturePerson setHidden:YES];
    }
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
    return;
    Report *aReport = [NSEntityDescription insertNewObjectForEntityForName:@"Report" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *incidentDate = [aFormatter dateFromString:_txtDateOfIncident.text];
    NSDate *managementFollowupDate = [aFormatter dateFromString:_txtManagementFollowUp.text];
    [aFormatter setDateFormat:@"yyyy-MM-dd"];
    aReport.dateOfIncident = [NSString stringWithFormat:@"%@ %@", [aFormatter stringFromDate:incidentDate], _txtTimeOfIncident.text];
    aReport.facilityId = selectedFacility.value;
    aReport.locationId = selectedLocation.value;
    aReport.incidentDesc = _txvIncidentDesc.text;
    aReport.isNotification1Selected = (_btn911Called.isSelected) ? @"true":@"false";
    aReport.isNotification2Selected = (_btnPoliceCalled.isSelected) ? @"true":@"false";
    aReport.isNotification3Selected = (_btnManager.isSelected) ? @"true":@"false";
    aReport.isNotification4Selected = (_btnNone.isSelected) ? @"true":@"false";
//    aReport.personPhoto =
    NSMutableSet *personSet = [NSMutableSet set];
    for (IncidentPersonalInformation *vwPerson in mutArrIncidentPerson) {
        Person *aPerson = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        aPerson.firstName = vwPerson.txtFirstName.text;
        aPerson.memberId = vwPerson.txtMemberId.text;
        aPerson.employeeTitle = vwPerson.txtEmployeePosition.text;
        aPerson.personTypeID = vwPerson.strPersonInvolved;
        aPerson.affiliationTypeID = vwPerson.strAffiliationType;
        aPerson.middleInitial = vwPerson.txtMi.text;
        aPerson.lastName = vwPerson.txtLastName.text;
        aPerson.streetAddress = vwPerson.txtStreetAddress.text;
        aPerson.apartmentNumber = vwPerson.txtAppartment.text;
        aPerson.city = vwPerson.txtCity.text;
        aPerson.state = vwPerson.txtState.text;
        aPerson.zip = vwPerson.txtZip.text;
        aPerson.primaryPhone = vwPerson.txtHomePhone.text;
        aPerson.alternatePhone = vwPerson.txtAlternatePhone.text;
        aPerson.email = vwPerson.txtEmailAddress.text;
        aPerson.dateOfBirth = vwPerson.txtDob.text;
        aPerson.guestOfFirstName = vwPerson.txtGuestFName.text;
        aPerson.guestOfMiddleInitial = vwPerson.txtGuestMI.text;
        aPerson.guestOfLastName = vwPerson.txtguestLName.text;
        aPerson.genderTypeID = vwPerson.strGenderType;
        aPerson.minor = (vwPerson.btnMinor.isSelected) ? @"true" : @"false";
        aPerson.duringWorkHours = (vwPerson.btnEmployeeOnWork.isSelected) ? @"true" : @"false";
        aPerson.report = aReport;
        [personSet addObject:aPerson];
    }
    aReport.persons = personSet;
    if (imgIncidentPerson) {
        aReport.personPhoto = UIImageJPEGRepresentation(imgIncidentPerson, 1.0);
    }
    
    NSMutableSet *emergencySet = [NSMutableSet set];
    for (EmergencyPersonnelView *vwEmergency in mutArrEmergencyPersonnel) {
        EmergencyPersonnel *aEmergencyPersonnel = [NSEntityDescription insertNewObjectForEntityForName:@"EmergencyPersonnel" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        aEmergencyPersonnel.time911Called = vwEmergency.txtTime911Called.text;
        aEmergencyPersonnel.time911Arrival = vwEmergency.txtTimeOfArrival.text;
        aEmergencyPersonnel.time911Departure = vwEmergency.txtTimeOfDeparture.text;
        aEmergencyPersonnel.caseNumber = vwEmergency.txtCaseNo.text;
        aEmergencyPersonnel.firstName = vwEmergency.txtFirstName.text;
        aEmergencyPersonnel.middileInitial = vwEmergency.txtMI.text;
        aEmergencyPersonnel.lastName = vwEmergency.txtLastName.text;
        aEmergencyPersonnel.phone = vwEmergency.txtPhone.text;
        aEmergencyPersonnel.badgeNumber = vwEmergency.txtBadge.text;
        aEmergencyPersonnel.additionalInformation = vwEmergency.txvAdditionalInfo.text;
        aEmergencyPersonnel.report = aReport;
        [emergencySet addObject:aEmergencyPersonnel];
    }
    aReport.emergencyPersonnels = emergencySet;
    
    NSMutableSet *witnessSet = [NSMutableSet set];
    for (WitnessView *vwWitness in mutArrWitnessView) {
        Witness *aWitness = [NSEntityDescription insertNewObjectForEntityForName:@"Witness" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        aWitness.firstName = vwWitness.txtWitnessFName.text;
        aWitness.middleInitial = vwWitness.txtWitnessMI.text;
        aWitness.lastName = vwWitness.txtWitnessLName.text;
        aWitness.homePhone = vwWitness.txtWitnessHomePhone.text;
        aWitness.alternatePhone = vwWitness.txtWitnessAlternatePhone.text;
        aWitness.email = vwWitness.txtWitnessEmailAddress.text;
        aWitness.witnessWrittenAccount = vwWitness.txvDescIncident.text;
        aWitness.report = aReport;
        [witnessSet addObject:aWitness];
    }
    aReport.witnesses = witnessSet;
    
    aReport.employeeFirstName = _txtEmpFName.text;
    aReport.employeeMiddleInitial = _txtEmpMI.text;
    aReport.employeeLastName = _txtEmpLName.text;
    aReport.employeeHomePhone = _txtEmpHomePhone.text;
    aReport.employeeAlternatePhone = _txtEmpAlternatePhone.text;
    aReport.employeeEmail = _txtEmpEmail.text;
    aReport.reportFilerAccount = _txtReportAccount.text;
    aReport.managementFollowUpDate = [aFormatter stringFromDate:managementFollowupDate];
    aReport.followUpCallType = @"";
    aReport.additionalInfo = _txvAdditionalInfo.text;
    [gblAppDelegate.managedObjectContext insertedObjects];
    [gblAppDelegate.managedObjectContext save:nil];
}

- (IBAction)btnCapturePersonPic:(UIButton*)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Capture Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Library", @"Camera", nil];
    CGRect rect = [_vwAfterPersonalInfo convertRect:sender.frame toView:self.view];
    [actionSheet showFromRect:rect inView:self.view animated:YES];
    _isUpdate = YES;
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


#pragma mark - Methods



- (void)addIncidentPersonalInformationViews {
    IncidentPersonalInformation *personalInfoView = (IncidentPersonalInformation*)[[[NSBundle mainBundle] loadNibNamed:@"IncidentPersonalInformation" owner:self options:nil] firstObject];
    personalInfoView.isAffiliationVisible = [reportSetupInfo.showAffiliation boolValue];
    personalInfoView.isMemberIdVisible = [reportSetupInfo.showMemberIdAndDriverLicense boolValue];
    personalInfoView.isDOBVisible = [reportSetupInfo.showDateOfBirth boolValue];
    personalInfoView.isGenderVisible = [reportSetupInfo.showGender boolValue];
    personalInfoView.isMinorVisible = [reportSetupInfo.showMinor boolValue];
    personalInfoView.isMinorVisible = [reportSetupInfo.showEmployeeId boolValue];
    [personalInfoView callInitialActions];
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
    else if ([_txtActivity isTextFieldBlank]) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if ([reportSetupInfo.showConditions boolValue] && ([_txtWeather isTextFieldBlank] || [_txtEquipment isTextFieldBlank])) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"type", REQUIRED_TYPE_PERSON];
    NSArray *fields = [[reportSetupInfo.requiredFields allObjects] filteredArrayUsingPredicate:predicate];
    NSArray *aryFields = [fields valueForKeyPath:@"name"];
    for (IncidentPersonalInformation *person in mutArrIncidentPerson) {
        if (![person isPersonalInfoValidationSuccessFor:aryFields]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)validateEmergencyPersonnel {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"type", REQUIRED_TYPE_EMERGENCY];
    NSArray *fields = [[reportSetupInfo.requiredFields allObjects] filteredArrayUsingPredicate:predicate];
    NSArray *aryFields = [fields valueForKeyPath:@"name"];
    for (EmergencyPersonnelView *emergency in mutArrEmergencyPersonnel) {
        if (![emergency isEmergencyPersonnelValidationSucceedFor:aryFields]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)validateWitnessView {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"type", REQUIRED_TYPE_WITNESS];
    NSArray *fields = [[reportSetupInfo.requiredFields allObjects] filteredArrayUsingPredicate:predicate];
    NSArray *aryFields = [fields valueForKeyPath:@"name"];
    for (WitnessView *witness in mutArrWitnessView) {
        if (![witness isWitnessViewValidationSuccessFor:aryFields]) {
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

- (void)showPhotoLibrary {
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imgPicker setDelegate:self];
    [imgPicker setAllowsEditing:YES];
    popOver = [[UIPopoverController alloc] initWithContentViewController:imgPicker];
    [popOver setPopoverContentSize:CGSizeMake(320, 480)];
    [popOver setDelegate:self];
    CGRect rect = [_vwAfterPersonalInfo convertRect:_btnCapturePerson.frame toView:self.view];
    [popOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)showCamera {
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [imgPicker setDelegate:self];
    [imgPicker setAllowsEditing:YES];
    [gblAppDelegate.navigationController presentViewController:imgPicker animated:YES completion:^{
        
    }];
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

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (buttonIndex == 0) {
            [self showPhotoLibrary];
        }
        else if (buttonIndex == 1) {
            [self showCamera];
        }
    }];
}

#pragma mark - UIPopOverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    popOver = nil;
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    imgIncidentPerson = [info objectForKey:UIImagePickerControllerEditedImage];
    if (popOver) {
        [popOver dismissPopoverAnimated:YES];
    }
    else {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
        }];
    }
}



@end
