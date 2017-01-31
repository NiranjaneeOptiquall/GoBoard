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
#import "AccidentReportViewController.h"
#import "ThirdSection.h"

@interface BodilyFluidView : UIView <UITextFieldDelegate,ThirdSectionFrameDelegate> {
   
}
@property (weak, nonatomic) ThirdSection *thirdSection;
@property (weak, nonatomic) IBOutlet UIView *vwBloodbornePathogens;
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
@property (weak, nonatomic) IBOutlet UIButton *btnSignature;

@property (weak, nonatomic) IBOutlet UITextView *txvStaffMemberAccount;
@property (weak, nonatomic) IBOutlet UILabel *lblStaffMemberAccount;
@property (strong, nonatomic) SignatureView *signatureView;

@property (weak, nonatomic) AccidentReportViewController *parentVC;
@property (weak, nonatomic) IBOutlet UIView *vwFirstAid;
@property (weak, nonatomic) IBOutlet UIView *vwBloodborne;
@property (weak, nonatomic) IBOutlet UIView *vwRefuseCare;
@property (weak, nonatomic) IBOutlet UIView *vwSelfCare;
@property (weak, nonatomic) IBOutlet UILabel *lblRefuseCareText;
@property (weak, nonatomic) IBOutlet UILabel *lblSelfCareText;
@property (weak, nonatomic) IBOutlet UIView *vwParticipantSignature;
@property (weak, nonatomic) IBOutlet UIView *vwStaffMember;
@property (weak, nonatomic) IBOutlet UILabel *lblRefuseCareCaption;
@property (weak, nonatomic) IBOutlet UILabel *lblSelfCareCaption;
@property (weak, nonatomic) IBOutlet UIView *vwEmergencyPersonnel;

@property (weak, nonatomic) IBOutlet UILabel *markerFName;
@property (weak, nonatomic) IBOutlet UILabel *markerMI;
@property (weak, nonatomic) IBOutlet UILabel *markerLName;
@property (weak, nonatomic) IBOutlet UILabel *markerPosition;

@property (assign, nonatomic) BOOL isBloodBornePathogenVisible;
@property (assign, nonatomic) BOOL isFirstAidVisible;
@property (assign, nonatomic) BOOL isRefuseCareStatementVisible;
@property (assign, nonatomic) BOOL isRefusedCareSelected;
@property (assign, nonatomic) BOOL isSelfCareStatementVisible;
@property (assign, nonatomic) BOOL isSelfCareSelected;
@property (assign, nonatomic) BOOL isParticipantSignatureVisible;
@property (assign, nonatomic) BOOL isEmergencyPersonnelVisible;
@property (assign, nonatomic) BOOL isEmergencyResponseSelected;


@property (assign, nonatomic) NSInteger intBloodBornePathogen;

- (IBAction)btnBloodbornePathogenTapped:(id)sender;
- (IBAction)btnExposedToBloodTapped:(UIButton *)sender;
- (IBAction)btnBloodCleanUpRequiredTapped:(id)sender;
- (IBAction)btnWasBloodPresentTapped:(UIButton *)sender;
- (IBAction)btnSignatureTapped:(id)sender;
- (void)setRequiredFields:(NSArray*)fields;
- (BOOL)isBodilyFluidValidationSucceedWith:(NSArray*)fields;

- (void)shouldShowFirstAddView:(BOOL)show;
- (void)shouldShowParticipantsSignatureView:(BOOL)show;
- (void)shouldShowEmergencyPersonnelView:(BOOL)show;

- (void)populateEmergencyPersonnel:(NSArray*)aryEmergency;
@end
