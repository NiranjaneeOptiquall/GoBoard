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
#import "UtilizationHeaderView.h"
#import "UtilizationCount.h"
#import "SubmitCountUser.h"
#import "SubmitUtilizationCount.h"

#ifdef __IPHONE_8_0
#define GregorianCalendar NSCalendarIdentifierGregorian
#else
#define GregorianCalendar NSGregorianCalendar
#endif

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
    [self submitData:YES];
}


- (IBAction)btnSubmitCountTapped:(id)sender {
    [self submitData:NO];
}

- (NSDictionary *)getPostLocation:(UtilizationCount*)location {
    if (!location.message) {
        location.message = @"";
    }
    NSMutableDictionary *aDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:location.message, @"Message", location.lastCount, @"LastCount", location.lastCountDateTime, @"LastCountDateTime", location.capacity, @"Capacity", location.name, @"Name", location.locationId, @"Id", nil];
    NSMutableArray *subLocations = [NSMutableArray array];
    for (UtilizationCount *subLocation in [location.sublocations array]) {
        if (subLocation.isUpdateAvailable) {
            [subLocations addObject:@{@"Id": subLocation.locationId, @"Name": subLocation.name, @"LastCount" : subLocation.lastCount, @"LastCountDateTime":subLocation.lastCountDateTime}];
        }
    }
    if ([subLocations count] > 0) {
        [aDict setObject:subLocations forKey:@"Sublocations"];
    }
    return aDict;
}

- (void)submitData:(BOOL)showTask {
    NSMutableArray *mutArrUpdatedCount = [NSMutableArray array];
    for (UtilizationCount *location in mutArrCount) {
        if (location.isUpdateAvailable) {
            [mutArrUpdatedCount addObject:[self getPostLocation:location]];
        }
    }
    if ([mutArrUpdatedCount count] > 0) {
        NSDictionary *aDict = @{ @"UserId":[[User currentUser]userId], @"Locations":mutArrUpdatedCount};
        [gblAppDelegate callWebService:UTILIZATION_COUNT parameters:aDict httpMethod:@"POST" complition:^(NSDictionary *response) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:@"Count has been updated successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            if (showTask) {
                [alert setTag:1];
            }
            [alert show];
        } failure:^(NSError *error, NSDictionary *response) {
            [self saveSubmitToLocal:aDict showTask:showTask];
        }];
    }
    else if (showTask) {
        [self showTask];
    }
    else {
        alert(@"", @"Count is already updated.");
    }
}

- (void)saveSubmitToLocal:(NSDictionary *)aDict showTask:(BOOL)showTask {
    SubmitCountUser *user = [NSEntityDescription insertNewObjectForEntityForName:@"SubmitCountUser" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    user.userId = [aDict objectForKey:@"UserId"];
    NSMutableSet *locSet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"Locations"]) {
        
        SubmitUtilizationCount *location = [NSEntityDescription insertNewObjectForEntityForName:@"SubmitUtilizationCount" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        
//        UtilizationCount *location = [NSEntityDescription insertNewObjectForEntityForName:@"UtilizationCount" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        location.name = [dict objectForKey:@"Name"];
        location.lastCount = [dict objectForKey:@"LastCount"];
        location.lastCountDateTime = [dict objectForKey:@"LastCountDateTime"];
        location.capacity = [dict objectForKey:@"Capacity"];
        location.message = [dict objectForKey:@"Message"];
        location.locationId = [dict objectForKey:@"Id"];
        NSMutableSet *set = [NSMutableSet set];
        for (NSDictionary *subLoc in [dict objectForKey:@"Sublocations"]) {
            SubmitUtilizationCount *subLocation = [NSEntityDescription insertNewObjectForEntityForName:@"SubmitUtilizationCount" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            subLocation.name = [subLoc objectForKey:@"Name"];
            subLocation.lastCount = [subLoc objectForKey:@"LastCount"];
            subLocation.lastCountDateTime = [subLoc objectForKey:@"LastCountDateTime"];
            subLocation.locationId = [subLoc objectForKey:@"Id"];
            subLocation.location = location;
            [set addObject:subLocation];
        }
        location.sublocations = set;
        [locSet addObject:location];
    }
    user.countLocation = locSet;
    [gblAppDelegate.managedObjectContext insertObject:user];
    if ([gblAppDelegate.managedObjectContext save:nil]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:MSG_ADDED_TO_SYNC delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        if (showTask) {
            [alert setTag:1];
        }
        [alert show];
    }
}

- (void)showTask {
    [self.navigationController popViewControllerAnimated:NO];
    [[[gblAppDelegate.navigationController viewControllers] lastObject] performSegueWithIdentifier:@"Tasks" sender:nil];
}

- (IBAction)btnCountCommentTapped:(UIButton *)sender {
}

- (IBAction)btnBackTapped:(id)sender {
    [self.view endEditing:YES];
    if (isUpdate) {
        [[[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:@"Do you want to save your information? If you press “Back” you will lose all entered information, do you want to proceed?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil] show];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)btnToggleSummaryTapped:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    [_tblCountList reloadData];
}

- (void)btnIncreaseCountTapped:(UIButton*)btn {
    isUpdate = YES;
    id view = [btn superview];
    while (![view isKindOfClass:[UtilizationCountTableViewCell class]] && ![view isKindOfClass:[UtilizationHeaderView class]]) {
        view = [view superview];
    }
    UtilizationCount *location;
    NSInteger section;
    if ([view isKindOfClass:[UtilizationHeaderView class]]) {
        section = [(UtilizationHeaderView*)view section];
        location = [mutArrCount objectAtIndex:section];
    }
    else {
        NSIndexPath *indexPath = [_tblCountList indexPathForCell:view];
        section = indexPath.section;
        location = [[[[mutArrCount objectAtIndex:indexPath.section] sublocations] array] objectAtIndex:indexPath.row];
    }
    NSInteger current = [location.lastCount integerValue];
    NSInteger max = [location.capacity integerValue];
    current++;
    if (current > max && !location.location) {
        NSString *strMsg = [NSString stringWithFormat:@"Maximum capacity for %@ is %@, %@ is over capacity now.", location.name, location.capacity, location.name];
        alert(@"Exceed Limit", strMsg);
    }
    location.lastCount = [NSString stringWithFormat:@"%ld", (long)current];
    if (location.location) {
        NSInteger totalCount = 0;
        for (UtilizationCount *loc in location.location.sublocations.array) {
            totalCount += [loc.lastCount integerValue];
        }
        location.location.lastCount = [NSString stringWithFormat:@"%ld", (long)totalCount];
        if ([location.location.lastCount intValue] > [location.location.capacity intValue]) {
            NSString *strMsg = [NSString stringWithFormat:@"Maximum capacity for %@ is %@, %@ is over capacity now.", location.location.name, location.location.capacity, location.location.name];
            alert(@"Exceed Limit", strMsg);
        }
        location.location.isUpdateAvailable = YES;
        location.location.lastCountDateTime = [self getCurrentDate];
    }
    else if (location.sublocations.count > 0) {
        for (UtilizationCount *subLoc in location.sublocations.array) {
            subLoc.lastCount = @"0";
            subLoc.isUpdateAvailable = YES;
        }
    }
    location.lastCountDateTime = [self getCurrentDate];
    location.isUpdateAvailable = YES;
    [_tblCountList reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
//    [_tblCountList reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self showTotalCount];
}

- (void)btnDecreaseCountTapped:(UIButton*)btn {
    isUpdate = YES;
    id view = [btn superview];
    while (![view isKindOfClass:[UtilizationCountTableViewCell class]] && ![view isKindOfClass:[UtilizationHeaderView class]]) {
        view = [view superview];
    }
    UtilizationCount *location;
    NSInteger section;
    if ([view isKindOfClass:[UtilizationHeaderView class]]) {
        section = [(UtilizationHeaderView*)view section];
        location = [mutArrCount objectAtIndex:section];
    }
    else {
        NSIndexPath *indexPath = [_tblCountList indexPathForCell:view];
        section = indexPath.section;
        location = [[[[mutArrCount objectAtIndex:indexPath.section] sublocations] array] objectAtIndex:indexPath.row];
    }
    NSInteger current = [location.lastCount integerValue];
    current--;
    if (current >= 0) {
        location.lastCount = [NSString stringWithFormat:@"%ld", (long)current];
        if (location.location) {
            NSInteger totalCount = 0;
            for (UtilizationCount *loc in location.location.sublocations.array) {
                totalCount += [loc.lastCount integerValue];
            }
            location.location.lastCount = [NSString stringWithFormat:@"%ld", (long)totalCount];
            location.location.isUpdateAvailable = YES;
            location.location.lastCountDateTime = [self getCurrentDate];
        }
        else if (location.sublocations.count > 0) {
            for (UtilizationCount *subLoc in location.sublocations.array) {
                subLoc.lastCount = @"0";
                subLoc.isUpdateAvailable = YES;
            }
        }
        location.isUpdateAvailable = YES;
        location.lastCountDateTime = [self getCurrentDate];
        [_tblCountList reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [self showTotalCount];
}


- (void)btnMessageTapped:(UIButton*)sender {
    id view = [sender superview];
    while (![view isKindOfClass:[UtilizationCountTableViewCell class]] && ![view isKindOfClass:[UtilizationHeaderView class]]) {
        view = [view superview];
    }
    UtilizationCount *location;
    if ([view isKindOfClass:[UtilizationHeaderView class]]) {
        editingIndex =[(UtilizationHeaderView*)view section];
        editIndexPath = nil;
        location = [mutArrCount objectAtIndex:[(UtilizationHeaderView*)view section]];
    }
    else {
        NSIndexPath *indexPath = [_tblCountList indexPathForCell:view];
        editIndexPath = indexPath;
        location = [[[[mutArrCount objectAtIndex:indexPath.section] sublocations] array] objectAtIndex:indexPath.row];
    }
    
    _lblPopOverLocation.text = location.name;
    
    _txtPopOverMessage.text = location.message;
    
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"hh:mm a"];
    [_lblPopOverTime setText:[aFormatter stringFromDate:[NSDate date]]];

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
    CGRect frame = [sender.superview convertRect:sender.frame toView:_tblCountList];
    frame = [_tblCountList convertRect:frame toView:self.view];
    [popOverMessage presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)btnCountRemainSameTapped:(UIButton*)sender {
    id view = [sender superview];
    while (![view isKindOfClass:[UtilizationCountTableViewCell class]] && ![view isKindOfClass:[UtilizationHeaderView class]]) {
        view = [view superview];
    }
    UtilizationCount *location;
    NSInteger section = 0;
    if ([view isKindOfClass:[UtilizationHeaderView class]]) {
        section = [(UtilizationHeaderView*)view section];
        location = [mutArrCount objectAtIndex:[(UtilizationHeaderView*)view section]];
    }
    else {
        NSIndexPath *indexPath = [_tblCountList indexPathForCell:view];
        section = indexPath.section;
        location = [[[[mutArrCount objectAtIndex:indexPath.section] sublocations] array] objectAtIndex:indexPath.row];
    }
    location.isCountRemainSame = !location.isCountRemainSame;
    location.isUpdateAvailable = YES;
    if (location.location) {
        location.location.isUpdateAvailable = YES;
        location.location.lastCountDateTime = [self getCurrentDate];
    }
    location.lastCountDateTime = [self getCurrentDate];
    [_tblCountList reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    isUpdate = YES;
}

#pragma mark - Methods

- (void)showTotalCount {
    NSInteger count = 0;
    for (UtilizationCount *location in mutArrCount) {
        count += [location.lastCount integerValue];
    }
    [_lblTotalCount setText:[NSString stringWithFormat:@"%ld", (long)count]];
}

- (void)getAllCounts {
    [[WebSerivceCall webServiceObject] callServiceForUtilizationCount:NO complition:^{
        [self fetchOfflineCountData];
        [_tblCountList reloadData];
    }];
    
}

- (void)updateCountForToday {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UtilizationCount"];
    NSError *error = nil;
    NSArray *aryCounts = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:&error];
    
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [aFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                    fromDate:[NSDate date]];
    NSDate *currentDate = [[NSCalendar currentCalendar]
                           dateFromComponents:components];
    for (UtilizationCount *location in aryCounts) {
        NSDate *lastCountDate = [aFormatter dateFromString:location.lastCountDateTime];
        
        if (!lastCountDate || [lastCountDate compare:currentDate] == NSOrderedAscending) {
            location.lastCount = @"0";
            location.lastCountDateTime = [aFormatter stringFromDate:currentDate];
        }
    }
    [gblAppDelegate.managedObjectContext save:nil];
}

- (void)fetchOfflineCountData {
    [self updateCountForToday];
    mutArrCount = [[NSMutableArray alloc] init];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UtilizationCount"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"location = nil"];
    [request setPredicate:predicate];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *sortBySequence = [[NSSortDescriptor alloc] initWithKey:@"sequence" ascending:YES];
    [request setSortDescriptors:@[sortBySequence, sortByName]];
    NSError *error = nil;
    NSArray *aryCategories = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        [mutArrCount addObjectsFromArray:aryCategories];
    }
    NSMutableArray *aMutArrTemp = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < mutArrCount.count; i++) {
        UtilizationCount *location = [mutArrCount objectAtIndex:i];
        
        NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"Name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
        NSMutableArray *aArrTemp = [[[location.sublocations array] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]] mutableCopy];
        location.sublocations=nil;
        NSOrderedSet *aSet = [NSOrderedSet orderedSetWithArray:aArrTemp];
        
        [location setSublocations:aSet];
        if ([[location.sublocations array] count] > 0) {
            NSLog(@"%@",location.sublocations);
        }
        [aMutArrTemp addObject:location];
    }
    [mutArrCount removeAllObjects];
    
    [mutArrCount addObjectsFromArray:aMutArrTemp];
    
    aMutArrTemp = nil;
    
    NSLog(@"THIS IS SHORTED ARRAY : %@",mutArrCount);
    
    if ([mutArrCount count] == 0) {
        [_lblNoRecords setHidden:NO];
    }
    else {
        for (UtilizationCount *location in mutArrCount) {
            [location setInitialValues];
        }
    }
    
    [self showTotalCount];
}

- (NSString *)getCurrentDate {
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [aFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSString *aStr = [aFormatter stringFromDate:[NSDate date]];
    return aStr;
}

- (NSString *)getLastUpdate:(NSString*)lastDate {
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [aFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *lastDt = [aFormatter dateFromString:lastDate];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:GregorianCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitMinute fromDate:lastDt toDate:[NSDate date] options:0];
    NSString *aStrTime = [NSString stringWithFormat:@"Last Count:%ld mins.", (long)components.minute];
    return aStrTime;
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [mutArrCount count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if (_btnToggleSummary.isSelected) {
        rows = [[[mutArrCount objectAtIndex:section] sublocations] count];
    }
    return rows;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UtilizationCountTableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.section == 0 || indexPath.section % 2 == 0) {
        [aCell setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    }
    else {
        [aCell setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
    }
    
    UtilizationCount *location = [mutArrCount objectAtIndex:indexPath.section];
   
//    if ([location.sublocations allObjects] > 0) {
//    }
//    
//    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"Name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
//    NSMutableArray *aArrTemp =  [NSMutableArray arrayWithArray:[[location.sublocations allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]]];
    
    UtilizationCount *subLocation = [[location.sublocations array] objectAtIndex:indexPath.row];//[aArrTemp objectAtIndex:indexPath.row];
    
    [aCell.lblFacilityArea setText:[NSString stringWithFormat:@"- %@", subLocation.name]];
    int aCurrent = [subLocation.lastCount intValue];
    
    if (subLocation.lastCountDateTime.length == 0) {
        aCell.lblLastUpdate.text = @"";
    }
    else {
        aCell.lblLastUpdate.text = [NSString stringWithFormat:@"- %@",[self getLastUpdate:subLocation.lastCountDateTime]];
    }
    int percent = 100 * [location.lastCount floatValue] / [location.capacity floatValue];
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
    [aCell.txtCount setFont:[UIFont boldSystemFontOfSize:50.0]];
    [aCell.txtCount setDelegate:self];
    
    [aCell.btnDecreaseCount addTarget:self action:@selector(btnDecreaseCountTapped:) forControlEvents:UIControlEventTouchUpInside];
    [aCell.btnIncreaseCount addTarget:self action:@selector(btnIncreaseCountTapped:) forControlEvents:UIControlEventTouchUpInside];
    [aCell.btnCountRemainSame.layer setCornerRadius:3.0];
    [aCell.btnCountRemainSame setClipsToBounds:YES];
    [aCell.btnCountRemainSame addTarget:self action:@selector(btnCountRemainSameTapped:) forControlEvents:UIControlEventTouchUpInside];
    [aCell.btnCountRemainSame.titleLabel setNumberOfLines:2];
    [aCell.btnCountRemainSame.titleLabel setTextAlignment:NSTextAlignmentCenter];
    if (aCurrent == 0) {
        [aCell.btnDecreaseCount setHidden:YES];
    }
    else {
        [aCell.btnDecreaseCount setHidden:NO];
    }
    if (indexPath.row == [location.sublocations count] - 1)
        [aCell.lblDevider setHidden:NO];
    else [aCell.lblDevider setHidden:YES];
    
    if (location.isCountRemainSame || subLocation.isCountRemainSame) {
        [aCell.btnCountRemainSame setBackgroundColor:[UIColor darkColorWithHexCodeString:@"#0c7574"]];
    }
    else {
        [aCell.btnCountRemainSame setBackgroundColor:[UIColor colorWithHexCodeString:@"#169F9E"]];
    }
    [aCell.btnKeyboard addTarget:self action:@selector(btnMessageTapped:) forControlEvents:UIControlEventTouchUpInside];
    CGRect frame = [aCell.lblDevider frame];
    frame.origin.y = aCell.frame.size.height - frame.size.height;
    [aCell.lblDevider setFrame:frame];
    return aCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 90;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    
    UtilizationHeaderView *aHeaderView = (UtilizationHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UtilizationHeaderView" owner:self options:nil] firstObject];
    aHeaderView.section = section;
    if (section == 0 || section % 2 == 0) {
        [aHeaderView setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    }
    else {
        [aHeaderView setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
    }
    UtilizationCount *location = [mutArrCount objectAtIndex:section];
    [aHeaderView.lblFacilityArea setText:location.name];
    int aMaxCapacity = [location.capacity intValue];
    int aCurrent = [location.lastCount intValue];
    int percent = 100 * aCurrent / aMaxCapacity;
    if (location.lastCountDateTime.length == 0) {
        aHeaderView.lblLastUpdate.text = @"";
    }
    else {
        aHeaderView.lblLastUpdate.text = [self getLastUpdate:location.lastCountDateTime];
    }
    [aHeaderView.lblCapicity setText:[NSString stringWithFormat:@"%d%% Capacity", percent]];
    if (percent > 80) {
        [aHeaderView.txtCount setTextColor:[UIColor colorWithRed:218.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.0]];
    }
    else if (percent > 40) {
        [aHeaderView.txtCount setTextColor:[UIColor colorWithRed:228.0/255.0 green:195.0/255.0 blue:96.0/255.0 alpha:1.0]];
    }
    else {
        [aHeaderView.txtCount setTextColor:[UIColor colorWithRed:124.0/255.0 green:193.0/255.0 blue:139.0/255.0 alpha:1.0]];
    }
    [aHeaderView.txtCount setText:[NSString stringWithFormat:@"%d", aCurrent]];
    [aHeaderView.txtCount setFont:[UIFont boldSystemFontOfSize:64.0]];
    [aHeaderView.txtCount setDelegate:self];
    [aHeaderView.btnDecreaseCount addTarget:self action:@selector(btnDecreaseCountTapped:) forControlEvents:UIControlEventTouchUpInside];
    [aHeaderView.btnIncreaseCount addTarget:self action:@selector(btnIncreaseCountTapped:) forControlEvents:UIControlEventTouchUpInside];
    [aHeaderView.btnMessage addTarget:self action:@selector(btnMessageTapped:) forControlEvents:UIControlEventTouchUpInside];
    [aHeaderView.btnCountRemainSame.layer setCornerRadius:3.0];
    [aHeaderView.btnCountRemainSame setClipsToBounds:YES];
    [aHeaderView.btnCountRemainSame addTarget:self action:@selector(btnCountRemainSameTapped:) forControlEvents:UIControlEventTouchUpInside];
    [aHeaderView.btnCountRemainSame.titleLabel setNumberOfLines:2];
    [aHeaderView.btnCountRemainSame.titleLabel setTextAlignment:NSTextAlignmentCenter];
    if (aCurrent == 0) {
        [aHeaderView.btnDecreaseCount setHidden:YES];
    }
    else {
        [aHeaderView.btnDecreaseCount setHidden:NO];
    }
    if ([location.sublocations count] > 0)
        [aHeaderView.lblDevider setHidden:YES];
    else
        [aHeaderView.lblDevider setHidden:NO];
    
    
    if (location.isCountRemainSame) {
        [aHeaderView.btnCountRemainSame setBackgroundColor:[UIColor darkColorWithHexCodeString:@"#0c7574"]];
    }
    else {
        [aHeaderView.btnCountRemainSame setBackgroundColor:[UIColor colorWithHexCodeString:@"#169F9E"]];
    }
    
    if (_btnToggleSummary.isSelected && [[location.sublocations array] count] > 0) {
        // Breakup is shown
        [aHeaderView.btnIncreaseCount setHidden:YES];
        [aHeaderView.btnDecreaseCount setHidden:YES];
        [aHeaderView.txtCount setUserInteractionEnabled:NO];
        [aHeaderView.btnCountRemainSame setHidden:YES];
        [aHeaderView.btnMessage setHidden:YES];
    }
    else {
        // Summary is shown
    }
    
    UITableViewHeaderFooterView *myHeader = [[UITableViewHeaderFooterView alloc] init];
    myHeader.frame=aHeaderView.frame;
    [myHeader addSubview:aHeaderView];
    return myHeader;
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    popOverMessage.contentViewController.view = nil;
    popOverMessage = nil;
}

#pragma mark - TextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    strPreviousText = textField.text;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (!isUpdate && ![strPreviousText isEqualToString:textField.text]) {
        isUpdate = YES;
    }
    if ([textField isEqual:_txtPopOverMessage]) {
        UtilizationCount *location = nil;
        if (editIndexPath) {
            location = [[[[mutArrCount objectAtIndex:editIndexPath.section] sublocations] array] objectAtIndex:editIndexPath.row];
        }
        else {
            location = [mutArrCount objectAtIndex:editingIndex];
        }
        if (![textField.trimText isEqualToString:location.message]) {
            location.message = textField.trimText;
            location.isUpdateAvailable = YES;
        }
    }
    else {
        id view = [textField superview];
        while (![view isKindOfClass:[UtilizationCountTableViewCell class]] && ![view isKindOfClass:[UtilizationHeaderView class]]) {
            view = [view superview];
        }
        UtilizationCount *location;
        NSInteger section;
        if ([view isKindOfClass:[UtilizationHeaderView class]]) {
            section = [(UtilizationHeaderView*)view section];
            location = [mutArrCount objectAtIndex:section];
        }
        else {
            NSIndexPath *indexPath = [_tblCountList indexPathForCell:view];
            section = indexPath.section;
            location = [[[[mutArrCount objectAtIndex:indexPath.section] sublocations] array] objectAtIndex:indexPath.row];
        }
        
        int max = [location.capacity intValue];
        int current = [textField.trimText intValue];
        if (current >= 0) {
            if ( current > max && !location.location) {
                NSString *strMsg = [NSString stringWithFormat:@"Maximum capacity for %@ is %@, %@ is over capacity now.", location.name, location.capacity, location.name];
                alert(@"Exceed Limit", strMsg);
            }
//            int previousCount = [location.lastCount intValue];
            location.lastCount = [NSString stringWithFormat:@"%d", current];
//            int newCount = [location.lastCount intValue];
            if (location.location) {
                NSInteger totalCount = 0;
                for (UtilizationCount *loc in location.location.sublocations.array) {
                    totalCount += [loc.lastCount integerValue];
                }
                location.location.lastCount = [NSString stringWithFormat:@"%ld", (long)totalCount];
                if ([location.location.lastCount intValue] > [location.location.capacity intValue]) {
                    NSString *strMsg = [NSString stringWithFormat:@"Maximum capacity for %@ is %@, %@ is over capacity now.", location.location.name, location.location.capacity, location.location.name];
                    alert(@"Exceed Limit", strMsg);
                }
                location.location.isUpdateAvailable = YES;
                location.location.lastCountDateTime = [self getCurrentDate];

            }
            else if (location.sublocations.count > 0) {
                for (UtilizationCount *subLoc in location.sublocations.array) {
                    subLoc.lastCount = @"0";
                    subLoc.isUpdateAvailable = YES;
                }
            }
            location.isUpdateAvailable = YES;
            location.lastCountDateTime = [self getCurrentDate];
            
            //Update Current Section Data
            NSArray *visibleRows = [_tblCountList visibleCells];
            for (UtilizationCountTableViewCell *aCell in visibleRows) {
                NSIndexPath *indexPath = [_tblCountList indexPathForCell:(UITableViewCell *)aCell];
                if (indexPath.section==section) {
                    UtilizationCount *location = [mutArrCount objectAtIndex:indexPath.section];
                    UtilizationCount *subLocation = [[location.sublocations array] objectAtIndex:indexPath.row];
                    [aCell.lblFacilityArea setText:[NSString stringWithFormat:@"- %@", subLocation.name]];
                    int aCurrent = [subLocation.lastCount intValue];
                    
                    if (subLocation.lastCountDateTime.length == 0)
                        aCell.lblLastUpdate.text = @"";
                    else
                        aCell.lblLastUpdate.text = [NSString stringWithFormat:@"- %@",[self getLastUpdate:subLocation.lastCountDateTime]];

                    int percent = 100 * [location.lastCount floatValue] / [location.capacity floatValue];
                    if (percent > 80)
                        [aCell.txtCount setTextColor:[UIColor colorWithRed:218.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.0]];
                    else if (percent > 40)
                        [aCell.txtCount setTextColor:[UIColor colorWithRed:228.0/255.0 green:195.0/255.0 blue:96.0/255.0 alpha:1.0]];
                    else
                        [aCell.txtCount setTextColor:[UIColor colorWithRed:124.0/255.0 green:193.0/255.0 blue:139.0/255.0 alpha:1.0]];
    
                    [aCell.txtCount setText:[NSString stringWithFormat:@"%d", aCurrent]];
                    
                    if (aCurrent == 0)
                        [aCell.btnDecreaseCount setHidden:YES];
                    else
                        [aCell.btnDecreaseCount setHidden:NO];

                    if (indexPath.row == [location.sublocations count] - 1)
                        [aCell.lblDevider setHidden:NO];
                    else [aCell.lblDevider setHidden:YES];
                    
                    if (location.isCountRemainSame || subLocation.isCountRemainSame)
                        [aCell.btnCountRemainSame setBackgroundColor:[UIColor darkColorWithHexCodeString:@"#0c7574"]];
                    else
                        [aCell.btnCountRemainSame setBackgroundColor:[UIColor colorWithHexCodeString:@"#169F9E"]];
                
                    CGRect frame = [aCell.lblDevider frame];
                    frame.origin.y = aCell.frame.size.height - frame.size.height;
                    [aCell.lblDevider setFrame:frame];
                }
            }
            
            
            //Update Cell Header Data
            UtilizationCount *locationHeader = [mutArrCount objectAtIndex:section];
            UITableViewHeaderFooterView *aHeaderView = [_tblCountList headerViewForSection:section];
            UtilizationHeaderView *aUtiHeaderView;
            for (id aView in aHeaderView.subviews) {
                if ([aView isKindOfClass:[UtilizationHeaderView class]]) {
                    aUtiHeaderView = (UtilizationHeaderView*)aView;
                    break;
                }
            }
            
            int aMaxCapacity = [locationHeader.capacity intValue];
            int aCurrent = [locationHeader.lastCount intValue];
            int percent = 100 * aCurrent / aMaxCapacity;
            if (locationHeader.lastCountDateTime.length == 0)
                aUtiHeaderView.lblLastUpdate.text = @"";
            else
                aUtiHeaderView.lblLastUpdate.text = [self getLastUpdate:locationHeader.lastCountDateTime];
        
            [aUtiHeaderView.lblCapicity setText:[NSString stringWithFormat:@"%d%% Capacity", percent]];
            if (percent > 80)
                [aUtiHeaderView.txtCount setTextColor:[UIColor colorWithRed:218.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1.0]];
            else if (percent > 40)
                [aUtiHeaderView.txtCount setTextColor:[UIColor colorWithRed:228.0/255.0 green:195.0/255.0 blue:96.0/255.0 alpha:1.0]];
            else
                [aUtiHeaderView.txtCount setTextColor:[UIColor colorWithRed:124.0/255.0 green:193.0/255.0 blue:139.0/255.0 alpha:1.0]];
            
            [aUtiHeaderView.txtCount setText:[NSString stringWithFormat:@"%d", aCurrent]];
            [aUtiHeaderView.txtCount setFont:[UIFont boldSystemFontOfSize:64.0]];
            
//          [_tblCountList reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];

            
        }
        else {
            [textField becomeFirstResponder];
        }
        [self showTotalCount];
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

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        [self showTask];
    }
    else {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
@end
