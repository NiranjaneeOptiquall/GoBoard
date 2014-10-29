//
//  AccidentReportViewController.h
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccidentFirstSection.h"
#import "PersonInformation.h"
#import "BodyPartInjury.h"
#import "ThirdSection.h"
#import "FinalSection.h"

@interface AccidentReportViewController : UIViewController<DropDownValueDelegate, UIPopoverControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    PersonInformation *personalInfoView;
    BodyPartInjury *bodyPartView;
    ThirdSection *thirdSection;
    FinalSection *finalSection;
    NSMutableArray *mutArrAccidentViews;
    NSInteger totalAccidentFirstSectionCount;
    UIPopoverController *popOver;
    UIImageView *imgBodilyFluid;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrlMainView;
@property (weak, nonatomic) IBOutlet UITextField *txtDateOfIncident;
@property (weak, nonatomic) IBOutlet UITextField *txtTimeOfIncident;
@property (weak, nonatomic) IBOutlet UITextField *txtFacility;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UITextView *txvDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblIncidentDesc;
@property (weak, nonatomic) IBOutlet UIButton *btn911Called;
@property (weak, nonatomic) IBOutlet UIButton *btnPoliceCalled;
@property (weak, nonatomic) IBOutlet UIButton *btnManager;
@property (weak, nonatomic) IBOutlet UIButton *btnNone;
@property (weak, nonatomic) IBOutlet UIView *vwBasicDetail;
@property (weak, nonatomic) IBOutlet UIView *vwFirstSection;
@property (weak, nonatomic) IBOutlet UIView *vwAddMoreFirstSection;
@property (weak, nonatomic) IBOutlet UIButton *btnCaptureImage;


- (IBAction)btnAttachPhotoTapped:(UIButton *)sender;
- (IBAction)btnAddMoreBodilyFluidTapped:(id)sender;

- (IBAction)btnNotificationTapped:(UIButton *)sender;
@end
