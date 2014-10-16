//
//  WitnessView.h
//  GoBoardPro
//
//  Created by ind558 on 30/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface WitnessView : UIView
@property (weak, nonatomic) IBOutlet UIButton *btnMember;
@property (weak, nonatomic) IBOutlet UIButton *btnGuest;
@property (weak, nonatomic) IBOutlet UIButton *btnEmployee;
@property (weak, nonatomic) IBOutlet UITextField *txtWitnessFName;
@property (weak, nonatomic) IBOutlet UITextField *txtWitnessMI;
@property (weak, nonatomic) IBOutlet UITextField *txtWitnessLName;
@property (weak, nonatomic) IBOutlet UITextField *txtWitnessHomePhone;
@property (weak, nonatomic) IBOutlet UITextField *txtWitnessAlternatePhone;
@property (weak, nonatomic) IBOutlet UITextField *txtWitnessEmailAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtDescIncident;


- (BOOL)isWitnessViewValidationSuccess;
@end
