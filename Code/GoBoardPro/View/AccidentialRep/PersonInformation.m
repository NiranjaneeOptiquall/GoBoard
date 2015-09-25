//
//  PersonInformation.m
//  GoBoardPro
//
//  Created by ind558 on 29/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "PersonInformation.h"
#import "TPKeyboardAvoidingScrollView.h"

@implementation PersonInformation

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [self btnPersonInvolvedTapped:_btnMember];
    [self btnAffiliationTapped:_btnNonAssessedStudent];
    [self btnWasEmployeeOnWorkTapped:_btnEmployeeOnWork];
    [self btnGenderTapped:_btnMale];
    [self btnIsMinorTapped:_btnNotMinor];
    
}

#pragma mark - IBActions

- (IBAction)btnPersonInvolvedTapped:(UIButton *)sender {
    _intPersonInvolved = sender.tag;
    [_vwEmpPosition setHidden:YES];
    [_vwGuest setHidden:YES];
    [_vwEmployee setHidden:YES];
    [_btnEmployee setSelected:NO];
    [_btnGuest setSelected:NO];
    [_btnMember setSelected:NO];
    [sender setSelected:YES];
    CGRect frame = _vwCommon.frame;
    if ([sender isEqual:_btnGuest]) {
        if (!_isGuestIdVisible) [self hideMemberId:YES];
        else [self hideMemberId:NO];
        
        if ([requiredFields containsObject:@"driverLicenseNumber"]) {
            [_markerMemberId setHidden:NO];
        }
        else{
            [_markerMemberId setHidden:YES];
        }
        
        [_txtMemberId setPlaceholder:@"Guest ID"];
        [_vwGuest setHidden:NO];
        frame.origin.y = CGRectGetMaxY(_vwGuest.frame);
        [_parentVC setPersonInvolved:PERSON_GUEST];
    }
    else if ([sender isEqual:_btnMember]) {
        if (!_isMemberIdVisible) [self hideMemberId:YES];
        else [self hideMemberId:NO];
        
        if ([requiredFields containsObject:@"memberId"]) {
            [_markerMemberId setHidden:NO];
        }
        else{
            [_markerMemberId setHidden:YES];
        }
        
        [_txtMemberId setPlaceholder:@"Member ID"];
        frame.origin.y = _vwEmployee.frame.origin.y;
        [_parentVC setPersonInvolved:PERSON_MEMBER];
    }
    else if ([sender isEqual:_btnEmployee]) {
        [self hideMemberId:NO];
        if (!_isEmployeeIdVisible) [_vwMemberId setHidden:YES];
        else [self hideMemberId:NO];
        
        if ([requiredFields containsObject:@"employeeId"]) {
            [_markerMemberId setHidden:NO];
        }
        else{
            [_markerMemberId setHidden:YES];
        }
        
        [_txtMemberId setPlaceholder:@"Employee ID"];
        [_vwEmpPosition setHidden:NO];
        [_vwEmployee setHidden:NO];
        frame.origin.y = CGRectGetMaxY(_vwEmployee.frame);
        [_parentVC setPersonInvolved:PERSON_EMPLOYEE];
    }
    _vwCommon.frame = frame;
    CGRect mainFrame = self.frame;
    mainFrame.size.height = CGRectGetMaxY(frame);
    [self setFrame:mainFrame];
    _parentVC.isUpdate = YES;
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
    _parentVC.isUpdate = YES;
}

- (IBAction)btnWasEmployeeOnWorkTapped:(UIButton *)sender {
    [_btnEmployeeNotOnWork setSelected:NO];
    [_btnEmployeeOnWork setSelected:NO];
    [sender setSelected:YES];
    _parentVC.isUpdate = YES;
}

- (IBAction)btnGenderTapped:(UIButton *)sender {
    _intGenderType = sender.tag;
    [_btnMale setSelected:NO];
    [_btnFemale setSelected:NO];
    [_btnNeutral setSelected:NO];
    [_btnOtherGender setSelected:NO];
    [sender setSelected:YES];
    _parentVC.isUpdate = YES;
}

- (IBAction)btnIsMinorTapped:(UIButton *)sender {
    [_btnNotMinor setSelected:NO];
    [_btnMinor setSelected:NO];
    [sender setSelected:YES];
    _parentVC.isUpdate = YES;
}

#pragma mark - Methods

- (void)setRequiredFields:(NSArray*)fields {
    requiredFields = fields;
    if (_intPersonInvolved == 1) // For Member
    {
        if ([requiredFields containsObject:@"memberId"]) {
            [_markerMemberId setHidden:NO];
        }
        else{
            [_markerMemberId setHidden:YES];
        }
    }
    else if (_intPersonInvolved == 2) // For Guest
    {
        if ([requiredFields containsObject:@"driverLicenseNumber"]) {
            [_markerMemberId setHidden:NO];
        }
        else{
            [_markerMemberId setHidden:YES];
        }
    }
    else if (_intPersonInvolved==3) // For Employee
    {
        if ([requiredFields containsObject:@"employeeId"]) {
            [_markerMemberId setHidden:NO];
        }
        else{
            [_markerMemberId setHidden:YES];
        }
    }
    
    //if ([requiredFields containsObject:@"memberId"] || [requiredFields containsObject:@"driverLicenseNumber"] || [requiredFields containsObject:@"employeeId"]) [_markerMemberId setHidden:NO];
    if ([requiredFields containsObject:@"employeePosition"]) [_markerEmployeeTitle setHidden:NO];
    if ([requiredFields containsObject:@"firstName"]) [_markerFirstName setHidden:NO];
    if ([requiredFields containsObject:@"middleInital"]) [_markerMI setHidden:NO];
    if ([requiredFields containsObject:@"lastName"]) [_markerLastName setHidden:NO];
    if ([requiredFields containsObject:@"homePhone"]) [_markerPhone setHidden:NO];
    if ([requiredFields containsObject:@"alternatePhone"]) [_markerAlternatePhone setHidden:NO];
    if ([requiredFields containsObject:@"email"]) [_markerEmail setHidden:NO];
    if ([requiredFields containsObject:@"streetAddress"]) [_markerAddress1 setHidden:NO];
//    if ([requiredFields containsObject:@"email"]) [_markerAddress2 setHidden:NO];
    if ([requiredFields containsObject:@"city"]) [_markerCity setHidden:NO];
    if ([requiredFields containsObject:@"state"]) [_markerState setHidden:NO];
    if ([requiredFields containsObject:@"zip"]) [_markerZip setHidden:NO];
    if ([requiredFields containsObject:@"dateOfBirth"]) [_markerDOB setHidden:NO];
    if ([requiredFields containsObject:@"guestFirstName"]) [_markerGuestFName setHidden:NO];
    if ([requiredFields containsObject:@"guestMiddleInitial"]) [_markerGuestMI setHidden:NO];
    if ([requiredFields containsObject:@"guestLastName"]) [_markerGuestLName setHidden:NO];
}

- (BOOL)isPersonalInfoValidationSuccess {
    BOOL success = YES;
    
    if (_intPersonInvolved == 1) {
        if ([requiredFields containsObject:@"memberId"] && [_txtMemberId isTextFieldBlank]) {
            success = NO;
            alert(@"", MSG_REQUIRED_FIELDS);
        }

    }
    else if (_intPersonInvolved == 2){
        if ([requiredFields containsObject:@"driverLicenseNumber"] && [_txtMemberId isTextFieldBlank]) {
            success = NO;
            alert(@"", MSG_REQUIRED_FIELDS);
        }
    }
    else if (_intPersonInvolved == 3){
        if ([requiredFields containsObject:@"employeeId"] && [_txtMemberId isTextFieldBlank]) {
            success = NO;
            alert(@"", MSG_REQUIRED_FIELDS);
        }
    }
    else if ([requiredFields containsObject:@"employeePosition"] && ([_btnEmployee isSelected] && [_txtEmployeePosition isTextFieldBlank])) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if ([requiredFields containsObject:@"firstName"] && [_txtFirstName isTextFieldBlank]) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if ([requiredFields containsObject:@"middleInitial"] && [_txtMi isTextFieldBlank]) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if ([requiredFields containsObject:@"lastName"] && [_txtLastName isTextFieldBlank]) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if ([requiredFields containsObject:@"streetAddress"] && [_txtStreetAddress isTextFieldBlank]) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if ([requiredFields containsObject:@"city"] && [_txtCity isTextFieldBlank]) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if ([requiredFields containsObject:@"state"] && [_txtState isTextFieldBlank]) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if ([requiredFields containsObject:@"zip"] && [_txtZip isTextFieldBlank]) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if ([requiredFields containsObject:@"phone"] && [_txtHomePhone isTextFieldBlank]) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if (![_txtHomePhone.text isValidPhoneNumber]) {
        success = NO;
        [_txtHomePhone becomeFirstResponder];
        alert(@"", @"Please enter valid home phone number");
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
    
    return success;
}


- (void)callInitialActions {
    
    if (!_isAffiliationVisible) [self hideAffiliation];
    if (!_isDOBVisible) [self hideDateOfBirth];
    if (!_isGenderVisible) [self hideGender];
    if (!_isMinorVisible) [self hideMinor];
    if (!_isConditionsVisible) [self hideConditions];
    
    [_btnMember setTitle:_parentVC.reportSetupInfo.personInvolved1 forState:UIControlStateNormal];
    [_btnGuest setTitle:_parentVC.reportSetupInfo.personInvolved2 forState:UIControlStateNormal];
    [_btnEmployee setTitle:_parentVC.reportSetupInfo.personInvolved3 forState:UIControlStateNormal];
    
    [_btnNonAssessedStudent setTitle:_parentVC.reportSetupInfo.affiliation1 forState:UIControlStateNormal];
    [_btnAssessedStudent setTitle:_parentVC.reportSetupInfo.affiliation2 forState:UIControlStateNormal];
    [_btnAlumni setTitle:_parentVC.reportSetupInfo.affiliation3 forState:UIControlStateNormal];
    [_btnStaff setTitle:_parentVC.reportSetupInfo.affiliation4 forState:UIControlStateNormal];
    [_btnCommunity setTitle:_parentVC.reportSetupInfo.affiliation5 forState:UIControlStateNormal];
    [_btnOther setTitle:_parentVC.reportSetupInfo.affiliation6 forState:UIControlStateNormal];
    
    [self btnPersonInvolvedTapped:_btnMember];
    [self btnAffiliationTapped:_btnNonAssessedStudent];
    [self btnWasEmployeeOnWorkTapped:_btnEmployeeOnWork];
    [self btnGenderTapped:_btnMale];
    [self btnIsMinorTapped:_btnNotMinor];
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
    
    frame = _vwCommon.frame;
    frame.origin.y = _vwEmployee.frame.origin.y;
    _vwCommon.frame = frame;
    
    frame = _vwGuest.frame;
    frame.origin.y = _vwEmployee.frame.origin.y;
    _vwGuest.frame = frame;
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
    
    frame = _vwCommon.frame;
    frame.origin.y = _vwEmployee.frame.origin.y;
    _vwCommon.frame = frame;
    
    frame = _vwGuest.frame;
    frame.origin.y = _vwEmployee.frame.origin.y;
    _vwGuest.frame = frame;
}

- (void)hideDateOfBirth {
    [_vwDob setHidden:YES];
}

- (void)hideGender {
    [_vwGender setHidden:YES];
    CGRect frame = _vwMinor.frame;
    frame.origin.y = _vwGender.frame.origin.y;
    _vwMinor.frame = frame;
    
    frame = _vwActivity.frame;
    frame.origin.y = CGRectGetMaxY(_vwMinor.frame);
    _vwActivity.frame = frame;
    
    frame = _vwConditions.frame;
    frame.origin.y = CGRectGetMaxY(_vwActivity.frame);
    _vwConditions.frame = frame;
    
    frame = _vwCommon.frame;
    frame.size.height = CGRectGetMaxY(_vwConditions.frame);
    _vwCommon.frame = frame;
}

- (void)hideMinor {
    [_vwMinor setHidden:YES];
    
    CGRect frame = _vwActivity.frame;
    frame.origin.y = CGRectGetMinY(_vwMinor.frame);
    _vwActivity.frame = frame;
    
    frame = _vwConditions.frame;
    frame.origin.y = CGRectGetMaxY(_vwActivity.frame);
    _vwConditions.frame = frame;
    
    frame = _vwCommon.frame;
    frame.size.height = CGRectGetMaxY(_vwConditions.frame);
    _vwCommon.frame = frame;
}

- (void)hideConditions {
    [_vwConditions setHidden:YES];
    CGRect frame = _vwCommon.frame;
    frame.size.height = CGRectGetMinY(_vwConditions.frame);
    _vwCommon.frame = frame;
}




#pragma mark - UITextField Delegate 

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL allowEditing = YES;
    _parentVC.isUpdate = YES;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sequence.intValue" ascending:YES];
    if ([textField isEqual:_txtDob]) {
        [self setKeepViewInFrame:textField];
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_PAST_ONLY option:DATE_SELECTION_DATE_ONLY updateField:textField];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtState]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:STATES view:textField key:nil];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtActivity]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        NSArray *ary = [[_parentVC.reportSetupInfo.activityList allObjects] sortedArrayUsingDescriptors:@[sort]];
        [dropDown showDropDownWith:ary view:textField key:@"name"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtWheather]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        NSArray *ary = [[_parentVC.reportSetupInfo.conditionList allObjects] sortedArrayUsingDescriptors:@[sort]];
        [dropDown showDropDownWith:ary view:textField key:@"name"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtEquipment]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        NSArray *ary = [[_parentVC.reportSetupInfo.equipmentList allObjects] sortedArrayUsingDescriptors:@[sort]];
        [dropDown showDropDownWith:ary view:textField key:@"name"];
        allowEditing = NO;
    }
    return allowEditing;
}

- (void)setKeepViewInFrame:(UIView*)vw {
    TPKeyboardAvoidingScrollView *scrollView = (TPKeyboardAvoidingScrollView*)[self superview];
    while (![scrollView isKindOfClass:[TPKeyboardAvoidingScrollView class]]) {
        scrollView = (TPKeyboardAvoidingScrollView*)[scrollView superview];
    }
    CGPoint point = [vw.superview convertPoint:vw.frame.origin toView:scrollView];
    if (point.y <scrollView.contentOffset.y || point.y > scrollView.contentOffset.y + scrollView.frame.size.height) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, point.y - 50) animated:NO];
    }
    
}

- (void)dropDownControllerDidSelectValue:(id)value atIndex:(NSInteger)index sender:(id)sender {
    if ([value isKindOfClass:[NSString class]]) {
        [sender setText:value];
    }
    else {
        [sender setText:[value valueForKey:@"name"]];
    }
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


@end
