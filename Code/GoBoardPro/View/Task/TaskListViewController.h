//
//  TaskListViewController.h
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface TaskListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPopoverControllerDelegate, UITextViewDelegate, DropDownValueDelegate,UIPopoverPresentationControllerDelegate,UIViewControllerTransitioningDelegate,UIWebViewDelegate> {
    NSArray *mutArrTaskList;
    NSArray *mutArrTaskUptoNx2Hrs;
    NSArray *mutArrFilteredTaskList;
    UIPopoverController *popOver;
    UIPopoverController *popOverOtherLink;
    UIPopoverController *popOverMessage;
    NSInteger editingIndex;
    BOOL isUpdate;
    NSString *strPreviousText;
}

@property (weak, nonatomic) IBOutlet UITableView *tblTaskList;
@property (weak, nonatomic) IBOutlet UIButton *btnHideCompleted;
@property (weak, nonatomic) IBOutlet UILabel *lblTaskRemaining;
@property (weak, nonatomic) IBOutlet UIView *vwDetailPopOver;
@property (weak, nonatomic) IBOutlet UILabel *lblDetailTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDetailDesc;
@property (strong, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblStartAndEndTime;

@property (weak, nonatomic) IBOutlet UIView *vwMessagePopOver;
@property (weak, nonatomic) IBOutlet UILabel *lblPopOverTaskTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPopOverTaskLocation;
@property (weak, nonatomic) IBOutlet UITextView *txvPopOverMessage;
@property (weak, nonatomic) IBOutlet UIWebView *webPopOverMessage;

@property (strong, nonatomic) IBOutlet UIView *vwPopOverOtherLink;
@property (weak, nonatomic) IBOutlet UIWebView *webViewPopOverOtherLink;

@property (weak, nonatomic) IBOutlet UILabel *lblPopOverTime;
@property (weak, nonatomic) IBOutlet UILabel *lblTask;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRecords;

@property (nonatomic, retain) IBOutlet UIButton *btnCommentTask;
@property (nonatomic, retain) IBOutlet UIButton *btnCommentGoBoardGroup;
@property (nonatomic, retain) IBOutlet UIButton *btnCommentBuildingSupervisor;
@property (nonatomic, retain) IBOutlet UIButton *btnCommentAreaSupervisor;
@property (nonatomic, retain) IBOutlet UIButton *btnCommentWorkOrder;

- (IBAction)btnHideCompletedTapped:(UIButton *)sender;
- (IBAction)btnSubmitTapped:(id)sender;
- (IBAction)btnToggleTaskAndCountTapped:(id)sender;
- (IBAction)btnBackTapped:(id)sender;

- (IBAction)btnPopOverTaskTapped:(UIButton *)sender;
@end
