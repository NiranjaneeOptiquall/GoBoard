//
//  DailyLogViewController.h
//  GoBoardPro
//
//  Created by ind558 on 10/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface DailyLogViewController : UIViewController <UITextViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *lblTodayTime;
@property (weak, nonatomic) IBOutlet UITableView *tblDailyLog;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeStamp;
@property (weak, nonatomic) IBOutlet UILabel *lblLogPlaceholder;
@property (weak, nonatomic) IBOutlet UITextView *txvDailyLog;
- (IBAction)btnBackTapped:(UIButton *)sender;
- (IBAction)btnSubmitTapped:(id)sender;
- (IBAction)btnEditTapped:(id)sender;
@end
