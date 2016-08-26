//
//  IncidentPersonalInformation.m
//  GoBoardPro
//
//  Created by ind558 on 01/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "IncidentPersonalInformation.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "EmergencyPersonnelView.h"
#import "EmergencyPersonnelIncident.h"
#import "ActionTakenList.h"
@implementation IncidentPersonalInformation
@synthesize mutArrEmergencyPersonnel,thirdSection;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {

}


#pragma mark - IBActions

- (IBAction)btnPersonInvolvedTapped:(UIButton *)sender {
    [_vwEmpPosition setHidden:YES];
    [_vwGuest setHidden:YES];
    [_vwEmployee setHidden:YES];
    [_btnEmployee setSelected:NO];
    [_btnGuest setSelected:NO];
    [_btnMember setSelected:NO];
    [sender setSelected:YES];
    CGRect frame = _vwCommon.frame;
    _intPersonInvolved = sender.tag;
    if ([sender isEqual:_btnGuest]) {
        if (!_isGuestIdVisible) [self hideMemberId:YES];
        else [self hideMemberId:NO];
        [_txtMemberId setPlaceholder:@"Guest ID"];
        [_vwGuest setHidden:NO];
        frame.origin.y = CGRectGetMaxY(_vwGuest.frame);
    }
    else if ([sender isEqual:_btnMember]) {
        if (!_isMemberIdVisible) [self hideMemberId:YES];
        else [self hideMemberId:NO];
        [_txtMemberId setPlaceholder:@"Member ID"];
        frame.origin.y = _vwEmployee.frame.origin.y;
    }
    else if ([sender isEqual:_btnEmployee]) {
        if (!_isEmployeeIdVisible) [_vwMemberId setHidden:YES];
        else [self hideMemberId:NO];
        
        CGRect frame1 = _vwPersonalInfo.frame;
        frame1.origin.y = CGRectGetMaxY(_vwEmpPosition.frame);
        _vwPersonalInfo.frame = frame1;

        frame1 = _vwEmployee.frame;
        frame1.origin.y = CGRectGetMaxY(_vwPersonalInfo.frame);
        _vwEmployee.frame = frame1;
        
        [_txtMemberId setPlaceholder:@"Employee ID"];
        [_vwEmpPosition setHidden:NO];
        [_vwEmployee setHidden:NO];
        frame.origin.y = CGRectGetMaxY(_vwEmployee.frame);
    }
    _vwCommon.frame = frame;
    
    frame = _vwIncidentDetail.frame;
    frame.origin.y = CGRectGetMaxY(_vwCommon.frame);
    _vwIncidentDetail.frame = frame;
    
    frame = _vwEmergencyPersonnel.frame;
    frame.origin.y = CGRectGetMaxY(_vwIncidentDetail.frame);
    _vwEmergencyPersonnel.frame = frame;
    
    frame = _btnCapturePerson.frame;
    frame.origin.y = CGRectGetMaxY(_vwEmergencyPersonnel.frame);
    _btnCapturePerson.frame = frame;
    
    CGRect mainFrame = self.frame;
    mainFrame.size.height = CGRectGetMaxY(frame);
    [self setFrame:mainFrame];
}

- (IBAction)btnAffiliationTapped:(UIButton *)sender {
    _intAffiliationType = sender.tag;
    [_btnNonAssessedStudent setSelected:NO];
    [_btnAssessedStudent setSelected:NO];
    [_btnAlumni setSelected:NO];
    [_btnStaff setSelected:NO];
    [_btnCommunity setSelected:NO];
    [_btnOther setSelected:NO];
    [sender setSelected:YES];
}

- (IBAction)btnWasEmployeeOnWorkTapped:(UIButton *)sender {
    [_btnEmployeeNotOnWork setSelected:NO];
    [_btnEmployeeOnWork setSelected:NO];
    [sender setSelected:YES];
}

- (IBAction)btnGenderTapped:(UIButton *)sender {
    _intGenderType = sender.tag;
    [_btnMale setSelected:NO];
    [_btnFemale setSelected:NO];
    [_btnNeutral setSelected:NO];
    [_btnOtherGender setSelected:NO];
    [sender setSelected:YES];
}

- (IBAction)btnIsMinorTapped:(UIButton *)sender {
    [_btnNotMinor setSelected:NO];
    [_btnMinor setSelected:NO];
    [sender setSelected:YES];
}

- (IBAction)btnCapturePersonPic:(UIButton*)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Capture Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Library", @"Camera", nil];
    CGRect rect = [self convertRect:sender.frame toView:self.superview];
    [actionSheet showFromRect:rect inView:self.superview animated:YES];
}

-(void)addEmergencyPersonnel
{
     [_vwEmergencyPersonnel setHidden:NO];
   
    if (!thirdSection) {
        thirdSection = (ThirdSection*)[[[NSBundle mainBundle] loadNibNamed:@"ThirdSection" owner:self options:nil] firstObject];
        thirdSection.delegate = self;
        thirdSection.isShowEmergencyResponse = YES;
        thirdSection.totalEmergencyPersonnelCount = 0;
        [thirdSection initialSetUp];
        [_vwEmergencyPersonnel addSubview:thirdSection];
    }else{
        [thirdSection addEmergencyPersonnel];
        [thirdSection resetSelfFrame];
    }
  
    CGRect frame = _vwEmergencyPersonnel.frame;
    frame.origin.y = CGRectGetMaxY(_vwIncidentDetail.frame);
    frame.size.height = CGRectGetMaxY(thirdSection.frame);
    _vwEmergencyPersonnel.frame = frame;
    
    frame = _btnCapturePerson.frame;
    frame.origin.y = CGRectGetMaxY(_vwEmergencyPersonnel.frame);
    _btnCapturePerson.frame = frame;
    
    frame = self.frame;
    frame.size.height = CGRectGetMaxY(_btnCapturePerson.frame);
    self.frame = frame;

}

// Third Section Delegate Method for adjusting frame after adding Extra Emergecny Personnel
-(void)adjustFramingForEmergencyView
{
    CGRect frame = _vwEmergencyPersonnel.frame;
    frame.size.height = CGRectGetMaxY(thirdSection.frame);
    _vwEmergencyPersonnel.frame = frame;
    
    frame = _btnCapturePerson.frame;
    frame.origin.y = CGRectGetMaxY(_vwEmergencyPersonnel.frame);
    _btnCapturePerson.frame = frame;
    
    frame = self.frame;
    frame.size.height = CGRectGetMaxY(_btnCapturePerson.frame);\
    self.frame = frame;
    
    frame = _parentVC.vwPersonalInfo.frame;
    frame.size.height = CGRectGetMaxY(self.frame);
    _parentVC.vwPersonalInfo.frame = frame;
    
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
    CGRect rect = [self convertRect:_btnCapturePerson.frame toView:self.superview];
    [popOver presentPopoverFromRect:rect inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)showCamera {
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [imgPicker setDelegate:self];
    [imgPicker setAllowsEditing:YES];
    [gblAppDelegate.navigationController presentViewController:imgPicker animated:YES completion:^{
        
    }];
}

- (void)setRequiredFields:(NSArray*)fields {
    requiredFields = fields;
   
    if ([requiredFields containsObject:@"memberId"]) [_markerMemberId setHidden:NO];
    if ([requiredFields containsObject:@"employeePosition"]) [_markerEmployeeTitle setHidden:NO];
    if ([requiredFields containsObject:@"firstName"]) [_markerFirstName setHidden:NO];
    if ([requiredFields containsObject:@"middleInitial"]) [_markerMI setHidden:NO];
    if ([requiredFields containsObject:@"lastName"]) [_markerLastName setHidden:NO];
    if ([requiredFields containsObject:@"homePhone"]) [_markerPhone setHidden:NO];
    if ([requiredFields containsObject:@"alternatePhone"]) [_markerAlternatePhone setHidden:NO];
    if ([requiredFields containsObject:@"email"]) [_markerEmail setHidden:NO];
    if ([requiredFields containsObject:@"streetAddress"]) [_markerAddress1 setHidden:NO];
    if ([requiredFields containsObject:@"email"]) [_markerAddress2 setHidden:NO];
    if ([requiredFields containsObject:@"city"]) [_markerCity setHidden:NO];
    if ([requiredFields containsObject:@"state"]) [_markerState setHidden:NO];
    if ([requiredFields containsObject:@"zip"]) [_markerZip setHidden:NO];
    if ([requiredFields containsObject:@"dateOfBirth"]) [_markerDOB setHidden:NO];
    if ([requiredFields containsObject:@"guestFirstName"]) [_markerGuestFName setHidden:NO];
    if ([requiredFields containsObject:@"guestMiddleInitial"]) [_markerGuestMI setHidden:NO];
    if ([requiredFields containsObject:@"guestLastName"]) [_markerGuestLName setHidden:NO];
}

- (void)populateEmergencyPersonnel:(NSArray*)aryEmergency {
    
    for (int i = 0; i < [aryEmergency count]; i++) {
//        if (i > 0) {
            [self addEmergencyPersonnel];
//        }
        EmergencyPersonnelView *vwEmergency = [thirdSection.mutArrEmergencyViews lastObject];
      
        EmergencyPersonnelIncident *aEmergencyIncident = aryEmergency[i];
        
        vwEmergency.txtFirstName.text = aEmergencyIncident.firstName;
        vwEmergency.txtLastName.text = aEmergencyIncident.lastName;
        vwEmergency.txtMI.text = aEmergencyIncident.middleInitial;
        vwEmergency.txtCaseNo.text = aEmergencyIncident.caseNumber;
        vwEmergency.txtPhone.text = aEmergencyIncident.phone;
        vwEmergency.txtBadge.text = aEmergencyIncident.badgeNumber;
        vwEmergency.txtTime911Called.text = aEmergencyIncident.time911Called;
        vwEmergency.txtTimeOfArrival.text = aEmergencyIncident.time911Arrival;
        vwEmergency.txtTimeOfDeparture.text = aEmergencyIncident.time911Departure;
        vwEmergency.txvAdditionalInfo.text = aEmergencyIncident.additionalInformation;
    }
}

- (BOOL)validateEmergencyPersonnel {
    for (EmergencyPersonnelView *emergency in mutArrEmergencyPersonnel) {
        if (![emergency isEmergencyPersonnelValidationSucceed]) {
            return NO;
        }
    }
    return YES;
}


- (BOOL)isPersonalInfoValidationSuccess {
    BOOL success = YES;
    
    if ([requiredFields containsObject:@"memberId"] && [_txtMemberId isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        success = NO;
    }
    else if ([requiredFields containsObject:@"employeePosition"] && ([_btnEmployee isSelected] && [_txtEmployeePosition isTextFieldBlank])) {
        alert(@"", MSG_REQUIRED_FIELDS);
        success = NO;
    }
    else if ([requiredFields containsObject:@"firstName"] && [_txtFirstName isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        success = NO;
    }
    else if ([requiredFields containsObject:@"middleInitial"] && [_txtMi isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        success = NO;
    }
    else if ([requiredFields containsObject:@"lastName"] && [_txtLastName isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        success = NO;
    }
    else if ([requiredFields containsObject:@"streetAddress"] && [_txtStreetAddress isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        success = NO;
    }
    else if ([requiredFields containsObject:@"city"] && [_txtCity isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        success = NO;
    }
    else if ([requiredFields containsObject:@"state"] && [_txtState isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        success = NO;
    }
    else if ([requiredFields containsObject:@"zip"] && [_txtZip isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        success = NO;
    }
    else if ([requiredFields containsObject:@"homePhone"] && [_txtHomePhone isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        success = NO;
    }
    else if (![_txtHomePhone.text isValidPhoneNumber]) {
        success = NO;
        [_txtHomePhone becomeFirstResponder];
        alert(@"", @"Please enter valid home phone number");
    }
    else if (![_txtAlternatePhone.text isValidPhoneNumber]) {
        success = NO;
        [_txtAlternatePhone becomeFirstResponder];
        alert(@"", @"Please enter valid alternate phone number");
    }
    else if ([requiredFields containsObject:@"email"] && [_txtEmailAddress isTextFieldBlank]) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if (![gblAppDelegate validateEmail:[_txtEmailAddress text]]) {
        success = NO;
        [_txtEmailAddress becomeFirstResponder];
        alert(@"", @"Please enter valid email address");
    }
    else if ([requiredFields containsObject:@"dateOfBirth"] && [_txtDob isTextFieldBlank]) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if ([requiredFields containsObject:@"guestFirstName"] && ([_btnGuest isSelected] && [_txtGuestFName isTextFieldBlank])) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if ([requiredFields containsObject:@"guestMiddleInitial"] && ([_btnGuest isSelected] && [_txtGuestMI isTextFieldBlank])) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if ([requiredFields containsObject:@"guestLastName"] && ([_btnGuest isSelected] && [_txtguestLName isTextFieldBlank])) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if (![self validateEmergencyPersonnel]) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    
    return success;
}

- (void)callInitialActions:(IncidentReportInfo*)reportSetupInfo {
    
    if (!_isAffiliationVisible) [self hideAffiliation];
    if (!_isDOBVisible) [self hideDateOfBirth];
    if (!_isGenderVisible) [self hideGender];
    if (!_isMinorVisible) [self hideMinor];
    if (!_isCapturePhotoVisible) [self hideCaptureButton];
    if (!_isConditionVisible) [self hideCondition];
    
    [_btnMember setTitle:reportSetupInfo.personInvolved1 forState:UIControlStateNormal];
    [_btnGuest setTitle:reportSetupInfo.personInvolved2 forState:UIControlStateNormal];
    [_btnEmployee setTitle:reportSetupInfo.personInvolved3 forState:UIControlStateNormal];
    
    [_btnNonAssessedStudent setTitle:reportSetupInfo.affiliation1 forState:UIControlStateNormal];
    [_btnAssessedStudent setTitle:reportSetupInfo.affiliation2 forState:UIControlStateNormal];
    [_btnAlumni setTitle:reportSetupInfo.affiliation3 forState:UIControlStateNormal];
    [_btnStaff setTitle:reportSetupInfo.affiliation4 forState:UIControlStateNormal];
    [_btnCommunity setTitle:reportSetupInfo.affiliation5 forState:UIControlStateNormal];
    [_btnOther setTitle:reportSetupInfo.affiliation6 forState:UIControlStateNormal];
    
    [self btnPersonInvolvedTapped:_btnMember];
    [self btnAffiliationTapped:_btnNonAssessedStudent];
    [self btnWasEmployeeOnWorkTapped:_btnEmployeeOnWork];
    [self btnGenderTapped:_btnMale];
    [self btnIsMinorTapped:_btnNotMinor];
}

-(void)hideCondition{
    
    
    
        [_vwConditions setHidden:YES];
        CGRect frame = _vwNatureOfIncident.frame;
        frame.origin.y = _vwConditions.frame.origin.y;
        _vwNatureOfIncident.frame = frame;
        frame = _vwIncidentDetail.frame;
        frame.size.height = CGRectGetMaxY(_vwNatureOfIncident.frame);
        _vwIncidentDetail.frame = frame;
        
        frame = _vwEmergencyPersonnel.frame;
        frame.origin.y = CGRectGetMaxY(_vwIncidentDetail.frame);
        _vwEmergencyPersonnel.frame = frame;
    
}

- (void)hideAffiliation {
    [_vwAffiliation setHidden:YES];
    CGRect frame = _vwMemberId.frame;
    frame.origin.y = CGRectGetMinY(_vwAffiliation.frame);
    _vwMemberId.frame = frame;
    
    frame = _vwEmpPosition.frame;
    frame.origin.y = CGRectGetMinY(_vwAffiliation.frame);
    _vwEmpPosition.frame = frame;
    
    frame = _vwPersonalInfo.frame;
    frame.origin.y = CGRectGetMaxY(_vwMemberId.frame);
    _vwPersonalInfo.frame = frame;
    
    frame = _vwEmployee.frame;
    frame.origin.y = CGRectGetMaxY(_vwPersonalInfo.frame);
    _vwEmployee.frame = frame;
    
    frame = _vwGuest.frame;
    frame.origin.y = _vwEmployee.frame.origin.y;
    _vwGuest.frame = frame;
    
    frame = _vwCommon.frame;
    frame.origin.y = _vwEmployee.frame.origin.y;
    _vwCommon.frame = frame;
    
    frame = _vwIncidentDetail.frame;
    frame.origin.y = CGRectGetMaxY(_vwCommon.frame);
    _vwIncidentDetail.frame = frame;
}


- (void)hideMemberId:(BOOL)shouldHide {
    [_vwMemberId setHidden:shouldHide];
    CGRect frame = _vwPersonalInfo.frame;
    if (shouldHide) {
        frame.origin.y = _vwMemberId.frame.origin.y;
    }
    else {
        frame.origin.y = CGRectGetMaxY(_vwMemberId.frame);
    }
    _vwPersonalInfo.frame = frame;
    
    frame = _vwEmployee.frame;
    frame.origin.y = CGRectGetMaxY(_vwPersonalInfo.frame);
    _vwEmployee.frame = frame;
    
    frame = _vwGuest.frame;
    frame.origin.y = _vwEmployee.frame.origin.y;
    _vwGuest.frame = frame;
    
    frame = _vwCommon.frame;
    frame.origin.y = _vwEmployee.frame.origin.y;
    _vwCommon.frame = frame;
    
    frame = _vwIncidentDetail.frame;
    frame.origin.y = CGRectGetMaxY(_vwCommon.frame);
    _vwIncidentDetail.frame = frame;
    
   
}

- (void)hideDateOfBirth {
    [_vwDob setHidden:YES];
}

- (void)hideGender {
    [_vwGender setHidden:YES];
    CGRect frame = _vwMinor.frame;
    frame.origin.y = _vwGender.frame.origin.y;
    _vwMinor.frame = frame;
    
    frame = _vwCommon.frame;
    frame.size.height = CGRectGetMaxY(_vwMinor.frame);
    _vwCommon.frame = frame;
    
    frame = _vwIncidentDetail.frame;
    frame.origin.y = CGRectGetMaxY(_vwCommon.frame);
    _vwIncidentDetail.frame = frame;
    
    frame = _vwEmergencyPersonnel.frame;
    frame.origin.y = CGRectGetMaxY(_vwIncidentDetail.frame);
    _vwEmergencyPersonnel.frame = frame;
}

- (void)hideMinor {
    [_vwMinor setHidden:YES];
    CGRect frame = _vwCommon.frame;
    frame.size.height = CGRectGetMinY(_vwMinor.frame);
    _vwCommon.frame = frame;
    
    frame = _vwIncidentDetail.frame;
    frame.origin.y = CGRectGetMaxY(_vwCommon.frame);
    _vwIncidentDetail.frame = frame;
    
    frame = _vwEmergencyPersonnel.frame;
    frame.origin.y = CGRectGetMaxY(_vwIncidentDetail.frame);
    _vwEmergencyPersonnel.frame = frame;
    
}

- (void)hideCaptureButton {
    [_btnCapturePerson setHidden:YES];
    CGRect frame = _btnCapturePerson.frame;
    frame.size = CGSizeZero;
    _btnCapturePerson.frame = frame;
}


#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL allowEditing = YES;
     NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sequence.intValue" ascending:YES];
    
    if ([textField isEqual:_txtDob]) {
//        [self setKeepViewInFrame:textField];
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_PAST_ONLY option:DATE_SELECTION_DATE_ONLY updateField:textField];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtState]) {
//        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:STATES view:textField key:nil];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtActivity]) {
        [self setKeepViewInFrameForTextField:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        NSArray *ary = [[_parentVC.reportSetupInfo.activityList allObjects] sortedArrayUsingDescriptors:@[sort]];
        [dropDown showDropDownWith:ary view:textField key:@"name"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtWeather]) {
         [self setKeepViewInFrameForTextField:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        NSArray *ary = [[_parentVC.reportSetupInfo.conditionList allObjects] sortedArrayUsingDescriptors:@[sort]];
        [dropDown showDropDownWith:ary view:textField key:@"name"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtEquipment]) {
         [self setKeepViewInFrameForTextField:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        NSArray *ary = [[_parentVC.reportSetupInfo.equipmentList allObjects] sortedArrayUsingDescriptors:@[sort]];
        [dropDown showDropDownWith:ary view:textField key:@"name"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtChooseIncident]) {
        [self setKeepViewInFrameForTextField:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        NSArray *ary = [[_parentVC.reportSetupInfo.natureList allObjects] sortedArrayUsingDescriptors:@[sort]];
        [dropDown showDropDownWith:ary view:textField key:@"name"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtActionTaken]) {
         [self setKeepViewInFrameForTextField:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        NSArray *ary = [[_parentVC.reportSetupInfo.actionList allObjects] sortedArrayUsingDescriptors:@[sort]];
        [dropDown showDropDownWith:ary view:textField key:@"name"];
        allowEditing = NO;
    }
    return allowEditing;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        if ([textField isEqual:_txtHomePhone] || [textField isEqual:_txtAlternatePhone]) {
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
    else if ([textField isEqual:_txtZip]) {
        NSCharacterSet *numericCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        if ([string rangeOfCharacterFromSet:numericCharacterSet].location == NSNotFound) {
            return NO;
        }
    }
    else if ([textField isEqual:_txtHomePhone] || [textField isEqual:_txtAlternatePhone]) {
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
    else if ([_txtMi isEqual:textField]) {
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 1) {
            return NO;
        }
    }
    
    return YES;
}

- (void)setKeepViewInFrame:(UIView*)vw {
    TPKeyboardAvoidingScrollView *scrollView = (TPKeyboardAvoidingScrollView*)[self superview];
    CGPoint point = [vw.superview convertPoint:vw.frame.origin toView:scrollView];
    if (point.y <scrollView.contentOffset.y || point.y > scrollView.contentOffset.y + scrollView.frame.size.height) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, point.y - 50) animated:NO];
    }
    
}
- (void)setKeepViewInFrameForTextField:(UIView*)vw {
//    CGPoint point = [vw.superview.superview convertPoint:vw.frame.origin toView:_parentVC.scrlMainView];
//    if (point.y <_parentVC.scrlMainView.contentOffset.y || point.y > _parentVC.scrlMainView.contentOffset.y + _parentVC.scrlMainView.frame.size.height) {
//        [_parentVC.scrlMainView setContentOffset:CGPointMake(_parentVC.scrlMainView.contentOffset.x, point.y - 50) animated:NO];
//    }
    
    TPKeyboardAvoidingScrollView *scrollView = (TPKeyboardAvoidingScrollView*)[self superview];
    while (![scrollView isKindOfClass:[TPKeyboardAvoidingScrollView class]]) {
        scrollView = (TPKeyboardAvoidingScrollView*)[scrollView superview];
    }
    CGPoint point = [vw.superview convertPoint:vw.frame.origin toView:scrollView];
    if (point.y <scrollView.contentOffset.y || point.y > scrollView.contentOffset.y + scrollView.frame.size.height) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, point.y - 50) animated:NO];
    }
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (buttonIndex == 0) {
            [self showPhotoLibrary];
        }
        else if (buttonIndex == 1)
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                [self showCamera];
            }
            else
            {
                alert(@"Error!!", @"Camera is not available");
            }
        }
    }];
}


- (void)dropDownControllerDidSelectValue:(id)value atIndex:(NSInteger)index sender:(id)sender {
    if ([value isKindOfClass:[NSString class]]) {
        [sender setText:value];
    }
    else {
        if (sender == _txtActionTaken) {
            
            
            if (_txtActionTaken.text.length==0) {
                ActionTakenList *aTask = (ActionTakenList *) value;
                
                NSLog(@"%d",aTask.emergencyPersonnel.boolValue);
                
                if (aTask.emergencyPersonnel.boolValue)
                    
                    [self addEmergencyPersonnel];
            }
            
            [sender setText:[value valueForKey:@"name"]];

        }
        else if (sender == _txtActivity)
        {
            
            [sender setText:[value valueForKey:@"name"]];
            
        }
        else if (sender == _txtChooseIncident)
        {            
            [sender setText:[value valueForKey:@"name"]];
            
        }
        else if (sender == _txtWeather)
        {
            [sender setText:[value valueForKey:@"name"]];
            
        }
        else if (sender == _txtWeather)
        {
            [sender setText:[value valueForKey:@"name"]];
            
        }
        else if (sender == _txtEquipment)
        {
            [sender setText:[value valueForKey:@"name"]];
            
        }
    }
}

#pragma mark - UIPopOverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    popOver = nil;
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    _imgIncidentPerson = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library saveImage:_imgIncidentPerson toAlbum:@"Connect2" withCompletionBlock:^(NSError *error) {
            if (error!=nil)
            {
                NSLog(@"error: %@", [error description]);
            }
            [gblAppDelegate.navigationController dismissViewControllerAnimated:YES completion:^{
            }];
        }];
    }else{
        if (popOver)
        {
            [popOver dismissPopoverAnimated:YES];
        }
        else
        {
            [gblAppDelegate.navigationController dismissViewControllerAnimated:YES completion:^{
            }];
        }
    }
}
@end