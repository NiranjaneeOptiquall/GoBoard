//
//  WitnessView.h
//  GoBoardPro
//
//  Created by ind558 on 30/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface WitnessView : UIView {
    NSArray *requiredFields;
}
@property (weak, nonatomic) IBOutlet UIButton *btnMember;
@property (weak, nonatomic) IBOutlet UIButton *btnGuest;
@property (weak, nonatomic) IBOutlet UIButton *btnEmployee;
@property (weak, nonatomic) IBOutlet UITextField *txtWitnessFName;
@property (weak, nonatomic) IBOutlet UITextField *txtWitnessMI;
@property (weak, nonatomic) IBOutlet UITextField *txtWitnessLName;
@property (weak, nonatomic) IBOutlet UITextField *txtWitnessHomePhone;
@property (weak, nonatomic) IBOutlet UITextField *txtWitnessAlternatePhone;
@property (weak, nonatomic) IBOutlet UITextField *txtWitnessEmailAddress;
@property (weak, nonatomic) IBOutlet UITextView *txvDescIncident;
@property (weak, nonatomic) IBOutlet UILabel *lblWitnessWrittenAccount;
@property (weak, nonatomic) IBOutlet UILabel *markerFirstName;
@property (weak, nonatomic) IBOutlet UILabel *markerMI;
@property (weak, nonatomic) IBOutlet UILabel *markerLastName;
@property (weak, nonatomic) IBOutlet UILabel *markerPhone;
@property (weak, nonatomic) IBOutlet UILabel *markerAlternatePhone;
@property (weak, nonatomic) IBOutlet UILabel *markerEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblDescCaption;
@property (weak, nonatomic) IBOutlet UILabel *markerDescription;
@property (assign, nonatomic) NSInteger witnessInvolved;

- (IBAction)btnWitnessStatusTapped:(UIButton*)sender;
- (BOOL)isWitnessViewValidationSuccess;
- (void)setRequiredFields:(NSArray*)fields;
@end
