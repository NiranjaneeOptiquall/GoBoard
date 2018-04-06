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
#import "SOPViewController.h"
#import "AccidentReportViewController.h"
#import "IncidentDetailViewController.h"
#import "DynamicFormsViewController.h"
#import "ERPDetailViewController.h"
#import "EmergencyResponseViewController.h"

@interface TaskListViewController ()<UIWebViewDelegate>
{
    NSMutableArray * allDataForLinkedSopErp;
}
@end

@implementation TaskListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.webPopOverMessage.scrollView.scrollEnabled = NO;
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
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:destinationDate];
        [components setHour:0];
        [components setMinute:0];
        [components setSecond:0];
        
        NSDate *dateSourceTemp = [calendar dateFromComponents:components];
        
        //NSDate *dateSourceTemp = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:destinationDate options:0];
        
        NSDate* dateSource = [[NSDate alloc] initWithTimeInterval:interval sinceDate:dateSourceTemp];
        
        //   NSLog(@"taskDateTime > %@ AND taskDateTime < %@", destinationDate , [destinationDate dateByAddingTimeInterval:60*60*2]);
        
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"taskDateTime >= %@ AND taskDateTime < %@", dateSource , [destinationDate dateByAddingTimeInterval:60*60*2]];
        
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
        
        //   NSLog(@"taskDateTime > %@ AND taskDateTime < %@", destinationDate , [destinationDate dateByAddingTimeInterval:60*60*2]);
        
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
    NSMutableArray * moduleArr = [NSMutableArray new];
    for (NSDictionary * tempDic in gblAppDelegate.mutArrHomeMenus) {
        if ([tempDic[@"SystemModule"] integerValue] == 1) {
            [moduleArr addObject:tempDic];
        }
    }
    
    __weak NSDictionary *aDict =  [moduleArr objectAtIndex:0];
    
    NSLog(@"%@",aDict);
    if ([aDict[@"IsActive"] boolValue] && [aDict[@"IsAccessAllowed"] boolValue])
    {
        [self submitTask:YES];
        
    }
    
    else{
        alert(@"", @"We’re sorry.  You do not have permission to access this area.  Please see your system administrator.");
    }
    
    //    [self submitTask:YES];
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
    
    //#warning Delete code when client approves
    
    /*  _lblPopOverTaskTitle.text = [aTask name];
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
     [popOverMessage presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];*/
    
    //#warning edited by Imaginovation
    
    if ([aTask.isCompleted boolValue] == 0) {
        _lblPopOverTaskTitle.text = [aTask name];
        _lblPopOverTaskLocation.text = [aTask location];
        _txvPopOverMessage.text = [aTask comment];
        [_webPopOverMessage loadHTMLString:[aTask comment] baseURL:nil];
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
        
        //#warning edited by Imaginovation
        
    }else{
        
        
        float height=[aTask.comment boundingRectWithSize:CGSizeMake(470, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size.height;
        
        
        float heightTaskTitle=[aTask.name boundingRectWithSize:CGSizeMake(470, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_lblDetailTitle.font} context:nil].size.height;
        
        CGRect frameTitle = _lblDetailTitle.frame;
        frameTitle.size.height = heightTaskTitle;
        _lblDetailTitle.frame = frameTitle;
        [_lblDetailTitle setText:aTask.name];
        
        
        CGRect frame = _lblDetailDesc.frame;
        frame.origin.y = heightTaskTitle + 10;
        frame.size.height = height;
        _lblDetailDesc.frame = frame;
        [_lblDetailDesc setText:aTask.desc];
        
        [_webPopOverMessage loadHTMLString:aTask.desc baseURL:nil];
        
        frame = _webPopOverMessage.frame;
        frame.origin.y = heightTaskTitle + 10;
        // frame.size.height = height;
        frame.size.height = _webPopOverMessage.scrollView.contentSize.height;
    //    _webPopOverMessage.frame = frame;
        
        
        if (aTask.comment) {
            [_lblDetailDesc setText:aTask.comment];
            [_webPopOverMessage loadHTMLString:aTask.comment baseURL:nil];
        }else {
            [_lblDetailDesc setText:@""];
            [_webPopOverMessage loadHTMLString:@"" baseURL:nil];
        }
        // [_lblDetailDesc sizeToFit];
        [_lblLocation setText:aTask.location];
        
        frame=_lblLocation.frame;
        //        frame.origin.y=CGRectGetMaxY(_lblDetailDesc.frame) + 8;
        frame.origin.y=CGRectGetMaxY(_webPopOverMessage.frame) + 8;
        _lblLocation.frame=frame;
        
        
        
        frame = _vwDetailPopOver.frame;
        //        frame.size.height = CGRectGetMaxY(_lblLocation.frame) + 18;
        frame.size.height = CGRectGetMaxY(_webPopOverMessage.frame) + 18;
        frame.size.width = 470;
        _vwDetailPopOver.frame = frame;
        //        if (popOver) {
        //            [popOver dismissPopoverAnimated:NO];
        //            popOver.contentViewController.view = nil;
        //            popOver = nil;
        //        }
        
        UIViewController *viewController = [[UIViewController alloc] init];
        viewController.view = _vwDetailPopOver;
        viewController.view.backgroundColor = [UIColor clearColor];
        CGRect aNewframe = [aCell convertRect:btn.frame toView:_tblTaskList];
        aNewframe = [_tblTaskList convertRect:aNewframe toView:self.view];
        
        viewController.modalPresentationStyle = UIModalPresentationPopover;
        viewController.transitioningDelegate = self;
        viewController.popoverPresentationController.sourceView = self.view;
        viewController.popoverPresentationController.sourceRect = aNewframe;
        viewController.preferredContentSize = CGSizeMake(500, frame.size.height);
        
        viewController.popoverPresentationController.delegate = self;
        [self presentViewController:viewController animated:YES completion:nil];
        
        
        
    }
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
     [_webPopOverMessage loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
       [_webViewPopOverOtherLink loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    popoverPresentationController = nil;
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
    
    //  NSLog(@"taskDateTime > %@ AND taskDateTime < %@", destinationDate , [destinationDate dateByAddingTimeInterval:60*60*2]);
    
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
    [aCell.imageOneTimeTask setHidden:YES];
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
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:[NSDate date]];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = sourceGMTOffset - destinationGMTOffset ;
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    NSDate* currentDate = [[NSDate alloc]initWithTimeInterval:-interval sinceDate:[NSDate date]]; //Interval is assign by '-' to convert it into EDT Time.
    
    //    NSTimeInterval interval1 = destinationGMTOffset - sourceGMTOffset ;
    //    NSDate* destinationDate1 = [[NSDate alloc] initWithTimeInterval:interval1 sinceDate:sourceDate];
    //    NSDate* currentDate1 = [[NSDate alloc]initWithTimeInterval:interval1 sinceDate:[NSDate date]];
    
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
            
            for (TaskResponseTypeValues *type in task.responseTypeValues) {
                if ([type.typeId isEqualToString:task.response]) {
                    aCell.txtDropDown.text = type.value;
                    break;
                }
            }
            aCell.txtDropDown.userInteractionEnabled = NO;
        }
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:aStrTaskName];
        [attributeString addAttribute:NSBaselineOffsetAttributeName value:@0 range:NSMakeRange(0, [attributeString length])];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@2
                                range:NSMakeRange(0, [attributeString length])];
        
        [aCell.lblTask setAttributedText:attributeString];
        [aCell.lblTask setTextColor:[UIColor lightGrayColor]];
        //  [aCell.btnKeyboardIcon setHidden:YES];
        //#warning edited by Imaginovation
        //#warning btnkeyboard icon gray here
        [aCell.btnKeyboardIcon setImage:[UIImage imageNamed:@"keyboard_icon_large@2x.png"] forState:UIControlStateNormal];
        aCell.btnKeyboardIcon.hidden = [task.comment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0?NO:YES;
    }
    else {
        
        //#warning edited by Imaginovation
        [aCell.btnKeyboardIcon setImage:[UIImage imageNamed:@"keyboard_icon@2x.png"] forState:UIControlStateNormal];
        
        [aCell.lblTask setAttributedText:nil];
        [aCell.lblTask setText:aStrTaskName];
        [aCell.lblTask setTextColor:[UIColor darkGrayColor]];
        aCell.btnKeyboardIcon.hidden = NO;
        
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
                    aCell.txtDropDown.text = type.value;
                    break;
                }
            }
            
            aCell.txtDropDown.userInteractionEnabled = YES;
        }
        
        //        NSLog(@"%@",currentDate);
        //        NSLog(@"%@",task.expirationTime);
        //        NSLog(@"%ld",(long)NSOrderedDescending);
        //        NSLog(@"%ld",(long)[currentDate compare:task.expirationTime/*sourceDate*/]);
        
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
            [attributeString addAttribute:NSBaselineOffsetAttributeName value:@0 range:NSMakeRange(0, [attributeString length])];
            
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
    if ([task.taskType isEqualToString:@"OneTime"]) {
        
        [aCell.imageOneTimeTask setHidden:NO];
        
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
    
    
    float heightTaskTitle=[task.name boundingRectWithSize:CGSizeMake(470, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_lblDetailTitle.font} context:nil].size.height;
    
    CGRect frameTitle = _lblDetailTitle.frame;
    frameTitle.size.height = heightTaskTitle;
    _lblDetailTitle.frame = frameTitle;
    [_lblDetailTitle setText:task.name];
    
    
    CGRect frame = _lblDetailDesc.frame;
    frame.origin.y = heightTaskTitle + 10;
    frame.size.height = height;
    _lblDetailDesc.frame = frame;
    [_lblDetailDesc setText:task.desc];
    
    
    [_webPopOverMessage loadHTMLString:task.desc baseURL:nil];
    frame = _webPopOverMessage.frame;
    frame.origin.y = heightTaskTitle + 10;
    frame.size.height = _webPopOverMessage.scrollView.contentSize.height;

    
    frame=_lblLocation.frame;
    frame.origin.y=CGRectGetMaxY(_webPopOverMessage.frame) + 8;
    _lblLocation.frame=frame;
    [_lblLocation setText:task.location];
    
    
    frame = _vwDetailPopOver.frame;
    frame.size.height = CGRectGetMaxY(_lblLocation.frame) + 18;
    _vwDetailPopOver.frame = frame;

    if (popOver) {
        [popOver dismissPopoverAnimated:YES];
        popOver.contentViewController.view = nil;
        popOver = nil;
    }
    _vwDetailPopOver.hidden = YES;
    UITableViewCell *aCell = [tableView cellForRowAtIndexPath:indexPath];
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view = _vwDetailPopOver;
    
    popOver = [[UIPopoverController alloc] initWithContentViewController:viewController];
    viewController = nil;
    [popOver setDelegate:self];
    [popOver setPopoverContentSize:_vwDetailPopOver.frame.size];
    frame = [tableView convertRect:aCell.frame toView:self.view];

    [popOver presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
  
}
//--------------------------------------------------

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    if (popOverOtherLink) {
        popOverOtherLink.contentViewController.view = nil;
        popOverOtherLink = nil;
    }
    else if (popOverMessage) {
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
    [(UITextField*)sender setText:[(TaskResponseTypeValues*)value value]];
}
-(void)getLinkedSopData:(NSArray*)dataDic{
    
    for (NSMutableDictionary * tempDic in dataDic) {
        if ([[tempDic valueForKey:@"Children"] count] ==0) {
            
            [allDataForLinkedSopErp addObject:tempDic];
            
        }
        else{
            [self getLinkedSopData:[tempDic valueForKey:@"Children"]];
        }
    }
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
  
    [gblAppDelegate showActivityIndicator];

    NSURL *url = [request URL];
    NSString * strUrl = [NSString stringWithFormat:@"%@",url];
    NSLog(@"%@",strUrl);
    if ( [strUrl containsString:@"IsLinked=true"]) {
        [popOver dismissPopoverAnimated:NO];
        //  NSLog(@"linked type");
        if ([strUrl containsString:@"SOPs"]) {
            NSLog(@"linked type SOPs");
            
            NSRange r1 = [strUrl rangeOfString:@"id="];
            NSRange r2 = [strUrl rangeOfString:@"&"];
            NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
            NSString *sopId = [strUrl substringWithRange:rSub];
            
            [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@",SOP_CATEGORY, [[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:SOP_CATEGORY] complition:^(NSDictionary *response) {
                
                
                SOPViewController *sopView = [self.storyboard instantiateViewControllerWithIdentifier:@"SOPViewController"];
                allDataForLinkedSopErp= [[NSMutableArray alloc]init];
                for (NSMutableDictionary * tempDic in [response valueForKey:@"SopCategories"]) {
                    [allDataForLinkedSopErp addObject:tempDic];
                }
                for (NSMutableDictionary * tempDic in [response valueForKey:@"SopCategories"]) {
                    [allDataForLinkedSopErp addObject:tempDic];
                }
                
                [self getLinkedSopData:[response valueForKey:@"SopCategories"]];
                
                for (int i = 0; i<allDataForLinkedSopErp.count; i++) {
                    if ([[NSString stringWithFormat:@"%@",[[allDataForLinkedSopErp valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:sopId]) {
                        sopView.dictSOPCategory = [allDataForLinkedSopErp objectAtIndex:i];
                    }
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (sopView.dictSOPCategory == nil) {
                        alert(@"", @"This link is broken or no longer exists.");
                        return;
                    }else{
                        sopView.mutArrCategoryHierarchy = [NSMutableArray array];
                        [sopView.mutArrCategoryHierarchy addObject:sopView.dictSOPCategory];
                        sopView.isBtnSOPListHidden = YES;
                        [self.navigationController pushViewController:sopView animated:YES];
                    }
                    
                });
                
                
            } failure:^(NSError *error, NSDictionary *response) {
                
            }];
            
        }
        else if ([strUrl containsString:@"ERP"]) {
            NSLog(@"linked type erp");
            
            NSRange r1 = [strUrl rangeOfString:@"id="];
            NSRange r2 = [strUrl rangeOfString:@"&"];
            NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
            NSString *sopId = [strUrl substringWithRange:rSub];
            
            [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@", ERP_CATEGORY, [[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:ERP_CATEGORY] complition:^(NSDictionary *response) {
                
                EmergencyResponseViewController *erpView = [self.storyboard instantiateViewControllerWithIdentifier:@"ERPViewController"];
                allDataForLinkedSopErp= [[NSMutableArray alloc]init];
                for (NSMutableDictionary * tempDic in [response valueForKey:@"ErpCategories"]) {
                    [allDataForLinkedSopErp addObject:tempDic];
                }
                [self getLinkedSopData:[response valueForKey:@"ErpCategories"]];
                
                for (int i = 0; i<allDataForLinkedSopErp.count; i++) {
                    if ([[NSString stringWithFormat:@"%@",[[allDataForLinkedSopErp valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:sopId]) {
                        erpView.dictERPCategory = [allDataForLinkedSopErp objectAtIndex:i];
                    }
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (erpView.dictERPCategory == nil) {
                        alert(@"", @"This link is broken or no longer exists.");
                        return;
                    }else{
                        erpView.mutArrCategoryHierarchy = [NSMutableArray array];
                        [erpView.mutArrCategoryHierarchy addObject:erpView.dictERPCategory];
                        erpView.isBtnERPListHidden = YES;
                        [self.navigationController pushViewController:erpView animated:YES];
                    }
                    
                });
                
                
            } failure:^(NSError *error, NSDictionary *response) {
                
            }];
            
        }
        else if ([strUrl containsString:@"Accident"]) {
            NSLog(@"linked type Accident");
            AccidentReportViewController * acciView = [self.storyboard instantiateViewControllerWithIdentifier:@"AccidentReportViewController"];
            [self.navigationController pushViewController:acciView animated:YES];
        }
        else if ([strUrl containsString:@"Incident"]) {
            
            if ([strUrl containsString:@"Misconduct"]) {
                NSLog(@"linked type Misconduct");
                IncidentDetailViewController * inciView = [self.storyboard instantiateViewControllerWithIdentifier:@"IncidentDetailViewController"];
                inciView.incidentType = 1;
                [self.navigationController pushViewController:inciView animated:YES];
            }
            else if ([strUrl containsString:@"CustomerService"]) {
                NSLog(@"linked type CustomerService");
                IncidentDetailViewController * inciView = [self.storyboard instantiateViewControllerWithIdentifier:@"IncidentDetailViewController"];
                inciView.incidentType = 2;
                [self.navigationController pushViewController:inciView animated:YES];
                
            }
            else if ([strUrl containsString:@"Other"]) {
                NSLog(@"linked type Other");
                IncidentDetailViewController * inciView = [self.storyboard instantiateViewControllerWithIdentifier:@"IncidentDetailViewController"];
                inciView.incidentType = 3;
                [self.navigationController pushViewController:inciView animated:YES];
                
            }
        }
        else if ([strUrl containsString:@"Survey"]) {
            NSLog(@"linked type Survey");
            NSRange r1 = [strUrl rangeOfString:@"surveyId="];
            NSRange r2 = [strUrl rangeOfString:@"&"];
            NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
            NSString *surveyId = [strUrl substringWithRange:rSub];
            
            [[WebSerivceCall webServiceObject] callServiceForSurvey:NO linkedSurveyId:surveyId complition:^{
                DynamicFormsViewController * formView = [self.storyboard instantiateViewControllerWithIdentifier:@"DYFormsView"];
                
                NSString *strSurveyUserType = @"1";
                if ([User checkUserExist]) {
                    strSurveyUserType = @"2";
                }
                NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SurveyList"];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userTypeId ==[CD] %@",strSurveyUserType];
                
                
                [request setPredicate:predicate];
                
                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
                NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"surveyId" ascending:YES];
                
                [request setSortDescriptors:@[sort,sort1]];
                NSMutableArray * mutArrFormList = [NSMutableArray arrayWithArray:[gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil]];
                NSLog(@"%@",mutArrFormList);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (mutArrFormList.count == 0) {
                        alert(@"", @"This link is broken or no longer exists.");
                        return;
                    }
                    else{
                        formView.objFormOrSurvey = [mutArrFormList objectAtIndex:0];
                        
                        formView.isSurvey = YES;
                        
                        [self.navigationController pushViewController:formView animated:YES];
                    }
                });
                
                
            }];
        }
        else if ([strUrl containsString:@"Form"]) {
            
            NSLog(@"linked type Form");
            NSRange r1 = [strUrl rangeOfString:@"formId="];
            NSRange r2 = [strUrl rangeOfString:@"&"];
            NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
            NSString *formId = [strUrl substringWithRange:rSub];
            
            [[WebSerivceCall webServiceObject] callServiceForForms:NO linkedFormId:formId complition:^{
                DynamicFormsViewController * formView = [self.storyboard instantiateViewControllerWithIdentifier:@"DYFormsView"];
                
                NSString *strSurveyUserType = @"1";
                if ([User checkUserExist]) {
                    strSurveyUserType = @"2";
                }
                NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"FormsList"];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userTypeId ==[CD] %@ AND NOT (typeId ==[cd] %@)",strSurveyUserType,[NSString stringWithFormat:@"%d", 3]];
                [request setPredicate:predicate];
                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
                NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"formId" ascending:YES];
                [request setSortDescriptors:@[sort,sort1]];
                NSMutableArray *mutArrFormList = [NSMutableArray arrayWithArray:[gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil]];
                NSLog(@"%@",mutArrFormList);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (mutArrFormList.count == 0) {
                        alert(@"", @"This link is broken or no longer exists.");
                        return;
                    }
                    else{
                        formView.objFormOrSurvey = [mutArrFormList objectAtIndex:0];
                        
                        formView.isSurvey = NO;
                        
                        [self.navigationController pushViewController:formView animated:YES];
                    }
                });
                
                
            }];
            
            
        }
         [gblAppDelegate hideActivityIndicator];
        return NO;
    }
    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
        //        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        //        return NO;
        
        //[gblAppDelegate showActivityIndicator];
        NSIndexPath* indexPathLoad = [NSIndexPath indexPathForRow:webView.tag inSection:0];
        if (popOver) {
            [popOver dismissPopoverAnimated:NO];
            popOver.contentViewController.view = nil;
            popOver = nil;
        }
        
        if (popOverOtherLink) {
            [popOverOtherLink dismissPopoverAnimated:NO];
            popOverOtherLink.contentViewController.view = nil;
            popOverOtherLink = nil;
        }
        
        
        [_webViewPopOverOtherLink loadRequest:request];
        
        UIViewController *viewController = [[UIViewController alloc] init];
        viewController.view = _vwPopOverOtherLink;
        popOverOtherLink = [[UIPopoverController alloc] initWithContentViewController:viewController];
        viewController = nil;
        [popOverOtherLink setDelegate:self];
        [popOverOtherLink setPopoverContentSize:_vwPopOverOtherLink.frame.size];
        UITableViewCell *aCell = [_tblTaskList cellForRowAtIndexPath:indexPathLoad];
        CGRect frame = webView.frame;// [_tblTaskList convertRect:aCell.frame toView:self.view];//_vwDetailPopOver.frame;
        frame.origin.x = 50;
        
        [popOverOtherLink presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
         [gblAppDelegate hideActivityIndicator];
        return NO;
        
    }

    
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if (webView.isLoading)
        return;
    
    [gblAppDelegate hideActivityIndicator];
    
    CGPoint viewCenterRelativeToTableview = [_tblTaskList convertPoint:CGPointMake(CGRectGetMidX(webView.bounds), CGRectGetMidY(webView.bounds)) fromView:webView];
    NSIndexPath *indexPath = [_tblTaskList indexPathForRowAtPoint:viewCenterRelativeToTableview];
    
    CGRect frame = _webPopOverMessage.frame;
    frame=_lblLocation.frame;
    frame.origin.y=CGRectGetMaxY(_webPopOverMessage.frame) + 8;
    _lblLocation.frame=frame;
    frame = _vwDetailPopOver.frame;
    frame.size.height = CGRectGetMaxY(_lblLocation.frame) + 30;
    _vwDetailPopOver.frame = frame;
    _vwDetailPopOver.hidden = NO;
    
    [popOver setPopoverContentSize:_vwDetailPopOver.frame.size animated:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
      [gblAppDelegate hideActivityIndicator];
}
@end

