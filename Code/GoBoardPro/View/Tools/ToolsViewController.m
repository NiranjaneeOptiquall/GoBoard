//
//  ToolsViewController.m
//  GoBoardPro
//
//  Created by ind558 on 07/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "ToolsViewController.h"
#import "DropDownField.h"

@interface ToolsViewController ()

@end

@implementation ToolsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(_vwFormBack.frame))];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)unwindBackToToolsScreen:(UIStoryboardSegue*)segue {
    
}

#pragma mark - IBActions

- (IBAction)btnSetUpActionTapped:(UIButton *)sender {
    if ([sender isSelected]) {
        return;
    }
    [_btnSetUpActionAdd setSelected:NO];
    [_btnSetUpActionEdit setSelected:NO];
    [_btnSetUpActionCopy setSelected:NO];
    [sender setSelected:YES];
    CGRect frame = _vwFormBack.frame;
    if ([sender isEqual:_btnSetUpActionAdd]) {
        [_vwFormBack setHidden:NO];
        frame.origin.y = _imvSelectTaskBG.frame.origin.y;
        [_imvSelectTaskBG setHidden:YES];
        [_txtSelectTask setHidden:YES];
    }
    else {
        [_vwFormBack setHidden:YES];
        [_imvSelectTaskBG setHidden:NO];
        [_txtSelectTask setHidden:NO];
        frame.origin.y = 275;
    }
    _vwFormBack.frame = frame;
    [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(_vwFormBack.frame))];
}

- (IBAction)btnSopTapped:(id)sender {
}

- (IBAction)btnTaskAnswerTypeTapped:(UIButton *)sender {
    [_btnYesNo setSelected:NO];
    [_btnNumeric setSelected:NO];
    [_btnCheckBox setSelected:NO];
    [_btnTextBox setSelected:NO];
    [_btnDropDown setSelected:NO];
    [sender setSelected:YES];
    if ([sender isEqual: _btnDropDown]) {
        [_vwDropDownList setHidden:NO];
        [self addDropdownFields];
        [self addDropdownFields];
        [self addDropdownFields];
        [self addDropdownFields];
        
    }
    else {
        [_vwDropDownList setHidden:YES];
        [self removeDropDownField];
    }
}

- (IBAction)btnAddDropdownFieldTapped:(id)sender {
    [self addDropdownFields];
}

- (void)btnRemoveDropdownTapped:(UIButton*)sender {
    if (totalDropDownFields > 2) {
        [sender.superview removeFromSuperview];
        totalDropDownFields --;
        [UIView animateWithDuration:0.5 animations:^{
            [self rearrangeFrames];
        }];
    }
    else {
        alert(@"", @"Minimum two options are required for a dropdown answer type");
    }
}

- (IBAction)btnDailyTapped:(UIButton *)sender {
    [sender setSelected:YES];
    [_btnWeekly setSelected:NO];
    [_btnMonthly setSelected:NO];
    [_btnYearly setSelected:NO];
    [self manageHowOftenViews:@[@{@"view": _vwDaily, @"isExpand": @YES}, @{@"view": _vwWeekly, @"isExpand": @NO}, @{@"view": _vwMonthly, @"isExpand": @NO}, @{@"view": _vwYearly, @"isExpand": @NO}]];
}

- (IBAction)btnDailyStartTimeTapped:(UIButton *)sender {
    [sender setSelected:![sender isSelected]];
    if ([sender isSelected]) {
        [_txtDailyStartTime setUserInteractionEnabled:YES];
    }
    else {
        [_txtDailyStartTime setUserInteractionEnabled:NO];
    }
}

- (IBAction)btnDailyEveryTapped:(UIButton *)sender {
    [sender setSelected:YES];
    [_btnDailyEveryWeekdays setSelected:NO];
    [_txtDailyEvery setUserInteractionEnabled:YES];
    [_txtDailyDays setUserInteractionEnabled:YES];
}

- (IBAction)btnDailyEveryWeekdayTapped:(UIButton *)sender {
    [sender setSelected:YES];
    [_btnDailyEvery setSelected:NO];
    [_txtDailyEvery setUserInteractionEnabled:NO];
    [_txtDailyDays setUserInteractionEnabled:NO];
}

- (IBAction)btnWeeklyTapped:(UIButton *)sender {
    [sender setSelected:YES];
    [_btnDaily setSelected:NO];
    [_btnMonthly setSelected:NO];
    [_btnYearly setSelected:NO];
    [self manageHowOftenViews:@[@{@"view": _vwDaily, @"isExpand": @NO}, @{@"view": _vwWeekly, @"isExpand": @YES}, @{@"view": _vwMonthly, @"isExpand": @NO}, @{@"view": _vwYearly, @"isExpand": @NO}]];
}

- (IBAction)btnWeeklyEveryTapped:(UIButton *)sender {
    [sender setSelected:![sender isSelected]];
    if ([sender isSelected]) {
        [_txtWeekEvery setUserInteractionEnabled:YES];
    }
    else {
        [_txtWeekEvery setUserInteractionEnabled:NO];
    }
}

- (IBAction)btnWeekDayTapped:(UIButton *)sender {
    [sender setSelected:![sender isSelected]];
}

- (IBAction)btnMonthlyTapped:(UIButton *)sender {
    [sender setSelected:YES];
    [_btnDaily setSelected:NO];
    [_btnWeekly setSelected:NO];
    [_btnYearly setSelected:NO];
    [self manageHowOftenViews:@[@{@"view": _vwDaily, @"isExpand": @NO}, @{@"view": _vwWeekly, @"isExpand": @NO}, @{@"view": _vwMonthly, @"isExpand": @YES}, @{@"view": _vwYearly, @"isExpand": @NO}]];
}

- (IBAction)btnMonthDayTapped:(UIButton *)sender {
    [sender setSelected:YES];
    [_txtMonthDay setUserInteractionEnabled:YES];
    [_txtEveryMonth setUserInteractionEnabled:YES];
    [_btnMonthThe setSelected:NO];
    [_txtMonthThe setUserInteractionEnabled:NO];
    [_txtMonthWeekday setUserInteractionEnabled:NO];
    [_txtMonthEveryThe setUserInteractionEnabled:NO];
}

- (IBAction)btnMonthTheTapped:(UIButton *)sender {
    [sender setSelected:YES];
    [_txtMonthDay setUserInteractionEnabled:NO];
    [_txtEveryMonth setUserInteractionEnabled:NO];
    [_btnMonthlyDay setSelected:NO];
    [_txtMonthThe setUserInteractionEnabled:YES];
    [_txtMonthWeekday setUserInteractionEnabled:YES];
    [_txtMonthEveryThe setUserInteractionEnabled:YES];
}

- (IBAction)btnYearlyTapped:(UIButton *)sender {
    [sender setSelected:YES];
    [_btnDaily setSelected:NO];
    [_btnWeekly setSelected:NO];
    [_btnMonthly setSelected:NO];
    [self manageHowOftenViews:@[@{@"view": _vwDaily, @"isExpand": @NO}, @{@"view": _vwWeekly, @"isExpand": @NO}, @{@"view": _vwMonthly, @"isExpand": @NO}, @{@"view": _vwYearly, @"isExpand": @YES}]];
}

- (IBAction)btnYearlyOnTapped:(UIButton *)sender {
    [sender setSelected:YES];
    [_btnOnThe setSelected:NO];
    [_txtYearMonth setUserInteractionEnabled:YES];
    [_txtYearDate setUserInteractionEnabled:YES];
    
    [_txtOnThe setUserInteractionEnabled:NO];
    [_txtYearWeekday setUserInteractionEnabled:NO];
    [_txtYearOnTheMonth setUserInteractionEnabled:NO];
}

- (IBAction)btnYearlyOnTheTapped:(UIButton *)sender {
    [sender setSelected:YES];
    [_btnOn setSelected:NO];
    [_txtYearMonth setUserInteractionEnabled:NO];
    [_txtYearDate setUserInteractionEnabled:NO];
    
    [_txtOnThe setUserInteractionEnabled:YES];
    [_txtYearWeekday setUserInteractionEnabled:YES];
    [_txtYearOnTheMonth setUserInteractionEnabled:YES];
}

- (IBAction)btnNotificationOptionTapped:(UIButton *)sender {
    [_btnNotifyNone setSelected:NO];
    [_btnNotifyOneCycle setSelected:NO];
    [_btnNotifyTwoCycle setSelected:NO];
    [_btnNotifyThreeCycle setSelected:NO];
    [sender setSelected:YES];
}

- (IBAction)btnSubmitTapped:(id)sender {
    if ([_txtPosition isTextFieldBlank] || [_txtLocation isTextFieldBlank] || [_txtFacility isTextFieldBlank] || [_txtTaskTitle isTextFieldBlank]) {
        alert(@"", @"Please fill up all required fields.");
        return;
    }
    [[[UIAlertView alloc] initWithTitle:@"GoBoardPro" message:@"Your task has been added success fully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}


- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Methods

- (void)manageHowOftenViews:(NSArray*)array {
    [UIView animateWithDuration:0.3 animations:^{
        float startY = _vwDaily.frame.origin.y;
        for (NSDictionary *aDict in array) {
            UIView *aView = [aDict objectForKey:@"view"];
            CGRect frame = aView.frame;
            frame.origin.y = startY;
            if ([[aDict objectForKey:@"isExpand"] boolValue]) {
                float maxHeight = 0;
                for (UIView *vw in aView.subviews) {
                    if (maxHeight < CGRectGetMaxY(vw.frame)) {
                        maxHeight = CGRectGetMaxY(vw.frame);
                    }
                }
                frame.size.height = maxHeight + 15;
            }
            else {
                frame.size.height = 52;
            }
            aView.frame = frame;
            startY = CGRectGetMaxY(frame);
        }
        CGRect frame = _vwNotification.frame;
        frame.origin.y = startY;
        _vwNotification.frame = frame;
        frame = _vwHowOften.frame;
        frame.size.height = CGRectGetMaxY(_vwNotification.frame);
        _vwHowOften.frame = frame;
        
    } completion:^(BOOL finished) {
        [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(_vwHowOften.frame))];
    }];
}

- (void)addDropdownFields {
    DropDownField *dropDown = (DropDownField*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownField" owner:self options:nil] firstObject];
    CGRect frame = dropDown.frame;
    float leftX = 55, rightX = 399;
    int totalRows = (int)totalDropDownFields / 2;
    if (totalDropDownFields % 2 == 0) {
        frame.origin.x = leftX;
    }
    else {
        frame.origin.x = rightX;
    }
    frame.origin.y = totalRows * frame.size.height + 50;
    dropDown.frame = frame;
    [dropDown.btnRemoveDropdown addTarget:self action:@selector(btnRemoveDropdownTapped:) forControlEvents:UIControlEventTouchUpInside];
    [dropDown.txtDropdownField setPlaceholder:[NSString stringWithFormat:@"Dropdown #%d", totalDropDownFields + 1]];
    [_vwDropDownList addSubview:dropDown];

    frame = _btnAddDropdownField.frame;
    frame.origin.y = CGRectGetMaxY(dropDown.frame) + 10;
    _btnAddDropdownField.frame = frame;
    frame = _vwDropDownList.frame;
    frame.size.height = CGRectGetMaxY(_btnAddDropdownField.frame) + 10;
    _vwDropDownList.frame = frame;
    frame = _vwHowOften.frame;
    frame.origin.y = CGRectGetMaxY(_vwDropDownList.frame);
    _vwHowOften.frame = frame;
    [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(_vwHowOften.frame))];
    totalDropDownFields++;
}

- (void)removeDropDownField {
    for (UIView *dropdown in _vwDropDownList.subviews) {
        if ([dropdown isKindOfClass:[DropDownField class]]) {
            [dropdown removeFromSuperview];
        }
    }
    totalDropDownFields = 0;
    CGRect frame = _btnAddDropdownField.frame;
    frame.origin.y = 40;
    [_btnAddDropdownField setFrame:frame];
    frame = _vwDropDownList.frame;
    frame.size.height = CGRectGetMaxY(_btnAddDropdownField.frame) + 10;
    _vwDropDownList.frame = frame;
    frame = _vwHowOften.frame;
    frame.origin.y = CGRectGetMaxY(_vwDropDownList.frame);
    _vwHowOften.frame = frame;
    [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(_vwHowOften.frame))];
}

- (void)rearrangeFrames {
    NSInteger index = 0;
    float leftX = 55, rightX = 399;
    float maxY = 0;
    for (DropDownField *field in _vwDropDownList.subviews) {
        if ([field isKindOfClass:[DropDownField class]]) {
            CGRect frame = field.frame;
            int totalRows = (int)index / 2;
            if (index % 2 == 0) {
                frame.origin.x = leftX;
            }
            else {
                frame.origin.x = rightX;
            }
            [field.txtDropdownField setPlaceholder:[NSString stringWithFormat:@"Dropdown #%d", index + 1]];
            frame.origin.y = totalRows * frame.size.height + 50;
            field.frame = frame;
            maxY = CGRectGetMaxY(frame);
            index++;
        }
    }
    CGRect frame = _btnAddDropdownField.frame;
    frame.origin.y = maxY + 10;
    [_btnAddDropdownField setFrame:frame];
    frame = _vwDropDownList.frame;
    frame.size.height = CGRectGetMaxY(_btnAddDropdownField.frame) + 10;
    _vwDropDownList.frame = frame;
    frame = _vwHowOften.frame;
    frame.origin.y = CGRectGetMaxY(_vwDropDownList.frame);
    _vwHowOften.frame = frame;
    [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(_vwHowOften.frame))];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_txtSelectTask]) {
        
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:LOCATION_VALUES view:textField key:@"title"];
        return NO;
    }
    else if ([textField isEqual:_txtPosition]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:POSITION_VALUES view:textField key:@"title"];
        return NO;
    }
    else if ([textField isEqual:_txtLocation]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:LOCATION_VALUES view:textField key:@"title"];
        return NO;
    }
    else if ([textField isEqual:_txtFacility]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:FACILITY_VALUES view:textField key:@"title"];
        return NO;
    }
    else if ([textField isEqual:_txtSop]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:LOCATION_VALUES view:textField key:@"title"];
        return NO;
    }
    else if ([textField isEqual:_txtDailyStartTime]) {
        [self setKeepViewInFrame:textField];
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_PAST_ONLY option:DATE_SELECTION_TIME_ONLY updateField:textField];
        return NO;
    }
    else if ([textField isEqual:_txtDailyEvery]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10",@"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20",@"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30",@"31"] view:textField key:nil];
        return NO;
    }
    else if ([textField isEqual:_txtDailyDays]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:@[@"day", @"two day", @"three day"] view:textField key:nil];
        return NO;
    }
    else if ([textField isEqual:_txtWeekEvery]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:@[@"1", @"2", @"3", @"4"] view:textField key:nil];
        return NO;
    }
    else if ([textField isEqual:_txtMonthDay]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10",@"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20",@"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30",@"31"] view:textField key:nil];
        return NO;
    }
    else if ([textField isEqual:_txtEveryMonth] || [textField isEqual:_txtMonthEveryThe]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10",@"11", @"12"] view:textField key:nil];
        return NO;
    }
    else if ([textField isEqual:_txtMonthThe] || [textField isEqual:_txtOnThe]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:@[@"first", @"second", @"third", @"fourth", @"fifth"] view:textField key:nil];
        return NO;
    }
    else if ([textField isEqual:_txtMonthWeekday] || [textField isEqual:_txtYearWeekday]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:WEEKDAYS view:textField key:@"title"];
        return NO;
    }
    else if ([textField isEqual:_txtEveryYear]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:@[@"1", @"2", @"3", @"4", @"5"] view:textField key:nil];
        return NO;
    }
    else if ([textField isEqual:_txtYearDate]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10"] view:textField key:nil];
        return NO;
    }
    else if ([textField isEqual:_txtYearMonth] || [textField isEqual:_txtYearOnTheMonth]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:MONTHS view:textField key:@"title"];
        return NO;
    }
    else if ([textField isEqual:_txtNotificationEmailGroup]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:POSITION_VALUES view:textField key:@"title"];
        return NO;
    }
    return YES;
}

- (void)setKeepViewInFrame:(UIView*)vw {
    CGPoint point = [vw.superview convertPoint:vw.frame.origin toView:_scrlMainView];
    if (point.y <_scrlMainView.contentOffset.y || point.y > _scrlMainView.contentOffset.y + _scrlMainView.frame.size.height) {
        [_scrlMainView setContentOffset:CGPointMake(_scrlMainView.contentOffset.x, point.y - 50) animated:NO];
    }
    
}

- (void)dropDownControllerDidSelectValue:(id)value atIndex:(NSInteger)index sender:(id)sender {
    if ([value isKindOfClass:[NSDictionary class]]) {
        [sender setText:[value objectForKey:@"title"]];
    }
    else {
        [sender setText:value];
    }
    if ([sender isEqual:_txtSelectTask]) {
        [_vwFormBack setHidden:NO];
    }
}

@end
