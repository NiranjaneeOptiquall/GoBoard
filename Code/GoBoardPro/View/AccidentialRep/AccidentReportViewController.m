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
    [self viewSetup];
//    [self btnNotificationTapped:_btnNone];
    [self addViews];
    _isUpdate = NO;
    [self fetchIncompleteReportIfAny];
}

- (void)fetchIncompleteReportIfAny {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AccidentReportSubmit"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userId MATCHES[cd] %@) AND isCompleted = 0", [[User currentUser] userId]];
    [request setPredicate:predicate];
    AccidentReportSubmit *aReport = [[gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil] firstObject];
    if (aReport) {
        _isUpdate = YES;
        [self PopulateIncompleteData:aReport];
        [gblAppDelegate.managedObjectContext deleteObject:aReport];
        [gblAppDelegate.managedObjectContext save:nil];
    }
    
    
}

- (void)PopulateIncompleteData:(AccidentReportSubmit*)aReport {
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    
    [aFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    [aFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *aAccidentDate = [aFormatter dateFromString:aReport.dateOfIncident];
    [aFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
//    _txtTimeOfIncident.text = [mutArr componentsJoinedByString:@" "];
    
    [aFormatter setDateFormat:@"MM/dd/yyyy"];
    _txtDateOfIncident.text = [aFormatter stringFromDate:aAccidentDate];
    [aFormatter setDateFormat:@"hh:mm a"];
    _txtTimeOfIncident.text = [aFormatter stringFromDate:aAccidentDate];
    
    selectedFacility = [[aryFacilities filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"value MATCHES[cd] %@", aReport.facilityId]] firstObject];
    _txtFacility.text = selectedFacility.name;
    if (selectedFacility)
        [self fetchLocation];
    selectedLocation = [[aryLocation filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"value MATCHES[cd] %@", aReport.locationId]] firstObject];
    _txtLocation.text = selectedLocation.name;
    _txvDescription.text = aReport.accidentDesc;

    _btn911Called.selected = ([aReport.isNotification1Selected isEqualToString:@"true"]) ? YES : NO;
    _btnPoliceCalled.selected = ([aReport.isNotification2Selected isEqualToString:@"true"]) ? YES : NO;
    _btnManager.selected = ([aReport.isNotification3Selected isEqualToString:@"true"]) ? YES : NO;
    _btnNone.selected = ([aReport.isNotification4Selected isEqualToString:@"true"]) ? YES : NO;
    
    [self popolatePersonalInformation:aReport.accidentPerson.allObjects];
    [self populateEmergencyPersonnel:aReport.emergencyPersonnels.allObjects];
    [self populateWitness:aReport.witnesses.allObjects];
    finalSection.txtEmpFName.text = aReport.employeeFirstName;
    finalSection.txtEmpLName.text = aReport.employeeLastName;
    finalSection.txtEmpMI.text = aReport.employeeMiddleInitial;
    finalSection.txtEmpHomePhone.text = aReport.employeeHomePhone;
    finalSection.txtEmpAlternatePhone.text = aReport.employeeAlternatePhone;
    finalSection.txtEmpEmailAddr.text = aReport.employeeEmail;
    finalSection.txvReportFilerAccount.text = aReport.reportFilerAccount;
    finalSection.txvAdditionalInformation.text = aReport.additionalInfo;
}

- (void)popolatePersonalInformation:(NSArray*)aryPersonInfo {
    for (int i = 0; i < [aryPersonInfo count]; i++) {
        AccidentPerson *aPerson = aryPersonInfo[i];
        if (i > 0) {
            [self addAccidentView];
        }
        AccidentFirstSection *aFirstSection = nil;
        for (AccidentFirstSection *aView in _vwFirstSection.subviews) {
            if ([aView isKindOfClass:[AccidentFirstSection class]]) {
                aFirstSection = aView;
            }
        }
        
        PersonInformation *vwPersonalInfo = aFirstSection.vwPersonalInfo;
        
        if (vwPersonalInfo.btnMember.tag == [aPerson.personTypeID integerValue]) {
            [vwPersonalInfo.btnMember setSelected:YES];
        }
        else if (vwPersonalInfo.btnGuest.tag == [aPerson.personTypeID integerValue]) {
            [vwPersonalInfo.btnGuest setSelected:YES];
        }
        else if (vwPersonalInfo.btnEmployee.tag == [aPerson.personTypeID integerValue]) {
            [vwPersonalInfo.btnEmployee setSelected:YES];
        }
        
        UIButton *aBtnAffiliationType = (UIButton*)[vwPersonalInfo.vwAffiliation viewWithTag:[aPerson.affiliationTypeID integerValue]];
        [aBtnAffiliationType setSelected:YES];
        
        vwPersonalInfo.txtMemberId.text = aPerson.memberId;
        vwPersonalInfo.txtEmployeePosition.text = aPerson.employeeTitle;
        vwPersonalInfo.txtFirstName.text = aPerson.firstName;
        vwPersonalInfo.txtMi.text = aPerson.middleInitial;
        vwPersonalInfo.txtLastName.text = aPerson.lastName;
        vwPersonalInfo.txtStreetAddress.text = aPerson.streetAddress;
        vwPersonalInfo.txtAppartment.text = aPerson.apartmentNumber;
        vwPersonalInfo.txtCity.text = aPerson.city;
        vwPersonalInfo.txtState.text = aPerson.state;
        vwPersonalInfo.txtZip.text = aPerson.zip;
        vwPersonalInfo.txtHomePhone.text = aPerson.primaryPhone;
        vwPersonalInfo.txtAlternatePhone.text = aPerson.alternatePhone;
        vwPersonalInfo.txtEmailAddress.text = aPerson.email;
        
        NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
        [aFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *aDate = [aFormatter dateFromString:[[aPerson.dateOfBirth componentsSeparatedByString:@" "] firstObject]];
        [aFormatter setDateFormat:@"MM/dd/yyyy"];
        vwPersonalInfo.txtDob.text = [aFormatter stringFromDate:aDate];
        
        vwPersonalInfo.txtActivity.text = [[[_reportSetupInfo.activityList.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"activityId MATCHES[cd] %@", aPerson.activityTypeID]] firstObject] name];
        vwPersonalInfo.txtWheather.text = [[[_reportSetupInfo.conditionList.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"conditionId MATCHES[cd] %@", aPerson.conditionTypeID]] firstObject] name];
        vwPersonalInfo.txtEquipment.text = [[[_reportSetupInfo.equipmentList.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"equipmentId MATCHES[cd] %@", aPerson.equipmentTypeID]] firstObject] name];
        
//        [aPerson.injuryList allObjects];
        BodyPartInjury *vwBodyPart = aFirstSection.vwBodyPartInjury;
        
        NSArray *injuryList = aPerson.injuryList.allObjects;
        
        NSMutableArray *mutArrInjury = [NSMutableArray array];
        for (InjuryDetail *injury in injuryList) {
            
            NSMutableDictionary *aMutDict = [NSMutableDictionary dictionary];
            [aMutDict setObject:injury.natureId forKey:@"nature"];
            if (![injury.generalInjuryTypeId isEqualToString:@""]) {
                id obj = [[_reportSetupInfo.generalInjuryType.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"typeId MATCHES[cd] %@", injury.generalInjuryTypeId]] firstObject];
                [aMutDict setObject:injury.generalInjuryOther forKey:@"generalOther"];
                [aMutDict setObject:injury.generalInjuryOther forKey:@"injury"];
                if (obj) {
                    [aMutDict setObject:[obj valueForKey:@"name"] forKey:@"injury"];
                    [aMutDict setObject:obj forKey:@"GeneralInjuryType"];
                }
            }
            if (injury.bodyPartInjuryTypeId) {
                id obj = [[_reportSetupInfo.bodypartInjuryType.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"typeId MATCHES[cd] %@", injury.bodyPartInjuryTypeId]] firstObject];
                if (obj) {
                    [aMutDict setObject:[obj valueForKey:@"name"] forKey:@"injury"];
                    [aMutDict setObject:obj forKey:@"BodyPartInjuryType"];
                }
                
                NSMutableArray *mutArr = [NSMutableArray array];
                [mutArr addObjectsFromArray:_reportSetupInfo.headInjuryList.allObjects];
                [mutArr addObjectsFromArray:_reportSetupInfo.abdomenInjuryList.allObjects];
                [mutArr addObjectsFromArray:_reportSetupInfo.legInjuryList.allObjects];
                [mutArr addObjectsFromArray:_reportSetupInfo.armInjuryList.allObjects];
                
                obj = [[mutArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"value MATCHES[cd] %@", injury.bodyPartInjuryTypeId]] firstObject];
                if (obj) {
                    [aMutDict setObject:obj forKey:@"part"];
                }
            
            }
            if (injury.actionTakenId) {
                id obj = [[[_reportSetupInfo.actionList allObjects] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K MATCHES %@", @"actionId", injury.actionTakenId]] firstObject];
                if (obj) {
                    [aMutDict setObject:obj forKey:@"action"];
                }
            }
            
            [mutArrInjury addObject:aMutDict];
        }
        vwBodyPart.mutArrInjuryList = mutArrInjury;
        [vwBodyPart.tblAddedInjuryList reloadData];
        
        NSMutableArray *ary = [NSMutableArray arrayWithArray:[_reportSetupInfo.careProviderList allObjects]];
        [ary addObject:@{@"name":@"Self Care", @"careProvidedID":@"-1"}];
        [ary addObject:@{@"name":@"Refused Care", @"careProvidedID":@"-2"}];
        
        vwBodyPart.txtCareProvided.text = [[[ary filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"careProvidedID MATCHES[cd] %@", aPerson.careProvidedBy]] firstObject] valueForKey:@"name"];
        vwBodyPart.careProvided = vwBodyPart.txtCareProvided.text;
        
        BodilyFluidView *vwBodilyFluid = aFirstSection.vwBodilyFluid;
        vwBodilyFluid.txtFName.text = aPerson.firstAidFirstName;
        vwBodilyFluid.txtLName.text = aPerson.firstAidLastName;
        vwBodilyFluid.txtMI.text = aPerson.firstAidMiddleInitial;
        vwBodilyFluid.txtPosition.text = aPerson.firstAidPosition;
        vwBodilyFluid.signatureView = [[SignatureView alloc] initWithNibName:@"SignatureView" bundle:nil];
//        [vwBodilyFluid.signatureView loadView];
        vwBodilyFluid.signatureView.lastSavedName = aPerson.participantName;
        vwBodilyFluid.signatureView.lastSignatureImage = [UIImage imageWithData:aPerson.participantSignature];
        
        vwBodilyFluid.txvStaffMemberAccount.text = aPerson.staffMemberWrittenAccount;
        if ([aPerson.wasBloodPresent isEqualToString:@"true"]) {
            [vwBodilyFluid btnWasBloodPresentTapped:vwBodilyFluid.btnBloodPresent];
        }
        else {
            [vwBodilyFluid btnWasBloodPresentTapped:vwBodilyFluid.btnBloodNotPresent];
        }

        if (vwBodilyFluid.btnSelfTreated.tag == [aPerson.bloodBornePathogenType integerValue]) {
            [vwBodilyFluid.btnSelfTreated setSelected:YES];
        }
        else if (vwBodilyFluid.btnEmployeeTreated.tag == [aPerson.bloodBornePathogenType integerValue]) {
            [vwBodilyFluid.btnEmployeeTreated setSelected:YES];
        }
        else if (vwBodilyFluid.btnMedicalPersonnelTreated.tag == [aPerson.bloodBornePathogenType integerValue]) {
            [vwBodilyFluid.btnMedicalPersonnelTreated setSelected:YES];
        }
        
        if ([aPerson.bloodCleanUpRequired isEqualToString:@"true"]) {
            [vwBodilyFluid.btnBloodCleanupRequired setSelected:YES];
            [vwBodilyFluid.btnBloodCleanupNotRequired setSelected:NO];
        }
        else {
            [vwBodilyFluid.btnBloodCleanupNotRequired setSelected:YES];
            [vwBodilyFluid.btnBloodCleanupRequired setSelected:NO];
        }
        if ([aPerson.wasExposedToBlood isEqualToString:@"true"]) {
            [vwBodilyFluid.btnExposedToBlood setSelected:YES];
            [vwBodilyFluid.btnNotExposedToBlood setSelected:NO];
        }
        else {
            [vwBodilyFluid.btnExposedToBlood setSelected:NO];
            [vwBodilyFluid.btnNotExposedToBlood setSelected:YES];
        }
        
        aFirstSection.imgBodilyFluid = [UIImage imageWithData:aPerson.personPhoto];
        
    }
}

- (void)populateEmergencyPersonnel:(NSArray*)aryEmergency {
    for (int i = 0; i < [aryEmergency count]; i++) {
        if (i > 0) {
            [thirdSection initialSetUp];
        }
        EmergencyPersonnelView *vwEmergency = [thirdSection.mutArrEmergencyViews lastObject];
        EmergencyPersonnel *aEmergency = aryEmergency[i];
        vwEmergency.txtFirstName.text = aEmergency.firstName;
        vwEmergency.txtLastName.text = aEmergency.lastName;
        vwEmergency.txtMI.text = aEmergency.middileInitial;
        vwEmergency.txtCaseNo.text = aEmergency.caseNumber;
        vwEmergency.txtPhone.text = aEmergency.phone;
        vwEmergency.txtBadge.text = aEmergency.badgeNumber;
        vwEmergency.txtTime911Called.text = aEmergency.time911Called;
        vwEmergency.txtTimeOfArrival.text = aEmergency.time911Arrival;
        vwEmergency.txtTimeOfDeparture.text = aEmergency.time911Departure;
        vwEmergency.txvAdditionalInfo.text = aEmergency.additionalInformation;
    }
}

- (void)populateWitness:(NSArray*)aryWitness {
    for (int i = 0; i < [aryWitness count]; i++) {
        if (i > 0) {
            [finalSection btnAddMoreWitnessTapped:nil];
        }
        WitnessView *vwWitness = [finalSection.mutArrWitnessViews lastObject];
        Witness *aWitness = aryWitness[i];
        vwWitness.txtWitnessFName.text = aWitness.firstName;
        vwWitness.txtWitnessLName.text = aWitness.lastName;
        vwWitness.txtWitnessMI.text = aWitness.middleInitial;
        vwWitness.txtWitnessHomePhone.text = aWitness.homePhone;
        vwWitness.txtWitnessAlternatePhone.text = aWitness.alternatePhone;
        vwWitness.txtWitnessEmailAddress.text = aWitness.email;
        vwWitness.txvDescIncident.text = aWitness.witnessWrittenAccount;
    }
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

- (void)saveAccidentReportToLocal:(NSDictionary*)aDict completed:(BOOL)isCompleted {
    
    AccidentReportSubmit *aReport = [NSEntityDescription insertNewObjectForEntityForName:@"AccidentReportSubmit" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    aReport.userId = [[User currentUser] userId];
    aReport.isCompleted = [NSNumber numberWithBool:isCompleted];
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
        if ([[dict objectForKey:@"Time911Called"] isKindOfClass:[NSNull class]]) {
            aEmergencyPersonnel.time911Called = @"";
        }
        else {
            aEmergencyPersonnel.time911Called = [dict objectForKey:@"Time911Called"];
        }
        if ([[dict objectForKey:@"ArrivalTime"] isKindOfClass:[NSNull class]]) {
            aEmergencyPersonnel.time911Arrival = @"";
        }
        else {
            aEmergencyPersonnel.time911Arrival = [dict objectForKey:@"ArrivalTime"];
        }
        if ([[dict objectForKey:@"DepartureTime"] isKindOfClass:[NSNull class]]) {
            aEmergencyPersonnel.time911Departure = @"";
        }
        else {
            aEmergencyPersonnel.time911Departure = [dict objectForKey:@"DepartureTime"];
        }
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
    aReport.reportFilerAccount = [aDict objectForKey:@"ReportFilerAccount"];
    //    aReport.managementFollowUpDate = [aFormatter stringFromDate:managementFollowupDate];
    //    aReport.followUpCallType = @"";
    aReport.additionalInfo = [aDict objectForKey:@"AdditionalInformation"];
    //    aReport.com
    [gblAppDelegate.managedObjectContext insertedObjects];
    if ([gblAppDelegate.managedObjectContext save:nil] && isCompleted) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:MSG_ADDED_TO_SYNC delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
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
        if (thirdSection && !thirdSection.isHidden) {
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
    [_btn911Called setSelected:NO];
    [_btnPoliceCalled setSelected:NO];
    [_btnManager setSelected:NO];
    [_btnNone setSelected:NO];
    [sender setSelected:YES];
    if (_btn911Called.isSelected && [_reportSetupInfo.showEmergencyPersonnel boolValue]) {
        [thirdSection setHidden:NO];
        CGRect frame = finalSection.frame;
        frame.origin.y = CGRectGetMaxY(thirdSection.frame);
        finalSection.frame = frame;
    }
    else if (thirdSection){
        [thirdSection setHidden:YES];
        CGRect frame = finalSection.frame;
        frame.origin.y = CGRectGetMinY(thirdSection.frame);
        finalSection.frame = frame;
    }
    _isUpdate = YES;
}

- (void)btnFinalSubmitTapped:(id)sender {
//    [self createSubmitRequest];
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
    else if (thirdSection && _btn911Called.isSelected && ![thirdSection isThirdSectionValidationSuccess]) {
        return;
    }
    else if (![finalSection isFinalSectionValidationSuccessWith:aryEmpFields]) {
        return;
    }
    
    NSMutableDictionary *request = [NSMutableDictionary dictionaryWithDictionary:[self createSubmitRequest]];
    NSString *strCareId = [request objectForKey:@"CareProvidedById"];
    if ([strCareId intValue] < 0) {
        [request setObject:@"" forKey:@"CareProvidedById"];
    }
    [gblAppDelegate callWebService:ACCIDENT_REPORT_POST parameters:request httpMethod:[SERVICE_HTTP_METHOD objectForKey:ACCIDENT_REPORT_POST] complition:^(NSDictionary *response) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:@"Accident Report has been submitted successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    } failure:^(NSError *error, NSDictionary *response) {
        [self saveAccidentReportToLocal:request completed:YES];
    }];
}

- (IBAction)btnAddMoreBodilyFluidTapped:(id)sender {
    _isUpdate = YES;
    [self addAccidentView];
}

- (IBAction)btnBackTapped:(id)sender {
    [self.view endEditing:YES];
    if (_isUpdate) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:@"Would you like to save this report and complete it later?  You will lose all entered information if you choose \"No\"." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        [alert setTag:3];
        [alert show];
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

- (void)viewSetup {
    [_btn911Called setTitle:_reportSetupInfo.notificationField1 forState:UIControlStateNormal];
    [_btn911Called setTitleColor:[UIColor colorWithHexCodeString:_reportSetupInfo.notificationField1Color] forState:UIControlStateNormal];
    [_btnPoliceCalled setTitle:_reportSetupInfo.notificationField2 forState:UIControlStateNormal];
    [_btnPoliceCalled setTitleColor:[UIColor colorWithHexCodeString:_reportSetupInfo.notificationField2Color] forState:UIControlStateNormal];
    [_btnManager setTitle:_reportSetupInfo.notificationField3 forState:UIControlStateNormal];
    [_btnManager setTitleColor:[UIColor colorWithHexCodeString:_reportSetupInfo.notificationField3Color] forState:UIControlStateNormal];
    [_btnNone setTitle:_reportSetupInfo.notificationField4 forState:UIControlStateNormal];
    [_btnNone setTitleColor:[UIColor colorWithHexCodeString:_reportSetupInfo.notificationField4Color] forState:UIControlStateNormal];
    _lblInstruction.text = _reportSetupInfo.instructions;
}

- (void)addAccidentView {
    AccidentFirstSection *accidentView = (AccidentFirstSection*)[[[NSBundle mainBundle] loadNibNamed:@"AccidentFirstSection" owner:self options:nil] firstObject];
    accidentView.parentVC = self;
    accidentView.isCaptureCameraVisible = [_reportSetupInfo.showPhotoIcon boolValue];
    accidentView.vwPersonalInfo.isAffiliationVisible = [_reportSetupInfo.showAffiliation boolValue];
    accidentView.vwPersonalInfo.isMemberIdVisible = [_reportSetupInfo.showMemberIdAndDriverLicense boolValue];
    accidentView.vwPersonalInfo.isDOBVisible = [_reportSetupInfo.showDateOfBirth boolValue];
    accidentView.vwPersonalInfo.isGenderVisible = [_reportSetupInfo.showGender boolValue];
    accidentView.vwPersonalInfo.isMinorVisible = [_reportSetupInfo.showMinor boolValue];
    accidentView.vwPersonalInfo.isEmployeeIdVisible = [_reportSetupInfo.showEmployeeId boolValue];
    accidentView.vwPersonalInfo.isConditionsVisible = [_reportSetupInfo.showConditions boolValue];
    [accidentView.vwPersonalInfo callInitialActions];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"type", REQUIRED_TYPE_PERSON];
    NSArray *fields = [[_reportSetupInfo.requiredFields allObjects] filteredArrayUsingPredicate:predicate];
    NSArray *aryFields = [fields valueForKeyPath:@"name"];
    [accidentView.vwPersonalInfo setRequiredFields:aryFields];
    predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"type", REQUIRED_TYPE_FIRST_AID];
    fields = [[_reportSetupInfo.requiredFields allObjects] filteredArrayUsingPredicate:predicate];
    NSArray *aryAidFields = [fields valueForKeyPath:@"name"];
    [accidentView.vwBodilyFluid setRequiredFields:aryAidFields];
    
    accidentView.vwBodilyFluid.isBloodBornePathogenVisible = [_reportSetupInfo.showBloodbornePathogens boolValue];
    accidentView.vwBodilyFluid.isRefuseCareStatementVisible = NO;
    accidentView.vwBodilyFluid.isParticipantSignatureVisible = [_reportSetupInfo.showParticipantSignature boolValue];
    accidentView.vwBodilyFluid.lblRefuseCareText.text = _reportSetupInfo.refusedCareStatement;
    [accidentView.vwBodilyFluid shouldShowFirstAddView:NO];
    [accidentView.vwBodilyFluid shouldShowParticipantsSignatureView:NO];
    [accidentView.vwBodilyFluid btnWasBloodPresentTapped:accidentView.vwBodilyFluid.btnBloodNotPresent];
    
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
        thirdSection.parentVC = self;
        [thirdSection initialSetUp];
        CGRect frame = thirdSection.frame;
        frame.origin.y = CGRectGetMaxY(_vwFirstSection.frame);
        thirdSection.frame = frame;
        [_scrlMainView addSubview:thirdSection];
        [thirdSection addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
        
    }
    
    
    finalSection = (FinalSection*)[[[NSBundle mainBundle] loadNibNamed:@"FinalSection" owner:self options:nil] firstObject];
    finalSection.parentVC = self;
    [finalSection addWitnessView];
    [finalSection setBackgroundColor:[UIColor clearColor]];
    frame = finalSection.frame;
    if ([_reportSetupInfo.showEmergencyPersonnel boolValue]) {
        frame.origin.y = CGRectGetMaxY(thirdSection.frame);
    }
    else {
        frame.origin.y = CGRectGetMaxY(_vwFirstSection.frame);
    }
    finalSection.frame = frame;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"type", REQUIRED_TYPE_EMPLOYEE];
    NSArray *fields = [[_reportSetupInfo.requiredFields allObjects] filteredArrayUsingPredicate:predicate];
    NSArray *aryFields = [fields valueForKeyPath:@"name"];
    [finalSection setupEmployeeRequiredFields:aryFields];
    [_scrlMainView addSubview:finalSection];
    [finalSection addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    finalSection.isCommunicationVisible = [_reportSetupInfo.showCommunicationAndNotification boolValue];
    finalSection.isManagementFollowUpVisible = [_reportSetupInfo.showManagementFollowup boolValue];
    [finalSection.btnFinalSubmit addTarget:self action:@selector(btnFinalSubmitTapped:) forControlEvents:UIControlEventTouchUpInside];
    [finalSection PersonInvolved:_personInvolved];
    [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(finalSection.frame))];
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

- (NSDictionary*)createSubmitRequest {
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    if (![_txtDateOfIncident.text isEqualToString:@""] && [_txtTimeOfIncident.text isEqualToString:@""]) {
        [aFormatter setDateFormat:@"MM/dd/yyyy"];
    }
    else if (![_txtTimeOfIncident.text isEqualToString:@""] && [_txtDateOfIncident.text isEqualToString:@""]) {
        [aFormatter setDateFormat:@"hh:mm a"];
    }
    
    
    NSString *aStr = [NSString stringWithFormat:@"%@ %@", _txtDateOfIncident.text, _txtTimeOfIncident.text];
    NSDate *incidentDate = [aFormatter dateFromString:aStr];
    [aFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [aFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    NSString *astrAccidentDate = [aFormatter stringFromDate:incidentDate];
    if (!astrAccidentDate)
        astrAccidentDate = @"";
    
    
    //    "ReportFilerAccount": "sample string 11",
    NSMutableArray *personList = [NSMutableArray array];
    for (AccidentFirstSection *view in _vwFirstSection.subviews) {
        if ([view isKindOfClass:[AccidentFirstSection class]]) {
            [personList addObject:[view getAccidentPerson]];
        }
    }
    
    NSMutableArray *mutArrEmergency = [NSMutableArray array];
    for (EmergencyPersonnelView *vwEmergency in thirdSection.mutArrEmergencyViews) {
        id time911Called, timeArrival, timeDeparture;
        if ([vwEmergency.txtTime911Called.text isEqualToString:@""]) {
            time911Called = [NSNull null];
        }
        else {
            time911Called = vwEmergency.txtTime911Called.text;
        }
        
        if ([vwEmergency.txtTime911Called.text isEqualToString:@""]) {
            timeArrival = [NSNull null];
        }
        else {
            timeArrival = vwEmergency.txtTime911Called.text;
        }
        
        if ([vwEmergency.txtTime911Called.text isEqualToString:@""]) {
            timeDeparture = [NSNull null];
        }
        else {
            timeDeparture = vwEmergency.txtTime911Called.text;
        }
        NSDictionary *aDict = @{@"FirstName":vwEmergency.txtFirstName.trimText, @"MiddleInitial":vwEmergency.txtMI.trimText, @"LastName":vwEmergency.txtLastName.trimText, @"Phone":vwEmergency.txtPhone.text, @"AdditionalInformation":vwEmergency.txvAdditionalInfo.text, @"CaseNumber":vwEmergency.txtCaseNo.trimText, @"BadgeNumber":vwEmergency.txtBadge.trimText, @"Time911Called":time911Called, @"ArrivalTime":timeArrival, @"DepartureTime":timeDeparture};
        [mutArrEmergency addObject:aDict];
    }
    NSMutableArray *mutArrWitness = [NSMutableArray array];
    for (WitnessView *vwWitness in finalSection.mutArrWitnessViews) {
        NSDictionary *aDict = @{@"FirstName":vwWitness.txtWitnessFName.trimText, @"MiddleInitial":vwWitness.txtWitnessMI.trimText, @"LastName":vwWitness.txtWitnessLName.trimText, @"HomePhone":vwWitness.txtWitnessHomePhone.text, @"AlternatePhone":vwWitness.txtWitnessAlternatePhone.text, @"Email":vwWitness.txtWitnessEmailAddress.text, @"IncidentDescription":vwWitness.txvDescIncident.text};
        [mutArrWitness addObject:aDict];
    }
    NSString *facilityId = [NSString string], *locationId = [NSString string];
    if (selectedFacility.value) {
        facilityId = selectedFacility.value;
    }
    if (selectedLocation.value) {
        locationId = selectedLocation.value;
    }
    NSDictionary *aDict = @{@"AccidentDate":astrAccidentDate, @"FacilityId":facilityId, @"LocationId":locationId, @"AccidentDescription":_txvDescription.text, @"IsNotificationField1Selected":(_btn911Called.isSelected) ? @"true":@"false", @"IsNotificationField2Selected":(_btnPoliceCalled.isSelected) ? @"true":@"false", @"IsNotificationField3Selected":(_btnManager.isSelected) ? @"true":@"false",@"IsNotificationField4Selected":(_btnNone.isSelected) ? @"true":@"false", @"EmployeeFirstName":finalSection.txtEmpFName.trimText, @"EmployeeMiddleInitial":finalSection.txtEmpMI.trimText, @"EmployeeLastName":finalSection.txtEmpLName.trimText, @"EmployeeHomePhone":finalSection.txtEmpHomePhone.text, @"EmployeeAlternatePhone":finalSection.txtEmpAlternatePhone.text, @"EmployeeEmail":finalSection.txtEmpEmailAddr.text, @"AdditionalInformation":finalSection.txvAdditionalInformation.text, @"IsAdministrationAlertSelected":(finalSection.btnAdmin.isSelected)?@"true":@"false", @"IsSupervisorAlertSelected":(finalSection.btnSupervisers.isSelected)?@"true":@"false", @"IsRiskManagementAlertSelected":(finalSection.btnRiskManagement.isSelected)?@"true":@"false", @"ReportFilerAccount":finalSection.txvReportFilerAccount.text, @"PersonsInvolved":personList, @"EmergencyPersonnel":mutArrEmergency, @"Witnesses":mutArrWitness};
    return aDict;
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
    aPerson.firstAidLastName = dict[@"FirstAidLastName"];
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
        aPerson.personPhoto = [[NSData alloc] initWithBase64EncodedString:[dict objectForKey:@"PersonPhoto"] options:0];
    if (![[dict objectForKey:@"PersonSignature"] isEqualToString:@""])
        aPerson.participantSignature = [[NSData alloc] initWithBase64EncodedString:[dict objectForKey:@"PersonSignature"] options:0];
    
    aPerson.participantName = [dict objectForKey:@"PersonName"];
    aPerson.bloodBornePathogenType = [dict objectForKey:@"BloodbornePathogenTypeId"];
    aPerson.staffMemberWrittenAccount = [dict objectForKey:@"StaffMemberWrittenAccount"];
    aPerson.wasBloodPresent = [dict objectForKey:@"WasBloodOrBodilyFluidPresent"];
    aPerson.bloodCleanUpRequired = [dict objectForKey:@"WasBloodCleanupRequired"];
    aPerson.wasExposedToBlood = [dict objectForKey:@"WasCaregiverExposedToBlood"];
    aPerson.duringWorkHours = [dict objectForKey:@"OccuredDuringBusinessHours"];
    
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"type", REQUIRED_TYPE_FIRST_AID];
    NSArray *fields = [[_reportSetupInfo.requiredFields allObjects] filteredArrayUsingPredicate:predicate];
    NSArray *aryAidFields = [fields valueForKeyPath:@"name"];
    for (AccidentFirstSection *view in _vwFirstSection.subviews) {
        if ([view isKindOfClass:[AccidentFirstSection class]]) {
            isSuccess = [view validateAccidentFirstSectionWith:aryAidFields];
            if (!isSuccess) {
                break;
            }
        }
    }
    return isSuccess;
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
        
        NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
        [aFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *accidentDate = [aFormatter dateFromString:_txtDateOfIncident.text];
        
        NSString *currentDate = [aFormatter stringFromDate:[NSDate date]];
        
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        NSDate *pickerDate = [NSDate date];;
        if (accidentDate) {
            if ([accidentDate compare:[aFormatter dateFromString:currentDate]] == NSOrderedAscending) {
                [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_NONE option:DATE_SELECTION_TIME_ONLY updateField:textField];
                pickerDate = accidentDate;
            }
            else {
                [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_PAST_ONLY option:DATE_SELECTION_TIME_ONLY updateField:textField];
            }
            
        }
        else {
            [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_PAST_ONLY option:DATE_SELECTION_TIME_ONLY updateField:textField];
        }
        if (![textField.text isEqualToString:@""]) {
            NSString *aPkrDate = [aFormatter stringFromDate:pickerDate];
            aPkrDate = [aPkrDate stringByAppendingFormat:@" %@", textField.text];
            [aFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
            pickerDate = [aFormatter dateFromString:aPkrDate];
        }
        datePopOver.datePicker.date = pickerDate;
        
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
    if (alertView.tag == 3) {
        if (buttonIndex == 0) {
            [self saveAccidentReportToLocal:[self createSubmitRequest] completed:NO];
        }
        [self removeObservers];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else if (buttonIndex == 0) {
        [self removeObservers];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
