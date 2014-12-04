//
//  GraphListViewController.m
//  GoBoardPro
//
//  Created by ind558 on 10/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "GraphListViewController.h"
#import "GraphDetailViewController.h"

@interface GraphListViewController ()

@end

@implementation GraphListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mutArrGraphList = [NSMutableArray arrayWithObjects:@"Incident Graph", @"Utilization Graph", nil];
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
    if ([[segue identifier] isEqualToString:@"goToGraphDetail"]) {
        GraphDetailViewController *detailVC = (GraphDetailViewController *)[segue destinationViewController];
        detailVC.graphType = row % 2;
    }
}

- (IBAction)unwindBackToGraphListScreen:(UIStoryboardSegue*)segue {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mutArrGraphList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 0 || indexPath.row % 2 == 0) {
        [aCell setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    }
    else {
        [aCell setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
    }
    UILabel *aLbl = (UILabel *)[aCell.contentView viewWithTag:2];
    [aLbl setText:[mutArrGraphList objectAtIndex:indexPath.row]];
    UIView *aView = [aCell.contentView viewWithTag:4];
    CGRect frame = aView.frame;
    frame.origin.y = aCell.frame.size.height - 3;
    [aView setFrame:frame];
    return aCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (gblAppDelegate.isNetworkReachable) {
        row = indexPath.row;
        [self performSegueWithIdentifier:@"goToGraphDetail" sender:self];
    }
    else {
        alert(@"", MSG_NO_INTERNET);
    }
}



@end
