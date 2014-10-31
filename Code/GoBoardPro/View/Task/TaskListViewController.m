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
        mutArrFilteredTaskList = mutArrTaskList;
    }
    else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isCompleted == NO"];
        mutArrFilteredTaskList = [NSMutableArray arrayWithArray:[mutArrTaskList filteredArrayUsingPredicate:predicate]];
    }
    [sender setSelected:![sender isSelected]];
    [_tblTaskList reloadData];
}

- (IBAction)btnToggleToCountTapped:(id)sender {
}

- (IBAction)btnSubmitTapped:(id)sender {
    for (NSMutableDictionary *aDict in mutArrFilteredTaskList) {
        if ([[aDict objectForKey:@"value"] length] > 0) {
            [aDict setObject:[NSNumber numberWithBool:YES] forKey:@"isCompleted"];
        }
    }
    [_tblTaskList reloadData];
}

- (IBAction)btnToggleTaskAndCountTapped:(id)sender {
    NSArray *aryNavigationStack = [self.navigationController viewControllers];
    BOOL isPoped = NO;
    for (id obj in aryNavigationStack) {
        if ([obj isKindOfClass:[UtilizationCountViewController class]]) {
            isPoped = YES;
            [self.navigationController popToViewController:obj animated:YES];
            break;
        }
    }
    if (!isPoped) {
        [self performSegueWithIdentifier:@"TaskToCount" sender:self];
    }
}

- (IBAction)btnBackTapped:(id)sender {
    [self.view endEditing:YES];
    if (isUpdate) {
        [[[UIAlertView alloc] initWithTitle:@"GoBoardPro" message:@"Do you want to save your information? If you press “Back” you will lose all entered information, do you want to proceed?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil] show];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)btnPopOverTaskTapped:(UIButton *)sender {
    [sender setSelected:YES];
    [mutArrFilteredTaskList[editingIndex] setObject:[NSNumber numberWithInteger:sender.tag] forKey:@"messageOption"];
}

- (void)btnNoTapped:(UIButton*)btn {
    isUpdate = YES;
    NSIndexPath *indexPath = [self indexPathForCellSubView:btn];
    if (btn.isSelected) {
        [[mutArrFilteredTaskList objectAtIndex:indexPath.row] setObject:@"" forKey:@"value"];
    }
    else {
        [[mutArrFilteredTaskList objectAtIndex:indexPath.row] setObject:@"N" forKey:@"value"];
    }
    [btn setSelected:YES];
    TaskTableViewCell *aCell = (TaskTableViewCell*)[_tblTaskList cellForRowAtIndexPath:indexPath];
    [aCell.btnYes setSelected:NO];
}
- (void)btnYesTapped:(UIButton*)btn {
    isUpdate = YES;
    NSIndexPath *indexPath = [self indexPathForCellSubView:btn];
    if (btn.isSelected) {
        [[mutArrFilteredTaskList objectAtIndex:indexPath.row] setObject:@"" forKey:@"value"];
    }
    else {
        [[mutArrFilteredTaskList objectAtIndex:indexPath.row] setObject:@"Y" forKey:@"value"];
    }
    [btn setSelected:YES];
    TaskTableViewCell *aCell = (TaskTableViewCell*)[_tblTaskList cellForRowAtIndexPath:indexPath];
    [aCell.btnNo setSelected:NO];
}
- (void)btnCheckBoxTapped:(UIButton*)btn {
    isUpdate = YES;
    NSIndexPath *indexPath = [self indexPathForCellSubView:btn];
    if (btn.isSelected) {
        [[mutArrFilteredTaskList objectAtIndex:indexPath.row] setObject:@"" forKey:@"value"];
    }
    else {
        [[mutArrFilteredTaskList objectAtIndex:indexPath.row] setObject:@"C" forKey:@"value"];
    }
   
}

- (void)btnKeyboardIconTapped:(UIButton*)btn {
    NSIndexPath *indexPath = [self indexPathForCellSubView:btn];
    TaskTableViewCell *aCell = (TaskTableViewCell*)[_tblTaskList cellForRowAtIndexPath:indexPath];
    _lblPopOverTaskTitle.text = [mutArrFilteredTaskList[indexPath.row] objectForKey:@"task"];
    _lblPopOverTaskLocation.text = _lblLocation.text;
    _txvPopOverMessage.text = [mutArrFilteredTaskList[indexPath.row] objectForKey:@"message"];
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"hh:mm a"];
    [_lblPopOverTime setText:[aFormatter stringFromDate:[NSDate date]]];
    NSInteger option = [[mutArrFilteredTaskList[indexPath.row] objectForKey:@"messageOption"] integerValue];
    
    for (int i = 2; i <= 6; i++) {
        if (i == option) {
            [(UIButton*)[_vwMessagePopOver viewWithTag:i] setSelected:YES];
        }
        else {
            [(UIButton*)[_vwMessagePopOver viewWithTag:i] setSelected:NO];
        }
    }
    
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
    mutArrTaskList = [[NSMutableArray alloc] init];

    [mutArrTaskList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"This is a Demo task with checkbox.", @"task", @"This is a demo description with single line.", @"description", @"checkbox", @"type", [NSNumber numberWithBool:NO], @"isCompleted", @"", @"value", @"", @"message", nil]];
    [mutArrTaskList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"This is a Demo task with checkbox.", @"task", @"This is a demo description with two line. For checking the PopOver size that suits for dynamic height or not, So we can be sure that it will work for any height based on the text, maximum lines allowed are four only.", @"description", @"checkbox", @"type", [NSNumber numberWithBool:YES], @"isCompleted", @"C", @"value", @"", @"message", nil]];
    [mutArrTaskList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"This is a Demo task with TextField.", @"task", @"This is a demo description with single line.", @"description", @"textField", @"type", [NSNumber numberWithBool:NO], @"isCompleted", @"", @"value", @"", @"message", nil]];
    [mutArrTaskList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"This is a Demo task with TextField.", @"task", @"This is a demo description with single line.", @"description", @"textField", @"type", [NSNumber numberWithBool:YES], @"isCompleted", @"72", @"value", @"", @"message", nil]];
    [mutArrTaskList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"This is a Demo task with YES/NO.", @"task", @"This is a demo description with single line.", @"description", @"yesNo", @"type", [NSNumber numberWithBool:NO], @"isCompleted", @"", @"value", @"", @"message", nil]];
    [mutArrTaskList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"This is a Demo task with YES/NO.", @"task", @"This is a demo description with single line.", @"description", @"yesNo", @"type", [NSNumber numberWithBool:YES], @"isCompleted", @"N", @"value", @"", @"message", nil]];
    [mutArrTaskList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"This is a Demo task with YES/NO.", @"task", @"This is a demo description with single line.", @"description", @"yesNo", @"type", [NSNumber numberWithBool:YES], @"isCompleted", @"Y", @"value", @"", @"message", nil]];
    mutArrFilteredTaskList = mutArrTaskList;
   
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
    NSDictionary *aDict = [mutArrFilteredTaskList objectAtIndex:indexPath.row];
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
    [aCell.btnNo addTarget:self action:@selector(btnNoTapped:) forControlEvents:UIControlEventTouchUpInside];
    [aCell.btnYes addTarget:self action:@selector(btnYesTapped:) forControlEvents:UIControlEventTouchUpInside];
    [aCell.btnCheckBox addTarget:self action:@selector(btnCheckBoxTapped:) forControlEvents:UIControlEventTouchUpInside];
    BOOL isCompleted = [[aDict objectForKey:@"isCompleted"] boolValue];
    [aCell.btnKeyboardIcon addTarget:self action:@selector(btnKeyboardIconTapped:) forControlEvents:UIControlEventTouchUpInside];
    if (isCompleted) {
        if ([[aDict objectForKey:@"type"] isEqualToString:@"checkbox"]) {
            [aCell.btnCheckBox setHidden:NO];
            [aCell.btnCheckBox setUserInteractionEnabled:NO];
            [aCell.btnCheckBox setSelected:YES];
        }
        else if ([[aDict objectForKey:@"type"] isEqualToString:@"textField"]) {
            [aCell.txtTemp setHidden:NO];
            [aCell.txtTemp setUserInteractionEnabled:NO];
            [aCell.txtTemp setText:[aDict objectForKey:@"value"]];
            [aCell.txtTemp setTextColor:[UIColor colorWithRed:120.0/255.0 green:197.0/255.0 blue:121.0/255.0 alpha:1.0]];
        }
        else {
            if ([[aDict objectForKey:@"value"] isEqualToString:@"Y"]) {
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
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[aDict objectForKey:@"task"]];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@2
                                range:NSMakeRange(0, [attributeString length])];
        [aCell.lblTask setAttributedText:attributeString];
        [aCell.lblTask setTextColor:[UIColor lightGrayColor]];
        [aCell.btnKeyboardIcon setHidden:YES];
    }
    else {
        [aCell.lblTask setAttributedText:nil];
        [aCell.lblTask setText:[aDict objectForKey:@"task"]];
        [aCell.lblTask setTextColor:[UIColor darkGrayColor]];
        [aCell.btnKeyboardIcon setHidden:NO];
        if ([[aDict objectForKey:@"type"] isEqualToString:@"checkbox"]) {
            if ([[aDict objectForKey:@"value"] isEqualToString:@"C"]) {
                [aCell.btnCheckBox setHidden:NO];
                [aCell.btnCheckBox setSelected:YES];
            }
            else {
                [aCell.btnCheckBox setHidden:NO];
                [aCell.btnCheckBox setSelected:NO];
            }
        }
        else if ([[aDict objectForKey:@"type"] isEqualToString:@"textField"]) {
            [aCell.txtTemp setHidden:NO];
            if (![[aDict objectForKey:@"value"] isEqualToString:@""]) {
                [aCell.txtTemp setText:[aDict objectForKey:@"value"]];
            }
            else {
                [aCell.txtTemp setText:@"--"];
            }
            [aCell.txtTemp setUserInteractionEnabled:YES];
            [aCell.txtTemp setTextColor:[UIColor colorWithRed:204.0/255.0 green:0.0 blue:0.0 alpha:1.0]];
        }
        else {
            [aCell.btnNo setHidden:NO];
            [aCell.btnYes setHidden:NO];
            [aCell.btnNo setSelected:NO];
            [aCell.btnYes setSelected:NO];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *aDict = [mutArrFilteredTaskList objectAtIndex:indexPath.row];
    CGRect frame = _lblDetailDesc.frame;
    frame.size.width = 470;
    _lblDetailDesc.frame = frame;
    [_lblDetailTitle setText:[aDict objectForKey:@"task"]];
    [_lblDetailDesc setText:[aDict objectForKey:@"description"]];
    [_lblDetailDesc sizeToFit];
    frame = _vwDetailPopOver.frame;
    frame.size.height = CGRectGetMaxY(_lblDetailDesc.frame) + 18;
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([[textField text] isEqualToString:@"--"]) {
        [textField setText:@""];
    }
    if (!isUpdate) {
        strPreviousText = textField.text;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSIndexPath *indexPath = [self indexPathForCellSubView:textField];
    if (indexPath) {
        [[mutArrFilteredTaskList objectAtIndex:indexPath.row] setObject:textField.trimText forKey:@"value"];
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
    [mutArrFilteredTaskList[editingIndex] setObject:textView.text forKey:@"message"];
    if (!isUpdate && ![strPreviousText isEqualToString:textView.text]) {
        isUpdate = YES;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end

