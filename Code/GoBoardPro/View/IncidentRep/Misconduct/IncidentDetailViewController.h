//
//  MisconductIncidentViewController.h
//  GoBoardPro
//
//  Created by ind558 on 25/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IncidentActionTaken.h"
#import "Constants.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "IncidentReportInfo.h"
#import "UserLocation.h"
#import "UserFacility.h"

@interface IncidentDetailViewController : UIViewController<DropDownValueDelegate, UITextViewDelegate> {
    NSInteger totalPersonCount, totalWitnessCount;
    IncidentActionTaken *actionTaken;
    NSMutableArray *mutArrIncidentPerson, *mutArrWitnessView;
    
    NSArray *aryFacilities, *aryLocation;
    UserFacility *selectedFacility;
    UserLocation *selectedLocation;
    
    NSInteger intFollowUpCallType;
    
    NSString *strReportType;
}
@property (weak, nonatomic)  IncidentReportInfo *reportSetupInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblIncidentTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblInstruction;
@property (weak, nonatomic) IBOutlet UIImageView *imvIncidentIcon;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlMainView;

@property (weak, nonatomic) IBOutlet UIView *vwPersonalInfo;
@property (strong, nonatomic) IBOutlet UIButton *btnAddmorePerson;
@property (strong, nonatomic) IBOutlet UIButton *btnRemovePerson;


@property (weak, nonatomic) IBOutlet UIView *vwAfterPersonalInfo;
@property (weak, nonatomic) IBOutlet UIView *vwConditions;
@property (weak, nonatomic) IBOutlet UIView *vwNatureOfIncident;

@property (weak, nonatomic) IBOutlet UIView *vwWitnesses;
@property (weak, nonatomic) IBOutlet UIButton *btnAddWitness;
@property (strong, nonatomic) IBOutlet UIButton *btnRemoveWitness;
@property (weak, nonatomic) IBOutlet UIView *vwEmployeeInfo;
@property (weak, nonatomic) IBOutlet UITextField *txtEmpFName;

@property (weak, nonatomic) IBOutlet UITextField *txtEmpMI;
@property (weak, nonatomic) IBOutlet UITextField *txtEmpLName;
@property (weak, nonatomic) IBOutlet UITextView *txtReportAccount;
@property (weak, nonatomic) IBOutlet UITextField *txtManagementFollowUp;
@property (weak, nonatomic) IBOutlet UIButton *btnYesCall;
@property (weak, nonatomic) IBOutlet UIButton *btnNoCall;
@property (weak, nonatomic) IBOutlet UIButton *btnCallNotReq;
@property (weak, nonatomic) IBOutlet UITextView *txvAdditionalInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblAdditonInfo;
@property (weak, nonatomic) IBOutlet UIView *vwBasicInfo;
@property (weak, nonatomic) IBOutlet UIView *vwSubmit;
@property (weak, nonatomic) IBOutlet UITextField *txtDateOfIncident;
@property (weak, nonatomic) IBOutlet UITextField *txtTimeOfIncident;
@property (weak, nonatomic) IBOutlet UITextField *txtFacility;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UITextView *txvIncidentDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblIncidentDesc;
@property (weak, nonatomic) IBOutlet UITextField *txtActivity;
@property (weak, nonatomic) IBOutlet UITextField *txtWeather;
@property (weak, nonatomic) IBOutlet UITextField *txtEquipment;
@property (weak, nonatomic) IBOutlet UITextField *txtChooseIncident;
@property (weak, nonatomic) IBOutlet UITextField *txtActionTaken;
@property (weak, nonatomic) IBOutlet UIView *vwManagementFollowUp;

@property (weak, nonatomic) IBOutlet UIButton *btn911Called;
@property (weak, nonatomic) IBOutlet UIButton *btnPoliceCalled;
@property (weak, nonatomic) IBOutlet UIButton *btnManager;
@property (weak, nonatomic) IBOutlet UIButton *btnNone;

@property (weak, nonatomic) IBOutlet UILabel *lblReportFilerPlaceHolder;
@property (weak, nonatomic) IBOutlet UITextField *txtEmpAlternatePhone;
@property (weak, nonatomic) IBOutlet UITextField *txtEmpHomePhone;
@property (weak, nonatomic) IBOutlet UITextField *txtEmpEmail;

@property (weak, nonatomic) IBOutlet UILabel *markerEmpFName;
@property (weak, nonatomic) IBOutlet UILabel *markerEmpMI;
@property (weak, nonatomic) IBOutlet UILabel *markerEmpLName;
@property (weak, nonatomic) IBOutlet UILabel *markerEmpPhone;
@property (weak, nonatomic) IBOutlet UILabel *markerEmpAltPhone;
@property (weak, nonatomic) IBOutlet UILabel *markerEmpEmail;

@property (assign, nonatomic) BOOL isUpdate;
@property (nonatomic, assign) NSInteger incidentType;

- (IBAction)btnAddPersonTapped:(id)sender;
- (IBAction)btnDeletePersonTapped:(UIButton *)sender;

- (IBAction)btnAddWitnessTapped:(id)sender;
- (IBAction)btnDeleteWitnessTapped:(UIButton *)sender;


- (IBAction)btnFollowUpCallTapped:(UIButton *)sender;
- (IBAction)btnNotificationTapped:(UIButton *)sender;
- (IBAction)btnSubmitTapped:(id)sender;

- (IBAction)btnBackTapped:(id)sender;

- (void)viewSetup;

@end
