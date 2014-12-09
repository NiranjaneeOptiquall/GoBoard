//
//  GraphDetailViewController.m
//  GoBoardPro
//
//  Created by ind558 on 07/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//




/*
 Developer Notes
 #1 drawHorizontalBgLines/drawVerticalBgLines methods from mimproperties class for graph lines
 #2 drawBgPattern method from mimproperties class for backgrould color...
 #3 Draw circle at ploating pint can be handle by _drawAnchorPoints of MimLineGraph class
 #4 Other value should pass while calling graph like xValues and ploating points value.
 */

#import "GraphDetailViewController.h"
#import "LineGraphView.h"
#import "BarGraphView.h"
#import "GraphView.h"

@interface GraphDetailViewController ()

@end

@implementation GraphDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_lblXValue setText:@""];
    if (_graphType == 0) {
        [_vwDropDownBack setHidden:YES];
        CGRect frame = _vwGraphBack.frame;
        frame.origin.y = _vwDropDownBack.frame.origin.y;
        _vwGraphBack.frame = frame;
        
        float y = CGRectGetMaxY(frame) + 31;
        frame = _lblXValue.frame;
        frame.origin.y = y;
        _lblXValue.frame = frame;
        
        frame = _scrlColHeader.frame;
        frame.origin.y = y;
        _scrlColHeader.frame = frame;
        
        frame = _scrlStatistics.frame;
        frame.origin.y = CGRectGetMaxY(_scrlColHeader.frame);
        frame.size.height = self.view.frame.size.height - frame.origin.y;
        _scrlStatistics.frame = frame;
        
        [_lblGraphTitle setText:@"Incident Graph"];
        [self callIncidentStatisticsWebService];
    }
    else {
        [_vwDropDownBack setHidden:NO];
        [_lblGraphTitle setText:@"Utilization Graph"];
        NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
        [aFormatter setDateFormat:@"MM/dd/yyyy"];
        _txtStartDate.text = [aFormatter stringFromDate:[NSDate date]];
        _txtEndDate.text = [aFormatter stringFromDate:[NSDate date]];
        [self fetchLocation];
        [self dropDownControllerDidSelectValue:[aryLocation objectAtIndex:0] atIndex:0 sender:_txtLocation];
    }
}

- (void)callIncidentStatisticsWebService {
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@",INCIDENT_GRAPH, [[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:INCIDENT_GRAPH] complition:^(NSDictionary *response) {
        NSArray *aryAllRecords = [response objectForKey:@"Incidents"];
        xAxisTitles = [aryAllRecords valueForKeyPath:@"Month"];
        mutArrDataSource = [NSMutableArray array];
        for (int i = 0; i < [aryAllRecords count]; i++) {
            NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
            NSMutableArray *mutArrXTitle = [NSMutableArray array];
            NSMutableArray *mutArrYValye = [NSMutableArray array];
            for (NSDictionary *dict in aryAllRecords[i][@"Counts"]) {
                [mutArrXTitle addObject:dict[@"IncidentReportName"]];
                [mutArrYValye addObject:[dict[@"Count"] stringValue]];
            }
            [aDict setObject:mutArrXTitle forKey:@"xTitle"];
            [aDict setObject:mutArrYValye forKey:@"xValue"];
            [mutArrDataSource addObject:aDict];
        }
        aryColumns = mutArrDataSource[0][@"xTitle"];
        
        [self showGraph];
            
    } failure:^(NSError *error, NSDictionary *response) {
        
    }];
}

- (void)callUtilizationCountStatisticsWebService {
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *aStartDate = [aFormatter dateFromString:_txtStartDate.text];
    NSDate *aEndDate = [aFormatter dateFromString:_txtEndDate.text];
    [aFormatter setDateFormat:@"yyyy-MM-dd"];
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?userId=%@&startDate=%@&endDate=%@&locationId=%@",UTILIZATION_GRAPH, [[User currentUser] userId], [aFormatter stringFromDate:aStartDate], [aFormatter stringFromDate:aEndDate], selectedLocationValue] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:UTILIZATION_GRAPH] complition:^(NSDictionary *response) {
        NSArray *aryAllRecords = [response objectForKey:@"Utilizations"];
        xAxisTitles = [aryAllRecords valueForKeyPath:@"Time"];

        NSArray *aryCount = [aryAllRecords valueForKeyPath:@"Counts.@unionOfObjects.Count"];
        NSArray *aryNames = [[aryAllRecords valueForKeyPath:@"Counts.@distinctUnionOfObjects.Location"] firstObject];
        mutArrDataSource = [NSMutableArray array];
        for (NSInteger i = 0; i < [aryNames count]; i++) {
            
            NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
            NSMutableArray *mutArrXTitle = [NSMutableArray array];
            [mutArrXTitle addObject:xAxisTitles];
            [aDict setObject:mutArrXTitle forKey:@"xTitle"];
            NSMutableArray *mutAry = [NSMutableArray array];
            for (NSArray *ary in aryCount) {
                [mutAry addObject:[ary[i] stringValue]];
            }
            [aDict setObject:mutAry forKey:@"xValue"];
            [mutArrDataSource addObject:aDict];
        }
        aryColumns = aryNames;
        
        [self showGraph];
        
    } failure:^(NSError *error, NSDictionary *response) {
        NSLog(@"%@", response);
    }];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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

- (void)createHeader {
    float width = 150; // CollectionView's cell width
    float x = 5, y = 0;
    float height = 22;
    for (int i = 0; i < [aryColumns count]; i++) {
        UILabel *aLbl = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [aLbl setFont:[UIFont systemFontOfSize:17.0]];
        [aLbl setTextColor:[UIColor whiteColor]];
        [aLbl setBackgroundColor:[UIColor clearColor]];
        [aLbl setText:[aryColumns objectAtIndex:i]];
        [_scrlColHeader addSubview:aLbl];
        x += width;
    }
    [_scrlColHeader setContentSize:CGSizeMake(x, 0)];
}

-(void)showGraph
{
    CGRect frame = _tblStatistics.frame;
    frame.size.height = [xAxisTitles count] * 40;
    _tblStatistics.frame = frame;
    frame = _colViewData.frame;
    frame.size.height = _tblStatistics.frame.size.height;
    _colViewData.frame = frame;
    [_tblStatistics reloadData];
    [self createHeader];
    [_colViewData reloadData];
    [_scrlStatistics setContentSize:CGSizeMake(_scrlStatistics.frame.size.width, frame.size.height)];
    for (UIView *vw in _vwGraphDisplay.subviews) {
        [vw removeFromSuperview];
    }
    
    
    NSMutableArray *myvalues = [NSMutableArray array];
    NSMutableArray *myxtitle = [NSMutableArray array];
    NSArray *colors = [self generateColors:[aryColumns count]];
    int index = 0;
    mutArrGraphTypes = [NSMutableArray array];
    for (NSString *str in aryColumns) {
        [mutArrGraphTypes addObject:@{@"type":str, @"color":[colors objectAtIndex:index]}];
        index++;
    }
    for (NSDictionary *dict in mutArrDataSource) {
        [myvalues addObject:[dict objectForKey:@"xValue"]];
        [myxtitle addObject:[dict objectForKey:@"xTitle"]];
    }
    GraphView *graphView = nil;
    if (_graphType == 0) {
        [_lblXValue setText:@"Month"];
        graphView = [[BarGraphView alloc] initWithFrame:_vwGraphDisplay.bounds];
        xTitles = myxtitle;
    }
    else {
        [_lblXValue setText:@"Time"];
        graphView = [[LineGraphView alloc] initWithFrame:_vwGraphDisplay.bounds];
        xTitles = xAxisTitles;//[[mutArrDataSource firstObject] objectForKey:@"xTitle"];
    }
    
    [graphView setBackgroundColor:[UIColor clearColor]];
   
    [graphView showStaticGraphWithValues :myvalues andWithTitle :xTitles withColors:colors groupTitle:xAxisTitles];
    [_vwGraphDisplay addSubview:graphView];
    [_tblGraphColor reloadData];
}


- (NSArray*)generateColors:(NSInteger)count {
    NSMutableArray *mutArrColors = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        UIColor *color = [UIColor colorWithRed:((float)(rand()%101))/100 green:((float)(rand()%101))/100 blue:((float)(rand()%101))/100 alpha:1.0];
        [mutArrColors addObject:color];
    }
    return mutArrColors;
}


- (void)fetchLocation {
    NSFetchRequest *requestLoc = [[NSFetchRequest alloc] initWithEntityName:@"UserLocation"];
    
    NSPredicate *predicateLoc = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"facility.value", [[[User currentUser] selectedFacility] value]];
    [requestLoc setPredicate:predicateLoc];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [requestLoc setSortDescriptors:@[sortByName]];
    [requestLoc setPropertiesToFetch:@[@"name", @"value"]];
    aryLocation = [gblAppDelegate.managedObjectContext executeFetchRequest:requestLoc error:nil];
    requestLoc = nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    if ([tableView isEqual:_tblGraphColor]) {
        row = [mutArrGraphTypes count];
    }
    else {
        row = [xAxisTitles count];
    }
    return row;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if ([tableView isEqual:_tblGraphColor]) {
        UIView *vwColor = [aCell.contentView viewWithTag:2];
        [vwColor.layer setBorderColor:[UIColor whiteColor].CGColor];
        [vwColor.layer setBorderWidth:1.0];
        [vwColor setBackgroundColor:[mutArrGraphTypes[indexPath.row] objectForKey:@"color"]];
        
        UILabel *aLblType = (UILabel *)[aCell.contentView viewWithTag:3];
        [aLblType setText:[mutArrGraphTypes[indexPath.row] objectForKey:@"type"]];
        [aCell setBackgroundColor:[UIColor clearColor]];
        [aCell.contentView setBackgroundColor:[UIColor clearColor]];
    }
    else {
        if (indexPath.row == 0 || indexPath.row % 2 == 0) {
            [aCell setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
        }
        else {
            [aCell setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
        }
        UILabel *aLblXValue = (UILabel *)[aCell.contentView viewWithTag:2];
        [aLblXValue setText:[xAxisTitles objectAtIndex:indexPath.row]];
    }
   
    return aCell;
}


#pragma mark - UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger items = 0;
    if (_graphType == 0) {
        NSInteger count = [[[mutArrDataSource objectAtIndex:0] objectForKey:@"xValue"] count];
        if (count < 4) {
            count = 4;
        }
        items = [mutArrDataSource count] * count;
    }
    else {
        NSInteger count = [mutArrDataSource count];
        if (count < 4) {
            count = 4;
        }
        items = count * [[[mutArrDataSource objectAtIndex:0] objectForKey:@"xValue"] count];
    }
    return items;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *aCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *aLblData = (UILabel*)[aCell.contentView viewWithTag:2];
    [aLblData setText:@""];
    NSInteger index = 0;
    if (_graphType == 0) {
        index = (indexPath.item % mutArrDataSource.count);
        if (indexPath.item < [mutArrDataSource count] * [[[mutArrDataSource objectAtIndex:0] objectForKey:@"xValue"] count]) {
            aLblData.text = [[[mutArrDataSource objectAtIndex:indexPath.item % mutArrDataSource.count] objectForKey:@"xValue"] objectAtIndex:indexPath.item / mutArrDataSource.count];
        }
    }
    else {
        NSInteger count = [mutArrDataSource[0][@"xValue"] count];
        index = (indexPath.item % count);
        if (indexPath.item < [mutArrDataSource count] * [[[mutArrDataSource objectAtIndex:0] objectForKey:@"xValue"] count]) {
            aLblData.text = [[[mutArrDataSource objectAtIndex:indexPath.item / count] objectForKey:@"xValue"] objectAtIndex:indexPath.item % count];
        }
    }
    if (index % 2 == 0) {
        [aCell setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    }
    else {
        [aCell setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
    }
    return aCell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _scrlColHeader.contentOffset = CGPointMake(_colViewData.contentOffset.x, 0);
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_txtStartDate]) {
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        datePopOver.delegate = self;
        [datePopOver showInPopOverFor:_txtStartDate limit:DATE_LIMIT_PAST_ONLY option:DATE_SELECTION_DATE_ONLY updateField:_txtStartDate];
    }
    else if ([textField isEqual:_txtEndDate]) {
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
        [aFormatter setDateFormat:@"dd/MM/yyyy"];
        datePopOver.delegate = self;
        [datePopOver.datePicker setMinimumDate:[aFormatter dateFromString:_txtStartDate.text]];
        [datePopOver showInPopOverFor:_txtEndDate limit:DATE_LIMIT_PAST_ONLY option:DATE_SELECTION_DATE_ONLY updateField:_txtEndDate];
    }
    else if ([textField isEqual:_txtLocation]) {
        DropDownPopOver *dropDown = (DropDownPopOver *)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        [dropDown setDelegate:self];
        [dropDown showDropDownWith:aryLocation view:_txtLocation key:@"name"];
    }
    return NO;
}

- (void)dropDownControllerDidSelectValue:(id)value atIndex:(NSInteger)index sender:(id)sender {
    [sender setText:[value valueForKey:@"name"]];
    if (![selectedLocationValue isEqualToString:[value valueForKey:@"value"]]) {
        selectedLocationValue = [value valueForKey:@"value"];
        [self callUtilizationCountStatisticsWebService];
    }
        
    
}

- (void)datePickerDidSelect:(NSDate *)date forObject:(id)field {
    [self callUtilizationCountStatisticsWebService];
}
@end
