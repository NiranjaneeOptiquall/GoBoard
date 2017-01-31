//
//  ERPDetailViewController.m
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "ERPDetailViewController.h"
#import "WebViewController.h"

@interface ERPDetailViewController ()

@end

@implementation ERPDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self getAllActionListForEmergency];
    [_lblERPTitle setText:[NSString stringWithFormat:@"%@ - %@", _erpSubcategory.erpHeader.title, _erpSubcategory.title]];
    if ([_erpSubcategory.erpTasks count] == 0) {
        [_lblNoRecords setHidden:NO];
    }
    [_txtTimeEnd setEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ERPLinkDetail"]) {
        WebViewController *webVC = (WebViewController *)[segue destinationViewController];
        webVC.strRequestURL = [[[_erpSubcategory.erpTasks allObjects] objectAtIndex:selectedRow] attachmentLink];
    }
}


#pragma mark - IBActions & Selectors

- (IBAction)btnSubmitTapped:(id)sender {
    if ([_txtTimeStart isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        return;
    }
    else if ([_txtTimeEnd isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        return;
    }
    NSString *key = @"isCompleted";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == 1", key];
    NSArray *a = [[_erpSubcategory.erpTasks allObjects] filteredArrayUsingPredicate:predicate];
    if ([a count] == 0) {
        alert(@"", @"Please check at least one item that was completed");
        return;
    }
//    alert(@"", @"Your response has been saved.");
    NSMutableArray *aryTask = [NSMutableArray array];
    for (ERPTask *task in _erpSubcategory.erpTasks) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:task.taskID forKey:@"ErpTaskId"];
        if (task.isCompleted) {
            [dict setObject:@"true" forKey:@"Completed"];
        }
        else {
            [dict setObject:@"false" forKey:@"Completed"];
        }
        [aryTask addObject:dict];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *aStrDate = [formatter stringFromDate:[NSDate date]];
    NSString *aStartDate = [NSString stringWithFormat:@"%@ %@", aStrDate, _txtTimeStart.text];
    NSString *aEndDate = [NSString stringWithFormat:@"%@ %@", aStrDate, _txtTimeEnd.text];
    
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    NSDate *stDt = [formatter dateFromString:aStartDate];
    NSDate *endDt = [formatter dateFromString:aEndDate];
    //[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    aStartDate = [formatter stringFromDate:stDt];
    aEndDate = [formatter stringFromDate:endDt];

    NSDictionary *aDict = @{@"UserId":[[User currentUser] userId], @"FacilityId":[[[User currentUser] selectedFacility] value], @"ErpSubcategoryId":[_erpSubcategory subCateId], @"StartDateTime":aStartDate, @"EndDateTime":aEndDate, @"Tasks":aryTask};
    if (gblAppDelegate.isNetworkReachable) {
        [gblAppDelegate callWebService:ERP_HISTORY parameters:aDict httpMethod:[SERVICE_HTTP_METHOD objectForKey:ERP_HISTORY] complition:^(NSDictionary *response) {
            [[[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:@"Your response has been saved. Thank you." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        } failure:^(NSError *error, NSDictionary *response) {
            [self saveInLocal:aDict];
        }];
    }
    else {
        [self saveInLocal:aDict];
    }
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
        [[[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:@"Do you want to save your information? If you press “Back” you will lose all entered information, do you want to proceed?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil] show];
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
    [[[_erpSubcategory.erpTasks allObjects] objectAtIndex:indexPath.row]setIsCompleted:btn.isSelected];
}

- (void)btnViewLinkTapped:(UIButton *)btn {
    UITableViewCell *cell = (UITableViewCell *)[btn superview];
    while (![cell isKindOfClass:[UITableViewCell class]]) {
        cell = (UITableViewCell*)[cell superview];
    }
    NSIndexPath *indexPath = [_tblActionsTaken indexPathForCell:cell];
    selectedRow = indexPath.row;
    [self performSegueWithIdentifier:@"ERPLinkDetail" sender:nil];
}

#pragma mark - Methods

- (void)saveInLocal:(NSDictionary*)dict {
    ERPHistory *aErpHistory = [NSEntityDescription insertNewObjectForEntityForName:@"ERPHistory" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    aErpHistory.userId = [dict objectForKey:@"UserId"];
    aErpHistory.facilityId = [dict objectForKey:@"FacilityId"];
    aErpHistory.erpSubcategoryId = [dict objectForKey:@"ErpSubcategoryId"];
    aErpHistory.startDateTime = [dict objectForKey:@"StartDateTime"];
    aErpHistory.endDateTime = [dict objectForKey:@"EndDateTime"];
    NSMutableSet *taskList = [NSMutableSet set];
    for (NSDictionary *aDictTask in [dict objectForKey:@"Tasks"]) {
        ERPHistoryTask *aTask = [NSEntityDescription insertNewObjectForEntityForName:@"ERPHistoryTask" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        aTask.completed = [aDictTask objectForKey:@"Completed"];
        aTask.erpTaskId = [aDictTask objectForKey:@"ErpTaskId"];
        aTask.erpHistory = aErpHistory;
        [taskList addObject:aTask];
    }
    aErpHistory.taskList = taskList;
    [gblAppDelegate.managedObjectContext insertObject:aErpHistory];
    if ([gblAppDelegate.managedObjectContext save:nil]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:MSG_ADDED_TO_SYNC delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
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


#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_erpSubcategory.erpTasks count];
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
    ERPTask *task = [[_erpSubcategory.erpTasks allObjects] objectAtIndex:indexPath.row];
    [aLbl setText:task.task];
    [aLbl sizeToFit];
    BOOL isChecked = [task isCompleted];
    UIButton *btn = (UIButton*)[aCell viewWithTag:3];
    [btn setSelected:isChecked];
    [btn addTarget:self action:@selector(btnCheckMarkTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *linkBtn = (UIButton*)[aCell viewWithTag:5];
    if ([task.attachmentLink length] > 0) {
        [linkBtn setHidden:NO];
    }
    else {
        [linkBtn setHidden:YES];
    }
//    if ([task.type isEqualToString:@"video"]) {
//        [linkBtn setImage:[UIImage imageNamed:@"erp_video_icon@2x.png"] forState:UIControlStateNormal];
//    }
//    else {
//        [linkBtn setImage:[UIImage imageNamed:@"erp_photo_icon@2x.png"] forState:UIControlStateNormal];
//    }
    
    [linkBtn addTarget:self action:@selector(btnViewLinkTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIView *aView = [aCell.contentView viewWithTag:4];
    CGRect frame = aView.frame;
    frame.origin.y = aCell.frame.size.height - 3;
    [aView setFrame:frame];
    return aCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *aLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 632, 21)];
    NSString *aStr = [(ERPTask *)[[_erpSubcategory.erpTasks allObjects] objectAtIndex:indexPath.row] task];
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
