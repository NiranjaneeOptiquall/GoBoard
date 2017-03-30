//
//  AccidentReportViewController.h
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ThirdSection.h"
#import "FinalSection.h"
#import "AccidentReportInfo.h"
#import "UserLocation.h"
#import "UserFacility.h"

@interface AccidentReportViewController : UIViewController<DropDownValueDelegate,UIAlertViewDelegate> {
    
    FinalSection *finalSection;
    NSMutableArray *mutArrAccidentViews;
    NSInteger totalAccidentFirstSectionCount;
    NSArray *aryFacilities, *aryLocation;
    UserFacility *selectedFacility;
    UserLocation *selectedLocation;
}


@property (weak, nonatomic) IBOutlet UIScrollView *scrlMainView;
@property (weak, nonatomic) IBOutlet UILabel *lblInstruction;
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
@property (strong, nonatomic) IBOutlet UILabel *lblDisclaimer;
@property (strong, nonatomic) IBOutlet UILabel *lblDisclaimerDetail;
@property (weak, nonatomic) IBOutlet UIView *vwBasicDetail;
@property (weak, nonatomic) IBOutlet UIView *vwFirstSection;
@property (weak, nonatomic) IBOutlet UIView *vwAddMoreFirstSection;
@property (strong, nonatomic) IBOutlet UIButton *btnAddMorePerson;
@property (strong, nonatomic) IBOutlet UIButton *btnRemovePerson;


@property (assign, nonatomic) NSInteger personInvolved;

@property (strong, nonatomic) AccidentReportInfo *reportSetupInfo;
@property (assign, nonatomic) BOOL isUpdate;


- (IBAction)btnAddMoreBodilyFluidTapped:(id)sender;
- (IBAction)btnDeleteRecentlyaddedPersonInvolved:(UIButton *)sender;


- (IBAction)btnBackTapped:(id)sender;

- (IBAction)btnNotificationTapped:(UIButton *)sender;
@end
