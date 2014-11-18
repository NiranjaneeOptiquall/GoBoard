//
//  ERPDetailViewController.h
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ERPTask.h"
#import "ERPSubcategory.h"
#import "ERPCategory.h"
#import "ERPHistory.h"
#import "ERPHistoryTask.h"

@interface ERPDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, DatePickerDelegate> {
    BOOL isUpdate;
    NSInteger selectedRow;
}
@property (weak, nonatomic) IBOutlet UILabel *lblERPTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtTimeStart;
@property (weak, nonatomic) IBOutlet UITextField *txtTimeEnd;
@property (weak, nonatomic) IBOutlet UITableView *tblActionsTaken;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRecords;

@property (nonatomic, weak) ERPSubcategory *erpSubcategory;
@property (nonatomic, weak) NSDictionary *dictCategory;
@property (nonatomic, assign) NSInteger selectedIndex;

- (IBAction)btnSubmitTapped:(id)sender;
- (IBAction)btnTimeStartTapped:(id)sender;
- (IBAction)btnTimeEndTapped:(id)sender;
- (IBAction)btnBackTapped:(id)sender;

@end
