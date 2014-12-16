//
//  AdminTaskListViewController.m
//  GoBoardPro
//
//  Created by ind558 on 13/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "AdminTaskListViewController.h"

@implementation AdminTaskListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mutArrTaskList = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i++) {
        NSMutableArray *mutArrTask = [NSMutableArray array];
        for (int j = 0; j < 10; j++) {
            [mutArrTask addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Task #%d", j], @"task" , [NSString stringWithFormat:@"Every %d Hours", arc4random() % 10], @"frequency", nil]];
        }
        [mutArrTaskList addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Position #%d", i], @"position", mutArrTask, @"taskList", nil]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [mutArrTaskList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[mutArrTaskList objectAtIndex:section] objectForKey:@"taskList"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *position = (UILabel*)[aCell.contentView viewWithTag:2];
    if (indexPath.row == 0) {
        [position setText:[[mutArrTaskList objectAtIndex:indexPath.section] objectForKey:@"position"]];
    }
    else {
        [position setText:@""];
    }
    
    NSDictionary *aDict = [[[mutArrTaskList objectAtIndex:indexPath.section] objectForKey:@"taskList"] objectAtIndex:indexPath.row];
    UILabel *aLblTask = (UILabel*)[aCell.contentView viewWithTag:3];
    [aLblTask setText:[aDict objectForKey:@"task"]];
    UILabel *aLblFrequency = (UILabel*)[aCell.contentView viewWithTag:3];
    [aLblFrequency setText:[aDict objectForKey:@"frequency"]];
    [aCell setBackgroundColor:[UIColor clearColor]];
    [aCell.contentView setBackgroundColor:[UIColor clearColor]];
    return aCell;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:_txtFacility]) {
        DropDownPopOver *dropDown = (DropDownPopOver *)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        [dropDown setDelegate:self];
//        [dropDown showDropDownWith:FACILITY_VALUES view:_txtLocation key:@"title"];
    }
    else if ([textField isEqual:_txtLocation]) {
        DropDownPopOver *dropDown = (DropDownPopOver *)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        [dropDown setDelegate:self];
//        [dropDown showDropDownWith:LOCATION_VALUES view:_txtLocation key:@"title"];
    }
    return NO;
}

- (void)dropDownControllerDidSelectValue:(id)value atIndex:(NSInteger)index sender:(id)sender {
    [sender setText:[value objectForKey:@"title"]];
}

@end
