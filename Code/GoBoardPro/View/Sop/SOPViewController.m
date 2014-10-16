//
//  SOPViewController.m
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "SOPViewController.h"
#import "ERPHeaderView.h"

@interface SOPViewController ()

@end

@implementation SOPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAllEmergencyList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark - IBActions & Selectors

- (void)btnHeaderTapped:(UIButton*)btn {
    BOOL isExpanded = [[[mutArrSOPList objectAtIndex:btn.tag] objectForKey:@"isExpanded"] boolValue];
    isExpanded = !isExpanded;
    [[mutArrSOPList objectAtIndex:btn.tag] setObject:[NSNumber numberWithBool:isExpanded] forKey:@"isExpanded"];
//    [_tblSOPList reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [mutArrSOPList count] - 1)] withRowAnimation:UITableViewRowAnimationFade];
    [_tblSOPList reloadData];
}


- (IBAction)unwindBackToSOPListScreen:(UIStoryboardSegue*)segue {
    
}

#pragma mark - Methods

- (void)getAllEmergencyList {
    mutArrSOPList = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        NSMutableArray *aTemp = [NSMutableArray array];
        for (int k = 0; k < 4; k++) {
            [aTemp addObject:[NSString stringWithFormat:@"Sub SOP Title %d-%d", i, k]];
        }
        NSMutableDictionary *aDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"SOP Title", @"title", aTemp, @"sub", [NSNumber numberWithBool:NO], @"isExpanded", nil];
        [mutArrSOPList addObject:aDict];
    }
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [mutArrSOPList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    BOOL isExpanded = [[[mutArrSOPList objectAtIndex:section] objectForKey:@"isExpanded"] boolValue];
    if (isExpanded) {
        return [[[mutArrSOPList objectAtIndex:section] objectForKey:@"sub"] count];
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSInteger currentIndex = indexPath.section + indexPath.row + 1;
    for (int i = 0; i < indexPath.section; i++) {
        NSMutableDictionary *aDict = [mutArrSOPList objectAtIndex:i];
        BOOL isExpand = [[aDict objectForKey:@"isExpanded"] boolValue];
        if (isExpand) {
            currentIndex += [[aDict objectForKey:@"sub"] count];
        }
    }
    if (currentIndex == 0 || currentIndex % 2 == 0) {
        [aCell setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    }
    else {
        [aCell setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
    }
    UILabel *aLbl = (UILabel *)[aCell.contentView viewWithTag:2];
    [aLbl setText:[[[mutArrSOPList objectAtIndex:indexPath.section] objectForKey:@"sub"] objectAtIndex:indexPath.row]];
    UIView *aView = [aCell.contentView viewWithTag:4];
    CGRect frame = aView.frame;
    frame.origin.y = aCell.frame.size.height - 3;
    [aView setFrame:frame];
    return aCell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSInteger currentIndex = section;
    for (int i = 0; i < section; i++) {
        NSMutableDictionary *aDict = [mutArrSOPList objectAtIndex:i];
        BOOL isExpand = [[aDict objectForKey:@"isExpanded"] boolValue];
        if (isExpand) {
            currentIndex += [[aDict objectForKey:@"sub"] count];
        }
    }
    
    ERPHeaderView *aHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"ERPHeaderView" owner:self options:nil] firstObject];
    if (currentIndex == 0 || currentIndex % 2 == 0) {
        [aHeaderView setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    }
    else {
        [aHeaderView setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
    }
    [aHeaderView.lblSectionHeaser setText:[[mutArrSOPList objectAtIndex:section] objectForKey:@"title"]];
    [aHeaderView.btnSection setTag:section];
    [aHeaderView.btnSection addTarget:self action:@selector(btnHeaderTapped:) forControlEvents:UIControlEventTouchUpInside];
    BOOL isExpanded = [[[mutArrSOPList objectAtIndex:section] objectForKey:@"isExpanded"] boolValue];
    if (isExpanded) {
        [aHeaderView.imvExpandCollapse setImage:[UIImage imageNamed:@"collaps_icon@2x.png"]];
    }
    else {
        [aHeaderView.imvExpandCollapse setImage:[UIImage imageNamed:@"expand_icon@2x.png"]];
    }
    return aHeaderView;
}

@end
