//
//  EndOfDayViewController.m
//  GoBoardPro
//
//  Created by ind558 on 11/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "EndOfDayViewController.h"
#import "DailyLog.h"
#import "TeamLog.h"
#import "EODTableViewCell.h"

@interface EndOfDayViewController ()
{
    NSMutableArray *imageArray;
    NSString * strAlert;
    UIView *viewActivity;
    UIActivityIndicatorView *indicatorView;
}
@property (nonatomic, assign) BOOL shouldHideActivityIndicator;

@end

@implementation EndOfDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    imageArray=[[NSMutableArray alloc]init];
    mutArrDailyList=[NSMutableArray new];
    [_lblNoRecords setHidden:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
        [gblAppDelegate showActivityIndicator];
        [[WebSerivceCall webServiceObject] callServiceForTeamLog:YES complition:^{
            [self fetchDailyLog];
            [self.tblDailyLog reloadData];
            [gblAppDelegate hideActivityIndicator];

        }];
}

- (void)showActivityIndicator {
    if (_shouldHideActivityIndicator) {
        [self showActivityIndicatorWithMessage:nil];
    }
}

- (void)showActivityIndicatorWithMessage:(NSString*)strMessage {
    [self showActivityIndicatorWithMessage:strMessage atPosition:ActivityIndicatorPositionCenter];
}


- (void)showActivityIndicatorWithMessage:(NSString*)strMessage atPosition:(ActivityIndicatorPosition)pos {
    if (!viewActivity) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        viewActivity = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [viewActivity setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]];
        indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicatorView startAnimating];
        if (strMessage && strMessage.length > 0) {
            NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"HelveticaNeue-Light" size:11] forKey: NSFontAttributeName];
            
            // iOS 7 method to mesure height of string instead if sizeWithFont: as it is deprecated
            float height = [strMessage boundingRectWithSize:CGSizeMake(viewActivity.frame.size.width - 6, 30) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin  attributes:stringAttributes context:nil].size.height;
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, viewActivity.frame.size.width - 6, height)];
            lbl.numberOfLines = 0;
            [lbl setBackgroundColor:[UIColor clearColor]];
            [lbl setTextColor:[UIColor whiteColor]];
            [lbl setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11]];
            [lbl setTextAlignment:NSTextAlignmentCenter];
            [lbl setText:strMessage];
            float a = ((viewActivity.frame.size.height - indicatorView.frame.size.height - height - 5) / 2) + (indicatorView.frame.size.height / 2);
            indicatorView.center = CGPointMake(viewActivity.center.x, a);
            lbl.center = CGPointMake(viewActivity.center.x, viewActivity.frame.size.height - indicatorView.frame.origin.y - (height/2));
            [viewActivity addSubview:lbl];
        }
        else {
            indicatorView.center = viewActivity.center;
        }
        
        [viewActivity addSubview:indicatorView];
        [viewActivity.layer setCornerRadius:6.0];
        if (pos == ActivityIndicatorPositionCenter) {
            viewActivity.center = self.view.center;
        }
        else if (pos == ActivityIndicatorPositionBottom) {
            viewActivity.center = CGPointMake(self.view.center.x, self.view.bounds.size.height - (viewActivity.bounds.size.height / 2) - 55);
        }
        else if (pos == ActivityIndicatorPositionTop) {
            viewActivity.center = CGPointMake(self.view.center.x, (viewActivity.bounds.size.height / 2) + 80);
        }
        
        [self.view addSubview:viewActivity];
    }
}

- (void)hideActivityIndicator {
    if (_shouldHideActivityIndicator) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if (viewActivity) {
            [indicatorView stopAnimating];
            [viewActivity removeFromSuperview];
            indicatorView = nil;
            viewActivity = nil;
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dismissKeyboard
{
    [_txtDescription resignFirstResponder];
}


- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSubmitTapped:(id)sender {
    __block BOOL isWSComplete = NO;
    __block BOOL waitUntilDone =YES;
    NSMutableString *strDailyLogIds = [NSMutableString new];
    NSMutableString *strDailyLogHeaderIds = [NSMutableString new];
    if ([mutArrDailyList count] == 0) {
        return;
    }
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"IncludeInEndOfDayReport == %@",@"true"];
    NSArray *aArrFiltered = [mutArrDailyList filteredArrayUsingPredicate:aPredicate];
    if (aArrFiltered.count>0)
    {    [gblAppDelegate showActivityIndicator];
        
        for (int atIndex=0;atIndex<aArrFiltered.count;atIndex++) {
            
            TeamLog *aLog = [aArrFiltered objectAtIndex:atIndex];
            
            [strDailyLogIds appendString:[NSString stringWithFormat:@"%@,",aLog.headerId]];
            [strDailyLogHeaderIds appendString:[NSString stringWithFormat:@"%@,",aLog.teamLogId]];
            aLog.includeInEndOfDayReport = @"false";
            [gblAppDelegate.managedObjectContext save:nil];
            if ([aLog.shouldSync isEqualToNumber:@1]) {
//             aLog.includeInEndOfDayReport = @"false";
//                [gblAppDelegate.managedObjectContext save:nil];

                [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"isSync"];
            }
        }
//        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isSync"] isEqualToString:@"YES"]) {
//            
//        }
//        else{
            [strDailyLogIds deleteCharactersInRange:NSMakeRange([strDailyLogIds length]-1, 1)];
            [strDailyLogHeaderIds deleteCharactersInRange:NSMakeRange([strDailyLogHeaderIds length]-1, 1)];
    //    }
        NSString *aStrURL = [NSString stringWithFormat:@"%@/%@?dailyLogIds=%@&dailyLogHeaderIds=%@",DAILY_LOG_TEAM,EOD_SUBMIT,[NSString stringWithFormat:@"%@",strDailyLogIds],[NSString stringWithFormat:@"%@",strDailyLogHeaderIds]];
        [gblAppDelegate callAsynchronousWebService:aStrURL parameters:nil httpMethod:@"GET" complition:^(NSDictionary *response) {
            for (DailyLog *aLog in aArrFiltered) {
                if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isSync"] isEqualToString:@"YES"]) {
                    
                }else{
                    [gblAppDelegate.managedObjectContext deleteObject:aLog];
                }
            }
            [gblAppDelegate.managedObjectContext save:nil];
            isWSComplete = YES;
            waitUntilDone = NO;
            [gblAppDelegate hideActivityIndicator];
            
        } failure:^(NSError* error, NSDictionary  *response) {
            [gblAppDelegate hideActivityIndicator];
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isSync"] isEqualToString:@"YES"]) {
                [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"isSync"];

                alert(@"", @"Before submitting Log to EOD report please sync the Log from Home Screen once you have an internet connection.");
         
            }
            else{
                alert(@"", MSG_NO_INTERNET);
            }
            
            isWSComplete = YES;
        }];
        if (waitUntilDone) {
            while (!isWSComplete) {
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
            }
            if (!waitUntilDone) {
                [[[UIAlertView alloc] initWithTitle:gblAppDelegate.appName message:@"Daily log has been submitted successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            }
        }
    }
    else
    {
        [gblAppDelegate hideActivityIndicator];
        alert(@"", @"Please add a log entry to submit a report.");
    }}
-(void)reloadData{
    
    [gblAppDelegate showActivityIndicator];
    [[WebSerivceCall webServiceObject] callServiceForTeamLog:YES complition:^{
        [self fetchDailyLog];
        [self.tblDailyLog reloadData];

       alert(gblAppDelegate.appName, strAlert);
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
    aLog.date = [NSDate date];
    aLog.includeInEndOfDayReport = @"false";
    aLog.isTeamLog = @"0";
    aLog.shouldSync = [NSNumber numberWithBool:NO];
   //[gblAppDelegate.managedObjectContext insertObject:aLog];
   //[gblAppDelegate.managedObjectContext save:nil];

    [mutArrDailyList addObject:aLog];
    
    NSSortDescriptor *aSortDesc = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:YES];
    [mutArrDailyList sortUsingDescriptors:@[aSortDesc]];
    
     [self postDataOnServer:YES mutArray:mutArrDailyList];
    [self reloadData];

    imageArray=[NSMutableArray new];
    for (int i=0; i<mutArrDailyList.count; i++) {
        [imageArray insertObject:@"NO" atIndex:i];
    }

    
    
    [_tblDailyLog reloadData];
    NSIndexPath *aIndexPath=[NSIndexPath indexPathForRow:(mutArrDailyList.count - 1) inSection:0];
    [_tblDailyLog scrollToRowAtIndexPath:aIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    
    _txtDescription.text = @"";
    
    [_lblNoRecords setHidden:YES];
    
}

-(void)postDataOnServer:(BOOL)waitUntilDone mutArray:(NSMutableArray*)mutArray{
    __block BOOL isWSComplete = NO;

    if ([mutArray count] == 0) {
        return;
    }
    NSMutableArray *mutAryLogs = [NSMutableArray array];
    
            NSDateFormatter *aFormatter1 = [[NSDateFormatter alloc] init];
            [aFormatter1 setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
            NSString *aStrName = [[User currentUser]username];
            
            [mutAryLogs addObject:@{@"Date":[gblAppDelegate getUTCDate:[NSDate date]],@"UserId":[[User currentUser] userId],  @"Description":_txtDescription.text, @"IncludeInEndOfDayReport": @"false",@"UserName":aStrName,@"Id":@"0"}];
    
        
        NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
        [aFormatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
       
        NSDictionary *aDict = @{@"UserId":[[User currentUser] userId],
                                @"Date":[gblAppDelegate getUTCDate:[NSDate date]],
                                @"DailyLogDetails":mutAryLogs,
                                @"Id":@"0",
                                @"FacilityId":[[User currentUser]selectedFacility].value,
                                @"PositionId":@"0",
                                @"IsTeamLog":[NSNumber numberWithBool:NO],
                                @"IsAlwaysVisible":[NSNumber numberWithBool:NO]};
        
        [gblAppDelegate callWebService:DAILY_LOG parameters:aDict httpMethod:[SERVICE_HTTP_METHOD objectForKey:DAILY_LOG] complition:^(NSDictionary *response) {
            
//            [[[UIAlertView alloc] initWithTitle:gblAppDelegate.appName message:@"Daily log has been submitted successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            strAlert =@"Daily log has been submitted successfully.";
                isWSComplete = YES;
            
        } failure:^(NSError *error, NSDictionary *response) {
            alert(@"", MSG_NO_INTERNET);
            isWSComplete = YES;
//            aObj.shouldSync = [NSNumber numberWithBool:YES];
//            [gblAppDelegate.managedObjectContext save:nil];
        }];
    if (waitUntilDone) {
        while (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
}

- (void)btnCheckMark:(UIButton*)sender {
    
//    UITableViewCell *aCell = (UITableViewCell *)[[sender superview] superview];
//    while (![aCell isKindOfClass:[UITableViewCell class]]) {
//        aCell = (UITableViewCell *)aCell.superview;
//    }
//
//    NSIndexPath *indexPath = [_tblDailyLog indexPathForCell:aCell];
    DailyLog *log = [mutArrDailyList objectAtIndex:sender.tag];
//    [sender setSelected:!sender.isSelected];
//    if (sender.isSelected) {
//        log.includeInEndOfDayReport = @"true";
//    }
//    else {
//        log.includeInEndOfDayReport = @"false";
//    }
  //  check_box_sel@2x.png
//check_box_desel@2x.png
        if ([[imageArray objectAtIndex:sender.tag] isEqualToString:@"NO"]) {
              log.includeInEndOfDayReport = @"true";
            [imageArray replaceObjectAtIndex:sender.tag withObject:@"YES"];
        }
        else{
            log.includeInEndOfDayReport = @"false";
            [imageArray replaceObjectAtIndex:sender.tag withObject:@"NO"];
        }
    
    
    
    [gblAppDelegate.managedObjectContext save:nil];
    
    [_tblDailyLog reloadData];
    
    
    
}

#pragma mark - Methods

- (void)fetchDailyLog {

    //NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"IncludeInEndOfDayReport == %@",@"false"];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"TeamLog"];

   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(isTeamLog==%@ AND userId MATCHES[cd] %@ AND includeInEndOfDayReport==%@)",@0, [[User currentUser] userId],@"false"];
//       NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(isTeamLog==%@ AND includeInEndOfDayReport==%@)", @0,@"false"];
    [request setPredicate:predicate];
    mutArrDailyList = [NSMutableArray arrayWithArray:[gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil]];
    if ([mutArrDailyList count] == 0) {
        [_lblNoRecords setHidden:NO];
    }
    else
        [_lblNoRecords setHidden:YES];
    NSSortDescriptor *aSortDesc = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:YES];
    [mutArrDailyList sortUsingDescriptors:@[aSortDesc]];

    imageArray=[NSMutableArray new];
    for (int i=0; i<mutArrDailyList.count; i++) {
        [imageArray insertObject:@"NO" atIndex:i];
      //  [imageArray addObject:@"check_box_desel@2x.png"];
    }
    [gblAppDelegate hideActivityIndicator];

}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mutArrDailyList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  EODTableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  
    if (!aCell) {
        aCell=[[EODTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    [aCell setBackgroundColor:[UIColor clearColor]];
//    UILabel *aLblTime = (UILabel*)[aCell.contentView viewWithTag:3];
//    UILabel *aLblLog = (UILabel*)[aCell.contentView viewWithTag:4];

  
            DailyLog *log = [mutArrDailyList objectAtIndex:indexPath.row];

            NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
            [aFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
            
            NSArray *aryDateComp = [[aFormatter stringFromDate:log.date] componentsSeparatedByString:@" "];
            
            [aCell.timeLabel setText:[NSString stringWithFormat:@"%@ %@", aryDateComp[1], aryDateComp[2]]];
            [aCell.detailLabel setText:log.desc];
            
            //----Changes By Chetan Kasundra-------------
            //-----Before prb in cell height,Content Overlap each other
            
            NSDictionary *aDicAttribute=@{NSFontAttributeName :[UIFont boldSystemFontOfSize:17]};
            CGFloat aHeight = [log.desc boundingRectWithSize:CGSizeMake(588, 9999) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:aDicAttribute context:kNilOptions].size.height;
            
            CGRect frame = aCell.detailLabel.frame;
            if (aHeight < 21) {
                frame.size.height = 21;
                aCell.detailLabel.frame = frame;
            }
            else
            {
                frame.size.height=aHeight;
                aCell.detailLabel.frame=frame;
            }
            
           // UIView *bgView = [aCell.contentView viewWithTag:2];
            frame = aCell.bgView.frame;
            frame.size.height = aHeight + 40;
            aCell.bgView.frame = frame;
         //   UIButton *aBtn = (UIButton *)[aCell.contentView viewWithTag:220];
            [aCell.checkMarkButton addTarget:self action:@selector(btnCheckMark:) forControlEvents:UIControlEventTouchUpInside];
          aCell.checkMarkButton.tag=indexPath.row;
    
    if ([[imageArray objectAtIndex:indexPath.row] isEqualToString:@"NO"]) {
        [aCell.checkMarkButton setImage:[UIImage imageNamed:@"check_box_desel@2x.png"] forState:UIControlStateNormal];
    }
    else{
        [aCell.checkMarkButton setImage:[UIImage imageNamed:@"check_box_sel@2x.png"] forState:UIControlStateNormal];
    }
    
    
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
