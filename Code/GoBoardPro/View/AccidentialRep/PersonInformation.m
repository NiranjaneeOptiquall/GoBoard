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
    [self btnNotificationTapped:_btnNone];
    [self btnPersonInvolvedTapped:_btnMember];
    [self btnAffiliationTapped:_btnNonAssessedStudent];
    [self btnWasEmployeeOnWorkTapped:_btnEmployeeOnWork];
    [self btnGenderTapped:_btnMale];
    [self btnIsMinorTapped:_btnNotMinor];
}

#pragma mark - IBActions


- (IBAction)btnNotificationTapped:(UIButton *)sender {
    [_btn911Called setSelected:NO];
    [_btnPoliceCalled setSelected:NO];
    [_btnManager setSelected:NO];
    [_btnNone setSelected:NO];
    [sender setSelected:YES];
}

- (IBAction)btnPersonInvolvedTapped:(UIButton *)sender {
    [_imvEmployeePosBG setHidden:YES];
    [_txtEmployeePosition setHidden:YES];
    [_vwGuest setHidden:YES];
    [_vwEmployee setHidden:YES];
    [_btnEmployee setSelected:NO];
    [_btnGuest setSelected:NO];
    [_btnMember setSelected:NO];
    [sender setSelected:YES];
    CGRect frame = _vwCommon.frame;
    if ([sender isEqual:_btnGuest]) {
        [_txtMemberId setPlaceholder:@"Driver's License #"];
        [_vwGuest setHidden:NO];
        frame.origin.y = CGRectGetMaxY(_vwGuest.frame);
    }
    else if ([sender isEqual:_btnMember]) {
        [_txtMemberId setPlaceholder:@"Member ID"];
        frame.origin.y = _vwEmployee.frame.origin.y;
    }
    else if ([sender isEqual:_btnEmployee]) {
        [_txtMemberId setPlaceholder:@"Employee ID"];
        [_imvEmployeePosBG setHidden:NO];
        [_txtEmployeePosition setHidden:NO];
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
    [_btnOther setSelected:NO];
    [sender setSelected:YES];
}

- (IBAction)btnIsMinorTapped:(UIButton *)sender {
    [_btnNotMinor setSelected:NO];
    [_btnMinor setSelected:NO];
    [sender setSelected:YES];
}

#pragma mark - Methods

- (BOOL)isPersonalInfoValidationSuccess {
    BOOL success = YES;
    if ([_txtDateOfIncident isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please choose date of incident");
    }
    else if ([_txtTimeOfIncident isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please choose time of incident");
    }
    else if ([_txtFacility isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please choose facility");
    }
    else if ([_txtLocation isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please choose location");
    }
    else if ([_txtMemberId isTextFieldBlank]) {
        success = NO;
        if ([_btnMember isSelected]) {
            alert(@"", @"Please enter member id");
        }
        else if ([_btnGuest isSelected]) {
            alert(@"", @"Please enter driver's licence number");
        }
        else if ([_btnEmployee isSelected]) {
            alert(@"", @"Please enter employee id");
        }
    }
    else if ([_btnEmployee isSelected] && [_txtEmployeePosition isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please enter employee position");
    }
    else if ([_txtFirstName isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please enter first name");
    }
    else if ([_txtMi isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please enter middle name");
    }
    else if ([_txtLastName isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please enter last name");
    }
    else if ([_txtStreetAddress isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please enter street address");
    }
    else if ([_txtCity isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please enter city");
    }
    else if ([_txtState isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please enter state");
    }
    else if ([_txtZip isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please enter zip");
    }
    else if ([_txtHomePhone isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please enter home phone number");
    }
    else if (![_txtHomePhone.text isValidPhoneNumber]) {
        success = NO;
        [_txtHomePhone becomeFirstResponder];
        alert(@"", @"Please enter valid home phone number");
    }
    else if ([_txtEmailAddress isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please enter email address");
    }
    else if (![gblAppDelegate validateEmail:[_txtEmailAddress text]]) {
        success = NO;
        [_txtEmailAddress becomeFirstResponder];
        alert(@"", @"Please enter valid email address");
    }
    else if ([_txtDob isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please choose date of birth");
    }
    else if ([_btnGuest isSelected] && [_txtGuestFName isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please enter host first name");
    }
    else if ([_btnGuest isSelected] && [_txtGuestMI isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please enter host middle name");
    }
    else if ([_btnGuest isSelected] && [_txtguestLName isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please enter host last name");
    }
    else if ([_txtActivity isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please choose activity");
    }
    else if ([_txtWheather isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please choose Wheather");
    }
    else if ([_txtEquipment isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please choose equipment");
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
        [dropDown showDropDownWith:FACILITY_VALUES view:textField key:@"title"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtLocation]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:LOCATION_VALUES view:textField key:@"title"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtDob]) {
        [self setKeepViewInFrame:textField];
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_PAST_ONLY option:DATE_SELECTION_DATE_ONLY updateField:textField];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtActivity]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:LOCATION_VALUES view:textField key:@"title"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtWheather]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:LOCATION_VALUES view:textField key:@"title"];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtEquipment]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:LOCATION_VALUES view:textField key:@"title"];
        allowEditing = NO;
    }
    return allowEditing;
}

- (void)setKeepViewInFrame:(UIView*)vw {
    TPKeyboardAvoidingScrollView *scrollView = (TPKeyboardAvoidingScrollView*)[self superview];
    CGPoint point = [vw.superview convertPoint:vw.frame.origin toView:scrollView];
    if (point.y <scrollView.contentOffset.y || point.y > scrollView.contentOffset.y + scrollView.frame.size.height) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, point.y - 50) animated:NO];
    }
    
}

- (void)dropDownControllerDidSelectValue:(id)value atIndex:(NSInteger)index sender:(id)sender {
    [sender setText:[value objectForKey:@"title"]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if ([textField isEqual:_txtHomePhone] || [textField isEqual:_txtAlternatePhone]) {
        NSCharacterSet *numericCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789 +()"];
        if ([string rangeOfCharacterFromSet:numericCharacterSet].location == NSNotFound) {
            return NO;
        }
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 15) {
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

@end
