//
//  ViewController.h
//  GoBoardPro
//
//  Created by ind558 on 22/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate,UIAlertViewDelegate> {
}

@property (weak, nonatomic) IBOutlet UIImageView *imvLogo;
@property (weak, nonatomic) IBOutlet UIButton *btnUserSignIn;
@property (weak, nonatomic) IBOutlet UIButton *btnGuestSignIn;
@property (weak, nonatomic) IBOutlet UIImageView *imvUserIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *imvGuestIndicator;
@property (weak, nonatomic) IBOutlet UILabel *lblVersionNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblBuildVersionNumber;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnSignInTapped;


//********** User Sign In View **********//

@property (weak, nonatomic) IBOutlet UIView *vwUserSignIn;
@property (weak, nonatomic) IBOutlet UITextField *txtUserId;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;


//********** Guest Sign In View **********//

@property (weak, nonatomic) IBOutlet UIView *vwGuestSignIn;
@property (weak, nonatomic) IBOutlet UITextField *txtGuestName;

#pragma mark - Actions & Methods

- (IBAction)btnGuestSignInTapped:(UIButton *)sender;
- (IBAction)btnUserSignInTapped:(UIButton *)sender;


//********** User Sign In View **********//

- (IBAction)btnSignInTapped:(id)sender;
- (IBAction)btnForgotPasswordTapped:(id)sender;
- (IBAction)btnSignUpTapped:(id)sender;

//********** Guest Sign In View **********//

- (IBAction)btnTakeASurveyTapped:(id)sender;
- (IBAction)btnMakeASuggestionTapped:(id)sender;
- (IBAction)btnCompleteAFormTapped:(id)sender;

- (IBAction)unwindBackToLoginScreen:(UIStoryboardSegue*)segue;

@end

