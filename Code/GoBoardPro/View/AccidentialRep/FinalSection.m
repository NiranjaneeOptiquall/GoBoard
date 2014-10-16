//
//  FinalSection.m
//  GoBoardPro
//
//  Created by ind558 on 30/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "FinalSection.h"
#import "WitnessView.h"

@implementation FinalSection

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    mutArrWitnessViews = [[NSMutableArray alloc] init];
    [self addWitnessView];
    [self btnCommunicationTapped:_btnAdmin];
    [self btnSentToInsuranceTapped:_btnYesInsurance];
    [self btnProcedureFollowedTapped:_btnYesProcedure];
    [self btnCallMadeTapped:_btnYesCall];
}

- (IBAction)btnAddMoreWitnessTapped:(id)sender {
    [self addWitnessView];
}

- (IBAction)btnCommunicationTapped:(UIButton *)sender {
    [_btnAdmin setSelected:NO];
    [_btnSupervisers setSelected:NO];
    [_btnRiskManagement setSelected:NO];
    [sender setSelected:YES];
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

- (void)addWitnessView {
    WitnessView *aWitnessView = (WitnessView*)[[[NSBundle mainBundle] loadNibNamed:@"WitnessView" owner:self options:nil] firstObject];
    [aWitnessView setBackgroundColor:[UIColor clearColor]];
    CGRect frame = aWitnessView.frame;
    frame.origin.y = totalWitnessCount * frame.size.height;
    aWitnessView.frame = frame;
    [self addSubview:aWitnessView];
    totalWitnessCount ++;
    [mutArrWitnessViews addObject:aWitnessView];
    frame = _vwFixedContent.frame;
    frame.origin.y = CGRectGetMaxY(aWitnessView.frame);
    _vwFixedContent.frame = frame;
    frame = self.frame;
    frame.size.height = CGRectGetMaxY(_vwFixedContent.frame);
    self.frame = frame;
}

- (BOOL)isFinalSectionValidationSuccess {
    BOOL success = YES;
    for (WitnessView *view in mutArrWitnessViews) {
        if (![view isWitnessViewValidationSuccess]) {
            success = NO;
            return success;
        }
    }
    if ([_txtEmpFName isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please enter employee first name, who is completing report");
    }
    else if ([_txtEmpMI isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please enter employee middle name, who is completing report");
    }
    else if ([_txtEmpLName isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please enter employee last name, who is completing report");
    }
    else if ([_txtEmpHomePhone isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please enter employee home phone number, who is completing report");
    }
    else if ([_txtEmpHomePhone.text isValidPhoneNumber]) {
        success = NO;
        [_txtEmpHomePhone becomeFirstResponder];
        alert(@"", @"Please enter employee's valid home phone number, who is completing report");
    }
    else if ([_txtEmpAlternatePhone.text isValidPhoneNumber]) {
        success = NO;
        [_txtEmpAlternatePhone becomeFirstResponder];
        alert(@"", @"Please enter employee's valid alternate phone number, who is completing report");
    }
    return success;
}


#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
