//
//  PersonInformation.h
//  GoBoardPro
//
//  Created by ind558 on 29/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface PersonInformation : UIView <UITextFieldDelegate, DropDownValueDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtDateOfIncident;
@property (weak, nonatomic) IBOutlet UITextField *txtTimeOfIncident;
@property (weak, nonatomic) IBOutlet UITextField *txtFacility;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UITextField *txtDescription;
@property (weak, nonatomic) IBOutlet UIButton *btn911Called;
@property (weak, nonatomic) IBOutlet UIButton *btnPoliceCalled;
@property (weak, nonatomic) IBOutlet UIButton *btnManager;
@property (weak, nonatomic) IBOutlet UIButton *btnNone;
@property (weak, nonatomic) IBOutlet UIButton *btnMember;
@property (weak, nonatomic) IBOutlet UIButton *btnGuest;
@property (weak, nonatomic) IBOutlet UIButton *btnEmployee;
@property (weak, nonatomic) IBOutlet UIButton *btnNonAssessedStudent;
@property (weak, nonatomic) IBOutlet UIButton *btnAssessedStudent;
@property (weak, nonatomic) IBOutlet UIButton *btnAlumni;
@property (weak, nonatomic) IBOutlet UIButton *btnStaff;
@property (weak, nonatomic) IBOutlet UIButton *btnCommunity;
@property (weak, nonatomic) IBOutlet UIButton *btnOther;
@property (weak, nonatomic) IBOutlet UITextField *txtMemberId;
@property (weak, nonatomic) IBOutlet UITextField *txtEmployeePosition;
@property (weak, nonatomic) IBOutlet UIImageView *imvEmployeePosBG;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtMi;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtStreetAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtAppartment;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtZip;
@property (weak, nonatomic) IBOutlet UITextField *txtHomePhone;
@property (weak, nonatomic) IBOutlet UITextField *txtAlternatePhone;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtDob;
@property (weak, nonatomic) IBOutlet UIView *vwGuest;
@property (weak, nonatomic) IBOutlet UITextField *txtGuestFName;
@property (weak, nonatomic) IBOutlet UITextField *txtguestLName;
@property (weak, nonatomic) IBOutlet UITextField *txtGuestMI;
@property (weak, nonatomic) IBOutlet UIView *vwEmployee;
@property (weak, nonatomic) IBOutlet UIButton *btnEmployeeOnWork;
@property (weak, nonatomic) IBOutlet UIButton *btnEmployeeNotOnWork;
@property (weak, nonatomic) IBOutlet UIView *vwCommon;
@property (weak, nonatomic) IBOutlet UIButton *btnMale;
@property (weak, nonatomic) IBOutlet UIButton *btnFemale;
@property (weak, nonatomic) IBOutlet UIButton *btnNeutral;
@property (weak, nonatomic) IBOutlet UIButton *btnOtherGender;
@property (weak, nonatomic) IBOutlet UIButton *btnNotMinor;
@property (weak, nonatomic) IBOutlet UIButton *btnMinor;
@property (weak, nonatomic) IBOutlet UITextField *txtActivity;
@property (weak, nonatomic) IBOutlet UITextField *txtWheather;
@property (weak, nonatomic) IBOutlet UITextField *txtEquipment;

- (IBAction)btnNotificationTapped:(UIButton *)sender;
- (IBAction)btnPersonInvolvedTapped:(UIButton *)sender;
- (IBAction)btnAffiliationTapped:(UIButton *)sender;
- (IBAction)btnWasEmployeeOnWorkTapped:(UIButton *)sender;
- (IBAction)btnGenderTapped:(UIButton *)sender;
- (IBAction)btnIsMinorTapped:(UIButton *)sender;

- (BOOL)isPersonalInfoValidationSuccess;
@end
