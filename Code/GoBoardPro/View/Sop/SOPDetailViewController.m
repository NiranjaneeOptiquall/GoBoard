//
//  SOPDetailViewController.m
//  GoBoardPro
//
//  Created by ind558 on 26/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "SOPDetailViewController.h"

@interface SOPDetailViewController ()

@end

@implementation SOPDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAllActionListForSOP];
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


#pragma mark - Methods

- (void)getAllActionListForSOP {
    mutArrSOPList = [[NSMutableArray alloc] init];
    [mutArrSOPList addObject:@"This is a simple action."];
    [mutArrSOPList addObject:@"This is a simple action with atleast two line in cell to display larger cell."];
    [mutArrSOPList addObject:@"This is a simple action with atleast two line in cell to display larger cell.This is a simple action with atleast two line in cell to display larger cell.This is a simple action with atleast two line in cell to display larger cell."];
    [mutArrSOPList addObject:@"This is a simple action with atleast two line in cell to display larger cell.This is a simple action with atleast two line in cell to display larger cell."];
    [mutArrSOPList addObject:@"This is a simple action with atleast two line in cell to display larger cell."];
    [mutArrSOPList addObject:@"This is a simple action."];
    [mutArrSOPList addObject:@"This is a simple action with atleast two line in cell to display larger cell.."];
    [mutArrSOPList addObject:@"This is a simple action."];
    [mutArrSOPList addObject:@"This is a simple action with atleast two line in cell to display larger cell.This is a simple action with atleast two line in cell to display larger cell.This is a simple action with atleast two line in cell to display larger cell.This is a simple action with atleast two line in cell to display larger cell."];
    [mutArrSOPList addObject:@"This is a simple action."];
    [mutArrSOPList addObject:@"This is a simple action with atleast two line in cell to display larger cell.This is a simple action with atleast two line in cell to display larger cell."];
    [mutArrSOPList addObject:@"This is a simple action."];
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mutArrSOPList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 0 || indexPath.row % 2 == 0) {
        [aCell setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    }
    else {
        [aCell setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
    }
    UILabel *aLbl = (UILabel*)[aCell viewWithTag:2];
    [aLbl setText:[mutArrSOPList objectAtIndex:indexPath.row]];
    [aLbl sizeToFit];
    UIView *aView = [aCell.contentView viewWithTag:4];
    CGRect frame = aView.frame;
    frame.origin.y = aCell.frame.size.height - 3;
    [aView setFrame:frame];
    return aCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *aLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 632, 21)];
    NSString *aStr = [mutArrSOPList objectAtIndex:indexPath.row];
    [aLbl setText:aStr];
    [aLbl setFont:[UIFont systemFontOfSize:17.0]];
    [aLbl setNumberOfLines:0];
    [aLbl sizeToFit];
    CGFloat height = aLbl.frame.size.height + 23;
    aLbl = nil;
    return height;
}


@end
