//
//  FinalSection.m
//  GoBoardPro
//
//  Created by ind558 on 30/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "FinalSection.h"
#import "WitnessView.h"
#import "AccidentReportViewController.h"

@implementation FinalSection

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    _mutArrWitnessViews = [[NSMutableArray alloc] init];
    
    [self btnCommunicationTapped:_btnAdmin];
    [self btnSentToInsuranceTapped:_btnYesInsurance];
    [self btnProcedureFollowedTapped:_btnYesProcedure];
    [self btnCallMadeTapped:_btnYesCall];
    _txtEmpFName.text = [[User currentUser] firstName];
    _txtEmpMI.text = [[User currentUser] middleInitials];
    _txtEmpLName.text = [[User currentUser] lastName];
    _txtEmpHomePhone.text = [[User currentUser] phone];
    _txtEmpAlternatePhone.text = [[User currentUser] mobile];
    _txtEmpEmailAddr.text = [[User currentUser] email];
    [self isAdmin];
}

- (IBAction)btnAddMoreWitnessTapped:(id)sender {
    [self addWitnessView];
}

- (IBAction)btnCommunicationTapped:(UIButton *)sender {
    [sender setSelected:![sender isSelected]];
}

- (IBAction)btnSentToInsuranceTapped:(UIButton *)sender {
    [_btnYesInsurance setSelected:NO];
    [_btnNoInsurance setSelected:NO];
    [_btnInsuranceNotReq setSelected:NO];
    [sender setSelected:YES];
}

- (IBAction)btnProcedureFollowedTapped:(UIButton *)sender {
    [_btnYesProcedure setSelected:NO];
    [_btnNoProcedure setSelected:NO];
    [_btnProcedureNotReq setSelected:NO];
    [sender setSelected:YES];
}

- (IBAction)btnCallMadeTapped:(UIButton *)sender {
    [_btnYesCall setSelected:NO];
    [_btnNoCall setSelected:NO];
    [_btnCallNotReq setSelected:NO];
    [sender setSelected:YES];
}

- (IBAction)btnSignatureTapped:(id)sender {
    if (!_signatureView)
        _signatureView = [[SignatureView alloc] initWithNibName:@"SignatureView" bundle:nil];
    
    [_signatureView showPopOverWithSender:sender];
}

#pragma mark - Method

- (void)PersonInvolved:(NSInteger)person {
    if (!_vwManagementFollowUp.hidden) {
        if (person == PERSON_EMPLOYEE) {
            // Employee Selected
            [_vwEmpCompProcedure setHidden:NO];
            CGRect frame = _vwFollowup.frame;
            frame.origin.y = CGRectGetMaxY(_vwEmpCompProcedure.frame);
            _vwFollowup.frame = frame;
        }
        else {
            [_vwEmpCompProcedure setHidden:YES];
            CGRect frame = _vwFollowup.frame;
            frame.origin.y = _vwEmpCompProcedure.frame.origin.y;
            _vwFollowup.frame = frame;
        }
        
        CGRect frm = _vwManagementFollowUp.frame;
        frm.size.height = CGRectGetMaxY(_vwFollowup.frame);
        _vwManagementFollowUp.frame = frm;
        frm = _vwSubmit.frame;
        frm.origin.y = CGRectGetMaxY(_vwManagementFollowUp.frame);
        _vwSubmit.frame = frm;
        _vwSubmit.frame = frm;
        frm = _vwFixedContent.frame;
        frm.size.height = CGRectGetMaxY(_vwSubmit.frame);
        _vwFixedContent.frame = frm;
        frm = self.frame;
        frm.size.height = CGRectGetMaxY(_vwFixedContent.frame);
        self.frame = frm;
    }
}

- (void)isAdmin {
    if (![[User currentUser] isAdmin]) {
        [_vwManagementFollowUp setHidden:YES];
        CGRect frame = _vwSubmit.frame;
        frame.origin.y = _vwManagementFollowUp.frame.origin.y;
        _vwSubmit.frame = frame;
        frame = _vwFixedContent.frame;
        frame.size.height = CGRectGetMaxY(_vwSubmit.frame);
        _vwFixedContent.frame = frame;
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(_vwFixedContent.frame);
        self.frame = frame;
    }
}

- (void)addWitnessView {
    WitnessView *aWitnessView = (WitnessView*)[[[NSBundle mainBundle] loadNibNamed:@"WitnessView" owner:self options:nil] firstObject];
    aWitnessView.lblDescCaption.text = @"Description of Accident";
    [aWitnessView setBackgroundColor:[UIColor clearColor]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"type", REQUIRED_TYPE_WITNESS];
    NSArray *fields = [[_parentVC.reportSetupInfo.requiredFields allObjects] filteredArrayUsingPredicate:predicate];
    NSArray *aryFields = [fields valueForKeyPath:@"name"];
    [aWitnessView setRequiredFields:aryFields];
    CGRect frame = aWitnessView.frame;
    frame.origin.y = totalWitnessCount * frame.size.height;
    aWitnessView.frame = frame;
    [self addSubview:aWitnessView];
    totalWitnessCount ++;
    [_mutArrWitnessViews addObject:aWitnessView];
    frame = _vwFixedContent.frame;
    frame.origin.y = CGRectGetMaxY(aWitnessView.frame);
    _vwFixedContent.frame = frame;
    frame = self.frame;
    frame.size.height = CGRectGetMaxY(_vwFixedContent.frame);
    self.frame = frame;
}

- (void)setupEmployeeRequiredFields:(NSArray*)aryFields {
    if ([aryFields containsObject:@"firstName"]) [_markerEmpFName setHidden:NO];
    if ([aryFields containsObject:@"middleInital"]) [_markerEmpMI setHidden:NO];
    if ([aryFields containsObject:@"lastName"]) [_markerEmpLName setHidden:NO];
    if ([aryFields containsObject:@"homePhone"]) [_markerEmpPhone setHidden:NO];
    if ([aryFields containsObject:@"alternatePhone"]) [_markerEmpAltPhone setHidden:NO];
    if ([aryFields containsObject:@"email"]) [_markerEmpEmail setHidden:NO];
}

- (BOOL)isFinalSectionValidationSuccessWith:(NSArray *)aryFields {
    BOOL success = YES;
    for (WitnessView *view in _mutArrWitnessViews) {
        if (![view isWitnessViewValidationSuccess]) {
            success = NO;
            return success;
        }
    }
    
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
    else if ([aryFields containsObject:@"email"] && [_txtEmpEmailAddr isTextFieldBlank]) {
        success = NO;
        alert(@"", MSG_REQUIRED_FIELDS);
    }
    else if (![gblAppDelegate validateEmail:[_txtEmpEmailAddr text]]) {
        success = NO;
        [_txtEmpEmailAddr becomeFirstResponder];
        alert(@"", @"Please enter witness's valid email address");
    }
    
    return success;
}


#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_txtManagementFollowUpDate]) {
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_PAST_ONLY option:DATE_SELECTION_DATE_ONLY updateField:textField];
        return NO;
    }
    return YES;
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
    return YES;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    _parentVC.isUpdate = YES;
    if ([textView isEqual:_txvAdditionalInformation])
        [_lblAdditionalInfo setHidden:YES];
    if ([textView isEqual:_txvReportFilerAccount])
        [_lblReportFilerAccount setHidden:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text length] == 0) {
        if ([textView isEqual:_txvAdditionalInformation])
            [_lblAdditionalInfo setHidden:NO];
        if ([textView isEqual:_txvReportFilerAccount])
            [_lblReportFilerAccount setHidden:NO];
    }
}

- (void)setIsCommunicationVisible:(BOOL)isCommunicationVisible {
    _isCommunicationVisible = isCommunicationVisible;
    if (!isCommunicationVisible) {
        [_vwCommunication setHidden:YES];
        CGRect frame = _vwManagementFollowUp.frame;
        frame.origin.y = _vwCommunication.frame.origin.y;
        _vwManagementFollowUp.frame = frame;
        
        frame = _vwSubmit.frame;
        frame.origin.y = CGRectGetMaxY(_vwManagementFollowUp.frame);
        _vwSubmit.frame = frame;
        
        frame = _vwFixedContent.frame;
        frame.size.height = CGRectGetMaxY(_vwSubmit.frame);
        _vwFixedContent.frame = frame;
        
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(_vwFixedContent.frame);
        self.frame = frame;
    }
}


- (void)setIsManagementFollowUpVisible:(BOOL)isManagementFollowUpVisible {
    _isManagementFollowUpVisible = isManagementFollowUpVisible;
    if (!_isManagementFollowUpVisible) {
        [_vwManagementFollowUp setHidden:YES];
        CGRect frame = _vwSubmit.frame;
        frame.origin.y = CGRectGetMinY(_vwManagementFollowUp.frame);
        _vwSubmit.frame = frame;
        
        frame = _vwFixedContent.frame;
        frame.size.height = CGRectGetMaxY(_vwSubmit.frame);
        _vwFixedContent.frame = frame;
        
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(_vwFixedContent.frame);
        self.frame = frame;
    }
}

@end
