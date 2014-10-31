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
    [self btnWasBloodPresentTapped:_btnBloodPresent];
    [self btnBloodbornePathogenTapped:_btnSelfTreated];
    [self btnExposedToBloodTapped:_btnExposedToBlood];
    [self btnBloodCleanUpRequiredTapped:_btnBloodCleanupRequired];
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
        alert(@"", @"Please completed all required fields.");
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

@end
