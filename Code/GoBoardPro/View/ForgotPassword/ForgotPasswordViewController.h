//
//  ForgotPasswordViewController.h
//  GoBoardPro
//
//  Created by ind558 on 23/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface ForgotPasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtEmailId;
- (IBAction)btnSubmitTapped:(id)sender;
@end
