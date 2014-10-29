//
//  WelcomeUserViewController.h
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface WelcomeUserViewController : UIViewController<UITextFieldDelegate, DropDownValueDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtFacility;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UITextField *txtPosition;

- (IBAction)btnSubmitTapped:(id)sender;
- (IBAction)btnUpdateProfileTapped:(id)sender;
@end
