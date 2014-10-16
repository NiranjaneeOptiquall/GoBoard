//
//  EmergencyPersonnelView.h
//  GoBoardPro
//
//  Created by ind558 on 30/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface EmergencyPersonnelView : UIView <DatePickerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtTime911Called;
@property (weak, nonatomic) IBOutlet UITextField *txtTimeOfArrival;
@property (weak, nonatomic) IBOutlet UITextField *txtTimeOfDeparture;
@property (weak, nonatomic) IBOutlet UITextField *txtCaseNo;
@property (weak, nonatomic) IBOutlet UIButton *btnPublicSafety;
@property (weak, nonatomic) IBOutlet UIButton *btnPoliceOfficer;
@property (weak, nonatomic) IBOutlet UIButton *btnEMT;
@property (weak, nonatomic) IBOutlet UIButton *btnFirePersonnel;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtMI;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtBadge;
@property (weak, nonatomic) IBOutlet UITextField *txtAdditionalInfo;

- (IBAction)btnEmergencyPersonnelTapped:(UIButton *)sender;
- (BOOL)isEmergencyPersonnelValidationSucceed;
@end
