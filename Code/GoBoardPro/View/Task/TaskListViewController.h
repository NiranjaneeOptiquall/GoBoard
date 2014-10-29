//
//  TaskListViewController.h
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface TaskListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPopoverControllerDelegate, UITextViewDelegate> {
    NSMutableArray *mutArrTaskList;
    NSMutableArray *mutArrFilteredTaskList;
    UIPopoverController *popOver;
    UIPopoverController *popOverMessage;
    NSInteger editingIndex;
    BOOL isUpdate;
    NSString *strPreviousText;
}

@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblFacility;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblPosition;
@property (weak, nonatomic) IBOutlet UITableView *tblTaskList;
@property (weak, nonatomic) IBOutlet UIButton *btnHideCompleted;
@property (weak, nonatomic) IBOutlet UILabel *lblTaskRemaining;
@property (weak, nonatomic) IBOutlet UIView *vwDetailPopOver;
@property (weak, nonatomic) IBOutlet UILabel *lblDetailTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDetailDesc;

@property (weak, nonatomic) IBOutlet UIView *vwMessagePopOver;
@property (weak, nonatomic) IBOutlet UILabel *lblPopOverTaskTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPopOverTaskLocation;
@property (weak, nonatomic) IBOutlet UITextView *txvPopOverMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnTaskComment;
@property (weak, nonatomic) IBOutlet UIButton *btnGoBoardGroup;
@property (weak, nonatomic) IBOutlet UIButton *btnBuildingSupervisor;
@property (weak, nonatomic) IBOutlet UIButton *btnAreaSupervisor;
@property (weak, nonatomic) IBOutlet UIButton *btnWorkOrder;
@property (weak, nonatomic) IBOutlet UILabel *lblTask;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;



- (IBAction)btnHideCompletedTapped:(UIButton *)sender;
- (IBAction)btnToggleToCountTapped:(id)sender;
- (IBAction)btnSubmitTapped:(id)sender;
- (IBAction)btnToggleTaskAndCountTapped:(id)sender;
- (IBAction)btnBackTapped:(id)sender;

- (IBAction)btnPopOverTaskTapped:(UIButton *)sender;
@end
