//
//  UserHomeViewController.h
//  GoBoardPro
//
//  Created by ind558 on 23/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface UserHomeViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSInteger syncCount;
    BOOL isErrorOccurred;
    NSInteger intUnreadMemoCount, intPendingAccidentReport, intPendingIncidentReport;
}
//Team Log
@property (nonatomic,assign)NSInteger intUnreadLogCount;
@property (nonatomic,assign)NSInteger intFormInProgressCount;
@property (nonatomic,assign)NSInteger intSurveyInProgressCount;

@property (nonatomic,assign)BOOL boolUpdateTeamLog;
@property (nonatomic,assign)BOOL boolUpdateFormInProgress;
@property (nonatomic,assign)BOOL boolUpdateSurveyInProgress;

@property (weak, nonatomic) IBOutlet UIButton *btnSurvey;
@property (weak, nonatomic) IBOutlet UIButton *btnTools;
@property (weak, nonatomic) IBOutlet UIButton *btnDailyLog;
@property (weak, nonatomic) IBOutlet UILabel *lblPendingCount;
@property (weak, nonatomic) IBOutlet UILabel *lblMemoCount;
@property (weak, nonatomic) IBOutlet UILabel *lblWelcomeUser;
@property (weak, nonatomic) IBOutlet UICollectionView *cvMenuGrid;
@property (strong, nonatomic) IBOutlet UILabel *lblVersion;
@property (nonatomic) BOOL allowMemoWSCall;


- (IBAction)btnStartSyncCount:(id)sender;
- (IBAction)unwindBackToHomeScreen:(UIStoryboardSegue*)segue;

@end
