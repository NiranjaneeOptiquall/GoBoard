//
//  TaskListViewController.m
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "TaskListViewController.h"
#import "TaskTableViewCell.h"
#import "UtilizationCountViewController.h"
#import "TaskList.h"
#import "TaskResponseTypeValues.h"
#import "SubmitCountUser.h"
#import "SubmittedTask.h"

@interface TaskListViewController ()

@end

@implementation TaskListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self getAllTasks];
    NSArray *aryNavigationStack = [self.navigationController viewControllers];
    BOOL isCount = NO;
    for (id obj in aryNavigationStack) {
        if ([obj isKindOfClass:[UtilizationCountViewController class]]) {
            isCount = YES;
            break;
        }
    }
    if (isCount) {
        _lblCount.text = @"Tasks";
        _lblTask.text = @"Counts";
        UIColor *color = _lblTask.textColor;
        _lblTask.textColor = [UIColor whiteColor];
        _lblCount.textColor = color;
    }
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

- (IBAction)btnHideCompletedTapped:(UIButton *)sender {
   
    if (sender.isSelected) {
        
        NSDate* sourceDate = [NSDate date];
        
        NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        
        NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
        
        NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
        
        NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
        
        NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
        
        NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:destinationDate];
        [components setHour:0];
        [components setMinute:0];
        [components setSecond:0];
        
        NSDate *dateSourceTemp = [calendar dateFromComponents:components];
        
        //NSDate *dateSourceTemp = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:destinationDate options:0];
        
        NSDate* dateSource = [[NSDate alloc] initWithTimeInterval:interval sinceDate:dateSourceTemp];
        
        NSLog(@"taskDateTime > %@ AND taskDateTime < %@", destinationDate , [destinationDate dateByAddingTimeInterval:60*60*2]);
        
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"taskDateTime > %@ AND taskDateTime < %@", dateSource , [destinationDate dateByAddingTimeInterval:60*60*2]];
        
        mutArrTaskUptoNx2Hrs = [mutArrTaskList filteredArrayUsingPredicate:predicate1];
        
        mutArrFilteredTaskList =  mutArrTaskUptoNx2Hrs;
    }
    else {
        
        NSDate* sourceDate = [NSDate date];
        
        NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        
        NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
        
        NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
        
        NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
        
        NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
        
        NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
        
        NSLog(@"taskDateTime > %@ AND taskDateTime < %@", destinationDate , [destinationDate dateByAddingTimeInterval:60*60*2]);
        
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"expirationTime > %@ AND taskDateTime < %@", destinationDate , [destinationDate dateByAddingTimeInterval:60*60*2]]; // AND taskDateTime > %@,destinationDate
        
        mutArrTaskUptoNx2Hrs = [mutArrTaskList filteredArrayUsingPredicate:predicate1];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isCompleted == NO"];
        
        mutArrFilteredTaskList = [NSMutableArray arrayWithArray:[mutArrTaskUptoNx2Hrs filteredArrayUsingPredicate:predicate]];
    }
    [sender setSelected:![sender isSelected]];
    if ([mutArrFilteredTaskList count] == 0) {
        [_lblNoRecords setHidden:NO];
    }else{
         [_lblNoRecords setHidden:YES];
    }
    [_tblTaskList reloadData];
}

- (IBAction)btnSubmitTapped:(id)sender {
    [self submitTask:NO];
}

- (void)submitTask:(BOOL)showCount {
    NSMutableArray *mutArrPostTask = [NSMutableArray array];
    for (TaskList *task in mutArrFilteredTaskList) {
        if (![task.isCompleted boolValue] && [task.response length] > 0) {
            NSString *comment = @"", *taskComment = @"false", *goboardGroup = @"false", *buildingSupervisor = @"false", *areaSupervisor = @"false", *workOrder = @"false";
            if (task.comment)
                comment = task.comment;
            if (task.isCommentTask.boolValue)
                taskComment = @"true";
            if (task.isCommentGoBoardGroup.boolValue)
                goboardGroup = @"true";
            if (task.isCommentBuildingSupervisor.boolValue)
                buildingSupervisor = @"true";
            if (task.isCommentAreaSupervisor.boolValue)
                areaSupervisor = @"true";
            if (task.isCommentWorkOrder.boolValue)
                workOrder = @"true";
            
            
            [mutArrPostTask addObject:@{@"Id": task.taskId, @"Name":task.name, @"Description":task.desc, @"Response":task.response, @"ResponseType":task.responseType, @"Comment":comment, @"IsCommentTask": taskComment, @"IsCommentGoBoardGroup":goboardGroup, @"IsCommentBuildingSupervisor":buildingSupervisor, @"IsCommentAreaSupervisor":areaSupervisor, @"IsCommentWorkOrder":workOrder, @"Completed":@"true"}];
            task.isCompleted = [NSNumber numberWithBool:YES];
        }
    }
    if ([mutArrPostTask count] > 0) {
        [gblAppDelegate.managedObjectContext save:nil];
        NSDictionary *aDict = @{@"UserId":[[User currentUser]userId], @"Tasks":mutArrPostTask};
        [gblAppDelegate callWebService:TASK parameters:aDict httpMethod:@"POST" complition:^(NSDictionary *response) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:@"Task has been submitted successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            if (showCount) {
                [alert setTag:1];
            }
            [alert show];
        } failure:^(NSError *error, NSDictionary *response) {
            [self saveCompletedTask:aDict showCount:showCount];
        }];
    }
    else if (showCount) {
        [self showCount];
    }
    else {
        alert(@"", @"Task is already updated.");
    }
}

- (void)showCount {
    [self.navigationController popViewControllerAnimated:NO];
    [[[gblAppDelegate.navigationController viewControllers] lastObject] performSegueWithIdentifier:@"Counts" sender:nil];
}

- (void)saveCompletedTask:(NSDictionary *)aDict showCount:(BOOL)showCount {
    SubmitCountUser *user = [NSEntityDescription insertNewObjectForEntityForName:@"SubmitCountUser" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    user.userId = [aDict objectForKey:@"UserId"];
    NSMutableSet *set = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"Tasks"]) {
        SubmittedTask *task = [NSEntityDescription insertNewObjectForEntityForName:@"SubmittedTask" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        task.taskId = [dict objectForKey:@"Id"];
        task.comment = [dict objectForKey:@"Comment"];
        task.responseType = [dict objectForKey:@"ResponseType"];
        task.response = [dict objectForKey:@"Response"];
        task.isCommentTask = [dict objectForKey:@"IsCommentTask"];
        task.isCommentGoBoardGroup = [dict objectForKey:@"IsCommentGoBoardGroup"];
        task.isCommentBuildingSupervisor = [dict objectForKey:@"IsCommentBuildingSupervisor"];
        task.isCommentAreaSupervisor = [dict objectForKey:@"IsCommentAreaSupervisor"];
        task.isCommentWorkOrder = [dict objectForKey:@"IsCommentWorkOrder"];
        task.user = user;
        [set addObject:task];
    }
    user.submittedTask = set;
    [gblAppDelegate.managedObjectContext insertObject:user];
    if ([gblAppDelegate.managedObjectContext save:nil]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:MSG_ADDED_TO_SYNC delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        if (showCount) {
            [alert setTag:1];
        }
        [alert show];
    }
}

- (IBAction)btnToggleTaskAndCountTapped:(id)sender {
    [self submitTask:YES];
}

//chetan kasundra changes starts
//change alert message
- (IBAction)btnBackTapped:(id)sender {
    [self.view endEditing:YES];
    if (isUpdate)
    {
        [[[UIAlertView alloc] initWithTitle:@"WARNING" message:@"If you press \"Back\" you will lose your information. Do you want to proceed?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil] show];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//chages ends

- (IBAction)btnPopOverTaskTapped:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    TaskList *task = [mutArrFilteredTaskList objectAtIndex:editingIndex];
    if ([sender isEqual:_btnCommentTask]) {
        task.isCommentTask = [NSNumber numberWithBool:sender.isSelected];
    }
    else if ([sender isEqual:_btnCommentGoBoardGroup]) {
        task.isCommentGoBoardGroup = [NSNumber numberWithBool:sender.isSelected];
    }
    else if ([sender isEqual:_btnCommentBuildingSupervisor]) {
        task.isCommentBuildingSupervisor = [NSNumber numberWithBool:sender.isSelected];
    }
    else if ([sender isEqual:_btnCommentAreaSupervisor]) {
        task.isCommentAreaSupervisor = [NSNumber numberWithBool:sender.isSelected];
    }
    else if ([sender isEqual:_btnCommentWorkOrder]) {
        task.isCommentWorkOrder = [NSNumber numberWithBool:sender.isSelected];
    }
}

- (void)btnNoTapped:(UIButton*)btn {
    isUpdate = YES;
    NSIndexPath *indexPath = [self indexPathForCellSubView:btn];
    if (btn.isSelected) {
        [[mutArrFilteredTaskList objectAtIndex:indexPath.row] setResponse:@""];
    }
    else {
        [[mutArrFilteredTaskList objectAtIndex:indexPath.row] setResponse:@"no"];
    }
    [btn setSelected:YES];
    TaskTableViewCell *aCell = (TaskTableViewCell*)[_tblTaskList cellForRowAtIndexPath:indexPath];
    [aCell.btnYes setSelected:NO];
}
- (void)btnYesTapped:(UIButton*)btn {
    isUpdate = YES;
    NSIndexPath *indexPath = [self indexPathForCellSubView:btn];
    if (btn.isSelected) {
        [[mutArrFilteredTaskList objectAtIndex:indexPath.row] setResponse:@""];
    }
    else {
        [[mutArrFilteredTaskList objectAtIndex:indexPath.row] setResponse:@"yes"];
    }
    [btn setSelected:YES];
    TaskTableViewCell *aCell = (TaskTableViewCell*)[_tblTaskList cellForRowAtIndexPath:indexPath];
    [aCell.btnNo setSelected:NO];
}
- (void)btnCheckBoxTapped:(UIButton*)btn {
    isUpdate = YES;
    NSIndexPath *indexPath = [self indexPathForCellSubView:btn];
    if (btn.isSelected) {
        [[mutArrFilteredTaskList objectAtIndex:indexPath.row] setResponse:@""];
    }
    else {
        [[mutArrFilteredTaskList objectAtIndex:indexPath.row] setResponse:@"checked"];
    }
    [btn setSelected:!btn.isSelected];
}

- (void)btnKeyboardIconTapped:(UIButton*)btn {
    NSIndexPath *indexPath = [self indexPathForCellSubView:btn];
    TaskTableViewCell *aCell = (TaskTableViewCell*)[_tblTaskList cellForRowAtIndexPath:indexPath];
    TaskList *aTask = mutArrFilteredTaskList[indexPath.row];
    _lblPopOverTaskTitle.text = [aTask name];
    _lblPopOverTaskLocation.text = [aTask location];
    _txvPopOverMessage.text = [aTask comment];
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"hh:mm a"];
    [_lblPopOverTime setText:[aFormatter stringFromDate:[NSDate date]]];
    
    [_btnCommentAreaSupervisor setSelected:[aTask.isCommentAreaSupervisor boolValue]];
    [_btnCommentBuildingSupervisor setSelected:[aTask.isCommentBuildingSupervisor boolValue]];
    [_btnCommentGoBoardGroup setSelected:[aTask.isCommentGoBoardGroup boolValue]];
    [_btnCommentTask setSelected:[aTask.isCommentTask boolValue]];
    [_btnCommentWorkOrder setSelected:[aTask.isCommentWorkOrder boolValue]];
    
    editingIndex = indexPath.row;
    if (popOverMessage) {
        [popOverMessage dismissPopoverAnimated:NO];
        popOverMessage.contentViewController.view = nil;
        popOverMessage = nil;
    }
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view = _vwMessagePopOver;
    popOverMessage = [[UIPopoverController alloc] initWithContentViewController:viewController];
    viewController = nil;
    [popOverMessage setDelegate:self];
    [popOverMessage setPopoverContentSize:_vwMessagePopOver.frame.size];
    CGRect frame = [aCell convertRect:aCell.btnKeyboardIcon.frame toView:_tblTaskList];
    frame = [_tblTaskList convertRect:frame toView:self.view];
    [popOverMessage presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
#pragma mark - Methods

- (void)getAllTasks {
    [[WebSerivceCall webServiceObject] callServiceForTaskList:NO complition:^{
        [self fetchAllTask];
        [_tblTaskList reloadData];
    }];
    
}



- (void)fetchAllTask {
    NSFetchRequest * allTask = [[NSFetchRequest alloc] initWithEntityName:@"TaskList"];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"taskDateTime" ascending:YES];
    NSSortDescriptor *sortBySequence = [[NSSortDescriptor alloc] initWithKey:@"sequence" ascending:YES];
    [allTask setSortDescriptors:@[descriptor, sortBySequence]];
    
    mutArrTaskList = [gblAppDelegate.managedObjectContext executeFetchRequest:allTask error:nil];
    
    NSDate* sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone =  [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone =  [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    
    NSLog(@"taskDateTime > %@ AND taskDateTime < %@", destinationDate , [destinationDate dateByAddingTimeInterval:60*60*2]);
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"expirationTime > %@ AND taskDateTime < %@", destinationDate , [destinationDate dateByAddingTimeInterval:60*60*2]]; // AND taskDateTime > %@,destinationDate
   
    mutArrTaskUptoNx2Hrs = [mutArrTaskList filteredArrayUsingPredicate:predicate1];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isCompleted == NO"];
    mutArrFilteredTaskList = [NSMutableArray arrayWithArray:[mutArrTaskUptoNx2Hrs filteredArrayUsingPredicate:predicate]];
    _lblTaskRemaining.text = [NSString stringWithFormat:@"%ld", (long)mutArrFilteredTaskList.count];
    
    if ([mutArrFilteredTaskList count] == 0) {
        [_lblNoRecords setHidden:NO];
    }
}

- (NSIndexPath*)indexPathForCellSubView:(id)view {
    TaskTableViewCell *aCell = (TaskTableViewCell*)[view superview];
    while (![aCell isKindOfClass:[TaskTableViewCell class]]) {
        aCell = (TaskTableViewCell*)[aCell superview];
    }
    NSIndexPath *indexPath = [_tblTaskList indexPathForCell:aCell];
    return indexPath;
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mutArrFilteredTaskList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskTableViewCell *aCell = (TaskTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 0 || indexPath.row % 2 == 0) {
        [aCell setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    }
    else {
        [aCell setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
    }
    [aCell.txtTemp setHidden:YES];
    [aCell.btnNo setHidden:YES];
    [aCell.btnYes setHidden:YES];
    [aCell.btnCheckBox setHidden:YES];
    [aCell.vwDrpDown setHidden:YES];
    [aCell.txtDropDown setDelegate:self];
    [aCell.btnNo addTarget:self action:@selector(btnNoTapped:) forControlEvents:UIControlEventTouchUpInside];
    [aCell.btnYes addTarget:self action:@selector(btnYesTapped:) forControlEvents:UIControlEventTouchUpInside];
    [aCell.btnCheckBox addTarget:self action:@selector(btnCheckBoxTapped:) forControlEvents:UIControlEventTouchUpInside];
    TaskList *task = [mutArrFilteredTaskList objectAtIndex:indexPath.row];
    BOOL isCompleted = [task.isCompleted boolValue];
    [aCell.btnKeyboardIcon addTarget:self action:@selector(btnKeyboardIconTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSDate* sourceDate = task.taskDateTime;
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = sourceGMTOffset - destinationGMTOffset ;
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    NSDate* currentDate = [[NSDate alloc]initWithTimeInterval:-interval sinceDate:[NSDate date]]; //Interval is assign by '-' to convert it into EDT Time.
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [aFormatter setDateFormat:@"hh:mm a"];
    NSLog(@"String %@", [aFormatter stringFromDate:destinationDate]);
    NSString *aStrTaskName = [NSString stringWithFormat:@"%@ %@", [aFormatter stringFromDate:destinationDate],task.name];
    
    
    [aCell.imvTextBG setHidden:YES];
    if (isCompleted) {
        if ([task.responseType isEqualToString:@"checkbox"]) {
            [aCell.btnCheckBox setHidden:NO];
            [aCell.btnCheckBox setUserInteractionEnabled:NO];
            [aCell.btnCheckBox setSelected:YES];
        }
        else if ([task.responseType isEqualToString:@"numeric"] || [task.responseType isEqualToString:@"textbox"]) {
            [aCell.imvTextBG setHidden:NO];
            [aCell.txtTemp setHidden:NO];
            [aCell.txtTemp setUserInteractionEnabled:NO];
            [aCell.txtTemp setText:task.response];
            [aCell.txtTemp setTextColor:[UIColor colorWithRed:120.0/255.0 green:197.0/255.0 blue:121.0/255.0 alpha:1.0]];
        }
        else if ([task.responseType isEqualToString:@"yesno"]) {
            if ([task.response isEqualToString:@"yes"]) {
                [aCell.btnYes setHidden:NO];
                [aCell.btnYes setSelected:YES];
                [aCell.btnYes setUserInteractionEnabled:NO];
            }
            else {
                [aCell.btnNo setHidden:NO];
                [aCell.btnNo setSelected:YES];
                [aCell.btnNo setUserInteractionEnabled:NO];
            }
        }
        else if ([task.responseType isEqualToString:@"dropdown"]) {
            [aCell.vwDrpDown setHidden:NO];
            aCell.txtDropDown.text = task.response;
            aCell.txtDropDown.userInteractionEnabled = NO;
        }
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:aStrTaskName];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@2
                                range:NSMakeRange(0, [attributeString length])];
        [aCell.lblTask setAttributedText:attributeString];
        [aCell.lblTask setTextColor:[UIColor lightGrayColor]];
        [aCell.btnKeyboardIcon setHidden:YES];
    }
    else {
        [aCell.lblTask setAttributedText:nil];
        [aCell.lblTask setText:aStrTaskName];
        [aCell.lblTask setTextColor:[UIColor darkGrayColor]];
        [aCell.btnKeyboardIcon setHidden:NO];
        if ([task.responseType isEqualToString:@"checkbox"]) {
            [aCell.btnCheckBox setHidden:NO];
            [aCell.btnCheckBox setUserInteractionEnabled:YES];
            if ([task.response isEqualToString:@"checked"]) {
                [aCell.btnCheckBox setSelected:YES];
            }
            else {
                [aCell.btnCheckBox setSelected:NO];
            }
        }
        else if ([task.responseType isEqualToString:@"numeric"] || [task.responseType isEqualToString:@"textbox"]) {
            [aCell.imvTextBG setHidden:NO];
            [aCell.txtTemp setHidden:NO];
            if ([task.responseType isEqualToString:@"numeric"]) {
                [aCell.txtTemp setText:@"--"];
                [aCell.txtTemp setKeyboardType:UIKeyboardTypeNumberPad];
            }
            else {
                [aCell.txtTemp setKeyboardType:UIKeyboardTypeAlphabet];
                aCell.txtTemp.text = @"";
            }
            if (![task.response isEqualToString:@""]) {
                [aCell.txtTemp setText:task.response];
            }
            
            [aCell.txtTemp setUserInteractionEnabled:YES];
            [aCell.txtTemp setTextColor:[UIColor colorWithRed:204.0/255.0 green:0.0 blue:0.0 alpha:1.0]];
        }
        else if ([task.responseType isEqualToString:@"yesno"]) {
            [aCell.btnNo setHidden:NO];
            [aCell.btnYes setHidden:NO];
            [aCell.btnNo setSelected:NO];
            [aCell.btnYes setSelected:NO];
            [aCell.btnYes setUserInteractionEnabled:YES];
            [aCell.btnNo setUserInteractionEnabled:YES];
            if ([task.response isEqualToString:@"yes"]) {
                [aCell.btnYes setSelected:YES];
            }
            else if ([task.response isEqualToString:@"no"]) {
                [aCell.btnNo setSelected:YES];
            }
        }
        else if ([task.responseType isEqualToString:@"dropdown"]) {
            [aCell.vwDrpDown setHidden:NO];
            for (TaskResponseTypeValues *type in task.responseTypeValues) {
                if ([type.typeId isEqualToString:task.response]) {
                    aCell.txtDropDown.text = type.code;
                    break;
                }
            }
            
            aCell.txtDropDown.userInteractionEnabled = YES;
        }
        
        
        if ( [currentDate compare:task.expirationTime/*sourceDate*/] == NSOrderedDescending) {
            NSLog(@"Task Is Expire and is passed away.");
            
            if ([task.responseType isEqualToString:@"checkbox"]) {
                [aCell.btnCheckBox setHidden:NO];
                [aCell.btnCheckBox setUserInteractionEnabled:NO];
                
            }
            else if ([task.responseType isEqualToString:@"numeric"] || [task.responseType isEqualToString:@"textbox"]) {
                [aCell.imvTextBG setHidden:NO];
                [aCell.txtTemp setHidden:NO];
                [aCell.txtTemp setUserInteractionEnabled:NO];
                [aCell.txtTemp setText:task.response];
                [aCell.txtTemp setTextColor:[UIColor colorWithRed:120.0/255.0 green:197.0/255.0 blue:121.0/255.0 alpha:1.0]];
            }
            else if ([task.responseType isEqualToString:@"yesno"]) {
                [aCell.btnYes setHidden:NO];
                [aCell.btnYes setUserInteractionEnabled:NO];
                [aCell.btnNo setUserInteractionEnabled:NO];
                
            }
            else if ([task.responseType isEqualToString:@"dropdown"]) {
                [aCell.vwDrpDown setHidden:NO];
                aCell.txtDropDown.userInteractionEnabled = NO;
            }
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:aStrTaskName];
            [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                    value:@2
                                    range:NSMakeRange(0, [attributeString length])];
            [aCell.lblTask setAttributedText:attributeString];
            [aCell.lblTask setTextColor:[UIColor redColor]];
            [aCell.btnKeyboardIcon setHidden:YES];
            
        }else if ([currentDate compare:sourceDate] == NSOrderedAscending || NSOrderedSame){
            NSLog(@"Task Is not Expire and will occur after words");
        }
    }
    
    [aCell.lblFarenhite setTextColor:aCell.txtTemp.textColor];
    [aCell.lblFarenhite setHidden:aCell.txtTemp.isHidden];
    UIView *aView = [aCell.contentView viewWithTag:4];
    CGRect frame = aView.frame;
    frame.origin.y = aCell.frame.size.height - 3;
    [aView setFrame:frame];
    
    return aCell;
}

//--------- changes by chetan kasundra -------------
//--------- show the description in full area ------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskList *task = [mutArrFilteredTaskList objectAtIndex:indexPath.row];
    
    [_lblDetailTitle setText:task.name];

    float height=[task.desc boundingRectWithSize:CGSizeMake(470, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size.height;
    
    CGRect frame = _lblDetailDesc.frame;
    frame.size.height = height;
    _lblDetailDesc.frame = frame;
    [_lblDetailDesc setText:task.desc];

    
    frame=_lblLocation.frame;
    frame.origin.y=CGRectGetMaxY(_lblDetailDesc.frame) + 8;
    _lblLocation.frame=frame;
    [_lblLocation setText:task.location];
    
    
    frame = _vwDetailPopOver.frame;
    frame.size.height = CGRectGetMaxY(_lblLocation.frame) + 18;
    _vwDetailPopOver.frame = frame;
    if (popOver) {
        [popOver dismissPopoverAnimated:NO];
        popOver.contentViewController.view = nil;
        popOver = nil;
    }
    UITableViewCell *aCell = [tableView cellForRowAtIndexPath:indexPath];
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view = _vwDetailPopOver;
    
    popOver = [[UIPopoverController alloc] initWithContentViewController:viewController];
    viewController = nil;
    [popOver setDelegate:self];
    [popOver setPopoverContentSize:_vwDetailPopOver.frame.size];
    frame = [tableView convertRect:aCell.frame toView:self.view];
    dispatch_async(dispatch_get_main_queue(), ^{
        [popOver presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    });

}
//--------------------------------------------------

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    if (popOverMessage) {
        popOverMessage.contentViewController.view = nil;
        popOverMessage = nil;
    }
    else {
        popOver.contentViewController.view = nil;
        popOver = nil;
    }
    
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSIndexPath *indexPath = [self indexPathForCellSubView:textField];
    TaskList *task = [mutArrFilteredTaskList objectAtIndex:indexPath.row];
    if ([[task responseType] isEqualToString:@"dropdown"]) {
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        editingIndex = indexPath.row;
        NSArray *ary = [task.responseTypeValues allObjects];
        [ary sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"code" ascending:YES]]];
        [dropDown showDropDownWith:ary view:textField key:@"value"];
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([[textField text] isEqualToString:@"--"]) {
        [textField setText:@""];
    }
    if (!isUpdate) {
        strPreviousText = textField.text;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) return YES;
    NSIndexPath *indexPath = [self indexPathForCellSubView:textField];
    TaskList *task = [mutArrFilteredTaskList objectAtIndex:indexPath.row];
    if ([[task responseType] isEqualToString:@"numeric"]) {
        NSCharacterSet *numericCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        if ([string rangeOfCharacterFromSet:numericCharacterSet].location == NSNotFound) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSIndexPath *indexPath = [self indexPathForCellSubView:textField];
    if (indexPath) {
        [[mutArrFilteredTaskList objectAtIndex:indexPath.row] setResponse:textField.trimText];
    }
    if (!isUpdate && ![strPreviousText isEqualToString:textField.text]) {
        isUpdate = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (!isUpdate) {
        strPreviousText = textView.text;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text length] > 0) {
        NSString *aStr = textView.text;
        aStr = [aStr stringByReplacingCharactersInRange:range withString:text];
        if ([aStr length] > 300) {
            return NO;
        }
        
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [mutArrFilteredTaskList[editingIndex] setComment:textView.text];
    if (!isUpdate && ![strPreviousText isEqualToString:textView.text]) {
        isUpdate = YES;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        [self showCount];
    }
    else {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


- (void)dropDownControllerDidSelectValue:(id)value atIndex:(NSInteger)index sender:(id)sender {
    TaskList *task = [mutArrFilteredTaskList objectAtIndex:editingIndex];
    task.response = [(TaskResponseTypeValues*)value typeId];
    [(UITextField*)sender setText:[(TaskResponseTypeValues*)value code]];
}

@end

