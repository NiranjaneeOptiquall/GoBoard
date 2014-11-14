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
    }
    else {
        [_vwDropDownBack setHidden:NO];
        _lblXValue.text = @"Time";
    }
    [self setDataSource];
    [self showGraph];
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

- (void)setDataSource {
    if (_graphType == 0) {
        mutArrDataSource = [[NSMutableArray alloc] init];
        for (int i = 0; i < 3; i++) {
            NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
            [aDict setObject:[NSString stringWithFormat:@"Incident %d", i] forKey:@"type"];
            [aDict setObject:[NSArray arrayWithObjects:@"Jan",@"Feb",@"Mar", nil] forKey:@"xTitle"];
            NSMutableArray *array1 = [[NSMutableArray alloc] init];
            for (int i=0; i<3; i++)
            {
                [array1 addObject:[NSString stringWithFormat:@"%d",rand()%1600 + 1000]];
            }
            [aDict setObject:array1 forKey:@"xValue"];
            [mutArrDataSource addObject:aDict];
        }
    }
    else {
        mutArrDataSource = [[NSMutableArray alloc] init];
        for (int i = 0; i < 3; i++) {
            NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
            [aDict setObject:[NSString stringWithFormat:@"Location %d", i] forKey:@"type"];
            [aDict setObject:[NSArray arrayWithObjects:@"8 AM",@"9 AM",@"10 AM", @"11 AM",@"12 PM", @"1 PM", @"2 PM", @"3 PM", @"4 PM", @"5 PM", @"6 PM",@"7 PM", @"8 PM", @"9 PM",@"10 PM", nil] forKey:@"xTitle"];
            NSMutableArray *array1 = [[NSMutableArray alloc] init];
            for (int i=0; i<15; i++)
            {
                [array1 addObject:[NSString stringWithFormat:@"%d",rand()%160]];
            }
            [aDict setObject:array1 forKey:@"xValue"];
            [mutArrDataSource addObject:aDict];
        }
    }
    
}

-(void)showGraph
{
    for (UIView *vw in _vwGraphDisplay.subviews) {
        [vw removeFromSuperview];
    }
    
    
    NSMutableArray *myvalues = [NSMutableArray array];
    NSMutableArray *myxtitle = [NSMutableArray array];
    NSArray *colors = [self generateColors];
    int index = 0;
    for (NSDictionary *dict in mutArrDataSource) {
        [myvalues addObject:[dict objectForKey:@"xValue"]];
        [myxtitle addObject:[dict objectForKey:@"xTitle"]];
        [mutArrGraphTypes addObject:@{@"type":[dict objectForKey:@"type"], @"color":[colors objectAtIndex:index]}];
        index++;
    }
    GraphView *graphView = nil;
    if (_graphType == 0) {
        graphView = [[BarGraphView alloc] initWithFrame:_vwGraphDisplay.bounds];
        xTitles = myxtitle;
    }
    else {
        graphView = [[LineGraphView alloc] initWithFrame:_vwGraphDisplay.bounds];
        xTitles = [[mutArrDataSource firstObject] objectForKey:@"xTitle"];
    }
    
    [graphView setBackgroundColor:[UIColor clearColor]];
   
    [graphView showStaticGraphWithValues :myvalues andWithTitle :xTitles withColors:colors];
    [_vwGraphDisplay addSubview:graphView];
    [_tblGraphColor reloadData];
}


- (NSArray*)generateColors {
    NSMutableArray *mutArrColors = [[NSMutableArray alloc] init];
    for (int i = 0; i < [mutArrDataSource count]; i++) {
        UIColor *color = [UIColor colorWithRed:((float)(rand()%101))/100 green:((float)(rand()%101))/100 blue:((float)(rand()%101))/100 alpha:1.0];
        [mutArrColors addObject:color];
    }
    return mutArrColors;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row = 0;
    if ([tableView isEqual:_tblGraphColor]) {
        row = [mutArrGraphTypes count];
    }
    else {
        row = [[[mutArrDataSource objectAtIndex:0] objectForKey:@"xTitle"] count];
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
        [aLblXValue setText:[[[mutArrDataSource objectAtIndex:indexPath.section] objectForKey:@"xTitle"] objectAtIndex:indexPath.row]];
        
        UILabel *aLblFistValue = (UILabel *)[aCell.contentView viewWithTag:3];
        UILabel *aLblSecondValue = (UILabel *)[aCell.contentView viewWithTag:4];
        UILabel *aLblThirdValue = (UILabel *)[aCell.contentView viewWithTag:5];
        UILabel *aLblTotalValue = (UILabel *)[aCell.contentView viewWithTag:6];
        NSArray *lbl = @[aLblFistValue, aLblSecondValue, aLblThirdValue];
        for (int i = 0; i < [mutArrDataSource count]; i++) {
            NSDictionary *aDict = [mutArrDataSource objectAtIndex:i];
            [(UILabel *)[lbl objectAtIndex:i] setText:[[aDict objectForKey:@"xValue"] objectAtIndex:indexPath.row]];
        }
        [aLblTotalValue setText:[NSString stringWithFormat:@"%ld", (long)([aLblFistValue.text integerValue] + [aLblSecondValue.text integerValue] + [aLblThirdValue.text integerValue])]];
    }
   
    return aCell;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_txtStartDate]) {
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        [datePopOver showInPopOverFor:_txtStartDate limit:DATE_LIMIT_PAST_ONLY option:DATE_SELECTION_DATE_ONLY updateField:_txtStartDate];
    }
    else if ([textField isEqual:_txtEndDate]) {
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
        [aFormatter setDateFormat:@"dd/MM/yyyy"];
        [datePopOver.datePicker setMinimumDate:[aFormatter dateFromString:_txtStartDate.text]];
        [datePopOver showInPopOverFor:_txtEndDate limit:DATE_LIMIT_PAST_ONLY option:DATE_SELECTION_DATE_ONLY updateField:_txtEndDate];
    }
    else if ([textField isEqual:_txtLocation]) {
        DropDownPopOver *dropDown = (DropDownPopOver *)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        [dropDown setDelegate:self];
        [dropDown showDropDownWith:LOCATION_VALUES view:_txtLocation key:@"title"];
    }
    return NO;
}

- (void)dropDownControllerDidSelectValue:(id)value atIndex:(NSInteger)index sender:(id)sender {
    [sender setText:[value objectForKey:@"title"]];
}
@end
