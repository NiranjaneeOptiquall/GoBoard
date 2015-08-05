//
//  DailyLogReviewProgressViewController.h
//  GoBoardPro
//
//  Created by ind558 on 10/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "TaskList.h"


@interface DailyLogReviewProgressViewController : UIViewController <UITableViewDataSource, UICollectionViewDataSource> {
    NSArray *aryMissedTask;
    NSArray *aryLocations;
    NSArray *aryPostions;
    NSDictionary *dictDailyMatrics;
    NSMutableArray *mutArrCompletedCount;
    NSInteger intOpenAccidentReport, intOpenIncidentReport, intOpenGuestForm, intOpenGuestSurvey, intOpenUserForm, intOpenUserSurvey;
    NSArray *mutArrTaskList;
    NSArray *mutArrMissedTaskList;
    NSArray *mutArrCompletedTaskList;
}
@property (weak, nonatomic) IBOutlet UILabel *lblTodayTime;
@property (weak, nonatomic) IBOutlet UITableView *tblTaskList;
@property (weak, nonatomic) IBOutlet UILabel *lblCompletedTaskCount;
@property (weak, nonatomic) IBOutlet UILabel *lblScheduledTaskCount;
@property (weak, nonatomic) IBOutlet UILabel *lblPercentage;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRecords;
@property (weak, nonatomic) IBOutlet UICollectionView *colCompleteCount;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UITableView *tblLoginUserInfo;
@property (weak, nonatomic) IBOutlet UIScrollView *scrView;

- (IBAction)btnBackTapped:(id)sender;
@end
