//
//  ToolsViewController.h
//  GoBoardPro
//
//  Created by ind558 on 07/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface ToolsViewController : UIViewController <UITextFieldDelegate, DropDownValueDelegate> {
    NSInteger totalDropDownFields;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrlMainView;
@property (weak, nonatomic) IBOutlet UIButton *btnSetUpActionAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnSetUpActionEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnSetUpActionCopy;
@property (weak, nonatomic) IBOutlet UITextField *txtSelectTask;
@property (weak, nonatomic) IBOutlet UIImageView *imvSelectTaskBG;
@property (weak, nonatomic) IBOutlet UITextField *txtPosition;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UITextField *txtFacility;
@property (weak, nonatomic) IBOutlet UITextField *txtTaskTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtPopUpDesc;
@property (weak, nonatomic) IBOutlet UIButton *btnSop;
@property (weak, nonatomic) IBOutlet UITextField *txtSop;
@property (weak, nonatomic) IBOutlet UIButton *btnYesNo;
@property (weak, nonatomic) IBOutlet UIButton *btnNumeric;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckBox;
@property (weak, nonatomic) IBOutlet UIButton *btnTextBox;
@property (weak, nonatomic) IBOutlet UIButton *btnDropDown;
@property (weak, nonatomic) IBOutlet UIView *vwDropDownList;
@property (weak, nonatomic) IBOutlet UIButton *btnAddDropdownField;
@property (weak, nonatomic) IBOutlet UIView *vwHowOften;
@property (weak, nonatomic) IBOutlet UIView *vwFormBack;

@property (weak, nonatomic) IBOutlet UIView *vwDaily;
@property (weak, nonatomic) IBOutlet UIButton *btnDaily;
@property (weak, nonatomic) IBOutlet UIButton *btnDailyStartTime;
@property (weak, nonatomic) IBOutlet UITextField *txtDailyStartTime;
@property (weak, nonatomic) IBOutlet UIButton *btnDailyEvery;
@property (weak, nonatomic) IBOutlet UITextField *txtDailyEvery;
@property (weak, nonatomic) IBOutlet UITextField *txtDailyDays;
@property (weak, nonatomic) IBOutlet UIButton *btnDailyEveryWeekdays;

@property (weak, nonatomic) IBOutlet UIView *vwWeekly;
@property (weak, nonatomic) IBOutlet UIButton *btnWeekly;
@property (weak, nonatomic) IBOutlet UIButton *btnWeekEvery;
@property (weak, nonatomic) IBOutlet UITextField *txtWeekEvery;
@property (weak, nonatomic) IBOutlet UIButton *btnWeekSunday;
@property (weak, nonatomic) IBOutlet UIButton *btnWeekMonday;
@property (weak, nonatomic) IBOutlet UIButton *btnWeekTuesday;
@property (weak, nonatomic) IBOutlet UIButton *btnWeekWednesday;
@property (weak, nonatomic) IBOutlet UIButton *btnWeekThursday;
@property (weak, nonatomic) IBOutlet UIButton *btnWeekFriday;
@property (weak, nonatomic) IBOutlet UIButton *btnWeekSaturday;

@property (weak, nonatomic) IBOutlet UIView *vwMonthly;
@property (weak, nonatomic) IBOutlet UIButton *btnMonthly;
@property (weak, nonatomic) IBOutlet UIButton *btnMonthlyDay;
@property (weak, nonatomic) IBOutlet UITextField *txtMonthDay;
@property (weak, nonatomic) IBOutlet UITextField *txtEveryMonth;
@property (weak, nonatomic) IBOutlet UIButton *btnMonthThe;
@property (weak, nonatomic) IBOutlet UITextField *txtMonthThe;
@property (weak, nonatomic) IBOutlet UITextField *txtMonthWeekday;
@property (weak, nonatomic) IBOutlet UITextField *txtMonthEveryThe;

@property (weak, nonatomic) IBOutlet UIView *vwYearly;
@property (weak, nonatomic) IBOutlet UIButton *btnYearly;
@property (weak, nonatomic) IBOutlet UITextField *txtEveryYear;
@property (weak, nonatomic) IBOutlet UIButton *btnOn;
@property (weak, nonatomic) IBOutlet UITextField *txtYearMonth;
@property (weak, nonatomic) IBOutlet UITextField *txtYearDate;
@property (weak, nonatomic) IBOutlet UIButton *btnOnThe;
@property (weak, nonatomic) IBOutlet UITextField *txtOnThe;
@property (weak, nonatomic) IBOutlet UITextField *txtYearWeekday;
@property (weak, nonatomic) IBOutlet UITextField *txtYearOnTheMonth;

@property (weak, nonatomic) IBOutlet UIView *vwNotification;
@property (weak, nonatomic) IBOutlet UIButton *btnNotifyNone;
@property (weak, nonatomic) IBOutlet UIButton *btnNotifyOneCycle;
@property (weak, nonatomic) IBOutlet UIButton *btnNotifyTwoCycle;
@property (weak, nonatomic) IBOutlet UIButton *btnNotifyThreeCycle;
@property (weak, nonatomic) IBOutlet UITextField *txtNotificationEmailGroup;

- (IBAction)btnSetUpActionTapped:(UIButton *)sender;
- (IBAction)btnSopTapped:(id)sender;
- (IBAction)btnTaskAnswerTypeTapped:(UIButton *)sender;
- (IBAction)btnAddDropdownFieldTapped:(id)sender;
- (IBAction)btnDailyTapped:(UIButton *)sender;
- (IBAction)btnDailyStartTimeTapped:(UIButton *)sender;
- (IBAction)btnDailyEveryTapped:(UIButton *)sender;
- (IBAction)btnDailyEveryWeekdayTapped:(UIButton *)sender;
- (IBAction)btnWeeklyTapped:(UIButton *)sender;
- (IBAction)btnWeeklyEveryTapped:(UIButton *)sender;
- (IBAction)btnWeekDayTapped:(UIButton *)sender;
- (IBAction)btnMonthlyTapped:(UIButton *)sender;
- (IBAction)btnMonthDayTapped:(UIButton *)sender;
- (IBAction)btnMonthTheTapped:(UIButton *)sender;
- (IBAction)btnYearlyTapped:(UIButton *)sender;
- (IBAction)btnYearlyOnTapped:(UIButton *)sender;
- (IBAction)btnYearlyOnTheTapped:(UIButton *)sender;
- (IBAction)btnNotificationOptionTapped:(UIButton *)sender;
- (IBAction)btnSubmitTapped:(id)sender;

- (IBAction)unwindBackToToolsScreen:(UIStoryboardSegue*)segue;
@end
