//
//  DailyLogReviewProgressViewController.m
//  GoBoardPro
//
//  Created by ind558 on 10/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "DailyLogReviewProgressViewController.h"

@interface DailyLogReviewProgressViewController ()

@end

@implementation DailyLogReviewProgressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_scrView setContentSize:CGSizeMake(768, 1200)];
    _lblUserName.text=[NSString stringWithFormat:@"%@ %@",[User currentUser].firstName,[User currentUser].lastName];
    NSDateFormatter *formate=[[NSDateFormatter alloc] init];
    [formate setDateFormat:@"EEEE MM/dd/YYYY"];
    NSDate *date=[NSDate date];
    _lblTodayTime.text= [NSString stringWithFormat:@"Today's Date: %@",[formate stringFromDate:date]];
    aryLocations=[User currentUser].mutArrSelectedLocations;
    aryPostions=[User currentUser].mutArrSelectedPositions;
    
    [_tblLoginUserInfo reloadData];
    
    [self getMissedTask];
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

#pragma mark - IBAction

- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  mark - Method

- (void)getMissedTask {
//    IncompleteTask
//    [[[User currentUser] mutArrSelectedPositions] value]
    NSString *strLocationIds = [[[[User currentUser] mutArrSelectedLocations] valueForKey:@"value"] componentsJoinedByString:@","];
    NSString *strPositionIds = [[[[User currentUser] mutArrSelectedPositions] valueForKey:@"value"] componentsJoinedByString:@","];
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?positionIds=%@&locationIds=%@", DAILY_MATRICS, strPositionIds, strLocationIds] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:DAILY_MATRICS] complition:^(NSDictionary *response) {
        dictDailyMatrics = response;
        aryMissedTask = [response objectForKey:@"IncompleteTasks"];
        if ([aryMissedTask count]) {
            [_lblNoRecords setHidden:NO];
        }
        [_lblCompletedTaskCount setText:[NSString stringWithFormat:@"%ld", [dictDailyMatrics[@"CompletedTaskCount"] longValue]]];
        [_lblScheduledTaskCount setText:[NSString stringWithFormat:@"%ld", [dictDailyMatrics[@"ScheduledTaskCount"] longValue]]];
        _lblPercentage.text = [NSString stringWithFormat:@"%0.1f%%", ([dictDailyMatrics[@"CompletedTaskCount"] floatValue] / [dictDailyMatrics[@"ScheduledTaskCount"] floatValue]) * 100];
        [_tblTaskList reloadData];
        [self createCompletedList];
    } failure:^(NSError *error, NSDictionary *response) {
        [_lblNoRecords setHidden:NO];
    }];
}

- (void)createCompletedList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userId MATCHES[cd] %@) AND isCompleted = 0",[User currentUser].userId];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AccidentReportSubmit"];
    [request setPredicate:predicate];
    intPendingAccidentReport = [gblAppDelegate.managedObjectContext countForFetchRequest:request error:nil];

    request = [[NSFetchRequest alloc] initWithEntityName:@"Report"];
    [request setPredicate:predicate];
    intPendingIncidentReport = [gblAppDelegate.managedObjectContext countForFetchRequest:request error:nil];
    
    
    
    mutArrCompletedCount = [[NSMutableArray alloc] init];
    [mutArrCompletedCount addObject:@{@"name":@"Incident Report", @"count":[dictDailyMatrics[@"CompletedIncidentReportCount"] stringValue],@"openCount":[NSString stringWithFormat:@"%i",intPendingIncidentReport]}];
    
    [mutArrCompletedCount addObject:@{@"name":@"User Forms", @"count":[dictDailyMatrics[@"CompletedUserFormCount"] stringValue],@"openCount":@"0"}];
    [mutArrCompletedCount addObject:@{@"name":@"User Survey", @"count":[dictDailyMatrics[@"CompletedUserSurveyCount"] stringValue],@"openCount":@"0"}];
    [mutArrCompletedCount addObject:@{@"name":@"Accident Report", @"count":[dictDailyMatrics[@"CompletedAccidentReportCount"] stringValue],@"openCount":[NSString stringWithFormat:@"%i",intPendingAccidentReport]}];
    
    [mutArrCompletedCount addObject:@{@"name":@"Guest Forms", @"count":[dictDailyMatrics[@"CompletedGuestFormCount"] stringValue],@"openCount":@"0"}];
    [mutArrCompletedCount addObject:@{@"name":@"Guest Survey", @"count":[dictDailyMatrics[@"CompletedGuestSurveyCount"] stringValue],@"openCount":@"0"}];
    
    [_colCompleteCount reloadData];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_tblLoginUserInfo])
    {
        if ([aryLocations count] > [aryPostions count])
        {
            return [aryLocations count];
        }
        else
        {
            return [aryPostions count];
        }
    }
    return [aryMissedTask count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *aCell;
    //------Chetan Kasundra--------
    //------Add the new Section for login user info
    if ([tableView isEqual:_tblLoginUserInfo])
    {
        aCell = [tableView dequeueReusableCellWithIdentifier:@"cellUserInfo"];
        
        UILabel *lblFacility = (UILabel *)[aCell.contentView viewWithTag:1];

        if (indexPath.row == 0)
        {
            lblFacility.text = [User currentUser].selectedFacility.name;
        }
        else
        {
            lblFacility.text = @"";
        }
        
        UILabel *lblLocatin = (UILabel *)[aCell.contentView viewWithTag:2];
        
        if (aryLocations.count > indexPath.row)
        {
            UserLocation *aLocation = [aryLocations objectAtIndex:indexPath.row];
            lblLocatin.text = aLocation.name;
        }
        else
        {
            lblLocatin.text = @"";
        }
        
        UILabel *lblPostion = (UILabel *)[aCell.contentView viewWithTag:3];
        
        if (aryPostions.count > indexPath.row)
        {
            UserPosition *aPostion = [aryPostions objectAtIndex:indexPath.row];
            lblPostion.text = aPostion.name;
        }
        else
        {
            lblPostion.text = @"";
        }
        aCell.backgroundColor = [UIColor clearColor];
      
    }
    //-------------------------------//
    else
    {

        aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (indexPath.row % 2 == 0) {
            [aCell setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0]];
        }
        else {
            [aCell setBackgroundColor:[UIColor colorWithRed:214.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
        }
        UILabel *aLblTime = (UILabel *)[aCell.contentView viewWithTag:2];
        UILabel *aLblTitle = (UILabel *)[aCell.contentView viewWithTag:3];
        UILabel *aLblRecurrance = (UILabel *)[aCell.contentView viewWithTag:4];
        UILabel *aLblLastComplete = (UILabel *)[aCell.contentView viewWithTag:6];
        UILabel *aLblPastDue = (UILabel *)[aCell.contentView viewWithTag:5];
        NSDictionary *aDict = [aryMissedTask objectAtIndex:indexPath.row];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm a"];
       // [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        NSDate *dt = [formatter dateFromString:aDict[@"Time"]];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        [aLblTime setText:[formatter stringFromDate:dt]];
        [aLblTitle setText:aDict[@"Name"]];
        [aLblRecurrance setText:[NSString stringWithFormat:@"Reoccurrence: %@", aDict[@"Recurrence"]]];
        if (![aDict[@"LastCompletedOn"] isKindOfClass:[NSNull class]]) {
            
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            //[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            NSDate *aDate = [formatter dateFromString:[[aDict[@"LastCompletedOn"] componentsSeparatedByString:@"."] firstObject]];
            [formatter setTimeZone:[NSTimeZone systemTimeZone]];
            [formatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
            aLblLastComplete.text = [formatter stringFromDate:aDate];
        }
        else {
            aLblLastComplete.text = @"";
        }
        
        [aLblPastDue setHidden:![aDict[@"PastDue"] boolValue]];
        
        
    //    UILabel *aLblTime = (UILabel *)[aCell.contentView viewWithTag:2];
        
    }
    return aCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:_tblLoginUserInfo])
    {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 22)];
    [view setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:1.0 blue:1.0 alpha:1.0]];
    UILabel *aLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, view.frame.size.width - 20, 22)];
    [aLbl setBackgroundColor:[UIColor clearColor]];
    [aLbl setText:@"Missed Tasks"];
    [aLbl setFont:[UIFont systemFontOfSize:16.0]];
    [aLbl setTextColor:[UIColor blackColor]];
    [view addSubview:aLbl];
    return view;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [mutArrCompletedCount count];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *aCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIView *bgView = [aCell.contentView viewWithTag:2];
    if (indexPath.row % 2 == 0) {
        [bgView setBackgroundColor:[UIColor colorWithRed:214.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
    }
    else {
        [bgView setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0]];
    }
    
    UIImageView *imgOpen=(UIImageView *)[aCell.contentView viewWithTag:5];
    if ([mutArrCompletedCount[indexPath.row][@"openCount"] integerValue] >=1 )
    {
        imgOpen.image=[UIImage imageNamed:@"radio_btn_checked.png"];
    }
    else
    {
        imgOpen.image=[UIImage imageNamed:@"radio_btn_unchecked.png"];
    }

    UILabel *aLblTitle = (UILabel*)[aCell.contentView viewWithTag:3];
    aLblTitle.text = mutArrCompletedCount[indexPath.item][@"name"];
    
    UILabel *aLblCount = (UILabel*)[aCell.contentView viewWithTag:4];
    aLblCount.text = mutArrCompletedCount[indexPath.item][@"count"];
    return aCell;
}

@end
