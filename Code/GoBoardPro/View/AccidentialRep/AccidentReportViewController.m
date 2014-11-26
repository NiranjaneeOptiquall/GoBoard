//
//  AccidentReportViewController.m
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "AccidentReportViewController.h"
#import "AccidentFirstSection.h"
#import "AccidentReportSubmit.h"
#import "AccidentPerson.h"
#import "InjuryDetail.h"
#import "Witness.h"
#import "EmergencyPersonnel.h"
#import "EmergencyPersonnelView.h"
#import "WitnessView.h"


@interface AccidentReportViewController ()

@end

@implementation AccidentReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mutArrAccidentViews = [[NSMutableArray alloc] init];
    [_txtLocation setEnabled:NO];
    [self fetchAccidentReportSetupInfo];
    [self fetchFacilities];
    [self btnNotificationTapped:_btnNone];
    [self addViews];
    _isUpdate = NO;
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - CoreData Methods

- (void)fetchAccidentReportSetupInfo {
    NSFetchRequest *aRequest = [[NSFetchRequest alloc] initWithEntityName:@"AccidentReportInfo"];
    NSArray *aryRecords = [gblAppDelegate.managedObjectContext executeFetchRequest:aRequest error:nil];
    _reportSetupInfo = [aryRecords firstObject];
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

- (void)viewSetup {
    [_btn911Called setTitle:_reportSetupInfo.notificationField1 forState:UIControlStateNormal];
    [_btnPoliceCalled setTitle:_reportSetupInfo.notificationField2 forState:UIControlStateNormal];
    [_btnManager setTitle:_reportSetupInfo.notificationField3 forState:UIControlStateNormal];
    [_btnNone setTitle:_reportSetupInfo.notificationField4 forState:UIControlStateNormal];
    _lblInstruction.text = _reportSetupInfo.instructions;
    if (![_reportSetupInfo.showPhotoIcon boolValue]) {
        [_btnCaptureImage setHidden:YES];
    }
}

#pragma mark - Navigation



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    _isUpdate = YES;
    if ([object isKindOfClass:[AccidentFirstSection class]]) {
        NSInteger index = [_vwFirstSection.subviews indexOfObject:object];
        CGRect frame = [object frame];
        for (NSInteger i = index + 1; i < [_vwFirstSection.subviews count]; i++) {
            UIView *view = [_vwFirstSection.subviews objectAtIndex:i];
            CGRect newFrame = view.frame;
            newFrame.origin.y = CGRectGetMaxY(frame);
            view.frame = newFrame;
            frame = newFrame;
        }
        CGRect newFrame = _vwFirstSection.frame;
        newFrame.size.height = CGRectGetMaxY(frame);
        _vwFirstSection.frame = newFrame;
        float nextY = CGRectGetMaxY(_vwFirstSection.frame);
        if (thirdSection) {
            frame = thirdSection.frame;
            frame.origin.y = CGRectGetMaxY(_vwFirstSection.frame);
            thirdSection.frame = frame;
            nextY = CGRectGetMaxY(thirdSection.frame);
        }
        
        
        frame = finalSection.frame;
        frame.origin.y = nextY;
        finalSection.frame = frame;
    }
    else if ([object isEqual:_vwFirstSection]) {
        float nextY = CGRectGetMaxY(_vwFirstSection.frame);
        CGRect frame = CGRectZero;
        if (thirdSection) {
            frame = thirdSection.frame;
            frame.origin.y = CGRectGetMaxY(_vwFirstSection.frame);
            thirdSection.frame = frame;
            nextY = CGRectGetMaxY(thirdSection.frame);
        }
        frame = finalSection.frame;
        frame.origin.y = nextY;
        finalSection.frame = frame;
    }
    else if ([object isEqual:thirdSection]) {
        CGRect frame = finalSection.frame;
        frame.origin.y = CGRectGetMaxY(thirdSection.frame);
        finalSection.frame = frame;
    }
    CGRect frame = finalSection.frame;
    [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
}

#pragma mark - IBActions & Selectors

- (IBAction)btnNotificationTapped:(UIButton *)sender {
//    [_btn911Called setSelected:NO];
//    [_btnPoliceCalled setSelected:NO];
//    [_btnManager setSelected:NO];
//    [_btnNone setSelected:NO];
    [sender setSelected:!sender.isSelected];
    _isUpdate = YES;
}

- (void)btnFinalSubmitTapped:(id)sender {
    if ([_txtDateOfIncident isTextFieldBlank] || [_txtTimeOfIncident isTextFieldBlank] || [_txtFacility isTextFieldBlank] || [_txtLocation isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        return;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"type", REQUIRED_TYPE_EMERGENCY];
    NSArray *fields = [[_reportSetupInfo.requiredFields allObjects] filteredArrayUsingPredicate:predicate];
    NSArray *aryEmergencyFields = [fields valueForKeyPath:@"name"];
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"type", REQUIRED_TYPE_WITNESS];
    NSArray *fields1 = [[_reportSetupInfo.requiredFields allObjects] filteredArrayUsingPredicate:predicate1];
    NSArray *aryWitnessFields = [fields1 valueForKeyPath:@"name"];
    
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"type", REQUIRED_TYPE_EMPLOYEE];
    NSArray *fields2 = [[_reportSetupInfo.requiredFields allObjects] filteredArrayUsingPredicate:predicate2];
    NSArray *aryEmpFields = [fields2 valueForKeyPath:@"name"];
    
    if (![self validateFirstSection]) {
        return;
    }
    else if (![thirdSection isThirdSectionValidationSuccessWith:aryEmergencyFields]) {
        return;
    }
    else if (![finalSection isFinalSectionValidationSuccessWith:aryWitnessFields emp:aryEmpFields]) {
        return;
    }
}

- (void)saveAccidentReportToLocal {
    AccidentReportSubmit *aReport = [NSEntityDescription insertNewObjectForEntityForName:@"AccidentReportSubmit" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *incidentDate = [aFormatter dateFromString:_txtDateOfIncident.text];
//    NSDate *managementFollowupDate = [aFormatter dateFromString:_txtManagementFollowUp.text];
    [aFormatter setDateFormat:@"yyyy-MM-dd"];
    aReport.dateOfIncident = [NSString stringWithFormat:@"%@ %@", [aFormatter stringFromDate:incidentDate], _txtTimeOfIncident.text];
    aReport.facilityId = selectedFacility.value;
    aReport.locationId = selectedLocation.value;
    aReport.desc = _txvDescription.text;
    aReport.isNotification1Selected = (_btn911Called.isSelected) ? @"true":@"false";
    aReport.isNotification2Selected = (_btnPoliceCalled.isSelected) ? @"true":@"false";
    aReport.isNotification3Selected = (_btnManager.isSelected) ? @"true":@"false";
    aReport.isNotification4Selected = (_btnNone.isSelected) ? @"true":@"false";
    NSMutableSet *personSet = [NSMutableSet set];
    for (AccidentFirstSection *view in _vwFirstSection.subviews) {
        if ([view isKindOfClass:[AccidentFirstSection class]]) {
            AccidentPerson *aPerson = [view getAccidentPerson];
            aPerson.accidentInfo = aReport;
            [personSet addObject:aPerson];
        }
    }
    NSMutableSet *emergencySet = [NSMutableSet set];
    for (EmergencyPersonnelView *vwEmergency in thirdSection.mutArrEmergencyViews) {
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
        aEmergencyPersonnel.accidentInfo = aReport;
        [emergencySet addObject:aEmergencyPersonnel];
    }
    aReport.emergencyPersonnels = emergencySet;
    
    NSMutableSet *witnessSet = [NSMutableSet set];
    for (WitnessView *vwWitness in finalSection.mutArrWitnessViews) {
        Witness *aWitness = [NSEntityDescription insertNewObjectForEntityForName:@"Witness" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        aWitness.firstName = vwWitness.txtWitnessFName.text;
        aWitness.middleInitial = vwWitness.txtWitnessMI.text;
        aWitness.lastName = vwWitness.txtWitnessLName.text;
        aWitness.homePhone = vwWitness.txtWitnessHomePhone.text;
        aWitness.alternatePhone = vwWitness.txtWitnessAlternatePhone.text;
        aWitness.email = vwWitness.txtWitnessEmailAddress.text;
        aWitness.witnessWrittenAccount = vwWitness.txvDescIncident.text;
        aWitness.accidentInfo = aReport;
        [witnessSet addObject:aWitness];
    }
    aReport.witnesses = witnessSet;
    
    aReport.employeeFirstName = finalSection.txtEmpFName.text;
    aReport.employeeMiddleInitial = finalSection.txtEmpMI.text;
    aReport.employeeLastName = finalSection.txtEmpLName.text;
    aReport.employeeHomePhone = finalSection.txtEmpHomePhone.text;
    aReport.employeeAlternatePhone = finalSection.txtEmpAlternatePhone.text;
    aReport.employeeEmail = finalSection.txtEmpEmailAddr.text;
#warning //    aReport.reportFilerAccount = finalSection.txt.text;
//    aReport.managementFollowUpDate = [aFormatter stringFromDate:managementFollowupDate];
//    aReport.followUpCallType = @"";
    aReport.additionalInfo = finalSection.txvAdditionalInformation.text;
//    aReport.com
    [gblAppDelegate.managedObjectContext insertedObjects];
    [gblAppDelegate.managedObjectContext save:nil];
}

- (BOOL)validateFirstSection {
    BOOL isSuccess = YES;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"type", REQUIRED_TYPE_PERSON];
    NSArray *fields = [[_reportSetupInfo.requiredFields allObjects] filteredArrayUsingPredicate:predicate];
    NSArray *aryFields = [fields valueForKeyPath:@"name"];
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"type", REQUIRED_TYPE_FIRST_AID];
    NSArray *fields1 = [[_reportSetupInfo.requiredFields allObjects] filteredArrayUsingPredicate:predicate1];
    NSArray *aryAidFields = [fields1 valueForKeyPath:@"name"];
    for (AccidentFirstSection *view in _vwFirstSection.subviews) {
        if ([view isKindOfClass:[AccidentFirstSection class]]) {
            isSuccess = [view validateAccidentFirstSectionWith:aryFields firstAidFields:aryAidFields];
            if (!isSuccess) {
                break;
            }
        }
    }
    return isSuccess;
}

- (IBAction)btnAddMoreBodilyFluidTapped:(id)sender {
    _isUpdate = YES;
    [self addAccidentView];
}

- (IBAction)btnBackTapped:(id)sender {
    [self.view endEditing:YES];
    if (_isUpdate) {
        [[[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:@"Do you want to save your information? If you press “Back” you will lose all entered information, do you want to proceed?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil] show];
    }
    else {
        [self removeObservers];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)removeObservers {
    for (AccidentFirstSection *vw in _vwFirstSection.subviews) {
        if ([vw isKindOfClass:[AccidentFirstSection class]]) {
            [vw removeObserver:self forKeyPath:@"frame"];
            [vw.vwBodyPartInjury removeObserver:vw forKeyPath:@"frame"];
            [vw.vwBodyPartInjury removeObserver:vw forKeyPath:@"careProvided"];
            [vw.vwBodilyFluid removeObserver:vw forKeyPath:@"frame"];
            [vw.vwPersonalInfo removeObserver:vw forKeyPath:@"frame"];
        }
    }
    [thirdSection removeObserver:self forKeyPath:@"frame"];
    [finalSection removeObserver:self forKeyPath:@"frame"];
}

- (IBAction)btnAttachPhotoTapped:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Capture Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Library", @"Camera", nil];
    CGRect rect = [_vwAddMoreFirstSection convertRect:sender.frame toView:_vwFirstSection];
    rect = [_vwFirstSection convertRect:rect toView:self.view];
    [actionSheet showFromRect:rect inView:self.view animated:YES];
}

#pragma mark - Methods

- (void)showPhotoLibrary {
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imgPicker setDelegate:self];
    [imgPicker setAllowsEditing:YES];
    popOver = [[UIPopoverController alloc] initWithContentViewController:imgPicker];
    [popOver setPopoverContentSize:CGSizeMake(320, 480)];
    [popOver setDelegate:self];
    [popOver presentPopoverFromRect:_btnCaptureImage.frame inView:_btnCaptureImage.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)showCamera {
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [imgPicker setDelegate:self];
    [imgPicker setAllowsEditing:YES];
    [gblAppDelegate.navigationController presentViewController:imgPicker animated:YES completion:^{

    }];
}

- (void)addAccidentView {
    AccidentFirstSection *accidentView = (AccidentFirstSection*)[[[NSBundle mainBundle] loadNibNamed:@"AccidentFirstSection" owner:self options:nil] firstObject];
    
    accidentView.vwPersonalInfo.isAffiliationVisible = [_reportSetupInfo.showAffiliation boolValue];
    accidentView.vwPersonalInfo.isMemberIdVisible = [_reportSetupInfo.showMemberIdAndDriverLicense boolValue];
    accidentView.vwPersonalInfo.isDOBVisible = [_reportSetupInfo.showDateOfBirth boolValue];
    accidentView.vwPersonalInfo.isGenderVisible = [_reportSetupInfo.showGender boolValue];
    accidentView.vwPersonalInfo.isMinorVisible = [_reportSetupInfo.showMinor boolValue];
    accidentView.vwPersonalInfo.isMinorVisible = [_reportSetupInfo.showEmployeeId boolValue];
    accidentView.vwPersonalInfo.isConditionsVisible = [_reportSetupInfo.showConditions boolValue];
    [accidentView.vwPersonalInfo callInitialActions];
    accidentView.vwBodilyFluid.isBloodBornePathogenVisible = [_reportSetupInfo.showBloodbornePathogens boolValue];
    accidentView.vwBodilyFluid.isRefuseCareStatementVisible = [_reportSetupInfo.showRefusedSelfCareText boolValue];
    accidentView.vwBodilyFluid.isParticipantSignatureVisible = [_reportSetupInfo.showParticipantSignature boolValue];
    accidentView.vwBodilyFluid.lblRefuseCareText.text = _reportSetupInfo.refusedCareStatement;
    accidentView.parentVC = self;
    CGRect frame = accidentView.frame;
    frame.origin.y = CGRectGetMaxY([[mutArrAccidentViews lastObject] frame]);
    totalAccidentFirstSectionCount++;
    accidentView.frame = frame;
    [accidentView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [_vwFirstSection addSubview:accidentView];
    [mutArrAccidentViews addObject:accidentView];
    frame = _vwFirstSection.frame;
    frame.size.height = CGRectGetMaxY(accidentView.frame) + _vwAddMoreFirstSection.frame.size.height;
    _vwFirstSection.frame = frame;
    frame = _vwAddMoreFirstSection.frame;
    frame.origin.y = CGRectGetMaxY(accidentView.frame);
    _vwAddMoreFirstSection.frame = frame;
    [_vwFirstSection bringSubviewToFront:_vwAddMoreFirstSection];
    if (thirdSection) {
        frame = thirdSection.frame;
        frame.origin.y = CGRectGetMaxY(_vwFirstSection.frame);
        thirdSection.frame = frame;
        frame = finalSection.frame;
        frame.origin.y = CGRectGetMaxY(thirdSection.frame);
        finalSection.frame = frame;
        [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
    }
    
}

- (void)addViews {
    [self addAccidentView];
    CGRect frame;
    if ([_reportSetupInfo.showEmergencyPersonnel boolValue]) {
        thirdSection = (ThirdSection*)[[[NSBundle mainBundle] loadNibNamed:@"ThirdSection" owner:self options:nil] firstObject];
        CGRect frame = thirdSection.frame;
        frame.origin.y = CGRectGetMaxY(_vwFirstSection.frame);
        thirdSection.frame = frame;
        [_scrlMainView addSubview:thirdSection];
        [thirdSection addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
        
    }
    
    
    finalSection = (FinalSection*)[[[NSBundle mainBundle] loadNibNamed:@"FinalSection" owner:self options:nil] firstObject];
    [finalSection setBackgroundColor:[UIColor clearColor]];
    frame = finalSection.frame;
    if ([_reportSetupInfo.showEmergencyPersonnel boolValue]) {
        frame.origin.y = CGRectGetMaxY(thirdSection.frame);
    }
    else {
        frame.origin.y = CGRectGetMaxY(_vwFirstSection.frame);
    }
    finalSection.frame = frame;
    [_scrlMainView addSubview:finalSection];
    [finalSection addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    finalSection.isCommunicationVisible = [_reportSetupInfo.showCommunicationAndNotification boolValue];
    finalSection.isManagementFollowUpVisible = [_reportSetupInfo.showManagementFollowup boolValue];
    [finalSection.btnFinalSubmit addTarget:self action:@selector(btnFinalSubmitTapped:) forControlEvents:UIControlEventTouchUpInside];
    [finalSection PersonInvolved:_personInvolved];
    [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
}

- (void)setPersonInvolved:(NSInteger)personInvolved {
    _personInvolved = personInvolved;
    BOOL isAtleastOneEmployee = NO;
    for (AccidentFirstSection *vw in _vwFirstSection.subviews) {
        if ([vw isKindOfClass:[AccidentFirstSection class]]) {
            isAtleastOneEmployee = [vw.vwPersonalInfo.btnEmployee isSelected];
            if (isAtleastOneEmployee) {
                break;
            }
        }
    }
    if (isAtleastOneEmployee) {
        [finalSection PersonInvolved:PERSON_EMPLOYEE];
    }
    else {
        [finalSection PersonInvolved:_personInvolved];
    }
}


//#pragma mark - UITableViewDatasource
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 5;
//}
//
//- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    return aCell;
//}
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
    imgBodilyFluid = [info objectForKey:UIImagePickerControllerEditedImage];
    if (popOver) {
        [popOver dismissPopoverAnimated:YES];
    }
    else {
        [gblAppDelegate.navigationController dismissViewControllerAnimated:YES completion:^{
        }];
    }
}


#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _isUpdate = YES;
    BOOL allowEditing = YES;
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
    return allowEditing;
}

- (void)setKeepViewInFrame:(UIView*)vw {
    CGPoint point = [vw.superview convertPoint:vw.frame.origin toView:_scrlMainView];
    if (point.y <_scrlMainView.contentOffset.y || point.y > _scrlMainView.contentOffset.y + _scrlMainView.frame.size.height) {
        [_scrlMainView setContentOffset:CGPointMake(_scrlMainView.contentOffset.x, point.y - 50) animated:NO];
    }
    
}

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


#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    _isUpdate = YES;
    [_lblIncidentDesc setHidden:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text length] == 0) {
        [_lblIncidentDesc setHidden:NO];
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self removeObservers];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
