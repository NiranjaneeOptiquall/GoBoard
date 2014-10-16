//
//  WitnessView.m
//  GoBoardPro
//
//  Created by ind558 on 30/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "WitnessView.h"

@implementation WitnessView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (BOOL)isWitnessViewValidationSuccess {
    BOOL success = YES;
    if ([_txtWitnessFName isTextFieldBlank]) {
        success = NO;
        [_txtWitnessFName becomeFirstResponder];
        alert(@"", @"Please enter witness's first name");
    }
    else if ([_txtWitnessMI isTextFieldBlank]) {
        success = NO;
        [_txtWitnessMI becomeFirstResponder];
        alert(@"", @"Please enter witness's middle name");
    }
    else if ([_txtWitnessLName isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please enter witness's last name");
    }
    else if ([_txtWitnessHomePhone isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please enter witness's home phone number");
    }
    else if ([_txtWitnessHomePhone.text isValidPhoneNumber]) {
        success = NO;
        [_txtWitnessHomePhone becomeFirstResponder];
        alert(@"", @"Please enter witness's valid home phone number");
    }
    else if ([_txtWitnessAlternatePhone.text isValidPhoneNumber]) {
        success = NO;
        [_txtWitnessAlternatePhone becomeFirstResponder];
        alert(@"", @"Please enter witness's valid alternate phone number");
    }
    else if ([_txtWitnessEmailAddress isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please enter witness's email address");
    }
    else if (![gblAppDelegate validateEmail:[_txtWitnessEmailAddress text]]) {
        success = NO;
        [_txtWitnessEmailAddress becomeFirstResponder];
        alert(@"", @"Please enter witness's valid email address");
    }
    return success;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if ([textField isEqual:_txtWitnessHomePhone] || [textField isEqual:_txtWitnessAlternatePhone]) {
        NSCharacterSet *numericCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789 +()"];
        if ([string rangeOfCharacterFromSet:numericCharacterSet].location == NSNotFound) {
            return NO;
        }
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 15) {
            return NO;
        }
    }
    else if ([_txtWitnessMI isEqual:textField]) {
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 5) {
            return NO;
        }
    }
    
    return YES;
}
@end
