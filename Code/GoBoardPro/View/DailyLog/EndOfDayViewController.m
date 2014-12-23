//
//  EndOfDayViewController.m
//  GoBoardPro
//
//  Created by ind558 on 11/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "EndOfDayViewController.h"
#import "DailyLog.h"

@interface EndOfDayViewController ()

@end

@implementation EndOfDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_lblNoRecords setHidden:YES];
    [self fetchDailyLog];
    // Do any additional setup after loading the view.
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

- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSubmitTapped:(id)sender {
    if ([mutArrDailyList count] == 0) {
        return;
    }
    NSMutableArray *mutAryLogs = [NSMutableArray array];
    for (DailyLog *aLog in mutArrDailyList) {
        [mutAryLogs addObject:@{@"Date":aLog.date, @"Description":aLog.desc, @"IncludeInEndOfDayReport": aLog.includeInEndOfDayReport}];
    }
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    [aFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDictionary *aDict = @{@"UserId":[[User currentUser] userId], @"Date":[aFormatter stringFromDate:[NSDate date]], @"DailyLogDetails":mutAryLogs};
    [gblAppDelegate callWebService:DAILY_LOG parameters:aDict httpMethod:[SERVICE_HTTP_METHOD objectForKey:DAILY_LOG] complition:^(NSDictionary *response) {
        for (DailyLog *aLog in mutArrDailyList) {
            [gblAppDelegate.managedObjectContext deleteObject:aLog];
        }
        [gblAppDelegate.managedObjectContext save:nil];
        [[[UIAlertView alloc] initWithTitle:gblAppDelegate.appName message:@"Daily log has been submitted successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    } failure:^(NSError *error, NSDictionary *response) {
    }];
    
}

- (void)btnCheckMarkTapped:(UIButton*)sender {
    UITableViewCell *aCell = (UITableViewCell *)sender.superview;
    while (![aCell isKindOfClass:[UITableViewCell class]]) {
        aCell = (UITableViewCell *)aCell.superview;
    }
    NSIndexPath *indexPath = [_tblDailyLog indexPathForCell:aCell];
    DailyLog *log = [mutArrDailyList objectAtIndex:indexPath.row];
    [sender setSelected:!sender.isSelected];
    if (sender.isSelected) {
        log.includeInEndOfDayReport = @"true";
    }
    else {
        log.includeInEndOfDayReport = @"false";
    }
    [gblAppDelegate.managedObjectContext save:nil];
}

#pragma mark - Methods

- (void)fetchDailyLog {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"DailyLog"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userId MATCHES[cd] %@)", [[User currentUser] userId]];
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
    NSArray *aryDateComp = [log.date componentsSeparatedByString:@" "];
    [aLblTime setText:[NSString stringWithFormat:@"%@ %@", aryDateComp[1], aryDateComp[2]]];
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
    UIButton *aBtn = (UIButton *)[aCell.contentView viewWithTag:5];
    [aBtn addTarget:self action:@selector(btnCheckMarkTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return aCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DailyLog *log = [mutArrDailyList objectAtIndex:indexPath.row];
    UILabel *aLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 588, 10)];
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

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
