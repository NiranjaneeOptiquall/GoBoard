//
//  IncidentActionTaken.m
//  GoBoardPro
//
//  Created by ind558 on 02/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "IncidentActionTaken.h"
#import "TPKeyboardAvoidingScrollView.h"

@implementation IncidentActionTaken

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)setShouldHideTextField:(BOOL)shouldHideTextField {
    _shouldHideTextField = shouldHideTextField;
    if (_shouldHideTextField) {
        [_vwTextContainer setHidden:YES];
    }
    else {
        [_vwTextContainer setHidden:NO];
    }
}

- (IBAction)btnActionTakenTapped:(UIButton *)sender {
    [_btnFacilitySuspension setSelected:NO];
    [_btnVerbalWarning setSelected:NO];
    [_btnWrittenWarning setSelected:NO];
    [_btnSuspension setSelected:NO];
    [_btnTermination setSelected:NO];
    [sender setSelected:YES];
    [_txtFacilitySuspensionFrom setEnabled:NO];
    [_txtFacilitySuspensionTill setEnabled:NO];
    [_txtSuspensionFrom setEnabled:NO];
    [_txtSuspensionTill setEnabled:NO];
    [_txtTerminationFrom setEnabled:NO];
    [_txtFacilitySuspensionFrom setText:@""];
    [_txtFacilitySuspensionTill setText:@""];
    [_txtSuspensionFrom setText:@""];
    [_txtSuspensionTill setText:@""];
    [_txtTerminationFrom setText:@""];
    if ([sender isEqual:_btnFacilitySuspension]) {
        [_txtFacilitySuspensionFrom setEnabled:YES];
        [_txtFacilitySuspensionTill setEnabled:YES];
    }
    else if ([sender isEqual:_btnSuspension]) {
        [_txtSuspensionFrom setEnabled:YES];
        [_txtSuspensionTill setEnabled:YES];
    }
    else if ([sender isEqual:_btnTermination]) {
        [_txtTerminationFrom setEnabled:YES];
    }
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_txtFacilitySuspensionFrom] || [textField isEqual:_txtSuspensionFrom] || [textField isEqual:_txtTerminationFrom]) {
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_PAST_ONLY option:DATE_SELECTION_DATE_ONLY updateField:textField];
    }
    else if ([textField isEqual:_txtFacilitySuspensionTill] || [textField isEqual:_txtSuspensionTill]) {
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
        [aFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *fromDate = ([textField isEqual:_txtFacilitySuspensionTill]) ? _txtFacilitySuspensionFrom.text : _txtSuspensionFrom.text;
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_ALL_DATE option:DATE_SELECTION_DATE_ONLY updateField:textField];
        [datePopOver.datePicker setMinimumDate:[aFormatter dateFromString:[NSString stringWithFormat:@"%@", fromDate]]];
    }
    return NO;
}
@end
