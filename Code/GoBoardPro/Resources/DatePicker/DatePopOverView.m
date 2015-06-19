//
//  DatePopOverView.m
//  GoBoardPro
//
//  Created by ind558 on 01/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "DatePopOverView.h"



@implementation DatePopOverView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    [_datePicker setMaximumDate:[NSDate date]];
}

- (void)allowAllDates {
    [_datePicker setMaximumDate:nil];
    [_datePicker setMinimumDate:nil];
}

- (void)allowFutureDateOnly {
    [_datePicker setMinimumDate:[NSDate date]];
    [_datePicker setMaximumDate:nil];
}

- (void)allowPastDateOnly {
    [_datePicker setMaximumDate:[NSDate date]];
}

- (IBAction)btnDoneTapped:(id)sender {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (!_desireDateFormat) {
        if (dateOption == DATE_SELECTION_DATE_ONLY) {
            _desireDateFormat = @"MM/dd/yyyy";
        }
        else if (dateOption == DATE_SELECTION_TIME_ONLY) {
            _desireDateFormat = @"hh:mm a";
        }
        else if (dateOption == DATE_SELECTION_DATE_AND_TIME) {
            _desireDateFormat = @"MM/dd/yyyy hh:mm a";
        }
    }
    
    [formatter setDateFormat:_desireDateFormat];
    tempTextField.text = [formatter stringFromDate:_datePicker.date];
    if (_delegate && [_delegate respondsToSelector:@selector(datePickerDidSelect:forObject:)]) {
        [_delegate datePickerDidSelect:_datePicker.date forObject:tempTextField];
    }
    if (popOver) {
        [popOver dismissPopoverAnimated:YES];
    }
    
    tempTextField = nil;
}

- (void)configurePickerWithOption:(DateSelectionOption)option andLimit:(DateLimitOption)limit {
    switch (limit) {
        case DATE_LIMIT_FETURE_ONLY:
            [self allowFutureDateOnly];
            break;
        case DATE_LIMIT_PAST_ONLY:
            [self allowPastDateOnly];
            break;
        case DATE_LIMIT_ALL_DATE:
            [self allowAllDates];
            break;
        default:
            break;
    }
    NSDateFormatter *aTempDateFormate = [[NSDateFormatter alloc] init];
    switch (option) {
        case DATE_SELECTION_DATE_ONLY:
            [aTempDateFormate setDateFormat:@"MM/dd/yyyy"];
            [_datePicker setDatePickerMode:UIDatePickerModeDate];
            break;
        case DATE_SELECTION_TIME_ONLY:
            [aTempDateFormate setDateFormat:@"hh:mm a"];
            [_datePicker setDatePickerMode:UIDatePickerModeTime];
            break;
        case DATE_SELECTION_DATE_AND_TIME:
            [aTempDateFormate setDateFormat:@"MM/dd/yyyy hh:mm a"];
            [_datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
            break;
        default:
            break;
    }
    if (_desireDateFormat) {
        [aTempDateFormate setDateFormat:_desireDateFormat];
    }
    if ([aTempDateFormate dateFromString:tempTextField.text]) {
        _datePicker.date = [aTempDateFormate dateFromString:tempTextField.text];
    }
    else [_datePicker setDate:[NSDate date]];
    
    dateOption = option;
}

- (void)showInPopOverFor:(UIView*)sender limit:(DateLimitOption)dateLimit option:(DateSelectionOption)option updateField:(UITextField*)textField {
    tempTextField = textField;
    [self configurePickerWithOption:option andLimit:dateLimit];
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view = self;
    popOver = [[UIPopoverController alloc] initWithContentViewController:vc];
    [popOver setPopoverContentSize:self.frame.size];
    [popOver setDelegate:self];
    [popOver presentPopoverFromRect:sender.frame inView:sender.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    popOver = nil;
}
@end
