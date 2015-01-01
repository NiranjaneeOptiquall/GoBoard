//
//  UtilizationCountViewController.h
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UtilizationCountViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPopoverControllerDelegate> {
    NSMutableArray *mutArrCount;
    NSInteger editingIndex;
    UIPopoverController *popOverMessage;
    BOOL isUpdate;
    NSString *strPreviousText;
}

@property (weak, nonatomic) IBOutlet UITableView *tblCountList;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalCount;
@property (weak, nonatomic) IBOutlet UIView *vwPopOverMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblPopOverLocation;
@property (weak, nonatomic) IBOutlet UITextField *txtPopOverMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnCountComment;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property (weak, nonatomic) IBOutlet UILabel *lblTask;
@property (weak, nonatomic) IBOutlet UILabel *lblPopOverTime;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRecords;
@property (weak, nonatomic) IBOutlet UIButton *btnToggleSummary;

- (IBAction)btnToggleCountAndTaskTapped:(id)sender;
- (IBAction)btnSubmitCountTapped:(id)sender;
- (IBAction)btnCountCommentTapped:(UIButton *)sender;
- (IBAction)btnBackTapped:(id)sender;
- (IBAction)btnToggleSummaryTapped:(UIButton *)sender;
@end
