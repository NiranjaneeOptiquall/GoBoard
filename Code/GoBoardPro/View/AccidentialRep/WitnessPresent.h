//
//  WitnessPresent.h
//  GoBoardPro
//
//  Created by ind726 on 03/02/15.
//  Copyright (c) 2015 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccidentReportViewController.h"
#import "IncidentDetailViewController.h"

@interface WitnessPresent : UIView <UIAlertViewDelegate>

@property (weak, nonatomic) AccidentReportViewController *parentVCAccident;

@property (weak, nonatomic) IncidentDetailViewController *parentVCIncident;

@property (strong, nonatomic) IBOutlet UIButton *btnWitnessPresentYes;

@property (strong, nonatomic) IBOutlet UIButton *btnWitnessPresentNo;

- (IBAction)btnWitnessPresenyYes:(UIButton *)sender;

- (IBAction)btnWitnessPresentNo:(UIButton *)sender;

@end
