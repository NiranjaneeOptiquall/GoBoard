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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"type", REQUIRED_TYPE_EMPLOYEE];
    NSArray *fields = [[_reportSetupInfo.requiredFields allObjects] filteredArrayUsingPredicate:predicate];
    NSArray *aryEmpFields = [fields valueForKeyPath:@"name"];
    
    if (![self validateFirstSection]) {
        return;
    }
    else if (![thirdSection isThirdSectionValidationSuccess]) {
        return;
    }
    else if (![finalSection isFinalSectionValidationSuccessWith:aryEmpFields]) {
        return;
    }
    
    NSDictionary *request = [self createSubmitRequest];
    [gblAppDelegate callWebService:ACCIDENT_REPORT_POST parameters:request httpMethod:[SERVICE_HTTP_METHOD objectForKey:ACCIDENT_REPORT_POST] complition:^(NSDictionary *response) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:@"Accident Report has been submitted successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    } failure:^(NSError *error, NSDictionary *response) {
        [self saveAccidentReportToLocal:request];
    }];
}

- (NSDictionary*)createSubmitRequest {
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *incidentDate = [aFormatter dateFromString:_txtDateOfIncident.text];
    //    NSDate *managementFollowupDate = [aFormatter dateFromString:_txtManagementFollowUp.text];
    [aFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *astrAccidentDate = [NSString stringWithFormat:@"%@ %@", [aFormatter stringFromDate:incidentDate], _txtTimeOfIncident.text];
    
    
    
    //    "ReportFilerAccount": "sample string 11",
    NSMutableArray *personList = [NSMutableArray array];
    for (AccidentFirstSection *view in _vwFirstSection.subviews) {
        if ([view isKindOfClass:[AccidentFirstSection class]]) {
            [personList addObject:[view getAccidentPerson]];
        }
    }
    
    NSMutableArray *mutArrEmergency = [NSMutableArray array];
    for (EmergencyPersonnelView *vwEmergency in thirdSection.mutArrEmergencyViews) {
        NSDictionary *aDict = @{@"FirstName":vwEmergency.txtFirstName.trimText, @"MiddleInitial":vwEmergency.txtMI.trimText, @"LastName":vwEmergency.txtLastName.trimText, @"Phone":vwEmergency.txtPhone.text, @"AdditionalInformation":vwEmergency.txvAdditionalInfo.text, @"CaseNumber":vwEmergency.txtCaseNo.trimText, @"BadgeNumber":vwEmergency.txtBadge.trimText, @"Time911Called":vwEmergency.txtTime911Called.text, @"ArrivalTime":vwEmergency.txtTimeOfArrival.text, @"DepartureTime":vwEmergency.txtTimeOfDeparture.text};
        [mutArrEmergency addObject:aDict];
    }
    NSMutableArray *mutArrWitness = [NSMutableArray array];
    for (WitnessView *vwWitness in finalSection.mutArrWitnessViews) {
        NSDictionary *aDict = @{@"FirstName":vwWitness.txtWitnessFName.trimText, @"MiddleInitial":vwWitness.txtWitnessMI.trimText, @"LastName":vwWitness.txtWitnessLName.trimText, @"HomePhone":vwWitness.txtWitnessHomePhone.text, @"AlternatePhone":vwWitness.txtWitnessAlternatePhone.text, @"Email":vwWitness.txtWitnessEmailAddress.text, @"IncidentDescription":vwWitness.txvDescIncident.text};
        [mutArrWitness addObject:aDict];
    }
    
    NSDictionary *aDict = @{@"AccidentDate":astrAccidentDate, @"FacilityId":selectedFacility.value, @"LocationId":selectedLocation.value, @"AccidentDescription":_txvDescription.text, @"IsNotificationField1Selected":(_btn911Called.isSelected) ? @"true":@"false", @"IsNotificationField2Selected":(_btnPoliceCalled.isSelected) ? @"true":@"false", @"IsNotificationField3Selected":(_btnManager.isSelected) ? @"true":@"false",@"IsNotificationField4Selected":(_btnNone.isSelected) ? @"true":@"false", @"EmployeeFirstName":finalSection.txtEmpFName.trimText, @"EmployeeMiddleInitial":finalSection.txtEmpMI.trimText, @"EmployeeLastName":finalSection.txtEmpLName.trimText, @"EmployeeHomePhone":finalSection.txtEmpHomePhone.text, @"EmployeeAlternatePhone":finalSection.txtEmpAlternatePhone.text, @"EmployeeEmail":finalSection.txtEmpEmailAddr.text, @"AdditionalInformation":finalSection.txvAdditionalInformation.text, @"IsAdministrationAlertSelected":(finalSection.btnAdmin.isSelected)?@"true":@"false", @"IsSupervisorAlertSelected":(finalSection.btnSupervisers.isSelected)?@"true":@"false", @"IsRiskManagementAlertSelected":(finalSection.btnRiskManagement.isSelected)?@"true":@"false", @"PersonsInvolved":personList, @"EmergencyPersonnel":mutArrEmergency, @"Witnesses":mutArrWitness};
    return aDict;
}

- (void)saveAccidentReportToLocal:(NSDictionary*)aDict {
    
    
    AccidentReportSubmit *aReport = [NSEntityDescription insertNewObjectForEntityForName:@"AccidentReportSubmit" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    
    aReport.dateOfIncident = [aDict objectForKey:@"AccidentDate"];
    aReport.facilityId = [aDict objectForKey:@"FacilityId"];
    aReport.locationId = [aDict objectForKey:@"LocationId"];
    aReport.accidentDesc = [aDict objectForKey:@"AccidentDescription"];
    aReport.isNotification1Selected = [aDict objectForKey:@"IsNotificationField1Selected"];
    aReport.isNotification2Selected = [aDict objectForKey:@"IsNotificationField2Selected"];
    aReport.isNotification3Selected = [aDict objectForKey:@"IsNotificationField3Selected"];
    aReport.isNotification4Selected = [aDict objectForKey:@"IsNotificationField4Selected"];
    NSMutableSet *personSet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"PersonsInvolved"]) {
        AccidentPerson *aPerson = [self getPersonFromDict:dict];
        aPerson.accidentInfo = aReport;
        [personSet addObject:aPerson];
    }
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
        aEmergencyPersonnel.accidentInfo = aReport;
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
        aWitness.accidentInfo = aReport;
        [witnessSet addObject:aWitness];
    }
    aReport.witnesses = witnessSet;
    
    aReport.employeeFirstName = [aDict objectForKey:@"EmployeeFirstName"];
    aReport.employeeMiddleInitial = [aDict objectForKey:@"EmployeeMiddleInitial"];
    aReport.employeeLastName = [aDict objectForKey:@"EmployeeLastName"];
    aReport.employeeHomePhone = [aDict objectForKey:@"EmployeeHomePhone"];
    aReport.employeeAlternatePhone = [aDict objectForKey:@"EmployeeAlternatePhone"];
    aReport.employeeEmail = [aDict objectForKey:@"EmployeeEmail"];
#warning //    aReport.reportFilerAccount = finalSection.txt.text;
    //    aReport.managementFollowUpDate = [aFormatter stringFromDate:managementFollowupDate];
    //    aReport.followUpCallType = @"";
    aReport.additionalInfo = [aDict objectForKey:@"AdditionalInformation"];
    //    aReport.com
    [gblAppDelegate.managedObjectContext insertedObjects];
    [gblAppDelegate.managedObjectContext save:nil];
}

- (AccidentPerson *)getPersonFromDict:(NSDictionary *)dict {
    AccidentPerson *aPerson = [NSEntityDescription insertNewObjectForEntityForName:@"AccidentPerson" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    
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
    aPerson.memberId = ([[dict objectForKey:@"PersonTypeId"] integerValue] == 3) ? [dict objectForKey:@"EmployeeId"] : [dict objectForKey:@"MemberId"];
    aPerson.dateOfBirth = [dict objectForKey:@"DateOfBirth"];
    aPerson.firstAidFirstName = [dict objectForKey:@"FirstAidFirstName"];
    aPerson.firstAidMiddleInitial = [dict objectForKey:@"FirstAidMiddleInitial"];
    aPerson.firstAidLastName = [dict objectForKey:@"FirstAidLastName"];
    aPerson.firstAidPosition = [dict objectForKey:@"FirstAidPosition"];
    aPerson.affiliationTypeID = [dict objectForKey:@"AffiliationTypeId"];
    aPerson.genderTypeID = [dict objectForKey:@"GenderTypeId"];
    aPerson.personTypeID = [dict objectForKey:@"PersonTypeId"];
    aPerson.guestOfFirstName = [dict objectForKey:@"GuestOfFirstName"];
    aPerson.guestOfMiddleInitial = [dict objectForKey:@"GuestOfMiddleInitial"];
    aPerson.guestOfLastName = [dict objectForKey:@"GuestOfLastName"];
    aPerson.minor = [dict objectForKey:@"IsMinor"];
    aPerson.activityTypeID = [dict objectForKey:@"ActivityTypeId"];
    aPerson.equipmentTypeID = [dict objectForKey:@"EquipmentTypeId"];
    aPerson.conditionTypeID = [dict objectForKey:@"ConditionId"];
    aPerson.careProvidedBy = [dict objectForKey:@"CareProvidedById"];
    if (![[dict objectForKey:@"PersonPhoto"] isEqualToString:@""])
        aPerson.personPhoto = [[dict objectForKey:@"PersonPhoto"] base64EncodedDataWithOptions:0];
    if (![[dict objectForKey:@"PersonSignature"] isEqualToString:@""])
        aPerson.participantSignature = [[dict objectForKey:@"PersonSignature"] base64EncodedDataWithOptions:0];
    
    aPerson.participantName = [dict objectForKey:@"PersonName"];
    aPerson.bloodBornePathogenType = [dict objectForKey:@"BloodbornePathogenTypeId"];
    aPerson.staffMemberWrittenAccount = [dict objectForKey:@"StaffMemberWrittenAccount"];
    aPerson.wasBloodPresent = [dict objectForKey:@"WasBloodOrBodilyFluidPresent"];
    aPerson.bloodCleanUpRequired = [dict objectForKey:@"WasBloodCleanupRequired"];
    aPerson.wasExposedToBlood = [dict objectForKey:@"WasCaregiverExposedToBlood"];
    
    NSMutableSet *injuryList = [NSMutableSet set];
    for (NSDictionary *aDict in [dict objectForKey:@"Injuries"]) {
        InjuryDetail *aInjury = [NSEntityDescription insertNewObjectForEntityForName:@"InjuryDetail" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        aInjury.natureId = [aDict objectForKey:@"NatureId"];
        aInjury.generalInjuryTypeId = [aDict objectForKey:@"GeneralInjuryTypeId"];
        aInjury.generalInjuryOther = [aDict objectForKey:@"GeneralInjuryOther"];
        aInjury.bodyPartInjuryTypeId = [aDict objectForKey:@"BodyPartInjuryTypeId"];
        aInjury.bodyPartInjuredId = [aDict objectForKey:@"BodyPartInjuredId"];
        aInjury.actionTakenId = [aDict objectForKey:@"ActionTakenId"];
        aInjury.accidentPerson = aPerson;
        [injuryList addObject:aInjury];
    }
    aPerson.injuryList = injuryList;
    return aPerson;
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


#pragma mark - Methods

- (void)addAccidentView {
    AccidentFirstSection *accidentView = (AccidentFirstSection*)[[[NSBundle mainBundle] loadNibNamed:@"AccidentFirstSection" owner:self options:nil] firstObject];
    accidentView.isCaptureCameraVisible = [_reportSetupInfo.showPhotoIcon boolValue];
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
    finalSection.parentVC = self;
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
