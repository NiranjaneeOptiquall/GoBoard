//
//  IncidenceReportViewController.m
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "IncidenceReportViewController.h"
#import "IncidentDetailViewController.h"

@interface IncidenceReportViewController ()

@end

@implementation IncidenceReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Report"];
    // Get Misconduct Count
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userId MATCHES[cd] %@) AND isCompleted = 0 AND incidentType = 1", [[User currentUser] userId]];
    [request setPredicate:predicate];
    NSInteger count = [gblAppDelegate.managedObjectContext countForFetchRequest:request error:nil];
    if (count > 0) {
        [_lblBadgeMisconduct setHidden:NO];
    }
    else {
        [_lblBadgeMisconduct setHidden:YES];
    }
    // Get Costumer service Count
    predicate = [NSPredicate predicateWithFormat:@"(userId MATCHES[cd] %@) AND isCompleted = 0 AND incidentType = 2", [[User currentUser] userId]];
    //    [request setPredicate:nil];
    [request setPredicate:predicate];
    count = [gblAppDelegate.managedObjectContext countForFetchRequest:request error:nil];
    if (count > 0) {
        [_lblBadgeCustomerService setHidden:NO];
    }
    else {
        [_lblBadgeCustomerService setHidden:YES];
    }
    
    // Get Other Count
    predicate = [NSPredicate predicateWithFormat:@"(userId MATCHES[cd] %@) AND isCompleted = 0 AND incidentType = 3", [[User currentUser] userId]];
    //    [request setPredicate:nil];
    [request setPredicate:predicate];
    count = [gblAppDelegate.managedObjectContext countForFetchRequest:request error:nil];
    if (count > 0) {
        [_lblBadgeOther setHidden:NO];
    }
    else {
        [_lblBadgeOther setHidden:YES];
    }
    
    _lblBadgeMisconduct.layer.cornerRadius = 2.0;
    _lblBadgeMisconduct.layer.borderColor = [UIColor whiteColor].CGColor;
    _lblBadgeMisconduct.layer.borderWidth = 1.0;
    
    _lblBadgeCustomerService.layer.cornerRadius = 2.0;
    _lblBadgeCustomerService.layer.borderColor = [UIColor whiteColor].CGColor;
    _lblBadgeCustomerService.layer.borderWidth = 1.0;
    
    _lblBadgeOther.layer.cornerRadius = 2.0;
    _lblBadgeOther.layer.borderColor = [UIColor whiteColor].CGColor;
    _lblBadgeOther.layer.borderWidth = 1.0;
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
    IncidentDetailViewController *aDetail = (IncidentDetailViewController*)[segue destinationViewController];
    if ([[segue identifier] isEqualToString:@"misconduct"]) {
        aDetail.incidentType = 1;
    }
    else if([[segue identifier] isEqualToString:@"customerService"]) {
        aDetail.incidentType = 2;
    }
    else if ([[segue identifier] isEqualToString:@"otherIncidents"]) {
        aDetail.incidentType = 3;
    }
}


@end
