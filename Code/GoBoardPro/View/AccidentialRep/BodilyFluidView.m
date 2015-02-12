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
    _intBloodBornePathogen = sender.tag;
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
    if ([sender isEqual:_btnBloodPresent]) {
        [_vwBloodborne setHidden:NO];
        CGRect frame = _vwBloodbornePathogens.frame;
        frame.size.height = CGRectGetMaxY(_vwBloodborne.frame);
        _vwBloodbornePathogens.frame = frame;
    }
    else {
        [_vwBloodborne setHidden:YES];
        CGRect frame = _vwBloodbornePathogens.frame;
        frame.size.height = CGRectGetMinY(_vwBloodborne.frame);
        _vwBloodbornePathogens.frame = frame;
    }
    CGRect frame = _vwRefuseCare.frame;
    frame.origin.y = CGRectGetMaxY(_vwBloodbornePathogens.frame);
    _vwRefuseCare.frame = frame;
    [self setIsRefuseCareStatementVisible:_isRefuseCareStatementVisible];
    [self setIsSelfCareStatementVisible:_isSelfCareStatementVisible];
    [self setIsParticipantSignatureVisible:_isParticipantSignatureVisible];
//    _vwParticipantSignature
//    _vwStaffMember
}

- (IBAction)btnSignatureTapped:(UIButton*)sender {
    if (!_signatureView)
        _signatureView = [[SignatureView alloc] initWithNibName:@"SignatureView" bundle:nil];
    __weak SignatureView *weakSignature = _signatureView;
        [_signatureView setCompletion:^{
            if (weakSignature.tempDrawImage.image) {
                [sender setTitle:@"Edit Participant's Signature" forState:UIControlStateNormal];
            }
            else {
                [sender setTitle:@"Participant's Signature" forState:UIControlStateNormal];
            }
        }];
    [_signatureView showPopOverWithSender:sender];
}

- (void)setRequiredFields:(NSArray*)fields {
    if ([fields containsObject:@"firstName"]) [_markerFName setHidden:NO];
    if ([fields containsObject:@"middleInital"]) [_markerMI setHidden:NO];
    if ([fields containsObject:@"lastName"]) [_markerLName setHidden:NO];
    if ([fields containsObject:@"position"]) [_markerPosition setHidden:NO];
}

- (BOOL)isBodilyFluidValidationSucceedWith:(NSArray*)fields {
    BOOL success = YES;
    if (!_vwFirstAid.isHidden) {
        if ([fields containsObject:@"firstName"] && [_txtFName isTextFieldBlank]) {
            alert(@"", MSG_REQUIRED_FIELDS);
            success = NO;
        }
        else if ([fields containsObject:@"middleInitial"] && [_txtMI isTextFieldBlank]) {
            alert(@"", MSG_REQUIRED_FIELDS);
            success = NO;
        }
        else if ([fields containsObject:@"lastName"] && [_txtLName isTextFieldBlank]) {
            alert(@"", MSG_REQUIRED_FIELDS);
            success = NO;
        }
        else if ([fields containsObject:@"position"] && [_txtPosition isTextFieldBlank]) {
            alert(@"", MSG_REQUIRED_FIELDS);
            success = NO;
        }
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
        
        frame = _vwSelfCare.frame;
        frame.origin.y = CGRectGetMaxY(_vwRefuseCare.frame);
        _vwSelfCare.frame = frame;
        
        frame = _vwParticipantSignature.frame;
        frame.origin.y = CGRectGetMaxY(_vwSelfCare.frame);
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
        
        CGRect frame = _vwSelfCare.frame;
        frame.origin.y = CGRectGetMinY(_vwRefuseCare.frame);
        _vwSelfCare.frame = frame;
        
        frame = _vwParticipantSignature.frame;
        frame.origin.y = CGRectGetMaxY(_vwSelfCare.frame);
        _vwParticipantSignature.frame = frame;
        
        frame = _vwStaffMember.frame;
        frame.origin.y = CGRectGetMaxY(_vwParticipantSignature.frame);
        _vwStaffMember.frame = frame;
        
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(_vwStaffMember.frame);
        self.frame = frame;
    }
    else {
        [_vwRefuseCare setHidden:NO];
        
        CGRect frame = _vwSelfCare.frame;
        frame.origin.y = CGRectGetMaxY(_vwRefuseCare.frame);
        _vwSelfCare.frame = frame;
        
        frame = _vwParticipantSignature.frame;
        frame.origin.y = CGRectGetMaxY(_vwSelfCare.frame);
        _vwParticipantSignature.frame = frame;
        
        frame = _vwStaffMember.frame;
        frame.origin.y = CGRectGetMaxY(_vwParticipantSignature.frame);
        _vwStaffMember.frame = frame;
        
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(_vwStaffMember.frame);
        self.frame = frame;
    }
}

- (void)setIsSelfCareStatementVisible:(BOOL)isSelfCareStatementVisible {
    _isSelfCareStatementVisible = isSelfCareStatementVisible;
    if (!_isSelfCareStatementVisible) {
        [_vwSelfCare setHidden:YES];
        
        CGRect frame = _vwParticipantSignature.frame;
        frame.origin.y = CGRectGetMinY(_vwSelfCare.frame);
        _vwParticipantSignature.frame = frame;
        
        frame = _vwStaffMember.frame;
        frame.origin.y = CGRectGetMaxY(_vwParticipantSignature.frame);
        _vwStaffMember.frame = frame;
        
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(_vwStaffMember.frame);
        self.frame = frame;
    }
    else {
        [_vwSelfCare setHidden:NO];
        
        CGRect frame = _vwParticipantSignature.frame;
        frame.origin.y = CGRectGetMaxY(_vwSelfCare.frame);
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
    [self shouldShowParticipantsSignatureView:_isParticipantSignatureVisible];
}

- (void)shouldShowParticipantsSignatureView:(BOOL)show {
    if (show && (_isRefusedCareSelected || _isSelfCareSelected)) {
        [_vwParticipantSignature setHidden:NO];
        CGRect frame = _vwStaffMember.frame;
        frame.origin.y = CGRectGetMaxY(_vwParticipantSignature.frame);
        _vwStaffMember.frame = frame;
        
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(_vwStaffMember.frame);
        self.frame = frame;
    }
    else {
        [_vwParticipantSignature setHidden:YES];
        CGRect frame = _vwStaffMember.frame;
        frame.origin.y = CGRectGetMinY(_vwParticipantSignature.frame);
        _vwStaffMember.frame = frame;
        
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(_vwStaffMember.frame);
        self.frame = frame;
    }
}

- (void)shouldShowFirstAddView:(BOOL)show {
    if (show) {
        [_vwFirstAid setHidden:NO];
        CGRect frame = _vwBloodborne.frame;
        frame.origin.y = CGRectGetMaxY(_vwFirstAid.frame);
        _vwBloodborne.frame = frame;
    }
    else {
        [_vwFirstAid setHidden:YES];
        CGRect frame = _vwBloodborne.frame;
        frame.origin.y = CGRectGetMinY(_vwFirstAid.frame);
        _vwBloodborne.frame = frame;
    }
    
    if ([_btnBloodPresent isSelected]) {
        CGRect frame = _vwBloodbornePathogens.frame;
        frame.size.height = CGRectGetMaxY(_vwBloodborne.frame);
        _vwBloodbornePathogens.frame = frame;
    }
    else {
        CGRect frame = _vwBloodbornePathogens.frame;
        frame.size.height = CGRectGetMinY(_vwBloodborne.frame);
        _vwBloodbornePathogens.frame = frame;
    }
    CGRect frame = _vwRefuseCare.frame;
    frame.origin.y = CGRectGetMaxY(_vwBloodbornePathogens.frame);
    _vwRefuseCare.frame = frame;
    
    frame = _vwSelfCare.frame;
    frame.origin.y = CGRectGetMaxY(_vwRefuseCare.frame);
    _vwSelfCare.frame = frame;
    

    [self setIsRefuseCareStatementVisible:_isRefuseCareStatementVisible];
    [self setIsSelfCareStatementVisible:_isSelfCareStatementVisible];
    [self setIsParticipantSignatureVisible:_isParticipantSignatureVisible];
}

@end
