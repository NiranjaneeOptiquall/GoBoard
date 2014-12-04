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
    mutArrGraphTypes = [[NSMutableArray alloc] init];
    if (_graphType == 0) {
        [_vwDropDownBack setHidden:YES];
        CGRect frame = _vwGraphBack.frame;
        frame.origin.y = _vwDropDownBack.frame.origin.y;
        _vwGraphBack.frame = frame;
        _lblXValue.text = @"Month";
        [self callIncidentStatisticsWebService];
    }
    else {
        [_vwDropDownBack setHidden:NO];
        _lblXValue.text = @"Time";
        NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
        [aFormatter setDateFormat:@"MM/dd/yyyy"];
        _txtStartDate.text = [aFormatter stringFromDate:[NSDate date]];
        _txtEndDate.text = [aFormatter stringFromDate:[NSDate date]];
        [self fetchLocation];
        [self dropDownControllerDidSelectValue:[aryLocation objectAtIndex:0] atIndex:0 sender:_txtLocation];
    }
//    [self setDataSource];
//    [self showGraph];
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
        
        
        
        
        
        
       /* NSArray *aryIncidentCount = [aryAllRecords valueForKeyPath:@"Counts.@unionOfObjects.Count"];
        NSArray *aryIncidentNames = [[aryAllRecords valueForKeyPath:@"Counts.@distinctUnionOfObjects.IncidentReportName"] firstObject];
        mutArrDataSource = [NSMutableArray array];
        for (NSInteger i = 0; i < [aryIncidentNames count]; i++) {
            
            NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
            [aDict setObject:aryXAxis forKey:@"xTitle"];
            [aDict setObject:aryIncidentNames[i] forKey:@"type"];
            NSMutableArray *mutAry = [NSMutableArray array];
            for (NSArray *ary in aryIncidentCount) {
                [mutAry addObject:ary[i]];
            }
            [aDict setObject:mutAry forKey:@"xValue"];
            [mutArrDataSource addObject:aDict];
        }*/
        [self showGraph:mutArrDataSource[0][@"xTitle"]];
            
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
       /* mutArrDataSource = [NSMutableArray array];
        for (int i = 0; i < [aryAllRecords count]; i++) {
            NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
            NSMutableArray *mutArrXTitle = [NSMutableArray array];
            NSMutableArray *mutArrYValye = [NSMutableArray array];
            for (NSDictionary *dict in aryAllRecords[i][@"Counts"]) {
                [mutArrXTitle addObject:dict[@"Location"]];
                [mutArrYValye addObject:dict[@"Count"]];
            }
            [aDict setObject:mutArrXTitle forKey:@"xTitle"];
            [aDict setObject:mutArrYValye forKey:@"xValue"];
            [mutArrDataSource addObject:aDict];
        }*/
        
        
        NSArray *aryIncidentCount = [aryAllRecords valueForKeyPath:@"Counts.@unionOfObjects.Count"];
        NSArray *aryIncidentNames = [[aryAllRecords valueForKeyPath:@"Counts.@distinctUnionOfObjects.Location"] firstObject];
        mutArrDataSource = [NSMutableArray array];
        for (NSInteger i = 0; i < [aryIncidentNames count]; i++) {
            
            NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
            NSMutableArray *mutArrXTitle = [NSMutableArray array];
//            NSMutableArray *mutArrYValye = [NSMutableArray array];
//            for (NSDictionary *dict in aryAllRecords[i][@"Counts"]) {
                [mutArrXTitle addObject:xAxisTitles];
//                [mutArrYValye addObject:dict[@"Count"]];
//            }
            [aDict setObject:mutArrXTitle forKey:@"xTitle"];
//            [aDict setObject:mutArrYValye forKey:@"xValue"];
            NSMutableArray *mutAry = [NSMutableArray array];
            for (NSArray *ary in aryIncidentCount) {
                [mutAry addObject:[ary[i] stringValue]];
            }
            [aDict setObject:mutAry forKey:@"xValue"];
            [mutArrDataSource addObject:aDict];
        }
        
        [self showGraph:aryIncidentNames];
        
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


-(void)showGraph:(NSArray*)categoryList
{
    [_tblStatistics reloadData];
    for (UIView *vw in _vwGraphDisplay.subviews) {
        [vw removeFromSuperview];
    }
    
    
    NSMutableArray *myvalues = [NSMutableArray array];
    NSMutableArray *myxtitle = [NSMutableArray array];
    NSArray *colors = [self generateColors:[categoryList count]];
    int index = 0;
    for (NSString *str in categoryList) {
        [mutArrGraphTypes addObject:@{@"type":str, @"color":[colors objectAtIndex:index]}];
        index++;
    }
    for (NSDictionary *dict in mutArrDataSource) {
        [myvalues addObject:[dict objectForKey:@"xValue"]];
        [myxtitle addObject:[dict objectForKey:@"xTitle"]];
    }
    GraphView *graphView = nil;
    if (_graphType == 0) {
        graphView = [[BarGraphView alloc] initWithFrame:_vwGraphDisplay.bounds];
        xTitles = myxtitle;
    }
    else {
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
        if (_graphType == 0) {
            row = [mutArrDataSource count];
        }
        else {
            row = [xAxisTitles count];
        }
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
        if (indexPath.row == 9) {
            NSLog(@"%@", indexPath);
        }
        UILabel *aLblXValue = (UILabel *)[aCell.contentView viewWithTag:2];
        UILabel *aLblFistValue = (UILabel *)[aCell.contentView viewWithTag:3];
        UILabel *aLblSecondValue = (UILabel *)[aCell.contentView viewWithTag:4];
        UILabel *aLblThirdValue = (UILabel *)[aCell.contentView viewWithTag:5];
        UILabel *aLblTotalValue = (UILabel *)[aCell.contentView viewWithTag:6];
        NSArray *lbl = @[aLblFistValue, aLblSecondValue, aLblThirdValue];
        if (_graphType == 0) {
            [aLblXValue setText:[xAxisTitles objectAtIndex:indexPath.row]];
            NSDictionary *aDict = [mutArrDataSource objectAtIndex:indexPath.row];
            for (int i = 0; i < [lbl count]; i++) {
                [(UILabel *)[lbl objectAtIndex:i] setText:[[aDict objectForKey:@"xValue"] objectAtIndex:i]];
            }
            [aLblTotalValue setText:[NSString stringWithFormat:@"%ld", (long)([aLblFistValue.text integerValue] + [aLblSecondValue.text integerValue] + [aLblThirdValue.text integerValue])]];
        }
        else {
            [aLblXValue setText:[xAxisTitles objectAtIndex:indexPath.row]];
            for (int i = 0; i < [lbl count]; i++) {
                NSDictionary *aDict = [mutArrDataSource objectAtIndex:i];
                [(UILabel *)[lbl objectAtIndex:i] setText:[[aDict objectForKey:@"xValue"] objectAtIndex:indexPath.row]];
            }
            [aLblTotalValue setText:[NSString stringWithFormat:@"%ld", (long)([aLblFistValue.text integerValue] + [aLblSecondValue.text integerValue] + [aLblThirdValue.text integerValue])]];
        }
        
    }
   
    return aCell;
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
        [dropDown showDropDownWith:aryLocation view:_txtLocation key:@"title"];
    }
    return NO;
}

- (void)dropDownControllerDidSelectValue:(id)value atIndex:(NSInteger)index sender:(id)sender {
    [sender setText:[value valueForKey:@"name"]];
    selectedLocationValue = [value valueForKey:@"value"];
    [self callUtilizationCountStatisticsWebService];
}

- (void)datePickerDidSelect:(NSDate *)date forObject:(id)field {
    [self callUtilizationCountStatisticsWebService];
}
@end
