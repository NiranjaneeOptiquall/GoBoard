//
//  UserRegistrationViewController.m
//  GoBoardPro
//
//  Created by ind558 on 23/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "UserRegistrationViewController.h"
#import "AddCertificateView.h"

@interface UserRegistrationViewController ()

@end

@implementation UserRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    mutArrCertificateViews = [[NSMutableArray alloc] init];
    [self addCertificationView];
    [self addCertificationView];
    [self addCertificationView];
    [_mainScrlView setContentSize:CGSizeMake(768, 1300)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBAction & Selectors

- (IBAction)btnAddMoreCertification:(id)sender {
    [self addCertificationView];
}

- (IBAction)btnAgreeTermsTapped:(UIButton*)sender {
    [sender setSelected:![sender isSelected]];
}

- (IBAction)btnSubmitTapped:(id)sender {
    if ([_txtFitstName isTextFieldBlank]) {
        alert(@"Sign Up", @"Please enter First Name");
        return;
    }
    else if ([_txtMiddleName isTextFieldBlank]) {
        alert(@"Sign Up", @"Please enter Middle Name");
        return;
    }
    else if ([_txtLastName isTextFieldBlank]) {
        alert(@"Sign Up", @"Please enter Last Name");
        return;
    }
    else if ([_txtEmail isTextFieldBlank]) {
        alert(@"Sign Up", @"Please enter Email address");
        return;
    }
    else if (![gblAppDelegate validateEmail:[_txtEmail text]]) {
        [_txtEmail becomeFirstResponder];
        alert(@"Sign Up", @"Please enter valid Email address");
        return;
    }
    else if ([_txtPhone isTextFieldBlank]) {
        alert(@"Sign Up", @"Please enter Phone Number");
        return;
    }
    else if (![_txtPhone.text isValidPhoneNumber]) {
        alert(@"Sign Up", @"Please enter valid Phone Number");
        [_txtPhone becomeFirstResponder];
        return;
    }
    else if ([_txtMobile isTextFieldBlank]) {
        alert(@"Sign Up", @"Please enter Mobile Number");
        return;
    }
    else if (![_txtMobile.text isValidPhoneNumber]) {
        alert(@"Sign Up", @"Please enter valid Mobile Number");
        [_txtMobile becomeFirstResponder];
        return;
    }
    else if ([_txtPassword isTextFieldBlank]) {
        alert(@"Sign Up", @"Please enter Password");
        return;
    }
    else if (![_txtPassword.text isValidPassword]) {
        alert(@"Login", @"Password should be 8 - 16 character long with atleast 1 numeric and 1 lower case letter and 1 upper case latter");
        [_txtPassword becomeFirstResponder];
        return;
    }
    else if ([_txtConfirmPassword isTextFieldBlank]) {
        alert(@"Sign Up", @"Please enter Confirm Password");
        return;
    }
    else if (![_txtPassword.text isEqualToString:_txtConfirmPassword.text]) {
        alert(@"Sign Up", @"Password and Confirm Password does not match");
        [_txtConfirmPassword becomeFirstResponder];
        return;
    }
    else if (![_btnAggreeTerms isSelected]) {
        alert(@"Sign Up", @"Please agree terms & conditions");
    }
    [self performSegueWithIdentifier:@"RegistrationToThankYou" sender:nil];
}

#pragma mark - Methods

- (void)addCertificationView {
    AddCertificateView *aCertView = [[[NSBundle mainBundle] loadNibNamed:@"AddCertificateView" owner:self options:nil] firstObject];
    aCertView.parentView = self;
    CGRect frame = aCertView.frame;
    frame.origin.y = totalCertificateCount * frame.size.height;
    aCertView.frame = frame;
    [aCertView.txtCertificateName setDelegate:self];
    totalCertificateCount++;
    [_scrlCertificationView addSubview:aCertView];
    [_scrlCertificationView setContentSize:CGSizeMake(0, CGRectGetMaxY(frame)+ 10)];
    [_scrlCertificationView setContentOffset:CGPointMake(0, _scrlCertificationView.contentSize.height - _scrlCertificationView.frame.size.height - 5) animated:YES];
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if ([textField isEqual:_txtPhone] || [textField isEqual:_txtMobile]) {
        NSCharacterSet *numericCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789 +()"];
        if ([string rangeOfCharacterFromSet:numericCharacterSet].location == NSNotFound) {
            return NO;
        }
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 15) {
            return NO;
        }
    }
    else if ([_txtMiddleName isEqual:textField]) {
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 5) {
            return NO;
        }
    }
        
    return YES;
}

@end
