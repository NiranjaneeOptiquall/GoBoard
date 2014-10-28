//
//  EmergencyPersonnelView.m
//  GoBoardPro
//
//  Created by ind558 on 30/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "EmergencyPersonnelView.h"
#import "TPKeyboardAvoidingScrollView.h"

@implementation EmergencyPersonnelView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [self btnEmergencyPersonnelTapped:_btnPublicSafety];
    [_txtTimeOfArrival setEnabled:NO];
    [_txtTimeOfDeparture setEnabled:NO];
}

- (IBAction)btnEmergencyPersonnelTapped:(UIButton *)sender {
    [_btnPublicSafety setSelected:NO];
    [_btnPoliceOfficer setSelected:NO];
    [_btnEMT setSelected:NO];
    [_btnFirePersonnel setSelected:NO];
    [sender setSelected:YES];
}

- (BOOL)isEmergencyPersonnelValidationSucceed {
    BOOL success = YES;
    if ([_txtTime911Called isTextFieldBlank] || [_txtTimeOfArrival isTextFieldBlank] || [_txtTimeOfDeparture isTextFieldBlank] || [_txtCaseNo isTextFieldBlank] || [_txtFirstName isTextFieldBlank] || [_txtMI isTextFieldBlank] || [_txtLastName isTextFieldBlank] || [_txtPhone isTextFieldBlank]) {
        success = NO;
        alert(@"", @"Please fill up all required fields.");
    }
    else if ([_txtPhone.text isValidPhoneNumber]) {
        success = NO;
        [_txtPhone becomeFirstResponder];
        alert(@"", @"Please enter valid phone number");
    }
    else if ([_txtBadge isTextFieldBlank]) {
        alert(@"", @"Please fill up all required fields.");
    }
    return success;
}

- (void)setKeepViewInFrame:(UIView*)vw {
    TPKeyboardAvoidingScrollView *scrollView = (TPKeyboardAvoidingScrollView*)[self superview];
    while (![scrollView isKindOfClass:[TPKeyboardAvoidingScrollView class]]) {
        scrollView = (TPKeyboardAvoidingScrollView*)[scrollView superview];
    }
    CGPoint point = [vw.superview convertPoint:vw.frame.origin toView:scrollView];
    if (point.y <scrollView.contentOffset.y || point.y > scrollView.contentOffset.y + scrollView.frame.size.height) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, point.y - 50) animated:NO];
    }
}


#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL allowEditing = YES;
    if ([textField isEqual:_txtTime911Called]) {
        [self setKeepViewInFrame:textField];
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        [datePopOver setDelegate:self];
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_PAST_ONLY option:DATE_SELECTION_TIME_ONLY updateField:textField];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtTimeOfArrival]) {
        [self setKeepViewInFrame:textField];
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        [datePopOver setDelegate:self];
        NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
        [aFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *aStr = [aFormatter stringFromDate:[NSDate date]];
        [aFormatter setDateFormat:@"dd/MM/yyyy hh:mm a"];
        [datePopOver.datePicker setMinimumDate:[aFormatter dateFromString:[NSString stringWithFormat:@"%@ %@", aStr, _txtTime911Called.text]]];
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_PAST_ONLY option:DATE_SELECTION_TIME_ONLY updateField:textField];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtTimeOfDeparture]) {
        [self setKeepViewInFrame:textField];
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
        [aFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *aStr = [aFormatter stringFromDate:[NSDate date]];
        [aFormatter setDateFormat:@"dd/MM/yyyy hh:mm a"];
        [datePopOver.datePicker setMinimumDate:[aFormatter dateFromString:[NSString stringWithFormat:@"%@ %@", aStr, _txtTimeOfArrival.text]]];
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_PAST_ONLY option:DATE_SELECTION_TIME_ONLY updateField:textField];
        allowEditing = NO;
    }
    return allowEditing;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if ([textField isEqual:_txtPhone]) {
        NSCharacterSet *numericCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789 +()"];
        if ([string rangeOfCharacterFromSet:numericCharacterSet].location == NSNotFound) {
            return NO;
        }
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 15) {
            return NO;
        }
    }
    else if ([_txtMI isEqual:textField]) {
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 5) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - DatePickerDelegate

- (void)datePickerDidSelect:(NSDate*)date forObject:(id)field {
    if ([field isEqual:_txtTime911Called]) {
        [_txtTimeOfArrival setEnabled:YES];
        [_txtTimeOfArrival setText:@""];
        [_txtTimeOfDeparture setText:@""];
    }
    else if ([field isEqual:_txtTimeOfArrival]) {
        [_txtTimeOfDeparture setEnabled:YES];
        [_txtTimeOfDeparture setText:@""];
    }
}
@end
