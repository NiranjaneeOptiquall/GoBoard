//
//  FinalSection.h
//  GoBoardPro
//
//  Created by ind558 on 30/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignatureView.h"

@interface FinalSection : UIView {
    NSInteger totalWitnessCount;
    NSMutableArray *mutArrWitnessViews;
}

@property (weak, nonatomic) IBOutlet UIView *vwFixedContent;
@property (weak, nonatomic) IBOutlet UITextField *txtEmpFName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmpMI;
@property (weak, nonatomic) IBOutlet UITextField *txtEmpLName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmpHomePhone;
@property (weak, nonatomic) IBOutlet UITextField *txtEmpAlternatePhone;
@property (weak, nonatomic) IBOutlet UITextField *txtEmpEmailAddr;
@property (weak, nonatomic) IBOutlet UIButton *btnAdmin;
@property (weak, nonatomic) IBOutlet UIButton *btnSupervisers;
@property (weak, nonatomic) IBOutlet UIButton *btnRiskManagement;
@property (weak, nonatomic) IBOutlet UIButton *btnYesInsurance;
@property (weak, nonatomic) IBOutlet UIButton *btnNoInsurance;
@property (weak, nonatomic) IBOutlet UIButton *btnInsuranceNotReq;
@property (weak, nonatomic) IBOutlet UIButton *btnYesProcedure;
@property (weak, nonatomic) IBOutlet UIButton *btnNoProcedure;
@property (weak, nonatomic) IBOutlet UIButton *btnProcedureNotReq;
@property (weak, nonatomic) IBOutlet UIButton *btnYesCall;
@property (weak, nonatomic) IBOutlet UIButton *btnNoCall;
@property (weak, nonatomic) IBOutlet UIButton *btnCallNotReq;
@property (weak, nonatomic) IBOutlet UITextField *txtAdditionalInformation;
@property (weak, nonatomic) IBOutlet UIButton *btnFinalSubmit;

@property (strong, nonatomic) SignatureView *signatureView;

- (IBAction)btnAddMoreWitnessTapped:(id)sender;
- (IBAction)btnCommunicationTapped:(UIButton *)sender;
- (IBAction)btnSentToInsuranceTapped:(UIButton *)sender;
- (IBAction)btnProcedureFollowedTapped:(UIButton *)sender;
- (IBAction)btnCallMadeTapped:(UIButton *)sender;
- (IBAction)btnSignatureTapped:(id)sender;

- (BOOL)isFinalSectionValidationSuccess;
- (void)addWitnessView;
@end
