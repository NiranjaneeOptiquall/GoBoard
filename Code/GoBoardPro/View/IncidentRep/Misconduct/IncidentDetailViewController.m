//
//  MisconductIncidentViewController.m
//  GoBoardPro
//
//  Created by ind558 on 25/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//
#import "WitnessPresent.h"
#import "IncidentDetailViewController.h"
#import "IncidentPersonalInformation.h"
#import "WitnessView.h"
#import "Report.h"
#import "Person.h"
#import "Witness.h"
#import "EmergencyPersonnel.h"
#import "EmergencyPersonnelView.h"
#import "EmergencyPersonnelIncident.h"


#define MISCONDUCT  @"misconduct"
#define CUSTOMER_SERVICE    @"customerservice"
#define OTHER   @"other"

@interface IncidentDetailViewController ()

@end

@implementation IncidentDetailViewController
@synthesize reportSetupInfo;
-(void)awakeFromNib
{
    
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAdjustContentOffsetsToRemoveWitness:) name:@"adjustContentOffsetsToDeleteWitnessView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAdjustContentOffsetsToInsertWitness:) name:@"adjustContentOffsetsToInsertWitnessView" object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"adjustContentOffsetsToDeleteWitnessView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"adjustContentOffsetsToInsertWitnessView" object:nil];
    
}
- (void)didAdjustContentOffsetsToRemoveWitness:(id)objectInfo
{
    for (int i = totalWitnessCount; i >0; i--) {
        WitnessView *aWitnessView = (WitnessView*)[_vwWitnesses viewWithTag:totalWitnessCount + 300];
        if ([[_vwWitnesses subviews] containsObject:aWitnessView]) {
            
            CGRect frame = _vwWitnesses.frame;
            frame.size.height = _vwWitnesses.frame.size.height - aWitnessView.frame.size.height;
            _vwWitnesses.frame = frame;
            
            frame = [[_vwWitnesses viewWithTag:9999] frame];
            frame.size.height = CGRectGetMinY(aWitnessView.frame);
            [[_vwWitnesses viewWithTag:9999] setFrame:frame];
            
            frame = _vwEmployeeInfo.frame;
            frame.origin.y = _vwEmployeeInfo.frame.origin.y - aWitnessView.frame.size.height ;
            _vwEmployeeInfo.frame = frame;
            
            [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
            
//            int yPosition = _scrlMainView.contentOffset.y - aWitnessView.frame.size.height;
//            
//            if (yPosition < _scrlMainView.contentOffset.y) {
//                [_scrlMainView setContentOffset:CGPointMake(_scrlMainView.contentOffset.x, yPosition)];
//            }
            
            _btnRemoveWitness.hidden=YES;
            _btnAddWitness.hidden = YES;
            
            totalWitnessCount --;
            if ([mutArrWitnessView containsObject:aWitnessView]) {
                [mutArrWitnessView removeObject:aWitnessView];
            }
            [aWitnessView removeFromSuperview];
        }
    }
}

- (void)didAdjustContentOffsetsToInsertWitness:(id)objectInfo
{
    [self addWitnessView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchIncidentSetupInfo];
    [self fetchFacilities];
    [_txtLocation setEnabled:NO];
    [_vwAfterPersonalInfo setBackgroundColor:[UIColor clearColor]];
    mutArrIncidentPerson = [[NSMutableArray alloc] init];
   
    mutArrWitnessView = [[NSMutableArray alloc] init];
    
    [self viewSetup];
    [self addIncidentPersonalInformationViews];

    [self addWitnessPresentView];
    [self addWitnessView];
    if ([reportSetupInfo.showManagementFollowup boolValue]) {
        [self addActionTakenView];
    }
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
    [self fetchIncompleteReportIfAny];
    
}


- (void)fetchIncompleteReportIfAny {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Report"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userId MATCHES[cd] %@) AND isCompleted = 0 AND incidentType = %ld", [[User currentUser] userId], _incidentType];
    [request setPredicate:predicate];
    Report *aReport = [[gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil] firstObject];
    if (aReport) {
        _isUpdate = YES;
        [self PopulateIncompleteData:aReport];
        [gblAppDelegate.managedObjectContext deleteObject:aReport];
        [gblAppDelegate.managedObjectContext save:nil];
    }
}

- (void)PopulateIncompleteData:(Report*)aReport {
    NSMutableArray *mutArr = [NSMutableArray arrayWithArray:[aReport.dateOfIncident componentsSeparatedByString:@" "]];
    NSString *aDateOfAccident = [mutArr firstObject];
    [mutArr removeObjectAtIndex:0];
    _txtTimeOfIncident.text = [mutArr componentsJoinedByString:@" "];
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *incidentDate = [aFormatter dateFromString:aDateOfAccident];
    [aFormatter setDateFormat:@"MM/dd/yyyy"];
    _txtDateOfIncident.text = [aFormatter stringFromDate:incidentDate];
    
    selectedFacility = [[aryFacilities filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"value MATCHES[cd] %@", aReport.facilityId]] firstObject];
    _txtFacility.text = selectedFacility.name;
    if (selectedFacility) {
        [self fetchLocation];
    }
    
    selectedLocation = [[aryLocation filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"value MATCHES[cd] %@", aReport.locationId]] firstObject];
    _txtLocation.text = selectedLocation.name;
    _txvIncidentDesc.text = aReport.incidentDesc;
    if (_txvIncidentDesc.text.length > 0) {
        [_lblIncidentDesc setHidden:YES];
    }
    
    _btn911Called.selected = ([aReport.isNotification1Selected isEqualToString:@"true"]) ? YES : NO;
    _btnPoliceCalled.selected = ([aReport.isNotification2Selected isEqualToString:@"true"]) ? YES : NO;
    _btnManager.selected = ([aReport.isNotification3Selected isEqualToString:@"true"]) ? YES : NO;
    _btnNone.selected = ([aReport.isNotification4Selected isEqualToString:@"true"]) ? YES : NO;
    
    
    if ((_btn911Called.selected && [[[[_btn911Called titleLabel] text] substringFromIndex:[[[_btn911Called titleLabel] text] length]-3] isEqualToString:@"(A)"]) ||
        (_btnPoliceCalled.selected && [[[[_btnPoliceCalled titleLabel] text] substringFromIndex:[[[_btnPoliceCalled titleLabel] text] length]-3] isEqualToString:@"(A)"]) ||
        (_btnManager.selected && [[[[_btnManager titleLabel] text] substringFromIndex:[[[_btnManager titleLabel] text] length]-3] isEqualToString:@"(A)"]) ||
        (_btnNone.selected && [[[[_btnNone titleLabel] text] substringFromIndex:[[[_btnNone titleLabel] text] length]-3] isEqualToString:@"(A)"]))
    {
        [_lblDisclaimer setHidden:NO];
        [_lblDisclaimerDetail setHidden:NO];
        
        CGRect frame = _vwBasicInfo.frame;
        
        frame.size.height = CGRectGetMaxY(_lblDisclaimerDetail.frame);
        
        _vwBasicInfo.frame = frame;
        
        frame = _vwPersonalInfo.frame;
        
        frame.origin.y = CGRectGetMaxY(_vwBasicInfo.frame);
        
        _vwPersonalInfo.frame = frame;
        
    }
    else{
        [_lblDisclaimer setHidden:YES];
        [_lblDisclaimerDetail setHidden:YES];
        
        CGRect frame = _vwBasicInfo.frame;
        
        frame.size.height = CGRectGetMaxY(_btnNone.frame);
        
        _vwBasicInfo.frame = frame;
        
        frame = _vwPersonalInfo.frame;
        
        frame.origin.y = CGRectGetMaxY(_vwBasicInfo.frame);
        
        _vwPersonalInfo.frame = frame;
    }
    [self popolatePersonalInformation:aReport.persons.allObjects];
    [self populateWitness:aReport.witnesses.allObjects];
    
    _txtEmpFName.text = aReport.employeeFirstName;
    _txtEmpLName.text = aReport.employeeLastName;
    _txtEmpMI.text = aReport.employeeMiddleInitial;
    _txtEmpHomePhone.text = aReport.employeeHomePhone;
    _txtEmpAlternatePhone.text = aReport.employeeAlternatePhone;
    _txtEmpEmail.text = aReport.employeeEmail;
    _txtReportAccount.text = aReport.reportFilerAccount;
    _txvAdditionalInfo.text = aReport.additionalInfo;

    if (_txtReportAccount.text.length > 0) {
        [_lblReportFilerPlaceHolder setHidden:YES];
    }
    if (_txvAdditionalInfo.text.length > 0) {
        [_lblAdditonInfo setHidden:YES];
    }
}

- (void)popolatePersonalInformation:(NSArray*)aryPersonInfo {
    for (int i = 0; i < [aryPersonInfo count]; i++) {
        Person *aPerson = aryPersonInfo[i];
        
        if (i > 0) {
            [self addIncidentPersonalInformationViews];
        }
        
        IncidentPersonalInformation *vwPersonalInfo = [mutArrIncidentPerson lastObject];
        
        if (vwPersonalInfo.btnMember.tag == [aPerson.personTypeID integerValue]) {
            [vwPersonalInfo btnPersonInvolvedTapped:vwPersonalInfo.btnMember];
        }
        else if (vwPersonalInfo.btnGuest.tag == [aPerson.personTypeID integerValue]) {
            [vwPersonalInfo btnPersonInvolvedTapped:vwPersonalInfo.btnGuest];
        }
        else if (vwPersonalInfo.btnEmployee.tag == [aPerson.personTypeID integerValue]) {
            [vwPersonalInfo btnPersonInvolvedTapped:vwPersonalInfo.btnEmployee];
        }
        
        UIButton *aBtnAffiliationType = (UIButton*)[vwPersonalInfo.vwAffiliation viewWithTag:[aPerson.affiliationTypeID integerValue]];
        [vwPersonalInfo btnAffiliationTapped:aBtnAffiliationType];
        
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
        vwPersonalInfo.imgIncidentPerson = [UIImage imageWithData:aPerson.personPhoto];
        
        if (aPerson.genderTypeID.intValue == 2){
            [vwPersonalInfo btnGenderTapped:vwPersonalInfo.btnFemale];
        }else if (aPerson.genderTypeID.intValue == 3){
            [vwPersonalInfo btnGenderTapped:vwPersonalInfo.btnNeutral];
        }else if (aPerson.genderTypeID.intValue == 4){
            [vwPersonalInfo btnGenderTapped:vwPersonalInfo.btnOtherGender];
        }else{
            [vwPersonalInfo btnGenderTapped:vwPersonalInfo.btnMale];
        }
        
        if ([aPerson.minor isEqualToString:@"true"]) {
            [vwPersonalInfo btnIsMinorTapped:vwPersonalInfo.btnMinor];
        }else{
            [vwPersonalInfo btnIsMinorTapped:vwPersonalInfo.btnNotMinor];
        }
        
            //              vwBodyPart.txtCareProvided.text = [[[ary filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"careProvidedID MATCHES[cd] %@", aPerson.careProvidedBy]] firstObject] valueForKey:@"name"];
        
        vwPersonalInfo.txtActivity.text = [[[reportSetupInfo.activityList.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"activityId MATCHES[cd] %@", aPerson.activityTypeId]] firstObject] name];
        vwPersonalInfo.txtWeather.text = [[[reportSetupInfo.conditionList.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"conditionId MATCHES[cd] %@", aPerson.conditionId]] firstObject] name];
        vwPersonalInfo.txtEquipment.text = [[[reportSetupInfo.equipmentList.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"equipmentId MATCHES[cd] %@", aPerson.equipmentTypeId]] firstObject] name];
        [vwPersonalInfo.txtActionTaken setText:[[[reportSetupInfo.actionList.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"actionId MATCHES[cd] %@", aPerson.actionTakenId]] firstObject] valueForKey:@"name"]];
        vwPersonalInfo.txtChooseIncident.text = [[[reportSetupInfo.natureList.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"natureId MATCHES[cd] %@", aPerson.natureId]] firstObject] name];
        
        if ([aPerson.emergencyPersonnelIncident.allObjects count] > 0) {
            [vwPersonalInfo populateEmergencyPersonnel:aPerson.emergencyPersonnelIncident.allObjects];
        }
        
    }
}

- (void)populateWitness:(NSArray*)aryWitness {
    for (int i = 0; i < [aryWitness count]; i++) {
        if (i > 0) {
            [self addWitnessView];
        }
        WitnessView *vwWitness = [mutArrWitnessView lastObject];
        Witness *aWitness = aryWitness[i];
        
        if (aWitness.personTypeId.intValue == 3) {
            [vwWitness btnWitnessStatusTapped:vwWitness.btnEmployee];
        }
        else if(aWitness.personTypeId.intValue == 2){
            [vwWitness btnWitnessStatusTapped:vwWitness.btnGuest];
        }else{
            [vwWitness btnWitnessStatusTapped:vwWitness.btnMember];
        }
        
        vwWitness.txtWitnessFName.text = aWitness.firstName;
        vwWitness.txtWitnessLName.text = aWitness.lastName;
        vwWitness.txtWitnessMI.text = aWitness.middleInitial;
        vwWitness.txtWitnessHomePhone.text = aWitness.homePhone;
        vwWitness.txtWitnessAlternatePhone.text = aWitness.alternatePhone;
        vwWitness.txtWitnessEmailAddress.text = aWitness.email;
        vwWitness.txvDescIncident.text = aWitness.witnessWrittenAccount;
        if (vwWitness.txvDescIncident.text.length > 0) {
            [vwWitness.lblWitnessWrittenAccount setHidden:YES];
        }
    }
}



- (void)viewSetup {
    _lblIncidentDesc.text = reportSetupInfo.descriptionLbl;
    
    NSString *aStrTitle1 = reportSetupInfo.notificationField1;
    if (reportSetupInfo.notificationField1Alert.boolValue) {
        [_btn911Called setTitle:[aStrTitle1 stringByAppendingString:@"(A)"] forState:UIControlStateNormal];
    }else{
        [_btn911Called setTitle:aStrTitle1 forState:UIControlStateNormal];
    }
    NSString *aStrTitle2 = reportSetupInfo.notificationField2;
    if (reportSetupInfo.notificationField2Alert.boolValue) {
        [_btnPoliceCalled setTitle:[aStrTitle2 stringByAppendingString:@"(A)"] forState:UIControlStateNormal];
    }else{
        [_btnPoliceCalled setTitle:aStrTitle2 forState:UIControlStateNormal];
    }
    NSString *aStrTitle3 = reportSetupInfo.notificationField3;
    if (reportSetupInfo.notificationField3Alert.boolValue) {
        [_btnManager setTitle:[aStrTitle3 stringByAppendingString:@"(A)"] forState:UIControlStateNormal];
    }else{
        [_btnManager setTitle:aStrTitle3 forState:UIControlStateNormal];
    }
    NSString *aStrTitle4 = reportSetupInfo.notificationField4;
    if (reportSetupInfo.notificationField4Alert.boolValue) {
        [_btnNone setTitle:[aStrTitle4 stringByAppendingString:@"(A)"] forState:UIControlStateNormal];
    }else{
        [_btnNone setTitle:aStrTitle4 forState:UIControlStateNormal];
    }
    
    [_btn911Called setTitleColor:[UIColor colorWithHexCodeString:reportSetupInfo.notificationField1Color] forState:UIControlStateNormal];
    [_btnPoliceCalled setTitleColor:[UIColor colorWithHexCodeString:reportSetupInfo.notificationField2Color] forState:UIControlStateNormal];
    [_btnManager setTitleColor:[UIColor colorWithHexCodeString:reportSetupInfo.notificationField3Color] forState:UIControlStateNormal];
    [_btnNone setTitleColor:[UIColor colorWithHexCodeString:reportSetupInfo.notificationField4Color] forState:UIControlStateNormal];
    
    [_btn911Called setHidden:!reportSetupInfo.showNotificationField1.boolValue];
    [_btnPoliceCalled setHidden:!reportSetupInfo.showNotificationField2.boolValue];
    [_btnManager setHidden:!reportSetupInfo.showNotificationField3.boolValue];
    [_btnNone setHidden:!reportSetupInfo.showNotificationField4.boolValue];
    
    [_lblDisclaimer setHidden:YES];
    [_lblDisclaimerDetail setHidden:YES];
    

    
    _lblInstruction.text = reportSetupInfo.instructions;
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:20] forKey: NSFontAttributeName];
    float height = [reportSetupInfo.instructions boundingRectWithSize:CGSizeMake(_lblInstruction.frame.size.width, 9999) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin  attributes:stringAttributes context:nil].size.height + 20;
    CGRect frameLblInstruction  = _lblInstruction.frame;
    frameLblInstruction.size.height = height;
    _lblInstruction.frame = frameLblInstruction;
    _lblInstruction.numberOfLines = 0;
    [_lblInstruction setFont:[UIFont systemFontOfSize:20]];
    [_lblInstruction setTextAlignment:NSTextAlignmentLeft];
    
    CGRect frame = _vwBasicInfo.frame;
    
    frame.origin.y = CGRectGetMaxY(_lblInstruction.frame);
    frame.size.height = CGRectGetMaxY(_btnNone.frame);
    _vwBasicInfo.frame = frame;
    
    frame = _vwPersonalInfo.frame;
    
    frame.origin.y = CGRectGetMaxY(_vwBasicInfo.frame);
    
    _vwPersonalInfo.frame = frame;
    
    frame = _vwAfterPersonalInfo.frame;
    
    frame.origin.y = CGRectGetMaxY(_vwPersonalInfo.frame);
    
    _vwAfterPersonalInfo.frame = frame;
    
    frame = _vwEmployeeInfo.frame;
    
    frame.origin.y = CGRectGetMaxY(_vwAfterPersonalInfo.frame);
    
    _vwEmployeeInfo.frame = frame;
    
    frame = _vwWitnesses.frame;
    
    frame.origin.y = CGRectGetMaxY(_vwEmployeeInfo.frame);
    
    _vwWitnesses.frame = frame;

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
    if ([aryFields containsObject:@"middleInitial"]) [_markerEmpMI setHidden:NO];
    if ([aryFields containsObject:@"lastName"]) [_markerEmpLName setHidden:NO];
    if ([aryFields containsObject:@"phone"]) [_markerEmpPhone setHidden:NO];
    if ([aryFields containsObject:@"alternatePhone"]) [_markerEmpAltPhone setHidden:NO];
    if ([aryFields containsObject:@"email"]) [_markerEmpEmail setHidden:NO];
    
    _txtEmpFName.text = [[User currentUser] firstName];
    _txtEmpMI.text = [[User currentUser] middleInitials];
    _txtEmpLName.text = [[User currentUser] lastName];
    _txtEmpHomePhone.text = [[User currentUser] phone];
    _txtEmpAlternatePhone.text = [[User currentUser] mobile];
    _txtEmpEmail.text = [[User currentUser] email];
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
        
        frame = _vwWitnesses.frame;
        frame.origin.y = CGRectGetMaxY(_vwAfterPersonalInfo.frame);
        _vwWitnesses.frame = frame;
        frame = _vwEmployeeInfo.frame;
        frame.origin.y = CGRectGetMaxY(_vwWitnesses.frame);
        _vwEmployeeInfo.frame = frame;
        [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
    }
}

- (IBAction)btnAddPersonTapped:(id)sender {
    [self addIncidentPersonalInformationViews];
}

- (IBAction)btnDeletePersonTapped:(UIButton *)sender {
    
    UIAlertView *aAlertDeletePerson = [[UIAlertView alloc]initWithTitle:[gblAppDelegate appName] message:@"Are you sure you want to delete most recently added Person Involved?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No", nil];
    
    aAlertDeletePerson.tag = 4;
    
    [aAlertDeletePerson show];
    
}

- (IBAction)btnAddWitnessTapped:(id)sender {
    [self addWitnessView];
}

- (IBAction)btnDeleteWitnessTapped:(UIButton *)sender {
    UIAlertView *aAlertDeleteWitness = [[UIAlertView alloc]initWithTitle:[gblAppDelegate appName] message:@"Are you sure you want to delete most recently added Witness?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No", nil];
    
    aAlertDeleteWitness.tag = 6;
    
    [aAlertDeleteWitness show];
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
    _isUpdate = YES;
    [sender setSelected:![sender isSelected]];
    
    if ((_btn911Called.selected && [[[[_btn911Called titleLabel] text] substringFromIndex:[[[_btn911Called titleLabel] text] length]-3] isEqualToString:@"(A)"]) ||
        (_btnPoliceCalled.selected && [[[[_btnPoliceCalled titleLabel] text] substringFromIndex:[[[_btnPoliceCalled titleLabel] text] length]-3] isEqualToString:@"(A)"]) ||
        (_btnManager.selected && [[[[_btnManager titleLabel] text] substringFromIndex:[[[_btnManager titleLabel] text] length]-3] isEqualToString:@"(A)"]) ||
        (_btnNone.selected && [[[[_btnNone titleLabel] text] substringFromIndex:[[[_btnNone titleLabel] text] length]-3] isEqualToString:@"(A)"]))
    {
        [_lblDisclaimer setHidden:NO];
        [_lblDisclaimerDetail setHidden:NO];
        
        CGRect frame = _vwBasicInfo.frame;
        
        frame.size.height = CGRectGetMaxY(_lblDisclaimerDetail.frame);
        
        _vwBasicInfo.frame = frame;
        
        frame = _vwPersonalInfo.frame;
        
        frame.origin.y = CGRectGetMaxY(_vwBasicInfo.frame);
        
        _vwPersonalInfo.frame = frame;
        
        
        //--- changes by chetan kasundra-----//
        //--- Problem when user click on Police called notification type. photo button of personalInvolved not click----
        frame = _vwAfterPersonalInfo.frame;
        frame.origin.y = CGRectGetMaxY(_vwPersonalInfo.frame);
        _vwAfterPersonalInfo.frame = frame;
        
        frame = _vwWitnesses.frame;
        frame.origin.y = CGRectGetMaxY(_vwAfterPersonalInfo.frame);
        _vwWitnesses.frame = frame;
        
        frame = _vwEmployeeInfo.frame;
        frame.origin.y = CGRectGetMaxY(_vwWitnesses.frame);
        _vwEmployeeInfo.frame = frame;
        [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
        
        //-----------//
        
    }
    else
    {
        [_lblDisclaimer setHidden:YES];
        [_lblDisclaimerDetail setHidden:YES];
        
        CGRect frame = _vwBasicInfo.frame;
        
        frame.size.height = CGRectGetMaxY(_btnNone.frame);
        
        _vwBasicInfo.frame = frame;
        
        frame = _vwPersonalInfo.frame;
        
        frame.origin.y = CGRectGetMaxY(_vwBasicInfo.frame);
        
        _vwPersonalInfo.frame = frame;
        
        
        
        //--- changes by chetan kasundra-----//
        //--- Problem when user click on Police called notification type. photo button of personalInvolved not click----
        
        frame = _vwAfterPersonalInfo.frame;
        frame.origin.y = CGRectGetMaxY(_vwPersonalInfo.frame);
        _vwAfterPersonalInfo.frame = frame;
        
        frame = _vwWitnesses.frame;
        frame.origin.y = CGRectGetMaxY(_vwAfterPersonalInfo.frame);
        _vwWitnesses.frame = frame;
        
        frame = _vwEmployeeInfo.frame;
        frame.origin.y = CGRectGetMaxY(_vwWitnesses.frame);
        _vwEmployeeInfo.frame = frame;
        [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
        
        //-----------//

    }
}

- (IBAction)btnSubmitTapped:(id)sender {
    if (![self checkValidation]) {
        return;
    }

    NSDictionary *aDict = [self createSubmitRequest];
    [gblAppDelegate callWebService:INCIDENT_REPORT_POST parameters:aDict httpMethod:[SERVICE_HTTP_METHOD objectForKey:INCIDENT_REPORT_POST] complition:^(NSDictionary *response) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:@"Incident Report has been submitted successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    } failure:^(NSError *error, NSDictionary *response) {
        [self saveIncidentToOffline:aDict completed:YES];
    }];
}

- (NSDictionary*)createSubmitRequest {
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *incidentDate = [aFormatter dateFromString:_txtDateOfIncident.text];
    NSDate *managementFollowupDate = [aFormatter dateFromString:_txtManagementFollowUp.text];
    [aFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *aStrDate = [NSString stringWithFormat:@"%@ %@", [aFormatter stringFromDate:incidentDate], _txtTimeOfIncident.text];
    
    NSMutableArray *mutArrPersons = [NSMutableArray array];
    for (IncidentPersonalInformation *vwPerson in mutArrIncidentPerson) {
        NSString *strDob = @"";
        
        if (vwPerson.txtDob.text.length > 0) {
            [aFormatter setDateFormat:@"MM/dd/yyyy"];
            NSDate *aDob = [aFormatter dateFromString:vwPerson.txtDob.text];
            [aFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            strDob = [aFormatter stringFromDate:aDob];
        }
        NSString *memberId = @"", *employeeId = @"",  *guestId = @"";
        
        if (vwPerson.intPersonInvolved == 3) {
            employeeId = vwPerson.txtMemberId.text;
        }
        else if(vwPerson.intPersonInvolved == 2){
            guestId = vwPerson.txtMemberId.text;
        }else{
            memberId = vwPerson.txtMemberId.text;
        }
        
        NSString *strPhoto = @"";
        if (vwPerson.imgIncidentPerson) {
            strPhoto = [UIImageJPEGRepresentation(vwPerson.imgIncidentPerson, 1.0) base64EncodedStringWithOptions:0];
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"name", vwPerson.txtActivity.text];
        NSArray *ary = [[reportSetupInfo.activityList allObjects] filteredArrayUsingPredicate:predicate];
        NSString *activityTypeID = [[ary firstObject] valueForKey:@"activityId"];
        if (!activityTypeID) activityTypeID = @"";
        
        
        predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"name", vwPerson.txtEquipment.text];
        ary = [[reportSetupInfo.equipmentList allObjects] filteredArrayUsingPredicate:predicate];
        NSString *equipmentTypeID = [[ary firstObject] valueForKey:@"equipmentId"];
        if (!equipmentTypeID) equipmentTypeID = @"";
        
        
        predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"name", vwPerson.txtWeather.text];
        ary = [[reportSetupInfo.conditionList allObjects] filteredArrayUsingPredicate:predicate];
        NSString* conditionTypeID = [[ary firstObject] valueForKey:@"conditionId"];
        if (!conditionTypeID) conditionTypeID = @"";
        
        predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"name", vwPerson.txtActionTaken.text];
        ary = [[reportSetupInfo.actionList allObjects] filteredArrayUsingPredicate:predicate];
        
        NSString* actionId = [[ary firstObject] valueForKey:@"actionId"];
        if (!actionId) actionId = @"";
        
        NSMutableArray *mutArrEmergency = [NSMutableArray array];
        if ([[[ary firstObject] valueForKey:@"emergencyPersonnel"] boolValue] && vwPerson.thirdSection) {
            for (EmergencyPersonnelView *vwEmergency in vwPerson.thirdSection.mutArrEmergencyViews) {
                id time911Called, timeArrival, timeDeparture;
                if ([vwEmergency.txtTime911Called.text isEqualToString:@""]) {
                    time911Called = [NSNull null];
                }
                else {
                    time911Called = vwEmergency.txtTime911Called.text;
                }
                
                if ([vwEmergency.txtTimeOfArrival.text isEqualToString:@""]) {
                    timeArrival = [NSNull null];
                }
                else {
                    timeArrival = vwEmergency.txtTimeOfArrival.text;
                }
                
                if ([vwEmergency.txtTimeOfDeparture.text isEqualToString:@""]) {
                    timeDeparture = [NSNull null];
                }
                else {
                    timeDeparture = vwEmergency.txtTimeOfDeparture.text;
                }
                NSDictionary *aDict = @{@"FirstName":vwEmergency.txtFirstName.text, @"MiddleInitial":vwEmergency.txtMI.text, @"LastName":vwEmergency.txtLastName.text, @"Phone":vwEmergency.txtPhone.text, @"AdditionalInformation":vwEmergency.txvAdditionalInfo.text, @"CaseNumber":vwEmergency.txtCaseNo.text, @"BadgeNumber":vwEmergency.txtBadge.text, @"Time911Called":time911Called, @"ArrivalTime":timeArrival, @"DepartureTime":timeDeparture};
                [mutArrEmergency addObject:aDict];
            }
            
        }
        
        predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"name", vwPerson.txtChooseIncident.text];
        ary = [[reportSetupInfo.natureList allObjects] filteredArrayUsingPredicate:predicate];
        NSString* natureId = [[ary firstObject] valueForKey:@"natureId"];
        if (!natureId) natureId = @"";
        
        
        
        NSDictionary *aDict = @{@"UserId": [[User currentUser] userId],@"FirstName": vwPerson.txtFirstName.trimText, @"MiddleInitial":vwPerson.txtMi.trimText, @"LastName":vwPerson.txtLastName.trimText, @"PrimaryPhone":vwPerson.txtHomePhone.text, @"AlternatePhone":vwPerson.txtAlternatePhone.text, @"Email":vwPerson.txtEmailAddress.text, @"Address1":vwPerson.txtStreetAddress.trimText, @"Address2":vwPerson.txtAppartment.trimText, @"City":vwPerson.txtCity.trimText, @"State":vwPerson.txtState.trimText, @"Zip": vwPerson.txtZip.text, @"AffiliationTypeId":[NSString stringWithFormat:@"%ld", (long)vwPerson.intAffiliationType], @"GenderTypeId":[NSString stringWithFormat:@"%ld", (long)vwPerson.intGenderType], @"PersonTypeId":[NSString stringWithFormat:@"%ld", (long)vwPerson.intPersonInvolved], @"GuestOfFirstName":vwPerson.txtGuestFName.text, @"GuestOfMiddleInitial":vwPerson.txtGuestMI.text, @"GuestOfLastName": vwPerson.txtguestLName.text, @"IsMinor":(vwPerson.btnMinor.isSelected) ? @"true" : @"false", @"EmployeeTitle":vwPerson.txtEmployeePosition.text, @"EmployeeId":employeeId, @"GuestId":guestId ,@"MemberId":memberId, @"OccuredDuringBusinessHours":(vwPerson.btnEmployeeOnWork.isSelected) ? @"true" : @"false", @"DateOfBirth":strDob, @"PersonPhoto":strPhoto , @"EmergencyPersonnel" : mutArrEmergency, @"NatureId" : natureId, @"ActionTakenId" : actionId, @"ActivityTypeId" : activityTypeID,@"EquipmentTypeId" : equipmentTypeID,@"ConditionId" : conditionTypeID};
        
        [mutArrPersons addObject:aDict];
    }
    
    NSMutableArray *mutArrEmergencyBlank = [NSMutableArray array];
    
    NSMutableArray *mutArrWitness = [NSMutableArray array];
    for (WitnessView *vwWitness in mutArrWitnessView) {
        NSDictionary *aDict = @{@"FirstName":vwWitness.txtWitnessFName.text, @"MiddleInitial":vwWitness.txtWitnessMI.text, @"LastName":vwWitness.txtWitnessLName.text, @"HomePhone":vwWitness.txtWitnessHomePhone.text, @"AlternatePhone":vwWitness.txtWitnessAlternatePhone.text, @"Email":vwWitness.txtWitnessEmailAddress.text, @"IncidentDescription":vwWitness.txvDescIncident.text, @"PersonTypeId" : [NSString stringWithFormat:@"%d",vwWitness.witnessInvolved]};
        [mutArrWitness addObject:aDict];
    }
    NSString *strFollowUpDate = [aFormatter stringFromDate:managementFollowupDate];
    if (!strFollowUpDate) strFollowUpDate = @"";
    NSString *facilityId = @"", *locationId = @"";
    if (selectedFacility.value) {
        facilityId = selectedFacility.value;
    }
    if (selectedLocation.value) {
        locationId = selectedLocation.value;
    }
      NSDictionary *aDict = @{ @"ReportType" : strReportType ,@"IncidentDate":aStrDate, @"FacilityId":facilityId, @"LocationId":locationId, @"IncidentDescription":_txvIncidentDesc.text, @"IsNotificationField1Selected":(_btn911Called.isSelected) ? @"true":@"false", @"IsNotificationField2Selected":(_btnPoliceCalled.isSelected) ? @"true":@"false", @"IsNotificationField3Selected":(_btnManager.isSelected) ? @"true":@"false", @"IsNotificationField4Selected":(_btnNone.isSelected) ? @"true":@"false", @"EmployeeFirstName":_txtEmpFName.trimText, @"EmployeeMiddleInitial": _txtEmpMI.trimText, @"EmployeeLastName":_txtEmpLName.trimText, @"EmployeeHomePhone":_txtEmpHomePhone.trimText, @"EmployeeAlternatePhone":_txtEmpAlternatePhone.text, @"EmployeeEmail":_txtEmpEmail.text, @"ReportFilerAccount":_txtReportAccount.text, @"ManagementFollowupDate":strFollowUpDate, @"AdditionalInformation": _txvAdditionalInfo.text, @"ManagementFollowupCallMadeType":[NSString stringWithFormat:@"%ld",(long)intFollowUpCallType], @"PersonsInvolved":mutArrPersons, @"EmergencyPersonnel":mutArrEmergencyBlank, @"Witnesses":mutArrWitness};

    //    NSDictionary *aDict = @{ @"ReportType" : strReportType ,@"IncidentDate":aStrDate, @"FacilityId":facilityId, @"LocationId":locationId, @"IncidentDescription":_txvIncidentDesc.text, @"IsNotificationField1Selected":(_btn911Called.isSelected) ? @"true":@"false", @"IsNotificationField2Selected":(_btnPoliceCalled.isSelected) ? @"true":@"false", @"IsNotificationField3Selected":(_btnManager.isSelected) ? @"true":@"false", @"IsNotificationField4Selected":(_btnNone.isSelected) ? @"true":@"false", @"EmployeeFirstName":_txtEmpFName.trimText, @"EmployeeMiddleInitial": _txtEmpMI.trimText, @"EmployeeLastName":_txtEmpLName.trimText, @"EmployeeHomePhone":_txtEmpHomePhone.trimText, @"EmployeeAlternatePhone":_txtEmpAlternatePhone.text, @"EmployeeEmail":_txtEmpEmail.text, @"ReportFilerAccount":_txtReportAccount.text, @"ManagementFollowupDate":strFollowUpDate, @"AdditionalInformation": _txvAdditionalInfo.text, @"ManagementFollowupCallMadeType":[NSString stringWithFormat:@"%ld",(long)intFollowUpCallType], @"ActivityTypeId": activityTypeID, @"EquipmentTypeId": equipmentTypeID, @"NatureId": natureId, @"ActionTakenId": actionId, @"ConditionId": conditionTypeID, @"PersonsInvolved":mutArrPersons, @"EmergencyPersonnel":mutArrEmergencyBlank, @"Witnesses":mutArrWitness};
    return aDict;
}



- (IBAction)btnBackTapped:(id)sender {
    [self.view endEditing:YES];
    if (_isUpdate) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:@"Would you like to save this report and complete it later?  You will lose all entered information if you choose \"No\"" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        alert.tag = 3;
        [alert show];
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
    
    if (alertView.tag == 3) {
        if (buttonIndex == 0) {
            [self saveIncidentToOffline:[self createSubmitRequest] completed:NO];
        }
        for (IncidentPersonalInformation *vw in mutArrIncidentPerson) {
            [vw removeObserver:self forKeyPath:@"frame"];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else if (alertView.tag == 4)
    {
        if (buttonIndex == 0){
            IncidentPersonalInformation *personalInfoView = (IncidentPersonalInformation*)[_vwPersonalInfo viewWithTag:totalPersonCount + 100];
            
            CGRect frame = _vwPersonalInfo.frame;
            frame.size.height = _vwPersonalInfo.frame.size.height - personalInfoView.frame.size.height;
            _vwPersonalInfo.frame = frame;
            
            frame = _vwAfterPersonalInfo.frame;
            frame.origin.y = CGRectGetMaxY(_vwPersonalInfo.frame);
            _vwAfterPersonalInfo.frame = frame;

            frame = _vwWitnesses.frame;
            frame.origin.y = CGRectGetMaxY(_vwAfterPersonalInfo.frame);
            _vwWitnesses.frame = frame;
            frame = _vwEmployeeInfo.frame;
            frame.origin.y = CGRectGetMaxY(_vwWitnesses.frame);
            _vwEmployeeInfo.frame = frame;
            [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
            
            int yPosition = _scrlMainView.contentOffset.y - personalInfoView.frame.size.height;
            
            if (yPosition < _scrlMainView.contentOffset.y) {
                  [_scrlMainView setContentOffset:CGPointMake(_scrlMainView.contentOffset.x, yPosition)];
            }
            
            [_scrlMainView setContentOffset:CGPointMake(_scrlMainView.contentOffset.x, yPosition)];
            
            totalPersonCount --;
        
            [personalInfoView removeObserver:self forKeyPath:@"frame" context:NULL];

            [personalInfoView removeFromSuperview];
            [mutArrIncidentPerson removeObject:personalInfoView];
            
            if (totalPersonCount<=1) {
                _btnRemovePerson.hidden=YES;
            }else{
                _btnRemovePerson.hidden=NO;
            }
        }
    }
    else if (alertView.tag == 6)
    {
        if (buttonIndex == 0){
            WitnessView *aWitnessView = (WitnessView*)[_vwWitnesses viewWithTag:totalWitnessCount + 300];
            
            CGRect frame = _vwWitnesses.frame;
            frame.size.height =  frame.size.height - aWitnessView.frame.size.height;
            _vwWitnesses.frame = frame;
            totalWitnessCount --;
            frame = _vwEmployeeInfo.frame;
            frame.origin.y = CGRectGetMaxY(_vwWitnesses.frame);
            _vwEmployeeInfo.frame = frame;
            [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
            
            int yPosition = _scrlMainView.contentOffset.y - aWitnessView.frame.size.height;
            
            if (yPosition < _scrlMainView.contentOffset.y) {
                [_scrlMainView setContentOffset:CGPointMake(_scrlMainView.contentOffset.x, yPosition)];
            }
            
            [mutArrWitnessView removeObject:aWitnessView];
            
            [aWitnessView removeFromSuperview];
            
            if (totalWitnessCount<=1) {
                _btnRemoveWitness.hidden=YES;
            }else{
                _btnRemoveWitness.hidden=NO;
            }
        }
    }
    else if (buttonIndex == 0) {
        for (IncidentPersonalInformation *vw in mutArrIncidentPerson) {
            [vw removeObserver:self forKeyPath:@"frame"];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - CoreData Methods

- (void)fetchIncidentSetupInfo {
    strReportType = @"";
    switch (_incidentType) {
        case 1:
            strReportType = MISCONDUCT;
            break;
        case 2:
            strReportType = CUSTOMER_SERVICE;
            break;
        case 3:
            strReportType = OTHER;
            break;
        default:
            break;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"IncidentReportInfo"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"reportType", strReportType];
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
    NSFetchRequest *requestLoc = [[NSFetchRequest alloc] initWithEntityName:@"UserLocation1"];
    
    NSPredicate *predicateLoc = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"facility.value", selectedFacility.value];
    [requestLoc setPredicate:predicateLoc];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [requestLoc setSortDescriptors:@[sortByName]];
    [requestLoc setPropertiesToFetch:@[@"name", @"value"]];
    aryLocation = [gblAppDelegate.managedObjectContext executeFetchRequest:requestLoc error:nil];
    requestLoc = nil;
}


- (void)saveIncidentToOffline:(NSDictionary*)aDict completed:(BOOL)isCompleted {
    Report *aReport = [NSEntityDescription insertNewObjectForEntityForName:@"Report" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    aReport.isCompleted = [NSNumber numberWithBool:isCompleted];
    aReport.userId = [[User currentUser] userId];
    aReport.incidentType = [NSNumber numberWithInteger:_incidentType];
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
    aReport.reportType = [aDict objectForKey:@"ReportType"];
    
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

        aPerson.guestOfFirstName = [dict objectForKey:@"GuestOfFirstName"];
        aPerson.guestOfMiddleInitial = [dict objectForKey:@"GuestOfMiddleInitial"];
        aPerson.guestOfLastName = [dict objectForKey:@"GuestOfLastName"];
        
        
        // NEED TO ENTER KEY NAME HERE
        aPerson.actionTakenId = [dict objectForKey:@"ActionTakenId"];
        aPerson.activityTypeId = [dict objectForKey:@"ActivityTypeId"];
        aPerson.conditionId = [dict objectForKey:@"ConditionId"];
        aPerson.natureId = [dict objectForKey:@"NatureId"];
        aPerson.equipmentTypeId = [dict objectForKey:@"EquipmentTypeId"];
        
        
        if (![[aDict objectForKey:@"PersonPhoto"] isEqualToString:@""]) {
            aPerson.personPhoto = [[aDict objectForKey:@"PersonPhoto"] base64EncodedDataWithOptions:0];
        }
        aPerson.minor = [dict objectForKey:@"IsMinor"];
        //        aPerson.duringWorkHours = (vwPerson.btnEmployeeOnWork.isSelected) ? @"true" : @"false";
        aPerson.report = aReport;
        
        
        
        NSMutableSet *emergencyPersonnel = [NSMutableSet set];
        
        for (NSDictionary *dictEmergency in [dict objectForKey:@"EmergencyPersonnel"]){
        
            EmergencyPersonnelIncident *aEmergencyPersonnelIncident = [NSEntityDescription insertNewObjectForEntityForName:@"EmergencyPersonnelIncident" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            
            aEmergencyPersonnelIncident.firstName = [dictEmergency objectForKey:@"FirstName"];
            aEmergencyPersonnelIncident.middleInitial = [dictEmergency objectForKey:@"MiddleInitial"];
            aEmergencyPersonnelIncident.lastName = [dictEmergency objectForKey:@"LastName"];
            aEmergencyPersonnelIncident.phone = [dictEmergency objectForKey:@"Phone"];
            aEmergencyPersonnelIncident.additionalInformation = [dictEmergency objectForKey:@"AdditionalInformation"];
            aEmergencyPersonnelIncident.caseNumber = [dictEmergency objectForKey:@"CaseNumber"];
            aEmergencyPersonnelIncident.badgeNumber = [dictEmergency objectForKey:@"BadgeNumber"];
            if ([[dictEmergency objectForKey:@"Time911Called"] isKindOfClass:[NSNull class]]) {
                aEmergencyPersonnelIncident.time911Called = @"";
            }
            else {
                aEmergencyPersonnelIncident.time911Called = [dictEmergency objectForKey:@"Time911Called"];
            }
            if ([[dictEmergency objectForKey:@"ArrivalTime"] isKindOfClass:[NSNull class]]) {
                aEmergencyPersonnelIncident.time911Arrival = @"";
            }
            else {
                aEmergencyPersonnelIncident.time911Arrival = [dictEmergency objectForKey:@"ArrivalTime"];
            }
            if ([[dictEmergency objectForKey:@"DepartureTime"] isKindOfClass:[NSNull class]]) {
                aEmergencyPersonnelIncident.time911Departure = @"";
            }
            else {
                aEmergencyPersonnelIncident.time911Departure = [dictEmergency objectForKey:@"DepartureTime"];
            }
            [emergencyPersonnel addObject:aEmergencyPersonnelIncident];
        }
        aPerson.emergencyPersonnelIncident = emergencyPersonnel;
        
        [personSet addObject:aPerson];
    }
    aReport.persons = personSet;
    
    NSMutableSet *emergencySet = [NSMutableSet set];

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
        aWitness.personTypeId = [dict objectForKey:@"PersonTypeId"];
        aWitness.report = aReport;
        [witnessSet addObject:aWitness];
    }
    aReport.witnesses = witnessSet;
    
    
    [gblAppDelegate.managedObjectContext insertedObjects];
    if ([gblAppDelegate.managedObjectContext save:nil] && isCompleted) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:MSG_ADDED_TO_SYNC delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
}

#pragma mark - Methods

- (void)addIncidentPersonalInformationViews {
    IncidentPersonalInformation *personalInfoView = (IncidentPersonalInformation*)[[[NSBundle mainBundle] loadNibNamed:@"IncidentPersonalInformation" owner:self options:nil] firstObject];
    personalInfoView.isCapturePhotoVisible = [reportSetupInfo.showPhotoIcon boolValue];
    personalInfoView.isAffiliationVisible = [reportSetupInfo.showAffiliation boolValue];
    personalInfoView.isMemberIdVisible = [reportSetupInfo.showMemberIdAndDriverLicense boolValue];
    personalInfoView.isGuestIdVisible = [reportSetupInfo.showGuestId boolValue];
    personalInfoView.isEmployeeIdVisible = [reportSetupInfo.showEmployeeId boolValue];
    personalInfoView.isDOBVisible = [reportSetupInfo.showDateOfBirth boolValue];
    personalInfoView.isGenderVisible = [reportSetupInfo.showGender boolValue];
    personalInfoView.isMinorVisible = [reportSetupInfo.showMinor boolValue];
    personalInfoView.isEmployeeIdVisible = [reportSetupInfo.showEmployeeId boolValue];
    personalInfoView.isConditionVisible = [reportSetupInfo.showConditions boolValue];
    personalInfoView.parentVC = self;
    

    [personalInfoView callInitialActions:reportSetupInfo];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"type", REQUIRED_TYPE_PERSON];
    NSArray *fields = [[reportSetupInfo.requiredFields allObjects] filteredArrayUsingPredicate:predicate];
    NSArray *aryFields = [fields valueForKeyPath:@"name"];
    [personalInfoView setRequiredFields:aryFields];
    [personalInfoView setBackgroundColor:[UIColor clearColor]];
    CGRect frame = personalInfoView.frame;
    if (mutArrIncidentPerson.count > 0) {
        CGRect rectLastView = [[mutArrIncidentPerson lastObject] frame];
        frame.origin.y = CGRectGetMaxY(rectLastView);
    }else{
        frame.origin.y = totalPersonCount * frame.size.height;
    }
    
    personalInfoView.frame = frame;
    [personalInfoView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [_vwPersonalInfo addSubview:personalInfoView];
    totalPersonCount ++;
    personalInfoView.tag = totalPersonCount + 100;
    [mutArrIncidentPerson addObject:personalInfoView];
    
    frame = _vwPersonalInfo.frame;
    frame.size.height = CGRectGetMaxY(personalInfoView.frame);
    _vwPersonalInfo.frame = frame;
    
    if (totalPersonCount<=1) {
        _btnRemovePerson.hidden=YES;
    }else{
        _btnRemovePerson.hidden=NO;
    }
    
    frame = _vwAfterPersonalInfo.frame;
    frame.origin.y = CGRectGetMaxY(_vwPersonalInfo.frame);
    _vwAfterPersonalInfo.frame = frame;
    
    frame = _vwWitnesses.frame;
    frame.origin.y = CGRectGetMaxY(_vwAfterPersonalInfo.frame);
    _vwWitnesses.frame = frame;
    
    frame = _vwEmployeeInfo.frame;
    frame.origin.y = CGRectGetMaxY(_vwWitnesses.frame);
    _vwEmployeeInfo.frame = frame;
    [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
}

-(void)addWitnessPresentView
{
    WitnessPresent *aWitnessPrensent = (WitnessPresent *) [[[NSBundle mainBundle]loadNibNamed:@"WitnessPresent" owner:self options:nil] firstObject];
    
    aWitnessPrensent.parentVCIncident = self;
    
    [aWitnessPrensent setBackgroundColor:[UIColor clearColor]];
    
    aWitnessPrensent.tag = 9999;
    
    [_vwWitnesses addSubview:aWitnessPrensent];
}


- (void)addWitnessView {
    
    WitnessView *aWitnessView = (WitnessView*)[[[NSBundle mainBundle] loadNibNamed:@"WitnessView" owner:self options:nil] firstObject];
    [aWitnessView setBackgroundColor:[UIColor clearColor]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"type", REQUIRED_TYPE_WITNESS];
    NSArray *fields = [[reportSetupInfo.requiredFields allObjects] filteredArrayUsingPredicate:predicate];
    NSArray *aryFields = [fields valueForKeyPath:@"name"];
    [aWitnessView setRequiredFields:aryFields];
    CGRect frame = aWitnessView.frame;
    
    if (mutArrWitnessView.count > 0) {
        CGRect frameLastView = [[mutArrWitnessView lastObject] frame];
        frame.origin.y = CGRectGetMaxY(frameLastView);
    }else{
        CGRect frameLastView = [[_vwWitnesses viewWithTag:9999] frame];
        frame.origin.y = CGRectGetMaxY(frameLastView);
        //frame.origin.y = totalWitnessCount * frame.size.height;
    }
    aWitnessView.frame = frame;
    [_vwWitnesses addSubview:aWitnessView];
    [mutArrWitnessView addObject:aWitnessView];
    totalWitnessCount ++;
    aWitnessView.tag = totalWitnessCount + 300;
    frame = _vwWitnesses.frame;
    frame.size.height = CGRectGetMaxY(aWitnessView.frame);
    _vwWitnesses.frame = frame;
    frame = _vwEmployeeInfo.frame;
    frame.origin.y = CGRectGetMaxY(_vwWitnesses.frame);
    _vwEmployeeInfo.frame = frame;
    [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
    _btnAddWitness.hidden = NO;
    if (totalWitnessCount<=1) {
        _btnRemoveWitness.hidden=YES;
    }else{
        _btnRemoveWitness.hidden=NO;
    }
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
    else if ([aryFields containsObject:@"middleInitial"] && [_txtEmpMI isTextFieldBlank]) {
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
//    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
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
        NSDate *pickerDate = [NSDate date];
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
//    else if ([textField isEqual:_txtActivity]) {
//        [self setKeepViewInFrame:textField];
//        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
//        dropDown.delegate = self;
//        NSArray *ary = [[reportSetupInfo.activityList allObjects] sortedArrayUsingDescriptors:@[sort]];
//        [dropDown showDropDownWith:ary view:textField key:@"name"];
//        allowEditing = NO;
//    }
//    else if ([textField isEqual:_txtWeather]) {
//        [self setKeepViewInFrame:textField];
//        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
//        dropDown.delegate = self;
//        NSArray *ary = [[reportSetupInfo.conditionList allObjects] sortedArrayUsingDescriptors:@[sort]];
//        [dropDown showDropDownWith:ary view:textField key:@"name"];
//        allowEditing = NO;
//    }
//    else if ([textField isEqual:_txtEquipment]) {
//        [self setKeepViewInFrame:textField];
//        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
//        dropDown.delegate = self;
//        NSArray *ary = [[reportSetupInfo.equipmentList allObjects] sortedArrayUsingDescriptors:@[sort]];
//        [dropDown showDropDownWith:ary view:textField key:@"name"];
//        allowEditing = NO;
//    }
//    else if ([textField isEqual:_txtChooseIncident]) {
//        [self setKeepViewInFrame:textField];
//        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
//        dropDown.delegate = self;
//        NSArray *ary = [[reportSetupInfo.natureList allObjects] sortedArrayUsingDescriptors:@[sort]];
//        [dropDown showDropDownWith:ary view:textField key:@"name"];
//        allowEditing = NO;
//    }
//    else if ([textField isEqual:_txtActionTaken]) {
//        [self setKeepViewInFrame:textField];
//        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
//        dropDown.delegate = self;
//        NSArray *ary = [[reportSetupInfo.actionList allObjects] sortedArrayUsingDescriptors:@[sort]];
//        [dropDown showDropDownWith:ary view:textField key:@"name"];
//        allowEditing = NO;
//    }
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
