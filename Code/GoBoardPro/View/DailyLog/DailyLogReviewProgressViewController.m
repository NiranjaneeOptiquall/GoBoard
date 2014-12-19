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

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?positionId=%@&locationId=%@", DAILY_MATRICS, strPositionIds, strLocationIds] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:DAILY_MATRICS] complition:^(NSDictionary *response) {
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

- (void)createCompletedList {
    mutArrCompletedCount = [[NSMutableArray alloc] init];
    [mutArrCompletedCount addObject:@{@"name":@"Incident Report", @"count":[dictDailyMatrics[@"CompletedIncidentReportCount"] stringValue]}];
    [mutArrCompletedCount addObject:@{@"name":@"User Forms", @"count":[dictDailyMatrics[@"CompletedUserFormCount"] stringValue]}];
    [mutArrCompletedCount addObject:@{@"name":@"User Survey", @"count":[dictDailyMatrics[@"CompletedUserSurveyCount"] stringValue]}];
    [mutArrCompletedCount addObject:@{@"name":@"Accident Report", @"count":[dictDailyMatrics[@"CompletedAccidentReportCount"] stringValue]}];
    [mutArrCompletedCount addObject:@{@"name":@"Guest Forms", @"count":[dictDailyMatrics[@"CompletedGuestFormCount"] stringValue]}];
    [mutArrCompletedCount addObject:@{@"name":@"Guest Survey", @"count":[dictDailyMatrics[@"CompletedGuestSurveyCount"] stringValue]}];
    [_colCompleteCount reloadData];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [aryMissedTask count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
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
    [aLblTime setText:aDict[@"Time"]];
    [aLblTitle setText:aDict[@"Name"]];
    [aLblRecurrance setText:[NSString stringWithFormat:@"Reoccurrence: %@", aDict[@"Recurrence"]]];
    if (![aDict[@"LastCompletedOn"] isKindOfClass:[NSNull class]]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *aDate = [formatter dateFromString:[[aDict[@"LastCompletedOn"] componentsSeparatedByString:@"."] firstObject]];
        [formatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
        aLblLastComplete.text = [formatter stringFromDate:aDate];
    }
    else {
        aLblLastComplete.text = @"";
    }
    
    [aLblPastDue setHidden:![aDict[@"PastDue"] boolValue]];
    
    
//    UILabel *aLblTime = (UILabel *)[aCell.contentView viewWithTag:2];
    return aCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
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
    UILabel *aLblTitle = (UILabel*)[aCell.contentView viewWithTag:3];
    aLblTitle.text = mutArrCompletedCount[indexPath.item][@"name"];
    
    UILabel *aLblCount = (UILabel*)[aCell.contentView viewWithTag:4];
    aLblCount.text = mutArrCompletedCount[indexPath.item][@"count"];
    return aCell;
}

@end
