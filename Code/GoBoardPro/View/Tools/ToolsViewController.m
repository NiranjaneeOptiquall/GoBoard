//
//  ToolsViewController.m
//  GoBoardPro
//
//  Created by ind558 on 07/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "ToolsViewController.h"
#import "DropDownField.h"

#define DAILY_DROPDOWN_VALUE    @[@"Min(s)", @"Hour(s)"]
#define TASK_STATUS             @[@"Active", @"Inactive"]
#define NUMBER_OF_DAY           @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10",@"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20",@"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30",@"31"]
#define NUMBER_OF_WEEKS         @[@{@"name":@"First", @"id":@"1"}, @{@"name":@"Second", @"id":@"2"}, @{@"name":@"Third", @"id":@"3"}, @{@"name":@"Fourth", @"id":@"4"}]

#define WEEKDAYS                @[@{@"name":@"Sunday", @"id": @"1"}, @{@"name":@"Monday", @"id": @"2"}, @{@"name":@"Tuesday", @"id": @"3"}, @{@"name":@"Wednesday", @"id": @"4"}, @{@"name":@"Thursday", @"id": @"5"}, @{@"name":@"Friday", @"id": @"6"}, @{@"name":@"Saturday", @"id": @"7"}]

@interface ToolsViewController ()

@end

@implementation ToolsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedTaskIndex = -1;
    [self fetchFacilities];
    [_txtLocation setEnabled:NO];
    [_txtPosition setEnabled:NO];
    [self getTaskList];
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
        [_imvDropDownArrow setHidden:YES];
    }
    else {
        [_vwFormBack setHidden:YES];
        [_imvSelectTaskBG setHidden:NO];
        [_txtSelectTask setHidden:NO];
        [_imvDropDownArrow setHidden:NO];
        frame.origin.y = 275;
        [self removeDropDownField];
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
        if (_btnSetUpActionAdd.selected) {
            [self addDropdownFields];
            [self addDropdownFields];
            [self addDropdownFields];
            [self addDropdownFields];
        }
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
    strRecurrence = @"daily";
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

    [sender setSelected:!sender.isSelected];
    if (sender.isSelected) {
        [_txtDailyEvery setUserInteractionEnabled:YES];
        [_txtDailyDays setUserInteractionEnabled:YES];
    }
}

- (IBAction)btnDailyEveryWeekdayTapped:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
}

- (IBAction)btnWeeklyTapped:(UIButton *)sender {
    [sender setSelected:YES];
    strRecurrence = @"weekly";
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
    strRecurrence = @"monthly";
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
    strRecurrence = @"yearly";
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
    selectedNotificationType = sender.tag;
    [sender setSelected:YES];
}

- (IBAction)btnSubmitTapped:(id)sender {
    if ([_txtPosition isTextFieldBlank] || [_txtLocation isTextFieldBlank] || [_txtFacility isTextFieldBlank] || [_txtTaskTitle isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        return;
    }
    NSDictionary *aDict = [self createSubmitRequest];
    [gblAppDelegate callWebService:TASK_SETUP parameters:aDict httpMethod:@"POST" complition:^(NSDictionary *response) {
        [[[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:@"Your task has been added success fully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    } failure:^(NSError *error, NSDictionary *response) {
        
    }];
    
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
        frame = _vwFormBack.frame;
        frame.size.height = CGRectGetMaxY(_vwHowOften.frame);
        _vwFormBack.frame = frame;
        
    } completion:^(BOOL finished) {
        [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(_vwFormBack.frame))];
    }];
}

- (DropDownField*)addDropdownFields {
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
    [dropDown.txtDropdownField setPlaceholder:[NSString stringWithFormat:@"Dropdown #%ld", (long)totalDropDownFields + 1]];
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
    frame = _vwFormBack.frame;
    frame.size.height = CGRectGetMaxY(_vwHowOften.frame);
    _vwFormBack.frame = frame;
    [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(_vwFormBack.frame))];
    totalDropDownFields++;
    return dropDown;
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
    frame = _vwFormBack.frame;
    frame.size.height = CGRectGetMaxY(_vwHowOften.frame);
    _vwFormBack.frame = frame;
    [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(_vwFormBack.frame))];
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
            [field.txtDropdownField setPlaceholder:[NSString stringWithFormat:@"Dropdown #%ld", (long)index + 1]];
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
    frame = _vwFormBack.frame;
    frame.size.height = CGRectGetMaxY(_vwHowOften.frame);
    _vwFormBack.frame = frame;
    [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(_vwFormBack.frame))];
}

- (void)getTaskList {
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?userId=%@", TASK_SETUP, [[User currentUser] userId]] parameters:nil httpMethod:@"GET" complition:^(NSDictionary *response) {
        aryTaskList = [response objectForKey:@"Tasks"];
        [self getEmailGroupList];
    } failure:^(NSError *error, NSDictionary *response) {
        
    }];
}

- (void)getEmailGroupList {
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@", NOTIFY_EMAIL_GROUP, [[User currentUser] userId]] parameters:nil httpMethod:@"GET" complition:^(NSDictionary *response) {
        aryEmailGroup = [response objectForKey:@"NotificationEmailGroups"];
    } failure:^(NSError *error, NSDictionary *response) {
        
    }];
}

- (void)getTastDetail {
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@", TASK_SETUP, [aryTaskList[selectedTaskIndex][@"Id"] stringValue]] parameters:nil httpMethod:@"GET" complition:^(NSDictionary *response) {
        dictTaskDetail = [self removeNullFromDictionary:[NSMutableDictionary dictionaryWithDictionary:[response objectForKey:@"Task"]]];
    
        [self populateTaskDetailOnScreen];
    } failure:^(NSError *error, NSDictionary *response) {
        
    }];
}
- (NSMutableDictionary*)removeNullFromDictionary:(NSMutableDictionary*)dict {
    NSArray *aryNullKeys = [dict allKeysForObject:[NSNull null]];
    for (NSString *str in aryNullKeys) {
        [dict setObject:@"" forKey:str];
    }
    return dict;
}

- (void)populateTaskDetailOnScreen {
    
    _txtTaskTitle.text = [dictTaskDetail objectForKey:@"Name"];
    _txtPopUpDesc.text = dictTaskDetail[@"Description"];

    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UserFacility"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"value MATCHES[cd] %@", [dictTaskDetail[@"FacilityId"] stringValue]]];
    selectedFacility = [[gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil] lastObject];
    if (selectedFacility) {
        _txtFacility.text = selectedFacility.name;
    }
    request = [[NSFetchRequest alloc] initWithEntityName:@"UserLocation"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"value MATCHES[cd] %@", [dictTaskDetail[@"LocationId"] stringValue]]];
    selectedLocation = [[gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil] lastObject];
    if (selectedLocation) {
        _txtLocation.text = selectedLocation.name;
    }
    request = [[NSFetchRequest alloc] initWithEntityName:@"UserPosition"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"value MATCHES[cd] %@", [dictTaskDetail[@"PositionId"] stringValue]]];
    selectedPosition = [[gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil] lastObject];
    if (selectedPosition) {
        _txtPosition.text = selectedPosition.name;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Id == %@", dictTaskDetail[@"NotificationEmailGroupId"]];
    NSDictionary *aDict = [[aryEmailGroup filteredArrayUsingPredicate:predicate] lastObject];
    if (aDict) {
        _txtNotificationEmailGroup.text = aDict[@"Name"];
    }
    selectedNotificationType = [dictTaskDetail[@"NotificationType"] integerValue];
    [(UIButton *)[_vwNotification viewWithTag:selectedNotificationType] setSelected:YES];
    if ([dictTaskDetail[@"RecurrenceType"] isEqualToString:@"daily"]) {
        [self btnDailyTapped:_btnDaily];
        NSMutableDictionary *dictSetting = [self removeNullFromDictionary:dictTaskDetail[@"TaskRecurrenceSettingsDaily"]];
        _txtDailyStartTime.text = dictSetting[@"StartTime"];
        if (![dictSetting[@"StartTime"] isEqualToString:@""]) {
            [_btnDailyStartTime setSelected:YES];
        }
        [_btnDailyEveryWeekdays setSelected:[dictSetting[@"StartTime"] boolValue]];
        if (![[dictSetting[@"RecurrenceValue"] stringValue] isEqualToString:@""]) {
            _txtDailyEvery.text = [dictSetting[@"RecurrenceValue"] stringValue];
            [_btnDailyEvery setSelected:YES];
            if ([dictSetting[@"RecurrenceTimeframe"] isEqualToString:@"minute"]) {
                _txtDailyDays.text = DAILY_DROPDOWN_VALUE[0];
            }
            else {
                _txtDailyDays.text = DAILY_DROPDOWN_VALUE[1];
            }
        }
    }
    else if ([dictTaskDetail[@"RecurrenceType"] isEqualToString:@"weekly"]) {
        [self btnWeeklyTapped:_btnWeekly];
        NSMutableDictionary *dictSetting = [self removeNullFromDictionary:dictTaskDetail[@"TaskRecurrenceSettingsWeekly"]];
        if (![[dictSetting[@"RecurrenceValue"] stringValue] isEqualToString:@""]) {
            [_btnWeekEvery setSelected:YES];
            [_txtWeekEvery setText:[dictSetting[@"RecurrenceValue"] stringValue]];
        }
        if ([dictSetting[@"Days"] isKindOfClass:[NSArray class]]) {
            NSArray *btns = @[_btnWeekSunday, _btnWeekMonday, _btnWeekTuesday, _btnWeekWednesday, _btnWeekThursday, _btnWeekFriday, _btnWeekSaturday];
            for (UIButton *btn in btns) {
                btn.selected = [dictSetting[@"Days"] containsObject:[btn.titleLabel.text lowercaseString]];
            }
        }
    }
    else if ([dictTaskDetail[@"RecurrenceType"] isEqualToString:@"monthly"]) {
        [self btnMonthlyTapped:_btnMonthly];
        NSMutableDictionary *dictSetting = [self removeNullFromDictionary:dictTaskDetail[@"TaskRecurrenceSettingsMonthly"]];
        if ([dictSetting[@"Type"] isEqualToString:@"day"]) {
            [_btnMonthlyDay setSelected:YES];
            [_btnMonthThe setSelected:NO];
            _txtMonthDay.text = [dictSetting[@"DateNumber"] stringValue];
            _txtEveryMonth.text = [dictSetting[@"DateRecurrenceValue"] stringValue];
        }
        else {
            [_btnMonthThe setSelected:YES];
            [_btnMonthlyDay setSelected:NO];
            NSDictionary *week = [[NUMBER_OF_WEEKS filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id MATCHES %@", [dictSetting[@"DayWeekNumber"] stringValue]]] firstObject];
            if (week) {
                _txtMonthEveryThe.text = week[@"name"];
            }
            NSDictionary *day = [[WEEKDAYS filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id MATCHES %@", [dictSetting[@"DayWeekDay"] stringValue]]] firstObject];
            if (day) {
                _txtMonthWeekday.text = week[@"name"];
            }
            _txtMonthEveryThe.text = [dictSetting[@"DayRecurrenceValue"] stringValue];
            //
        }
    }
    else if ([dictTaskDetail[@"RecurrenceType"] isEqualToString:@"yearly"]) {
        [self btnYearlyTapped:_btnYearly];
        NSMutableDictionary *dictSetting = [self removeNullFromDictionary:dictTaskDetail[@"TaskRecurrenceSettingsYearly"]];
        _txtEveryYear.text = [dictSetting[@"RecurrenceValue"] stringValue];
        if ([dictSetting[@"Type"] isEqualToString:@"date"]) {
            [_btnOn setSelected:YES];
            [_btnOnThe setSelected:NO];
            NSDictionary *month = [[WEEKDAYS filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id MATCHES %@", [dictSetting[@"DateMonth"] stringValue]]] firstObject];
            if (month) {
                _txtYearMonth.text = month[@"name"];
            }
            _txtYearDate.text = [dictSetting[@"DateDay"] stringValue];
        }
        else {
            [_btnOn setSelected:NO];
            [_btnOnThe setSelected:YES];
            NSDictionary *week = [[NUMBER_OF_WEEKS filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id MATCHES %@", [dictSetting[@"DayWeekNumber"] stringValue]]] firstObject];
            if (week) {
                _txtMonthEveryThe.text = week[@"name"];
            }
            NSDictionary *day = [[WEEKDAYS filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id MATCHES %@", [dictSetting[@"DayWeekDay"] stringValue]]] firstObject];
            if (day) {
                _txtYearWeekday.text = week[@"name"];
            }
            NSDictionary *month = [[MONTHS filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id MATCHES %@", [dictSetting[@"DayMonth"] stringValue]]] firstObject];
            if (month) {
                _txtYearOnTheMonth.text = month[@"name"];
            }
            
        }
        
    }
    
    if ([dictTaskDetail[@"ResponseType"] isEqualToString:@"dropdown"]) {
        [self btnTaskAnswerTypeTapped:_btnDropDown];
//
        if ([dictTaskDetail[@"ResponseTypeValues"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *aDict in dictTaskDetail[@"ResponseTypeValues"]) {
                DropDownField *dropDown = [self addDropdownFields];
                dropDown.strDorpdownId = [[aDict objectForKey:@"Id"] stringValue];
                dropDown.txtCode.text = [aDict objectForKey:@"Code"];
                dropDown.txtDropdownField.text = [aDict objectForKey:@"Value"];
            }
        }
    }
    else if ([dictTaskDetail[@"ResponseType"] isEqualToString:@"yesno"]) {
        [self btnTaskAnswerTypeTapped:_btnYesNo];
    }
    else if ([dictTaskDetail[@"ResponseType"] isEqualToString:@"numeric"]) {
        [self btnTaskAnswerTypeTapped:_btnNumeric];
    }
    else if ([dictTaskDetail[@"ResponseType"] isEqualToString:@"checkbox"]) {
        [self btnTaskAnswerTypeTapped:_btnCheckBox];
    }
    else if ([dictTaskDetail[@"ResponseType"] isEqualToString:@"textbox"]) {
        [self btnTaskAnswerTypeTapped:_btnTextBox];
    }
    
}



- (void)fetchFacilities {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UserFacility"];
    [request setPropertiesToFetch:@[@"name", @"value"]];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [request setSortDescriptors:@[sortByName]];
    aryFacilities = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
}

- (void)fetchPositionAndLocation {
    NSFetchRequest *requestLoc = [[NSFetchRequest alloc] initWithEntityName:@"UserLocation"];
    
    NSPredicate *predicateLoc = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"facility.value", selectedFacility.value];
    [requestLoc setPredicate:predicateLoc];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [requestLoc setSortDescriptors:@[sortByName]];
    [requestLoc setPropertiesToFetch:@[@"name", @"value"]];
    aryLocation = [gblAppDelegate.managedObjectContext executeFetchRequest:requestLoc error:nil];
    requestLoc = nil;
    
    NSFetchRequest *requestPos = [[NSFetchRequest alloc] initWithEntityName:@"UserPosition"];
    NSPredicate *predicatePos = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"facility.value", selectedFacility.value];
    [requestPos setPredicate:predicatePos];
    [requestPos setSortDescriptors:@[sortByName]];
    [requestPos setPropertiesToFetch:@[@"name", @"value"]];
    aryPositions = [gblAppDelegate.managedObjectContext executeFetchRequest:requestPos error:nil];
}

- (NSMutableDictionary *)createSubmitRequest {
    NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
    if (_btnSetUpActionEdit.selected) {
        [aDict setObject:dictTaskDetail[@"Id"] forKey:@"Id"];
    }
    if (_btnYesNo.selected) {
        [aDict setObject:@"yesno" forKey:@"ResponseType"];
    }
    else if (_btnTextBox.selected) {
        [aDict setObject:@"textbox" forKey:@"ResponseType"];
    }
    else if (_btnNumeric.selected) {
        [aDict setObject:@"numeric" forKey:@"ResponseType"];
    }
    else if (_btnCheckBox.selected) {
        [aDict setObject:@"checkbox" forKey:@"ResponseType"];
    }
    else if (_btnDropDown.selected) {
        [aDict setObject:@"dropdown" forKey:@"ResponseType"];
        NSMutableArray *mutArrResponseValue = [NSMutableArray array];
        for (DropDownField *dropdown in _vwDropDownList.subviews) {
            if ([dropdown isKindOfClass:[DropDownField class]]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                if (![dropdown.txtDropdownField.trimText isEqualToString:@""]) {
                    [dict setObject:dropdown.txtDropdownField.trimText forKey:@"Value"];
                }
                if (![dropdown.txtCode.trimText isEqualToString:@""]) {
                    [dict setObject:dropdown.txtCode.trimText forKey:@"Code"];
                }
                if (dropdown.strDorpdownId) {
                    [dict setObject:dropdown.strDorpdownId forKey:@"Id"];
                }
                [mutArrResponseValue addObject:dict];
            }
        }
        [aDict setObject:mutArrResponseValue forKey:@"ResponseTypeValues"];
    }
    NSString *aStrEmailGroup = @"";
    if (![_txtNotificationEmailGroup.text isEqualToString:@""]) {
        aStrEmailGroup = [[[[aryEmailGroup filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Name MATCHES[cd] %@", _txtNotificationEmailGroup.text]] firstObject] objectForKey:@"Id"] stringValue];
    }
    
    NSDictionary *dict = @{@"FacilityId":selectedFacility.value, @"LocationId":selectedLocation.value, @"PositionId":selectedPosition.value, @"Name":_txtTaskTitle.trimText, @"Description":_txtPopUpDesc.trimText, @"NotificationType":[NSString stringWithFormat:@"%ld", (long)selectedNotificationType], @"NotificationEmailGroupId":aStrEmailGroup, @"RecurrenceType":strRecurrence};
    [aDict addEntriesFromDictionary:dict];
    
    if ([strRecurrence isEqualToString:@"daily"]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (_btnDailyStartTime.selected) {
            [dict setObject:_txtDailyStartTime.text forKey:@"StartTime"];
        }
        if (_btnDailyEvery.selected) {
            [dict setObject:_txtDailyEvery.trimText forKey:@"RecurrenceValue"];
            if ([_txtDailyDays.text isEqualToString:DAILY_DROPDOWN_VALUE[0]]) {
                [dict setObject:@"minute" forKey:@"RecurrenceTimeframe"];
            }
            else {
                [dict setObject:@"hour" forKey:@"RecurrenceTimeframe"];
            }
        }
        [dict setObject:(_btnDailyEveryWeekdays.selected) ? @"true":@"false" forKey:@"WeekdaysOnly"];
        [aDict setObject:dict forKey:@"TaskRecurrenceSettingsDaily"];
    }
    else if ([strRecurrence isEqualToString:@"weekly"]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (_btnWeekEvery.selected) {
            [dict setObject:_txtWeekEvery.trimText forKey:@"RecurrenceValue"];
        }
        NSArray *btns = @[_btnWeekSunday, _btnWeekMonday, _btnWeekTuesday, _btnWeekWednesday, _btnWeekThursday, _btnWeekFriday, _btnWeekSaturday];
        NSMutableArray *aryDays = [NSMutableArray array];
        for (UIButton *btn in btns) {
            if (btn.selected) {
                [aryDays addObject:btn.titleLabel.text.lowercaseString];
            }
        }
        [dict setObject:aryDays forKey:@"Days"];
        [aDict setObject:dict forKey:@"TaskRecurrenceSettingsWeekly"];
    }
    else if ([strRecurrence isEqualToString:@"monthly"]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (_btnMonthlyDay.selected) {
            [dict setObject:@"date" forKey:@"Type"];
            [dict setObject:_txtMonthDay.text forKey:@"DateNumber"];
            [dict setObject:_txtEveryMonth.text forKey:@"DateRecurrenceValue"];
        }
        else {
            [dict setObject:@"day" forKey:@"Type"];
            [dict setObject:_txtMonthThe.text forKey:@"DayWeekNumber"];
            [dict setObject:_txtMonthWeekday.text forKey:@"DayWeekDay"];
            [dict setObject:_txtMonthEveryThe.text forKey:@"DayRecurrenceValue"];
        }
        [aDict setObject:dict forKey:@"TaskRecurrenceSettingsMonthly"];
    }
    else if ([strRecurrence isEqualToString:@"yearly"]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:_txtEveryYear.trimText forKey:@"RecurrenceValue"];
        if (_btnOn.selected) {
            [dict setObject:@"date" forKey:@"Type"];
            [dict setObject:_txtYearDate.text forKey:@"DateDay"];
            [dict setObject:_txtYearMonth.text forKey:@"DateMonth"];
        }
        else {
            [dict setObject:@"day" forKey:@"Type"];
            [dict setObject:_txtOnThe.text forKey:@"DayWeekNumber"];
            [dict setObject:_txtYearWeekday.text forKey:@"DayWeekDay"];
            [dict setObject:_txtYearOnTheMonth.text forKey:@"DayMonth"];
        }
        [aDict setObject:dict forKey:@"TaskRecurrenceSettingsMonthly"];
    }
        
    return aDict;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_txtStatus]) {
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:TASK_STATUS view:textField key:nil];
        return NO;
    }
    else if ([textField isEqual:_txtSelectTask]) {
        
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:aryTaskList view:textField key:@"Name"];
        return NO;
    }
    else if ([textField isEqual:_txtPosition]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:aryPositions view:textField key:@"name"];
        return NO;
    }
    else if ([textField isEqual:_txtLocation]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:aryLocation view:textField key:@"name"];
        return NO;
    }
    else if ([textField isEqual:_txtFacility]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:aryFacilities view:textField key:@"name"];
        return NO;
    }
    else if ([textField isEqual:_txtSop]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:LOCATION_VALUES view:textField key:@"name"];
        return NO;
    }
    else if ([textField isEqual:_txtDailyStartTime]) {
        [self setKeepViewInFrame:textField];
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_PAST_ONLY option:DATE_SELECTION_TIME_ONLY updateField:textField];
        return NO;
    }
    else if ([textField isEqual:_txtDailyDays]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:DAILY_DROPDOWN_VALUE view:textField key:nil];
        return NO;
    }
    else if ([textField isEqual:_txtMonthDay]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:NUMBER_OF_DAY view:textField key:nil];
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
        [dropDown showDropDownWith:NUMBER_OF_WEEKS view:textField key:@"name"];
        return NO;
    }
    else if ([textField isEqual:_txtMonthWeekday] || [textField isEqual:_txtYearWeekday]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:WEEKDAYS view:textField key:@"name"];
        return NO;
    }
    else if ([textField isEqual:_txtYearDate]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:NUMBER_OF_DAY view:textField key:nil];
        return NO;
    }
    else if ([textField isEqual:_txtYearMonth] || [textField isEqual:_txtYearOnTheMonth]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:MONTHS view:textField key:@"name"];
        return NO;
    }
    else if ([textField isEqual:_txtNotificationEmailGroup]) {
        [self setKeepViewInFrame:textField];
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:aryEmailGroup view:textField key:@"Name"];
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
    if ([value isKindOfClass:[NSString class]]) {
        [sender setText:value];
    }
    else {
        if ([value valueForKey:@"Name"]) {
            [sender setText:[value valueForKey:@"Name"]];
        }
        else if ([value valueForKey:@"name"]) {
            [sender setText:[value valueForKey:@"name"]];
        }
    }
    if ([sender isEqual:_txtSelectTask]) {
        [_vwFormBack setHidden:NO];
        if (selectedTaskIndex != index) {
            selectedTaskIndex = index;
            [self getTastDetail];
        }
    }
    else if ([sender isEqual:_txtFacility]) {
        [_txtLocation setEnabled:YES];
        [_txtPosition setEnabled:YES];
        if (![selectedFacility isEqual:value]) {
            selectedFacility = value;
            selectedPosition = nil;
            selectedLocation = nil;
            [_txtLocation setText:@""];
            [_txtPosition setText:@""];
            [self fetchPositionAndLocation];
        }
    }
    else if ([sender isEqual:_txtPosition]) {
        selectedPosition = value;
    }
    else if ([sender isEqual:_txtLocation]) {
        selectedLocation = value;
    }
}

@end
