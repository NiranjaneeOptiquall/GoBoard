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
@property (weak, nonatomic) IBOutlet UIButton *btnSurvey;
@property (weak, nonatomic) IBOutlet UIButton *btnTools;

- (IBAction)unwindBackToHomeScreen:(UIStoryboardSegue*)segue;

@end
