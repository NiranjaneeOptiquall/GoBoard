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
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [[WebSerivceCall webServiceObject] callServiceForIncidentReport:NO complition:^{
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
    // Do any additional setup after loading the view.
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
