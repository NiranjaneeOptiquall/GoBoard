//
//  FinalSection.h
//  GoBoardPro
//
//  Created by ind558 on 30/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignatureView.h"

@class AccidentReportViewController;
@interface FinalSection : UIView<UITextFieldDelegate,UIAlertViewDelegate> {
    NSInteger totalWitnessCount;
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
@property (weak, nonatomic) IBOutlet UITextView *txvAdditionalInformation;
@property (weak, nonatomic) IBOutlet UILabel *lblAdditionalInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnFinalSubmit;
@property (weak, nonatomic) IBOutlet UIView *vwEmpCompProcedure;
@property (weak, nonatomic) IBOutlet UIView *vwFollowup;
@property (weak, nonatomic) IBOutlet UITextField *txtManagementFollowUpDate;
@property (weak, nonatomic) IBOutlet UIView *vwSubmit;
@property (weak, nonatomic) IBOutlet UIView *vwCommunication;
@property (weak, nonatomic) IBOutlet UIView *vwManagementFollowUp;
@property (weak, nonatomic) IBOutlet UILabel *lblReportFilerAccount;
@property (weak, nonatomic) IBOutlet UITextView *txvReportFilerAccount;

@property (weak, nonatomic) IBOutlet UILabel *markerEmpFName;
@property (weak, nonatomic) IBOutlet UILabel *markerEmpMI;
@property (weak, nonatomic) IBOutlet UILabel *markerEmpLName;
@property (weak, nonatomic) IBOutlet UILabel *markerEmpPhone;
@property (weak, nonatomic) IBOutlet UILabel *markerEmpAltPhone;
@property (weak, nonatomic) IBOutlet UILabel *markerEmpEmail;

@property (strong, nonatomic) NSMutableArray *mutArrWitnessViews;

@property (assign, nonatomic) BOOL isCommunicationVisible;
@property (assign, nonatomic) BOOL isManagementFollowUpVisible;

@property (weak, nonatomic) AccidentReportViewController *parentVC;

@property (strong, nonatomic) SignatureView *signatureView;


@property (strong, nonatomic) IBOutlet UIButton *btnAddWitness;
@property (strong, nonatomic) IBOutlet UIButton *btnRemoveWitness;
- (IBAction)btnAddMoreWitnessTapped:(id)sender;
- (IBAction)btnDeleteWitnessTapped:(UIButton *)sender;
- (IBAction)btnCommunicationTapped:(UIButton *)sender;
- (IBAction)btnSentToInsuranceTapped:(UIButton *)sender;
- (IBAction)btnProcedureFollowedTapped:(UIButton *)sender;
- (IBAction)btnCallMadeTapped:(UIButton *)sender;
- (void)PersonInvolved:(NSInteger)person;
- (void)setupEmployeeRequiredFields:(NSArray*)aryFields;
- (BOOL)isFinalSectionValidationSuccessWith:(NSArray *)aryFields;
- (void)addWitnessView;
@end
