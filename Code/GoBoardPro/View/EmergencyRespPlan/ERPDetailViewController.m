//
//  ERPDetailViewController.m
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "ERPDetailViewController.h"

@interface ERPDetailViewController ()

@end

@implementation ERPDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAllActionListForEmergency];
    [_lblERPTitle setText:[NSString stringWithFormat:@"%@ - %@", [_dictCategory objectForKey:@"title"], [[_dictCategory objectForKey:@"sub"] objectAtIndex:_selectedIndex]]];
    [_txtTimeEnd setEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBActions & Selectors

- (IBAction)btnSubmitTapped:(id)sender {
    if ([_txtTimeStart isTextFieldBlank]) {
        alert(@"", @"Please fill up all required fields.");
        return;
    }
    else if ([_txtTimeEnd isTextFieldBlank]) {
        alert(@"", @"Please fill up all required fields.");
        return;
    }
    NSString *key = @"isChecked";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == 1", key];
    NSArray *a = [mutArrActionList filteredArrayUsingPredicate:predicate];
    if ([a count] == 0) {
        alert(@"", @"Please select atleast a step you followed.");
        return;
    }
    alert(@"", @"Your response has been saved.");
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnTimeStartTapped:(id)sender {
    isUpdate = YES;
    DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
    [datePopOver setDelegate:self];
    [datePopOver showInPopOverFor:sender limit:DATE_LIMIT_NONE option:DATE_SELECTION_TIME_ONLY updateField:_txtTimeStart];
}
- (IBAction)btnTimeEndTapped:(id)sender {
    isUpdate = YES;
    if (![_txtTimeEnd isEnabled]) {
        return;
    }
    DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *aStr = [aFormatter stringFromDate:[NSDate date]];
    [aFormatter setDateFormat:@"dd/MM/yyyy hh:mm a"];
    [datePopOver.datePicker setMinimumDate:[aFormatter dateFromString:[NSString stringWithFormat:@"%@ %@", aStr, _txtTimeStart.text]]];
    [datePopOver showInPopOverFor:sender limit:DATE_LIMIT_NONE option:DATE_SELECTION_TIME_ONLY updateField:_txtTimeEnd];
}

- (IBAction)btnBackTapped:(id)sender {
    if (isUpdate) {
        [[[UIAlertView alloc] initWithTitle:@"GoBoardPro" message:@"Do you want to save your information? If you press “Back” you will lose all entered information, do you want to proceed?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil] show];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)btnCheckMarkTapped:(UIButton*)btn {
    isUpdate = YES;
    [btn setSelected:![btn isSelected]];
    UITableViewCell *cell = (UITableViewCell *)[btn superview];
    while (![cell isKindOfClass:[UITableViewCell class]]) {
        cell = (UITableViewCell*)[cell superview];
    }
    NSIndexPath *indexPath = [_tblActionsTaken indexPathForCell:cell];
    [[mutArrActionList objectAtIndex:indexPath.row] setObject:[NSNumber numberWithBool:[btn isSelected]] forKey:@"isChecked"];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_txtTimeStart]) {
        [self btnTimeStartTapped:textField];
    }
    else {
        [self btnTimeEndTapped:textField];
    }
    return NO;
}

#pragma mark - Methods

- (void)getAllActionListForEmergency {
    mutArrActionList = [[NSMutableArray alloc] init];
    [mutArrActionList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"This is a simple action.", @"action", [NSNumber numberWithBool:NO], @"isChecked", nil]];
    [mutArrActionList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"This is a simple action with atleast two line in cell to display larger cell.", @"action", [NSNumber numberWithBool:NO], @"isChecked", nil]];
    [mutArrActionList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"This is a simple action with atleast two line in cell to display larger cell.This is a simple action with atleast two line in cell to display larger cell.This is a simple action with atleast two line in cell to display larger cell.", @"action", [NSNumber numberWithBool:NO], @"isChecked", nil]];
    [mutArrActionList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"This is a simple action with atleast two line in cell to display larger cell.This is a simple action with atleast two line in cell to display larger cell.", @"action", [NSNumber numberWithBool:NO], @"isChecked", nil]];
    [mutArrActionList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"This is a simple action with atleast two line in cell to display larger cell.", @"action", [NSNumber numberWithBool:NO], @"isChecked", nil]];
    [mutArrActionList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"This is a simple action.", @"action", [NSNumber numberWithBool:NO], @"isChecked", nil]];
    [mutArrActionList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"This is a simple action with atleast two line in cell to display larger cell..", @"action", [NSNumber numberWithBool:NO], @"isChecked", nil]];
    [mutArrActionList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"This is a simple action.", @"action", [NSNumber numberWithBool:NO], @"isChecked", nil]];
    [mutArrActionList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"This is a simple action with atleast two line in cell to display larger cell.This is a simple action with atleast two line in cell to display larger cell.This is a simple action with atleast two line in cell to display larger cell.This is a simple action with atleast two line in cell to display larger cell.", @"action", [NSNumber numberWithBool:NO], @"isChecked", nil]];
    [mutArrActionList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"This is a simple action.", @"action", [NSNumber numberWithBool:NO], @"isChecked", nil]];
    [mutArrActionList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"This is a simple action with atleast two line in cell to display larger cell.This is a simple action with atleast two line in cell to display larger cell.", @"action", [NSNumber numberWithBool:NO], @"isChecked", nil]];
    [mutArrActionList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"This is a simple action.", @"action", [NSNumber numberWithBool:NO], @"isChecked", nil]];
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mutArrActionList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 0 || indexPath.row % 2 == 0) {
        [aCell setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    }
    else {
        [aCell setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
    }
    UILabel *aLbl = (UILabel*)[aCell viewWithTag:2];
    [aLbl setText:[[mutArrActionList objectAtIndex:indexPath.row] objectForKey:@"action"]];
    [aLbl sizeToFit];
    BOOL isChecked = [[[mutArrActionList objectAtIndex:indexPath.row] objectForKey:@"isChecked"] boolValue];
    UIButton *btn = (UIButton*)[aCell viewWithTag:3];
    [btn setSelected:isChecked];
    [btn addTarget:self action:@selector(btnCheckMarkTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIView *aView = [aCell.contentView viewWithTag:4];
    CGRect frame = aView.frame;
    frame.origin.y = aCell.frame.size.height - 3;
    [aView setFrame:frame];
    return aCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *aLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 632, 21)];
    NSString *aStr = [[mutArrActionList objectAtIndex:indexPath.row] objectForKey:@"action"];
    [aLbl setText:aStr];
    [aLbl setFont:[UIFont systemFontOfSize:17.0]];
    [aLbl setNumberOfLines:0];
    [aLbl sizeToFit];
    CGFloat height = aLbl.frame.size.height + 27;
    aLbl = nil;
    return height;
}

#pragma mark - DatePickerDelegate

- (void)datePickerDidSelect:(NSDate*)date forObject:(id)field {
    if ([field isEqual:_txtTimeStart]) {
        [_txtTimeEnd setText:@""];
        [_txtTimeEnd setEnabled:YES];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
