//
//  UserHomeViewController.h
//  GoBoardPro
//
//  Created by ind558 on 23/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface UserHomeViewController : UIViewController
{
    NSInteger syncCount;
    BOOL isErrorOccurred;
}
@property (weak, nonatomic) IBOutlet UIButton *btnSurvey;
@property (weak, nonatomic) IBOutlet UIButton *btnTools;
@property (weak, nonatomic) IBOutlet UIButton *btnDailyLog;
@property (weak, nonatomic) IBOutlet UILabel *lblPendingCount;
@property (weak, nonatomic) IBOutlet UILabel *lblMemoCount;
@property (weak, nonatomic) IBOutlet UILabel *lblWelcomeUser;


- (IBAction)btnStartSyncCount:(id)sender;
- (IBAction)unwindBackToHomeScreen:(UIStoryboardSegue*)segue;

@end
