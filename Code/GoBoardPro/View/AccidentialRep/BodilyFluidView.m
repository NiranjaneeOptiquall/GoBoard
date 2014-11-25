//
//  BodilyFluidView.m
//  GoBoardPro
//
//  Created by ind558 on 30/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "BodilyFluidView.h"

@implementation BodilyFluidView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    
}

- (IBAction)btnBloodbornePathogenTapped:(UIButton*)sender {
    [_btnSelfTreated setSelected:NO];
    [_btnEmployeeTreated setSelected:NO];
    [_btnMedicalPersonnelTreated setSelected:NO];
    [sender setSelected:YES];
}

- (IBAction)btnExposedToBloodTapped:(UIButton *)sender {
    [_btnExposedToBlood setSelected:NO];
    [_btnNotExposedToBlood setSelected:NO];
    [sender setSelected:YES];
}

- (IBAction)btnBloodCleanUpRequiredTapped:(id)sender {
    [_btnBloodCleanupRequired setSelected:NO];
    [_btnBloodCleanupNotRequired setSelected:NO];
    [sender setSelected:YES];
}

- (IBAction)btnWasBloodPresentTapped:(UIButton *)sender {
    [_btnBloodPresent setSelected:NO];
    [_btnBloodNotPresent setSelected:NO];
    [sender setSelected:YES];
}

- (IBAction)btnSignatureTapped:(id)sender {
    if (!_signatureView)
        _signatureView = [[SignatureView alloc] initWithNibName:@"SignatureView" bundle:nil];
        
    [_signatureView showPopOverWithSender:sender];
}

- (BOOL)isBodilyFluidValidationSucceed {
    BOOL success = YES;
    if ([_txtFName isTextFieldBlank] || [_txtMI isTextFieldBlank] || [_txtLName isTextFieldBlank] || [_txtPosition isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        success = NO;
    }
    return success;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _parentVC.isUpdate = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if ([_txtMI isEqual:textField]) {
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 5) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    _parentVC.isUpdate = YES;
    [_lblStaffMemberAccount setHidden:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text length] == 0) {
        [_lblStaffMemberAccount setHidden:NO];
    }
}


- (void)setIsBloodBornePathogenVisible:(BOOL)isBloodBornePathogenVisible {
    _isBloodBornePathogenVisible = isBloodBornePathogenVisible;
    if (_isBloodBornePathogenVisible) {
        [self btnWasBloodPresentTapped:_btnBloodPresent];
        [self btnBloodbornePathogenTapped:_btnSelfTreated];
        [self btnExposedToBloodTapped:_btnExposedToBlood];
        [self btnBloodCleanUpRequiredTapped:_btnBloodCleanupRequired];
    }
    else {
        [_vwBloodbornePathogens setHidden:YES];
        CGRect frame = _vwRefuseCare.frame;
        frame.origin.y = CGRectGetMinY(_vwBloodbornePathogens.frame);
        _vwRefuseCare.frame = frame;
        
        frame = _vwParticipantSignature.frame;
        frame.origin.y = CGRectGetMaxY(_vwRefuseCare.frame);
        _vwParticipantSignature.frame = frame;
        
        frame = _vwStaffMember.frame;
        frame.origin.y = CGRectGetMaxY(_vwParticipantSignature.frame);
        _vwStaffMember.frame = frame;
        
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(_vwStaffMember.frame);
        self.frame = frame;
    }
}

- (void)setIsRefuseCareStatementVisible:(BOOL)isRefuseCareStatementVisible {
    _isRefuseCareStatementVisible = isRefuseCareStatementVisible;
    if (!_isRefuseCareStatementVisible) {
        [_vwRefuseCare setHidden:YES];
        
        CGRect frame = _vwParticipantSignature.frame;
        frame.origin.y = CGRectGetMinY(_vwRefuseCare.frame);
        _vwParticipantSignature.frame = frame;
        
        frame = _vwStaffMember.frame;
        frame.origin.y = CGRectGetMaxY(_vwParticipantSignature.frame);
        _vwStaffMember.frame = frame;
        
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(_vwStaffMember.frame);
        self.frame = frame;
    }
}

- (void)setIsParticipantSignatureVisible:(BOOL)isParticipantSignatureVisible {
    _isParticipantSignatureVisible = isParticipantSignatureVisible;
    if (!_isParticipantSignatureVisible) {
        [_vwParticipantSignature setHidden:YES];
        CGRect frame = _vwStaffMember.frame;
        frame.origin.y = CGRectGetMinY(_vwParticipantSignature.frame);
        _vwStaffMember.frame = frame;
        
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(_vwStaffMember.frame);
        self.frame = frame;
    }
}

@end
