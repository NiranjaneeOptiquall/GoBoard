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

@interface IncidentDetailViewController : UIViewController<DropDownValueDelegate, UIActionSheetDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate> {
    NSInteger totalPersonCount, totalEmergencyPersonnelCount, totalWitnessCount;
    IncidentActionTaken *actionTaken;
    NSMutableArray *mutArrIncidentPerson, *mutArrEmergencyPersonnel, *mutArrWitnessView;
    UIPopoverController *popOver;
}
@property (weak, nonatomic) IBOutlet UILabel *lblIncidentTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imvIncidentIcon;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlMainView;

@property (weak, nonatomic) IBOutlet UIView *vwPersonalInfo;
@property (weak, nonatomic) IBOutlet UIView *vwAfterPersonalInfo;
@property (weak, nonatomic) IBOutlet UIView *vwEmergencyPersonnel;
@property (weak, nonatomic) IBOutlet UIButton *btnAddEmergency;
@property (weak, nonatomic) IBOutlet UIView *vwWitnesses;
@property (weak, nonatomic) IBOutlet UIButton *btnAddWitness;
@property (weak, nonatomic) IBOutlet UIView *vwEmployeeInfo;
@property (weak, nonatomic) IBOutlet UITextField *txtEmpFName;

@property (weak, nonatomic) IBOutlet UITextField *txtEmpMI;
@property (weak, nonatomic) IBOutlet UITextField *txtEmpLName;
@property (weak, nonatomic) IBOutlet UITextView *txtReportAccount;
@property (weak, nonatomic) IBOutlet UITextField *txtManagementFollowUp;
@property (weak, nonatomic) IBOutlet UIButton *btnYesCall;
@property (weak, nonatomic) IBOutlet UIButton *btnNoCall;
@property (weak, nonatomic) IBOutlet UIButton *btnCallNotReq;
@property (weak, nonatomic) IBOutlet UITextField *txtAdditionalInfo;
@property (weak, nonatomic) IBOutlet UIView *vwBasicInfo;
@property (weak, nonatomic) IBOutlet UIView *vwSubmit;
@property (weak, nonatomic) IBOutlet UITextField *txtDateOfIncident;
@property (weak, nonatomic) IBOutlet UITextField *txtTimeOfIncident;
@property (weak, nonatomic) IBOutlet UITextField *txtFacility;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UITextField *txtIncidentDesc;
@property (weak, nonatomic) IBOutlet UITextField *txtActivity;
@property (weak, nonatomic) IBOutlet UITextField *txtWeather;
@property (weak, nonatomic) IBOutlet UITextField *txtEquipment;
@property (weak, nonatomic) IBOutlet UITextField *txtChooseIncident;

@property (weak, nonatomic) IBOutlet UIButton *btn911Called;
@property (weak, nonatomic) IBOutlet UIButton *btnPoliceCalled;
@property (weak, nonatomic) IBOutlet UIButton *btnManager;
@property (weak, nonatomic) IBOutlet UIButton *btnNone;
@property (weak, nonatomic) IBOutlet UIButton *btnCapturePerson;
@property (weak, nonatomic) IBOutlet UILabel *lblReportFilerPlaceHolder;



@property (nonatomic, assign) NSInteger incidentType;

- (IBAction)btnAddEmergencyPersonnelTapped:(id)sender;
- (IBAction)btnAddPersonTapped:(id)sender;
- (IBAction)btnAddWitnessTapped:(id)sender;
- (IBAction)btnFollowUpCallTapped:(UIButton *)sender;
- (IBAction)btnNotificationTapped:(UIButton *)sender;
- (IBAction)btnSubmitTapped:(id)sender;
- (IBAction)btnCapturePersonPic:(id)sender;
@end
