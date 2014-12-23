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
@property (weak, nonatomic) IBOutlet UIButton *btnSurvey;
@property (weak, nonatomic) IBOutlet UIButton *btnTools;
@property (weak, nonatomic) IBOutlet UIButton *btnDailyLog;
@property (weak, nonatomic) IBOutlet UILabel *lblPendingCount;
@property (weak, nonatomic) IBOutlet UILabel *lblMemoCount;
@property (weak, nonatomic) IBOutlet UILabel *lblWelcomeUser;
@property (weak, nonatomic) IBOutlet UICollectionView *cvMenuGrid;


- (IBAction)btnStartSyncCount:(id)sender;
- (IBAction)unwindBackToHomeScreen:(UIStoryboardSegue*)segue;

@end
