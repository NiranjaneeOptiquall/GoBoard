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
    //[aFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
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

//click when user submit the DailyLog
- (IBAction)btnSubmitClick:(id)sender
{
    if ([_txtDescription.text.trimString isEqualToString:@""])
    {
        alert(@"", @"Please enter log detail.");
        return;
    }
    
    DailyLog *aLog = [NSEntityDescription insertNewObjectForEntityForName:@"DailyLog" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    aLog.desc = _txtDescription.text;
    aLog.userId = [User currentUser].userId;
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
    //[aFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    aLog.date = [aFormatter stringFromDate:[NSDate date]];
    aLog.includeInEndOfDayReport = @"false";
    aLog.shouldSync = [NSNumber numberWithBool:NO];
    [gblAppDelegate.managedObjectContext insertObject:aLog];
    [gblAppDelegate.managedObjectContext save:nil];

    [mutArrDailyList addObject:aLog];
    
    NSSortDescriptor *aSortDesc = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:YES];
    [mutArrDailyList sortUsingDescriptors:@[aSortDesc]];
    [_tblDailyLog reloadData];
    NSIndexPath *aIndexPath=[NSIndexPath indexPathForRow:(mutArrDailyList.count - 1) inSection:0];
    [_tblDailyLog scrollToRowAtIndexPath:aIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    _txtDescription.text = @"";
    
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
    
    //----Changes By Chetan Kasundra-------------
    //-----Before prb in cell height,Content Overlap each other
    
    NSDictionary *aDicAttribute=@{NSFontAttributeName :[UIFont boldSystemFontOfSize:17]};
    CGFloat aHeight = [log.desc boundingRectWithSize:CGSizeMake(588, 9999) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:aDicAttribute context:kNilOptions].size.height;
    
   CGRect frame = aLblLog.frame;
    if (aHeight < 21) {
        frame.size.height = 21;
        aLblLog.frame = frame;
    }
    else
    {
        frame.size.height=aHeight;
        aLblLog.frame=frame;
    }
    
    UIView *bgView = [aCell.contentView viewWithTag:2];
    frame = bgView.frame;
    frame.size.height = aHeight + 40;
    bgView.frame = frame;
    //---------------------------------
    
    UIButton *aBtn = (UIButton *)[aCell.contentView viewWithTag:5];
    [aBtn addTarget:self action:@selector(btnCheckMarkTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return aCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DailyLog *log = [mutArrDailyList objectAtIndex:indexPath.row];
    
    NSDictionary *aDicAttribute=@{NSFontAttributeName :[UIFont boldSystemFontOfSize:17]};
    CGFloat aHeight = [log.desc boundingRectWithSize:CGSizeMake(588, 9999) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:aDicAttribute context:kNilOptions].size.height;

    if (aHeight < 21)
    {
        aHeight = 21;
    }
    return aHeight + 49;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
