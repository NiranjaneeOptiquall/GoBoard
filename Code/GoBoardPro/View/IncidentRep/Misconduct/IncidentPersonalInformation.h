//
//  IncidentPersonalInformation.h
//  GoBoardPro
//
//  Created by ind558 on 01/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "IncidentReportInfo.h"
#import "Constants.h"
#import "IncidentDetailViewController.h"
#import "ThirdSection.h"
#import "SignatureView.h"

@interface IncidentPersonalInformation : UIView<UIPopoverControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, DropDownValueDelegate,ThirdSectionFrameDelegate, UITextFieldDelegate,UITextViewDelegate> {
    UIPopoverController *popOver;
    NSArray *requiredFields;
    NSInteger totalEmergencyPersonnelCount;
}
@property (weak, nonatomic) ThirdSection *thirdSection;
@property (strong, nonatomic)  NSMutableArray *mutArrEmergencyPersonnel;
@property (strong, nonatomic) IncidentDetailViewController *parentVC;
@property (weak, nonatomic) IBOutlet UIView *vwPersonalInvolved;
@property (weak, nonatomic) IBOutlet UIButton *btnMember;
@property (weak, nonatomic) IBOutlet UIButton *btnGuest;
@property (weak, nonatomic) IBOutlet UIButton *btnEmployee;
@property (weak, nonatomic) IBOutlet UIView *vwAffiliation;
@property (weak, nonatomic) IBOutlet UIButton *btnNonAssessedStudent;
@property (weak, nonatomic) IBOutlet UIButton *btnAssessedStudent;
@property (weak, nonatomic) IBOutlet UIButton *btnAlumni;
@property (weak, nonatomic) IBOutlet UIButton *btnStaff;
@property (weak, nonatomic) IBOutlet UIButton *btnCommunity;
@property (weak, nonatomic) IBOutlet UIButton *btnOther;
@property (weak, nonatomic) IBOutlet UIView *vwMemberId;
@property (weak, nonatomic) IBOutlet UITextField *txtMemberId;
@property (weak, nonatomic) IBOutlet UIView *vwEmpPosition;
@property (weak, nonatomic) IBOutlet UITextField *txtEmployeePosition;
@property (weak, nonatomic) IBOutlet UIView *vwPersonalInfo;
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
@property (weak, nonatomic) IBOutlet UIView *vwDob;
@property (weak, nonatomic) IBOutlet UITextField *txtDob;
@property (weak, nonatomic) IBOutlet UIView *vwGuest;
@property (weak, nonatomic) IBOutlet UITextField *txtGuestFName;
@property (weak, nonatomic) IBOutlet UITextField *txtguestLName;
@property (weak, nonatomic) IBOutlet UITextField *txtGuestMI;
@property (weak, nonatomic) IBOutlet UIView *vwEmployee;
@property (weak, nonatomic) IBOutlet UIButton *btnEmployeeOnWork;
@property (weak, nonatomic) IBOutlet UIButton *btnEmployeeNotOnWork;
@property (weak, nonatomic) IBOutlet UIView *vwCommon;
@property (weak, nonatomic) IBOutlet UIView *vwGender;
@property (weak, nonatomic) IBOutlet UIButton *btnMale;
@property (weak, nonatomic) IBOutlet UIButton *btnFemale;
@property (weak, nonatomic) IBOutlet UIButton *btnNeutral;
@property (weak, nonatomic) IBOutlet UIButton *btnOtherGender;
@property (weak, nonatomic) IBOutlet UIView *vwMinor;
@property (weak, nonatomic) IBOutlet UIButton *btnNotMinor;
@property (weak, nonatomic) IBOutlet UIButton *btnMinor;

@property (weak, nonatomic) IBOutlet UIView *vwEmergencyPersonnel;
-(void)addEmergencyPersonnel;


@property (weak, nonatomic) IBOutlet UIButton *btnCapturePerson;

@property (weak, nonatomic) IBOutlet UILabel *markerMemberId;
@property (weak, nonatomic) IBOutlet UILabel *markerEmployeeTitle;
@property (weak, nonatomic) IBOutlet UILabel *markerFirstName;
@property (weak, nonatomic) IBOutlet UILabel *markerMI;
@property (weak, nonatomic) IBOutlet UILabel *markerLastName;
@property (weak, nonatomic) IBOutlet UILabel *markerAddress1;
@property (weak, nonatomic) IBOutlet UILabel *markerAddress2;
@property (weak, nonatomic) IBOutlet UILabel *markerCity;
@property (weak, nonatomic) IBOutlet UILabel *markerState;
@property (weak, nonatomic) IBOutlet UILabel *markerZip;
@property (weak, nonatomic) IBOutlet UILabel *markerPhone;
@property (weak, nonatomic) IBOutlet UILabel *markerAlternatePhone;
@property (weak, nonatomic) IBOutlet UILabel *markerEmail;
@property (weak, nonatomic) IBOutlet UILabel *markerDOB;
@property (weak, nonatomic) IBOutlet UILabel *markerGuestFName;
@property (weak, nonatomic) IBOutlet UILabel *markerGuestMI;
@property (weak, nonatomic) IBOutlet UILabel *markerGuestLName;

@property (assign, nonatomic) BOOL isAffiliationVisible;
@property (assign, nonatomic) BOOL isMemberIdVisible;
@property (assign, nonatomic) BOOL isGuestIdVisible;
@property (assign, nonatomic) BOOL isEmployeeIdVisible;
@property (assign, nonatomic) BOOL isDOBVisible;
@property (assign, nonatomic) BOOL isGenderVisible;
@property (assign, nonatomic) BOOL isMinorVisible;
@property (assign, nonatomic) BOOL isCapturePhotoVisible;
@property (assign, nonatomic) BOOL isConditionVisible;


@property (assign, nonatomic) NSInteger intPersonInvolved;
@property (assign, nonatomic) NSInteger intAffiliationType;
@property (assign, nonatomic) NSString * intGenderType;


@property (strong, nonatomic) IBOutlet UIView *vwIncidentDetail;
@property (weak, nonatomic) IBOutlet UITextField *txtActivity;
@property (weak, nonatomic) IBOutlet UIView *vwConditions;
@property (weak, nonatomic) IBOutlet UITextField *txtWeather;
@property (weak, nonatomic) IBOutlet UITextField *txtEquipment;

@property (weak, nonatomic) IBOutlet UIView *vwNatureOfIncident;
@property (weak, nonatomic) IBOutlet UITextField *txtChooseIncident;
@property (weak, nonatomic) IBOutlet UITextField *txtActionTaken;

@property (strong, nonatomic) UIImage *imgIncidentPerson;

@property (strong, nonatomic) SignatureView *signatureViewGaurdian;
@property (weak, nonatomic) IBOutlet UIView *vwMinorParentInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnParentContactedYes;
@property (weak, nonatomic) IBOutlet UIButton *btnParentContactedNo;
@property (weak, nonatomic) IBOutlet UIButton *btnParentSignature;
@property (weak, nonatomic) IBOutlet UITextField *txtParentFName;
@property (weak, nonatomic) IBOutlet UITextField *txtParentMName;
@property (weak, nonatomic) IBOutlet UITextField *txtParentLName;
@property (weak, nonatomic) IBOutlet UITextField *txtRelationshipWithMinor;
@property (weak, nonatomic) IBOutlet UITextView *txtMinorAdditionalInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblMinorAdditionalInfo;
@property (weak, nonatomic) IBOutlet UIView *vwParentName;
@property (weak, nonatomic) IBOutlet UIView *vwParentRelation;
@property (weak, nonatomic) IBOutlet UIView *vwParentAddInfo;
@property (weak, nonatomic) IBOutlet UIView *vwParentContacted;
@property (weak, nonatomic) IBOutlet UILabel *lblGenderTitle;

@property (assign, nonatomic) BOOL isGenderMVisible;
@property (assign, nonatomic) BOOL isGenderFVisible;
@property (assign, nonatomic) BOOL isGenderNVisible;
@property (assign, nonatomic) BOOL isGenderOVisible;

@property (assign, nonatomic) BOOL isGuardianContactedVisible;
@property (assign, nonatomic) BOOL isGuardianNameVisible;
@property (assign, nonatomic) BOOL isGuardianRelationVisible;
@property (assign, nonatomic) BOOL isGuardianSignatureVisible;
@property (assign, nonatomic) BOOL isGuardianAddInfoVisible;
@property (assign, nonatomic) NSString * strMale;
@property (assign, nonatomic) NSString * strFemale;
@property (assign, nonatomic) NSString * strNutrel;
@property (assign, nonatomic) NSString * strOther;


- (IBAction)btnPersonInvolvedTapped:(UIButton *)sender;
- (IBAction)btnAffiliationTapped:(UIButton *)sender;
- (IBAction)btnWasEmployeeOnWorkTapped:(UIButton *)sender;
- (IBAction)btnGenderTapped:(UIButton *)sender;
- (IBAction)btnIsMinorTapped:(UIButton *)sender;
- (IBAction)btnGaurdianContactedTapped:(UIButton *)sender;
- (IBAction)btnCapturePersonPic:(id)sender;
- (BOOL)isPersonalInfoValidationSuccess;
- (void)setRequiredFields:(NSArray*)fields;

- (void)callInitialActions:(IncidentReportInfo*)reportSetupInfo;

- (void)populateEmergencyPersonnel:(NSArray*)aryEmergency;
@end
