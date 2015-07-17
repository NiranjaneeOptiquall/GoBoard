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
    [aFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
    //[aFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    aLog.date = [aFormatter stringFromDate:[NSDate date]];
    aLog.includeInEndOfDayReport = @"false";
    aLog.shouldSync = [NSNumber numberWithBool:NO];
    [gblAppDelegate.managedObjectContext insertObject:aLog];
    [gblAppDelegate.managedObjectContext save:nil];
    [mutArrDailyList addObject:aLog];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSMutableArray *aMutArrTemp = [[NSMutableArray alloc]initWithArray:[mutArrDailyList sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]]];
    [mutArrDailyList removeAllObjects];
    [mutArrDailyList addObjectsFromArray:aMutArrTemp];
    aMutArrTemp = nil;
    
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
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSMutableArray *aMutArrTemp = [[NSMutableArray alloc]initWithArray:[mutArrDailyList sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]]];
    [mutArrDailyList removeAllObjects];
    [mutArrDailyList addObjectsFromArray:aMutArrTemp];
    aMutArrTemp = nil;

    [mutArrDailyList sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]];
    if ([mutArrDailyList count] == 0) {
        [_lblNoRecords setHidden:NO];
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mutArrDailyList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [aCell setBackgroundColor:[UIColor clearColor]];
    UILabel *aLblTime = (UILabel*)[aCell.contentView viewWithTag:3];
    UILabel *aLblLog = (UILabel*)[aCell.contentView viewWithTag:4];
    DailyLog *log = [mutArrDailyList objectAtIndex:indexPath.row];
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
    NSDate *aDate = [aFormatter dateFromString:log.date];
    [aFormatter setDateFormat:@"hh:mm a"];
    
    
    [aLblTime setText:[aFormatter stringFromDate:aDate]];
    [aLblLog setText:log.desc];
    //----Changes By Chetan Kasundra-------------
    //-----Before prb in cell height,Content Overlap each other
    
    NSDictionary *aDicAttribute=@{NSFontAttributeName :[UIFont boldSystemFontOfSize:17]};
    CGFloat aHeight = [log.desc boundingRectWithSize:CGSizeMake(664, 9999) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:aDicAttribute context:kNilOptions].size.height;
    
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
    return aCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DailyLog *log = [mutArrDailyList objectAtIndex:indexPath.row];
    NSDictionary *aDicAttribute=@{NSFontAttributeName :[UIFont boldSystemFontOfSize:17]};
    CGFloat aHeight = [log.desc boundingRectWithSize:CGSizeMake(664, 9999) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:aDicAttribute context:kNilOptions].size.height;
    
    if (aHeight < 21)
    {
        aHeight = 21;
    }
    return aHeight + 49;
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
