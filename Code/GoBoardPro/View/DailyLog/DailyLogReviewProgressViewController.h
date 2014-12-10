//
//  DailyLogReviewProgressViewController.h
//  GoBoardPro
//
//  Created by ind558 on 10/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface DailyLogReviewProgressViewController : UIViewController <UITableViewDataSource, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *lblTodayTime;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblFacility;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblPosition;
@property (weak, nonatomic) IBOutlet UITableView *tblTaskList;
@property (weak, nonatomic) IBOutlet UILabel *lblCompletedTaskCount;
@property (weak, nonatomic) IBOutlet UILabel *lblScheduledTaskCount;
@property (weak, nonatomic) IBOutlet UILabel *lblPercentage;

- (IBAction)btnBackTapped:(id)sender;
@end
