//
//  DailyLogViewController.m
//  GoBoardPro
//
//  Created by ind558 on 10/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "DailyLogViewController.h"
#import "DailyLog.h"

@interface DailyLogViewController ()

@end

@implementation DailyLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_lblNoRecords setHidden:YES];
    [self fetchDailyLog];
    [_tblDailyLog setBackgroundColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBActions

- (IBAction)btnBackTapped:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSubmitTapped:(id)sender {
    if ([[_txvDailyLog.text trimString] isEqualToString:@""]) {
        alert(@"", @"Please enter log detail.");
        return;
    }
    DailyLog *aLog = [NSEntityDescription insertNewObjectForEntityForName:@"DailyLog" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    aLog.desc = _txvDailyLog.text;
    aLog.userId = [[User currentUser] userId];
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    [aFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    aLog.date = [aFormatter stringFromDate:[NSDate date]];
    aLog.includeInEndOfDayReport = @"false";
    aLog.shouldSync = [NSNumber numberWithBool:NO];
    [gblAppDelegate.managedObjectContext insertObject:aLog];
    [gblAppDelegate.managedObjectContext save:nil];
    [mutArrDailyList addObject:aLog];
    [_lblNoRecords setHidden:YES];
    [_tblDailyLog reloadData];
    _txvDailyLog.text = @"";
}

- (IBAction)btnEditTapped:(id)sender {
}

#pragma mark - Methods

- (void)fetchDailyLog {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"DailyLog"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId MATCHES[cd] %@", [[User currentUser] userId]];
    [request setPredicate:predicate];
    mutArrDailyList = [NSMutableArray arrayWithArray:[gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil]];
    if ([mutArrDailyList count] == 0) {
        [_lblNoRecords setHidden:NO];
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mutArrDailyList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [aCell setBackgroundColor:[UIColor clearColor]];
    UILabel *aLblTime = (UILabel*)[aCell.contentView viewWithTag:3];
    UILabel *aLblLog = (UILabel*)[aCell.contentView viewWithTag:4];
    DailyLog *log = [mutArrDailyList objectAtIndex:indexPath.row];
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    NSDate *aDate = [aFormatter dateFromString:log.date];
    [aFormatter setDateFormat:@"hh:mm a"];
    
    
    [aLblTime setText:[aFormatter stringFromDate:aDate]];
    [aLblLog setText:log.desc];
    [aLblLog sizeToFit];
    CGRect frame = aLblLog.frame;
    if (frame.size.height < 21) {
        frame.size.height = 21;
        aLblLog.frame = frame;
    }
    else {
        UIView *bgView = [aCell.contentView viewWithTag:2];
        frame = bgView.frame;
        frame.size.height = aLblLog.frame.size.height + 40;
        bgView.frame = frame;
    }
    
    return aCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DailyLog *log = [mutArrDailyList objectAtIndex:indexPath.row];
    UILabel *aLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 664, 10)];
    [aLbl setText:log.desc];
    [aLbl setFont:[UIFont boldSystemFontOfSize:17.0]];
    [aLbl setNumberOfLines:0];
    [aLbl sizeToFit];
    CGFloat height = aLbl.frame.size.height;
    if (height < 21) {
        height = 21;
    }
    return height + 49;
}


#pragma mark - UITextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [_lblLogPlaceholder setHidden:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([_txvDailyLog.text isEqualToString:@""]) {
        [_lblLogPlaceholder setHidden:NO];
    }
}
@end
