//
//  BodilyFluidView.m
//  GoBoardPro
//
//  Created by ind558 on 30/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "BodilyFluidView.h"
#import "EmergencyPersonnelView.h"
#import "Emergency.h"

@implementation BodilyFluidView
@synthesize thirdSection;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
   
}

#pragma mark - To Populate Emergency Personnel
- (void)populateEmergencyPersonnel:(NSArray*)aryEmergency {
    
    for (int i = 0; i < [aryEmergency count]; i++) {
        if (i > 0) {
            [thirdSection addEmergencyPersonnel];
            [thirdSection resetSelfFrame];
        }
        
        EmergencyPersonnelView *vwEmergency = [thirdSection.mutArrEmergencyViews lastObject];
        
        Emergency *aEmergency = aryEmergency[i];
        
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
    
    CGRect frame = _vwEmergencyPersonnel.frame;
    
    frame.size.height = CGRectGetMaxY(thirdSection.frame);
    
    _vwEmergencyPersonnel.frame = frame;
    
    frame = _vwStaffMember.frame;
    frame.origin.y = CGRectGetMaxY(_vwEmergencyPersonnel.frame);
    _vwStaffMember.frame = frame;
    
    frame = self.frame;
    frame.size.height = CGRectGetMaxY(_vwStaffMember.frame);
    self.frame = frame;
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
    
    
    CGRect frame = _vwStaffMember.frame;
    frame.origin.y = CGRectGetMaxY(_vwBloodbornePathogens.frame);
    _vwStaffMember.frame = frame;
   
    frame = self.frame;
    frame.size.height = CGRectGetMaxY(_vwStaffMember.frame);
    self.frame = frame;
    
//    [self setIsFirstAidVisible:_isFirstAidVisible];
//    [self setIsRefuseCareStatementVisible:_isRefuseCareStatementVisible];
//    [self setIsSelfCareStatementVisible:_isSelfCareStatementVisible];
//    [self setIsParticipantSignatureVisible:_isParticipantSignatureVisible];
//    [self setIsEmergencyPersonnelVisible:_isEmergencyPersonnelVisible];

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
    if ([fields containsObject:@"middleInitial"]) [_markerMI setHidden:NO];
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
    if (thirdSection && ![thirdSection isThirdSectionValidationSuccess]) {
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
        [_vwBloodbornePathogens setHidden:NO];
        [self btnWasBloodPresentTapped:_btnBloodNotPresent];
        [self btnBloodbornePathogenTapped:_btnSelfTreated];
        [self btnExposedToBloodTapped:_btnExposedToBlood];
        [self btnBloodCleanUpRequiredTapped:_btnBloodCleanupRequired];
    }
    else {
        [_vwBloodbornePathogens setHidden:YES];
        CGRect frame = _vwStaffMember.frame;
        frame.origin.y = CGRectGetMinY(_vwBloodbornePathogens.frame);
        _vwStaffMember.frame = frame;
        
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(_vwStaffMember.frame);
        self.frame = frame;
    }
}

- (void)setIsRefuseCareStatementVisible:(BOOL)isRefuseCareStatementVisible {
    _isRefuseCareStatementVisible = isRefuseCareStatementVisible;
    if (!_isRefuseCareStatementVisible) {
        _isRefusedCareSelected = NO;
        [_vwRefuseCare setHidden:YES];
        
        CGRect frame = _vwSelfCare.frame;
        frame.origin.y = CGRectGetMinY(_vwRefuseCare.frame);
        _vwSelfCare.frame = frame;
        
        frame = _vwParticipantSignature.frame;
        frame.origin.y = CGRectGetMaxY(_vwSelfCare.frame);
        _vwParticipantSignature.frame = frame;
        
        
        frame = _vwEmergencyPersonnel.frame;
        frame.origin.y = CGRectGetMaxY(_vwParticipantSignature.frame);
        _vwEmergencyPersonnel.frame = frame;
        
        frame = _vwBloodbornePathogens.frame;
        frame.origin.y = CGRectGetMaxY(_vwEmergencyPersonnel.frame);
        _vwBloodbornePathogens.frame = frame;
        
        frame = _vwStaffMember.frame;
        frame.origin.y = CGRectGetMaxY(_vwBloodbornePathogens.frame);
        _vwStaffMember.frame = frame;
        
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(_vwStaffMember.frame);
        self.frame = frame;
    }
    else {
        _isRefusedCareSelected = YES;
        [_vwRefuseCare setHidden:NO];
        
        CGRect frame = _vwSelfCare.frame;
        frame.origin.y = CGRectGetMaxY(_vwRefuseCare.frame);
        _vwSelfCare.frame = frame;
        
        frame = _vwParticipantSignature.frame;
        frame.origin.y = CGRectGetMaxY(_vwSelfCare.frame);
        _vwParticipantSignature.frame = frame;
        
        frame = _vwEmergencyPersonnel.frame;
        frame.origin.y = CGRectGetMaxY(_vwParticipantSignature.frame);
        _vwEmergencyPersonnel.frame = frame;
        
        frame = _vwBloodbornePathogens.frame;
        frame.origin.y = CGRectGetMaxY(_vwEmergencyPersonnel.frame);
        _vwBloodbornePathogens.frame = frame;
        
        frame = _vwStaffMember.frame;
        frame.origin.y = CGRectGetMaxY(_vwBloodbornePathogens.frame);
        _vwStaffMember.frame = frame;
        
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(_vwStaffMember.frame);
        self.frame = frame;
    }
}

- (void)setIsSelfCareStatementVisible:(BOOL)isSelfCareStatementVisible {
    _isSelfCareStatementVisible = isSelfCareStatementVisible;
    if (!_isSelfCareStatementVisible) {
        _isSelfCareSelected = NO;
        [_vwSelfCare setHidden:YES];
        
        CGRect frame = _vwParticipantSignature.frame;
        frame.origin.y = CGRectGetMinY(_vwSelfCare.frame);
        _vwParticipantSignature.frame = frame;
        
        frame = _vwEmergencyPersonnel.frame;
        frame.origin.y = CGRectGetMaxY(_vwParticipantSignature.frame);
        _vwEmergencyPersonnel.frame = frame;
        
        frame = _vwBloodbornePathogens.frame;
        frame.origin.y = CGRectGetMaxY(_vwEmergencyPersonnel.frame);
        _vwBloodbornePathogens.frame = frame;
        
        frame = _vwStaffMember.frame;
        frame.origin.y = CGRectGetMaxY(_vwBloodbornePathogens.frame);
        _vwStaffMember.frame = frame;
        
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(_vwStaffMember.frame);
        self.frame = frame;
    }
    else {
        _isSelfCareSelected = YES;
        [_vwSelfCare setHidden:NO];
        
        CGRect frame = _vwParticipantSignature.frame;
        frame.origin.y = CGRectGetMaxY(_vwSelfCare.frame);
        _vwParticipantSignature.frame = frame;
        
        frame = _vwEmergencyPersonnel.frame;
        frame.origin.y = CGRectGetMaxY(_vwParticipantSignature.frame);
        _vwEmergencyPersonnel.frame = frame;
        
        frame = _vwBloodbornePathogens.frame;
        frame.origin.y = CGRectGetMaxY(_vwEmergencyPersonnel.frame);
        _vwBloodbornePathogens.frame = frame;
        
        frame = _vwStaffMember.frame;
        frame.origin.y = CGRectGetMaxY(_vwBloodbornePathogens.frame);
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
    
        CGRect  frame = _vwEmergencyPersonnel.frame;
        frame.origin.y = CGRectGetMaxY(_vwParticipantSignature.frame);
        _vwEmergencyPersonnel.frame = frame;
        
        frame = _vwBloodbornePathogens.frame;
        frame.origin.y = CGRectGetMaxY(_vwEmergencyPersonnel.frame);
        _vwBloodbornePathogens.frame = frame;
        
        frame = _vwStaffMember.frame;
        frame.origin.y = CGRectGetMaxY(_vwBloodbornePathogens.frame);
        _vwStaffMember.frame = frame;
        
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(_vwStaffMember.frame);
        self.frame = frame;
    }
    else {
        [_vwParticipantSignature setHidden:YES];
        
        CGRect  frame = _vwEmergencyPersonnel.frame;
        frame.origin.y = CGRectGetMinY(_vwParticipantSignature.frame);
        _vwEmergencyPersonnel.frame = frame;
        
        frame = _vwBloodbornePathogens.frame;
        frame.origin.y = CGRectGetMaxY(_vwEmergencyPersonnel.frame);
        _vwBloodbornePathogens.frame = frame;
        
        frame = _vwStaffMember.frame;
        frame.origin.y = CGRectGetMaxY(_vwBloodbornePathogens.frame);
        _vwStaffMember.frame = frame;
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(_vwStaffMember.frame);
        self.frame = frame;
    }
}
-(void)setIsEmergencyPersonnelVisible:(BOOL)isEmergencyPersonnelVisible{
    _isEmergencyPersonnelVisible = isEmergencyPersonnelVisible;
    [self shouldShowEmergencyPersonnelView:_isEmergencyPersonnelVisible];
}

- (void)shouldShowEmergencyPersonnelView:(BOOL)show {
    
    if (show) {
        [_vwEmergencyPersonnel setHidden:NO];
        
        for (UIView *aVW in _vwEmergencyPersonnel.subviews) {
            if ([aVW isKindOfClass:[ThirdSection class]]) {
                [aVW removeFromSuperview];
            }
        }
        
        thirdSection = (ThirdSection*)[[[NSBundle mainBundle] loadNibNamed:@"ThirdSection" owner:self options:nil] firstObject];
        thirdSection.parentVC = _parentVC;
        thirdSection.isShowEmergencyResponse = _isEmergencyResponseSelected;
        thirdSection.delegate = self;
        [thirdSection initialSetUp];
        [_vwEmergencyPersonnel addSubview:thirdSection];
        
        CGRect frame = _vwEmergencyPersonnel.frame;
        frame.size.height = CGRectGetMaxY(thirdSection.frame);
        _vwEmergencyPersonnel.frame = frame;

        if (_isEmergencyPersonnelVisible) {
            
            frame = _vwEmergencyPersonnel.frame;
            
            if (_isParticipantSignatureVisible && (_isRefusedCareSelected || _isSelfCareSelected)) {
                frame.origin.y = CGRectGetMaxY(_vwParticipantSignature.frame);
            }else{
                if(_isSelfCareStatementVisible) {
                    frame.origin.y = CGRectGetMaxY(_vwSelfCare.frame);
                }else{
                    if (_isRefuseCareStatementVisible) {
                        frame.origin.y = CGRectGetMaxY(_vwRefuseCare.frame);
                    }else{
                        frame.origin.y = CGRectGetMinY(_vwRefuseCare.frame);
                    }
                }
            }
            _vwEmergencyPersonnel.frame = frame;
        }
        
        
        frame = _vwBloodbornePathogens.frame;
        frame.origin.y = CGRectGetMaxY(_vwEmergencyPersonnel.frame);
        _vwBloodbornePathogens.frame = frame;
        
        frame = _vwStaffMember.frame;
        frame.origin.y = CGRectGetMaxY(_vwBloodbornePathogens.frame);
        _vwStaffMember.frame = frame;
        
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(_vwStaffMember.frame);
        self.frame = frame;

    }
    else {
        
        [_vwEmergencyPersonnel setHidden:YES];
       
        for (ThirdSection *objThirdSection in _vwEmergencyPersonnel.subviews) {
            [objThirdSection removeFromSuperview];
        }
        
        if ([_vwEmergencyPersonnel.subviews containsObject:thirdSection]) {
            [thirdSection removeFromSuperview];
        }
        
        if (thirdSection) {
            thirdSection.isShowEmergencyResponse = NO;
            thirdSection = nil;
        }
        CGRect frame = _vwEmergencyPersonnel.frame;
        
        if (_isParticipantSignatureVisible && (_isRefusedCareSelected || _isSelfCareSelected)) {
            frame.origin.y = CGRectGetMaxY(_vwParticipantSignature.frame);
        }else{
            if(_isSelfCareStatementVisible) {
                frame.origin.y = CGRectGetMaxY(_vwSelfCare.frame);
            }else{
                if (_isRefuseCareStatementVisible) {
                    frame.origin.y = CGRectGetMaxY(_vwRefuseCare.frame);
                }else{
                    frame.origin.y = CGRectGetMinY(_vwRefuseCare.frame);
                }
            }
        }
        _vwEmergencyPersonnel.frame = frame;
        
        frame = _vwBloodbornePathogens.frame;
        frame.origin.y = CGRectGetMaxY(_vwEmergencyPersonnel.frame);
        _vwBloodbornePathogens.frame = frame;
        
        frame = _vwStaffMember.frame;
        frame.origin.y = CGRectGetMinY(_vwBloodbornePathogens.frame);
        _vwStaffMember.frame = frame;
        
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(_vwStaffMember.frame);
        self.frame = frame;
    }
}
// Third Section Delegate Method for adjusting frame after adding Extra Emergecny Personnel
-(void)adjustFramingForEmergencyView
{

    CGRect frame = _vwEmergencyPersonnel.frame;
    frame.size.height = CGRectGetMaxY(thirdSection.frame);
    _vwEmergencyPersonnel.frame = frame;
    
    if (_isEmergencyPersonnelVisible) {
        
        frame = _vwEmergencyPersonnel.frame;
        
        if (_isParticipantSignatureVisible && (_isRefusedCareSelected || _isSelfCareSelected)) {
            frame.origin.y = CGRectGetMaxY(_vwParticipantSignature.frame);
        }else{
            if(_isSelfCareStatementVisible) {
                frame.origin.y = CGRectGetMaxY(_vwSelfCare.frame);
            }else{
                if (_isRefuseCareStatementVisible) {
                    frame.origin.y = CGRectGetMaxY(_vwRefuseCare.frame);
                }else{
                    frame.origin.y = CGRectGetMinY(_vwRefuseCare.frame);
                }
            }
        }
        _vwEmergencyPersonnel.frame = frame;
    }
    
    
    frame = _vwBloodbornePathogens.frame;
    frame.origin.y = CGRectGetMaxY(_vwEmergencyPersonnel.frame);
    _vwBloodbornePathogens.frame = frame;
    
    frame = _vwStaffMember.frame;
    frame.origin.y = CGRectGetMaxY(_vwBloodbornePathogens.frame);
    _vwStaffMember.frame = frame;
    
    frame = self.frame;
    frame.size.height = CGRectGetMaxY(_vwStaffMember.frame);
    self.frame = frame;
}

-(void)setIsFirstAidVisible:(BOOL)isFirstAidVisible{
    _isFirstAidVisible = isFirstAidVisible;
    [self shouldShowFirstAddView:_isFirstAidVisible];
}


- (void)shouldShowFirstAddView:(BOOL)show {

    if (show) {
        [_vwFirstAid setHidden:NO];
        CGRect frame = _vwRefuseCare.frame;
        frame.origin.y = CGRectGetMaxY(_vwFirstAid.frame);
        _vwRefuseCare.frame = frame;
    }
    else {
        [_vwFirstAid setHidden:YES];
        CGRect frame = _vwRefuseCare.frame;
        frame.origin.y = CGRectGetMinY(_vwFirstAid.frame);
        _vwRefuseCare.frame = frame;
    }
    
    [self setIsSelfCareStatementVisible:_isSelfCareStatementVisible];
    [self setIsParticipantSignatureVisible:_isParticipantSignatureVisible];
    [self setIsEmergencyPersonnelVisible:_isEmergencyPersonnelVisible];
    [self setIsBloodBornePathogenVisible:_isBloodBornePathogenVisible];
}

@end
