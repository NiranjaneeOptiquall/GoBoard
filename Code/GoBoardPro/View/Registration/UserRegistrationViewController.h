//
//  UserRegistrationViewController.h
//  GoBoardPro
//
//  Created by ind558 on 23/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "Constants.h"

@interface UserRegistrationViewController : UIViewController<UITextFieldDelegate> {
//    NSMutableArray *mutArrCertificateViews;
    NSInteger totalCertificateCount;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrlCertificationView;
@property (weak, nonatomic) IBOutlet UITextField *txtFitstName;
@property (weak, nonatomic) IBOutlet UITextField *txtMiddleName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *mainScrlView;
@property (weak, nonatomic) IBOutlet UIButton *btnAggreeTerms;

- (IBAction)btnAddMoreCertification:(id)sender;
- (IBAction)btnAgreeTermsTapped:(UIButton*)sender;
- (IBAction)btnSubmitTapped:(id)sender;

@end
