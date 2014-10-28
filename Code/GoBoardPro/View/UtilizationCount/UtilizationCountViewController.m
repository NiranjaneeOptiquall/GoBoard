//
//  UtilizationCountViewController.m
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "UtilizationCountViewController.h"
#import "TaskListViewController.h"
#import "UtilizationCountTableViewCell.h"
#import "Constants.h"

@interface UtilizationCountViewController ()

@end

@implementation UtilizationCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAllCounts];
    NSArray *aryNavigationStack = [self.navigationController viewControllers];
    BOOL isTask = NO;
    for (id obj in aryNavigationStack) {
        if ([obj isKindOfClass:[TaskListViewController class]]) {
            isTask = YES;
            break;
        }
    }
    if (isTask) {
        _lblCount.text = @"Tasks";
        _lblTask.text = @"Counts";
        UIColor *color = _lblCount.textColor;
        _lblCount.textColor = [UIColor whiteColor];
        _lblTask.textColor = color;
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

- (IBAction)btnToggleCountAndTaskTapped:(id)sender {
    NSArray *aryNavigationStack = [self.navigationController viewControllers];
    BOOL isPoped = NO;
    for (id obj in aryNavigationStack) {
        if ([obj isKindOfClass:[TaskListViewController class]]) {
            isPoped = YES;
            [self.navigationController popToViewController:obj animated:YES];
            break;
        }
    }
    if (!isPoped) {
        [self performSegueWithIdentifier:@"CountToTask" sender:self];
    }
}

- (IBAction)btnViewBreakOutTapped:(id)sender {
}

- (IBAction)btnSubmitCountTapped:(id)sender {
    NSInteger count = 0;
    for (NSDictionary *dict in mutArrCount) {
        count += [[dict objectForKey:@"current"] integerValue];
    }
    [_lblTotalCount setText:[NSString stringWithFormat:@"%d", count]];
}

- (IBAction)btnCountCommentTapped:(UIButton *)sender {
}

- (void)btnIncreaseCountTapped:(UIButton*)btn {
    NSIndexPath *indexPath = [self indexPathForView:btn];
    NSMutableDictionary *aDict = [mutArrCount objectAtIndex:indexPath.row];
    NSInteger current = [[aDict objectForKey:@"current"] integerValue];
    NSInteger max = [[aDict objectForKey:@"maxCapacity"] integerValue];
    current++;
    if (current <= max) {
        [aDict setObject:[NSNumber numberWithInteger:current] forKey:@"current"];
    }
    [_tblCountList reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)btnDecreaseCountTapped:(UIButton*)btn {
    NSIndexPath *indexPath = [self indexPathForView:btn];
    NSMutableDictionary *aDict = [mutArrCount objectAtIndex:indexPath.row];
    NSInteger current = [[aDict objectForKey:@"current"] integerValue];
    current--;
    if (current >= 0) {
        [aDict setObject:[NSNumber numberWithInteger:current] forKey:@"current"];
    }
    [_tblCountList reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Methods

- (void)getAllCounts {
    mutArrCount = [[NSMutableArray alloc] init];
    [mutArrCount addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Fitness Center", @"facility", [NSNumber numberWithInt:30], @"maxCapacity", [NSNumber numberWithInt:25], @"current", [NSDate dateWithTimeIntervalSinceNow:-36000], @"lastUpdate", @"", @"message", nil]];
    [mutArrCount addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Swimming Pool", @"facility", [NSNumber numberWithInt:20], @"maxCapacity", [NSNumber numberWithInt:5], @"current", [NSDate dateWithTimeIntervalSinceNow:-3600], @"lastUpdate", @"", @"message", nil]];
    [mutArrCount addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"East Lounge", @"facility", [NSNumber numberWithInt:50], @"maxCapacity", [NSNumber numberWithInt:25], @"current", [NSDate dateWithTimeIntervalSinceNow:-18000], @"lastUpdate", @"", @"message", nil]];
    [mutArrCount addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Snack Bar", @"facility", [NSNumber numberWithInt:40], @"maxCapacity", [NSNumber numberWithInt:18], @"current", [NSDate dateWithTimeIntervalSinceNow:-20000], @"lastUpdate", @"", @"message", nil]];
    [mutArrCount addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"SpaGo", @"facility", [NSNumber numberWithInt:30], @"maxCapacity", [NSNumber numberWithInt:2], @"current", [NSDate dateWithTimeIntervalSinceNow:-76000], @"lastUpdate", @"", @"message", nil]];
    NSInteger count = 0;
    for (NSDictionary *dict in mutArrCount) {
        count += [[dict objectForKey:@"current"] integerValue];
    }
    [_lblTotalCount setText:[NSString stringWithFormat:@"%d", count]];
}

- (NSIndexPath *)indexPathForView:(id)view {
    UtilizationCountTableViewCell *aCell = (UtilizationCountTableViewCell*)[view superview];
    while (![aCell isKindOfClass:[UtilizationCountTableViewCell class]]) {
        aCell = (UtilizationCountTableViewCell*)[aCell superview];
    }
    NSIndexPath *indexPath = [_tblCountList indexPathForCell:aCell];
    return indexPath;
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mutArrCount count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UtilizationCountTableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 0 || indexPath.row % 2 == 0) {
        [aCell setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    }
    else {
        [aCell setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
    }
    NSMutableDictionary *aDictCountInfo = [mutArrCount objectAtIndex:indexPath.row];
    [aCell.lblFacilityArea setText:[aDictCountInfo objectForKey:@"facility"]];
    int aMaxCapacity = [[aDictCountInfo objectForKey:@"maxCapacity"] intValue];
    int aCurrent = [[aDictCountInfo objectForKey:@"current"] intValue];
    int percent = 100 * aCurrent / aMaxCapacity;
    [aCell.lblCapicity setText:[NSString stringWithFormat:@"%d%% Capacity", percent]];
    if (percent > 80) {
        [aCell.txtCount setTextColor:[UIColor colorWithRed:218.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.0]];
    }
    else if (percent > 40) {
        [aCell.txtCount setTextColor:[UIColor colorWithRed:228.0/255.0 green:195.0/255.0 blue:96.0/255.0 alpha:1.0]];
    }
    else {
        [aCell.txtCount setTextColor:[UIColor colorWithRed:124.0/255.0 green:193.0/255.0 blue:139.0/255.0 alpha:1.0]];
    }
    [aCell.txtCount setText:[NSString stringWithFormat:@"%d", aCurrent]];
    [aCell.txtCount setFont:[UIFont boldSystemFontOfSize:64.0]];
    [aCell.txtCount setDelegate:self];
    [aCell.btnDecreaseCount addTarget:self action:@selector(btnDecreaseCountTapped:) forControlEvents:UIControlEventTouchUpInside];
    [aCell.btnIncreaseCount addTarget:self action:@selector(btnIncreaseCountTapped:) forControlEvents:UIControlEventTouchUpInside];
    if (aCurrent == 0) {
        [aCell.btnDecreaseCount setHidden:YES];
    }
    else {
        [aCell.btnDecreaseCount setHidden:NO];
    }
    if (aCurrent == aMaxCapacity) {
        [aCell.btnIncreaseCount setHidden:YES];
    }
    else {
        [aCell.btnIncreaseCount setHidden:NO];
    }
    
    CGRect frame = [aCell.lblDevider frame];
    frame.origin.y = aCell.frame.size.height - frame.size.height;
    [aCell.lblDevider setFrame:frame];
    return aCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *aCell = [tableView cellForRowAtIndexPath:indexPath];
    _lblPopOverLocation.text = [mutArrCount[indexPath.row] objectForKey:@"facility"];
    _txtPopOverMessage.text = [mutArrCount[indexPath.row] objectForKey:@"message"];

    editingIndex = indexPath.row;
    if (popOverMessage) {
        [popOverMessage dismissPopoverAnimated:NO];
        popOverMessage.contentViewController.view = nil;
        popOverMessage = nil;
    }
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view = _vwPopOverMessage;
    popOverMessage = [[UIPopoverController alloc] initWithContentViewController:viewController];
    viewController = nil;
    [popOverMessage setDelegate:self];
    [popOverMessage setPopoverContentSize:_vwPopOverMessage.frame.size];
    CGRect frame = [tableView convertRect:aCell.frame toView:self.view];
    [popOverMessage presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    popOverMessage.contentViewController.view = nil;
    popOverMessage = nil;
}

#pragma mark - TextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:_txtPopOverMessage]) {
        [mutArrCount[editingIndex] setObject:textField.trimText forKey:@"message"];
    }
    else {
        NSIndexPath *indexPath = [self indexPathForView:textField];
        NSMutableDictionary *aDict = [mutArrCount objectAtIndex:indexPath.row];
        int max = [[aDict objectForKey:@"maxCapacity"] intValue];
        int current = [textField.trimText intValue];
        if (current >= 0 && current <= max) {
            [aDict setObject:[NSNumber numberWithInt:current] forKey:@"current"];
            [_tblCountList reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        else {
            NSString *strMsg = [NSString stringWithFormat:@"Maximum capacity for %@ is %d", [aDict objectForKey:@"facility"], [[aDict objectForKey:@"maxCapacity"] intValue]];
            alert(@"Exceed Limit", strMsg);
            [textField becomeFirstResponder];
        }
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:_txtPopOverMessage]) {
        return YES;
    }
    if ([string length] > 0) {
        if (textField.trimText.length < 3) {
            NSCharacterSet *numericCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
            if ([string rangeOfCharacterFromSet:numericCharacterSet].location == NSNotFound) {
                return YES;
            }
        }
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
