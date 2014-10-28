//
//  UpdateProfileViewController.m
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "UpdateProfileViewController.h"
#import "AddCertificateView.h"

@interface UpdateProfileViewController ()

@end

@implementation UpdateProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
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

#pragma mark - IBActions & Selectors


- (IBAction)btnAddMoreCertification:(id)sender {
    [self addCertificationView];
}

- (IBAction)btnSubmitTapped:(id)sender {
    if ([_txtFitstName isTextFieldBlank] || [_txtMiddleName isTextFieldBlank] || [_txtLastName isTextFieldBlank] || [_txtEmail isTextFieldBlank]) {
        alert(@"", @"Please fill up all required fields.");
        return;
    }
    else if (![gblAppDelegate validateEmail:[_txtEmail text]]) {
        [_txtEmail becomeFirstResponder];
        alert(@"", @"Please enter valid Email address");
        return;
    }
    else if ([_txtPhone isTextFieldBlank]) {
        alert(@"", @"Please fill up all required fields.");
        return;
    }
    else if (![_txtPhone.text isValidPhoneNumber]) {
        alert(@"", @"Please enter valid Phone Number");
        return;
    }
    else if ([_txtMobile isTextFieldBlank]) {
        alert(@"", @"Please fill up all required fields.");
        return;
    }
    else if (![_txtMobile.text isValidPhoneNumber]) {
        alert(@"", @"Please enter valid Mobile Number");
        return;
    }
    else if ([_txtPassword isTextFieldBlank]) {
        alert(@"", @"Please fill up all required fields.");
        return;
    }
    else if (![_txtPassword.text isValidPassword]) {
        alert(@"", @"Password should be 8 - 16 character long with atleast 1 numeric, 1 lower case letter and 1 upper case latter");
        return;
    }
    else if ([_txtConfirmPassword isTextFieldBlank]) {
        alert(@"", @"Please fill up all required fields.");
        return;
    }
    else if (![_txtPassword.text isEqualToString:_txtConfirmPassword.text]) {
        alert(@"", @"Password and Confirm Password does not match");
        [_txtConfirmPassword becomeFirstResponder];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnBackTapped:(id)sender {
    [self.view endEditing:YES];
    if (isUpdate) {
        [[[UIAlertView alloc] initWithTitle:@"GoBoardPro" message:@"Do you want to save your information? If you press “Back” you will lose all entered information, do you want to proceed?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil] show];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - Methods

- (void)addCertificationView {
    AddCertificateView *aCertView = [[[NSBundle mainBundle] loadNibNamed:@"AddCertificateView" owner:self options:nil] firstObject];
    CGRect frame = aCertView.frame;
    frame.origin.y = totalCertificateCount * frame.size.height;
    aCertView.frame = frame;
    totalCertificateCount++;
    [_scrlCertificationView addSubview:aCertView];
    [_scrlCertificationView setContentSize:CGSizeMake(0, CGRectGetMaxY(frame)+ 10)];
    if (totalCertificateCount > 3) {
    [_scrlCertificationView setContentOffset:CGPointMake(0, _scrlCertificationView.contentSize.height - _scrlCertificationView.frame.size.height - 5) animated:YES];    
    }
    
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (!isUpdate) {
        strPreviousText = textField.text;
    }
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (!isUpdate && ![strPreviousText isEqualToString:textField.text]) {
        isUpdate = YES;
    }
    return YES;
}

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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
