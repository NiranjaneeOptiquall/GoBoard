//
//  BodilyFluidView.h
//  GoBoardPro
//
//  Created by ind558 on 30/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "SignatureView.h"

@interface BodilyFluidView : UIView <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnBloodPresent;
@property (weak, nonatomic) IBOutlet UIButton *btnBloodNotPresent;
@property (weak, nonatomic) IBOutlet UITextField *txtFName;
@property (weak, nonatomic) IBOutlet UITextField *txtMI;
@property (weak, nonatomic) IBOutlet UITextField *txtLName;
@property (weak, nonatomic) IBOutlet UITextField *txtPosition;
@property (weak, nonatomic) IBOutlet UIButton *btnSelfTreated;
@property (weak, nonatomic) IBOutlet UIButton *btnEmployeeTreated;
@property (weak, nonatomic) IBOutlet UIButton *btnMedicalPersonnelTreated;
@property (weak, nonatomic) IBOutlet UIButton *btnBloodCleanupRequired;
@property (weak, nonatomic) IBOutlet UIButton *btnBloodCleanupNotRequired;
@property (weak, nonatomic) IBOutlet UIButton *btnExposedToBlood;
@property (weak, nonatomic) IBOutlet UIButton *btnNotExposedToBlood;

@property (strong, nonatomic) SignatureView *signatureView;

- (IBAction)btnBloodbornePathogenTapped:(id)sender;
- (IBAction)btnExposedToBloodTapped:(UIButton *)sender;
- (IBAction)btnBloodCleanUpRequiredTapped:(id)sender;
- (IBAction)btnWasBloodPresentTapped:(UIButton *)sender;
- (IBAction)btnSignatureTapped:(id)sender;

- (BOOL)isBodilyFluidValidationSucceed;
@end
