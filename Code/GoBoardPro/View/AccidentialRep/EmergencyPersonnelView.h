//
//  EmergencyPersonnelView.h
//  GoBoardPro
//
//  Created by ind558 on 30/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface EmergencyPersonnelView : UIView <DatePickerDelegate> {
    NSArray *requiredFields;
}

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
@property (weak, nonatomic) IBOutlet UITextView *txvAdditionalInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblAdditionalInfo;

@property (weak, nonatomic) IBOutlet UILabel *marker911Called;
@property (weak, nonatomic) IBOutlet UILabel *markerArrivalTime;
@property (weak, nonatomic) IBOutlet UILabel *markerDepartureTime;
@property (weak, nonatomic) IBOutlet UILabel *markerCaseNumber;
@property (weak, nonatomic) IBOutlet UILabel *markerFirstName;
@property (weak, nonatomic) IBOutlet UILabel *markerMI;
@property (weak, nonatomic) IBOutlet UILabel *markerLastName;
@property (weak, nonatomic) IBOutlet UILabel *markerPhone;
@property (weak, nonatomic) IBOutlet UILabel *markerBadgeNumber;

@property (strong, nonatomic) IBOutlet UIView *vwResponse;
@property (strong, nonatomic) IBOutlet UIView *vwPersonnel;



- (IBAction)btnEmergencyPersonnelTapped:(UIButton *)sender;
- (BOOL)isEmergencyPersonnelValidationSucceed;
- (void)setRequiredFields:(NSArray*)fields;
@end
