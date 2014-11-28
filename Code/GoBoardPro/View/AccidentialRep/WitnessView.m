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
- (void)awakeFromNib {
    [self btnWitnessStatusTapped:_btnMember];
}

- (IBAction)btnWitnessStatusTapped:(UIButton*)sender {
    [_btnEmployee setSelected:NO];
    [_btnGuest setSelected:NO];
    [_btnMember setSelected:NO];
    [sender setSelected:YES];
}

- (void)setRequiredFields:(NSArray*)fields {
    requiredFields = fields;
    if ([requiredFields containsObject:@"firstName"]) [_markerFirstName setHidden:NO];
    if ([requiredFields containsObject:@"middleInital"]) [_markerMI setHidden:NO];
    if ([requiredFields containsObject:@"lastName"]) [_markerLastName setHidden:NO];
    if ([requiredFields containsObject:@"phone"]) [_markerPhone setHidden:NO];
    if ([requiredFields containsObject:@"alternatePhone"]) [_markerAlternatePhone setHidden:NO];
    if ([requiredFields containsObject:@"email"]) [_markerEmail setHidden:NO];
}

- (BOOL)isWitnessViewValidationSuccess {
    BOOL success = YES;
    if (requiredFields) {
        if ([requiredFields containsObject:@"firstName"] && [_txtWitnessFName isTextFieldBlank]) {
            success = NO;
            alert(@"", MSG_REQUIRED_FIELDS);
        }
        else if ([requiredFields containsObject:@"middleInital"] && [_txtWitnessMI isTextFieldBlank]) {
            success = NO;
            alert(@"", MSG_REQUIRED_FIELDS);
        }
        else if ([requiredFields containsObject:@"lastName"] && [_txtWitnessLName isTextFieldBlank]) {
            success = NO;
            alert(@"", MSG_REQUIRED_FIELDS);
        }
        else if ([requiredFields containsObject:@"phone"] && [_txtWitnessHomePhone isTextFieldBlank]) {
            success = NO;
            alert(@"", MSG_REQUIRED_FIELDS);
        }
        else if (![_txtWitnessHomePhone.text isValidPhoneNumber]) {
            success = NO;
            [_txtWitnessHomePhone becomeFirstResponder];
            alert(@"", @"Please enter witness's valid home phone number");
        }
        else if (![_txtWitnessAlternatePhone.text isValidPhoneNumber]) {
            success = NO;
            [_txtWitnessAlternatePhone becomeFirstResponder];
            alert(@"", @"Please enter witness's valid alternate phone number");
        }
        else if ([requiredFields containsObject:@"email"] && [_txtWitnessEmailAddress isTextFieldBlank]) {
            success = NO;
            alert(@"", MSG_REQUIRED_FIELDS);
        }
        else if (![gblAppDelegate validateEmail:[_txtWitnessEmailAddress text]]) {
            success = NO;
            [_txtWitnessEmailAddress becomeFirstResponder];
            alert(@"", @"Please enter witness's valid email address");
        }
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
        if ([textField isEqual:_txtWitnessHomePhone] || [textField isEqual:_txtWitnessAlternatePhone]) {
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
    if ([textField isEqual:_txtWitnessHomePhone] || [textField isEqual:_txtWitnessAlternatePhone]) {
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
    else if ([_txtWitnessMI isEqual:textField]) {
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 5) {
            return NO;
        }
    }
    
    return YES;
}


#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [_lblWitnessWrittenAccount setHidden:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text length] == 0) {
        [_lblWitnessWrittenAccount setHidden:NO];
    }
}
@end
