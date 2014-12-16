//
//  EndOfDayViewController.h
//  GoBoardPro
//
//  Created by ind558 on 11/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface EndOfDayViewController : UIViewController {
    NSMutableArray *mutArrDailyList;
}
@property (weak, nonatomic) IBOutlet UITableView *tblDailyLog;
@property (weak, nonatomic) IBOutlet UILabel *lblTodayDate;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRecords;

- (IBAction)btnBackTapped:(id)sender;
- (IBAction)btnSubmitTapped:(id)sender;
@end
