//
//  IncidentPersonalInformation.m
//  GoBoardPro
//
//  Created by ind558 on 01/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "IncidentPersonalInformation.h"
#import "TPKeyboardAvoidingScrollView.h"

@implementation IncidentPersonalInformation

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
    if ([sender isEqual:_btnGuest]) {
        if (!_isMemberIdVisible) [self hideMemberId:YES];
        [_txtMemberId setPlaceholder:@"Driver's License #"];
        [_vwGuest setHidden:NO];
        frame.origin.y = CGRectGetMaxY(_vwGuest.frame);
    }
    else if ([sender isEqual:_btnMember]) {
        if (!_isMemberIdVisible) [self hideMemberId:YES];
        [_txtMemberId setPlaceholder:@"Member ID"];
        frame.origin.y = _vwEmployee.frame.origin.y;
    }
    else if ([sender isEqual:_btnEmployee]) {
        [self hideMemberId:NO];
        [_txtMemberId setPlaceholder:@"Employee ID"];
        [_vwEmpPosition setHidden:NO];
        [_vwEmployee setHidden:NO];
        frame.origin.y = CGRectGetMaxY(_vwEmployee.frame);
    }
    _vwCommon.frame = frame;
    CGRect mainFrame = self.frame;
    mainFrame.size.height = CGRectGetMaxY(frame);
    [self setFrame:mainFrame];
}

- (IBAction)btnAffiliationTapped:(UIButton *)sender {
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

#pragma mark - Methods

- (BOOL)isPersonalInfoValidationSuccessFor:(NSArray*)fields {
    BOOL success = YES;
    
    if ([fields containsObject:@"memberid"] && [_txtMemberId isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        success = NO;
    }
    else if ([fields containsObject:@"employeePosition"] && ([_btnEmployee isSelected] && [_txtEmployeePosition isTextFieldBlank])) {
        alert(@"", MSG_REQUIRED_FIELDS);
        success = NO;
    }
    else if ([fields containsObject:@"firstname"] && [_txtFirstName isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        success = NO;
    }
    else if ([fields containsObject:@"middleInitial"] && [_txtMi isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        success = NO;
    }
    else if ([fields containsObject:@"lastname"] && [_txtLastName isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        success = NO;
    }
    else if ([fields containsObject:@"streetAddress"] && [_txtStreetAddress isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        success = NO;
    }
    else if ([fields containsObject:@"city"] && [_txtCity isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        success = NO;
    }
    else if ([fields containsObject:@"state"] && [_txtState isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        success = NO;
    }
    else if ([fields containsObject:@"zip"] && [_txtZip isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        success = NO;
    }
    else if ([fields containsObject:@"homePhone"] && [_txtHomePhone isTextFieldBlank]) {
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
    else if ([fields containsObject:@"email"] && [_txtEmailAddress isTextFieldBlank]) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if (![gblAppDelegate validateEmail:[_txtEmailAddress text]]) {
        success = NO;
        [_txtEmailAddress becomeFirstResponder];
        alert(@"", @"Please enter valid email address");
    }
    else if ([fields containsObject:@"dateOfBirth"] && [_txtDob isTextFieldBlank]) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if ([fields containsObject:@"guestFirstName"] && ([_btnGuest isSelected] && [_txtGuestFName isTextFieldBlank])) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if ([fields containsObject:@"guestMiddleInitial"] && ([_btnGuest isSelected] && [_txtGuestMI isTextFieldBlank])) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if ([fields containsObject:@"guestLastName"] && ([_btnGuest isSelected] && [_txtguestLName isTextFieldBlank])) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    return success;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL allowEditing = YES;
    if ([textField isEqual:_txtDob]) {
        [self setKeepViewInFrame:textField];
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_PAST_ONLY option:DATE_SELECTION_DATE_ONLY updateField:textField];
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
    if ([textField isEqual:_txtHomePhone] || [textField isEqual:_txtAlternatePhone]) {
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
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 5) {
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

- (void)callInitialActions {
    
    if (!_isAffiliationVisible) [self hideAffiliation];
    if (!_isDOBVisible) [self hideDateOfBirth];
    if (!_isGenderVisible) [self hideGender];
    if (!_isMinorVisible) [self hideMinor];
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
    
    frame = _vwCommon.frame;
    frame.size.height = CGRectGetMaxY(_vwMinor.frame);
    _vwCommon.frame = frame;
}

- (void)hideMinor {
    [_vwMinor setHidden:YES];
    CGRect frame = _vwCommon.frame;
    frame.size.height = CGRectGetMinY(_vwMinor.frame);
    _vwCommon.frame = frame;
}



@end
