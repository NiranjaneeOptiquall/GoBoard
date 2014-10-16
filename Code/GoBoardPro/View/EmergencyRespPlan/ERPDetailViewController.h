//
//  ERPDetailViewController.h
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface ERPDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, DatePickerDelegate> {
    NSMutableArray *mutArrActionList;
}

@property (weak, nonatomic) IBOutlet UILabel *lblERPTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtTimeStart;
@property (weak, nonatomic) IBOutlet UITextField *txtTimeEnd;
@property (weak, nonatomic) IBOutlet UITableView *tblActionsTaken;

@property (nonatomic, weak) NSDictionary *dictCategory;
@property (nonatomic, assign) NSInteger selectedIndex;

- (IBAction)btnSubmitTapped:(id)sender;
- (IBAction)btnTimeStartTapped:(id)sender;
- (IBAction)btnTimeEndTapped:(id)sender;

@end
