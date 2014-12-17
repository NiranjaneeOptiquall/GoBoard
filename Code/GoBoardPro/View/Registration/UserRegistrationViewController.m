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
    [_mainScrlView setContentSize:CGSizeMake(768, CGRectGetMaxY(_vwTermsView.frame))];
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
    isUpdate = YES;
    [self addCertificationView];
}

- (IBAction)btnAgreeTermsTapped:(UIButton*)sender {
    [sender setSelected:![sender isSelected]];
}

- (IBAction)btnSubmitTapped:(id)sender {
    if ([_txtFitstName isTextFieldBlank] || [_txtMiddleName isTextFieldBlank] || [_txtLastName isTextFieldBlank] || [_txtEmail isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        return;
    }
    else if (![gblAppDelegate validateEmail:[_txtEmail text]]) {
        [_txtEmail becomeFirstResponder];
        alert(@"", @"Please enter valid Email address");
        return;
    }
    else if ([_txtPhone isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        return;
    }
    else if (![_txtPhone.text isValidPhoneNumber]) {
        alert(@"", @"Please enter valid Phone Number");
        [_txtPhone becomeFirstResponder];
        return;
    }
    else if ([_txtMobile isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        return;
    }
    else if (![_txtMobile.text isValidPhoneNumber]) {
        alert(@"", @"Please enter valid Mobile Number");
        [_txtMobile becomeFirstResponder];
        return;
    }
    else if ([_txtPassword isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        return;
    }
    else if (![_txtPassword.text isValidPassword]) {
        alert(@"", @"Password must be between 8-16 characters with the use of both upper- and lower-case letters (case sensitivity) and inclusion of one or more numerical digits");
        [_txtPassword becomeFirstResponder];
        return;
    }
    else if ([_txtConfirmPassword isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        return;
    }
    else if (![_txtPassword.text isEqualToString:_txtConfirmPassword.text]) {
        alert(@"", @"Password and Confirm Password does not match");
        [_txtConfirmPassword becomeFirstResponder];
        return;
    }
    else if (![_btnAggreeTerms isSelected]) {
        alert(@"", @"Please agree terms & conditions");
        return;
    }
    
//    WebSerivceCall *aServiceCall = [[WebSerivceCall alloc] init];
    NSMutableArray *aMutArrCertificate = [NSMutableArray array];
    for (AddCertificateView *certificate in _scrlCertificationView.subviews) {
        if ([certificate isKindOfClass:[AddCertificateView class]]) {
//            NSData *aData = UIImageJPEGRepresentation(certificate.imgCertificate, 1.0);
            [aMutArrCertificate addObject:@{@"Name": certificate.txtCertificateName.trimText, @"ExpirationDate":certificate.txtExpDate.trimText, @"Photo":@""}];
            //, @"Photo":[aData base64EncodedStringWithOptions:0]
        }
    }
    NSDictionary *aDictParam = @{@"FirstName":_txtFitstName.trimText, @"MiddleInitial":_txtMiddleName.trimText, @"LastName":_txtLastName.trimText, @"Email":[_txtEmail trimText], @"Phone":_txtPhone.trimText, @"Mobile":_txtMobile.trimText, @"Password":[_txtPassword trimText], @"Certifications":aMutArrCertificate};
    [gblAppDelegate callWebService:USER_SERVICE parameters:aDictParam httpMethod:@"POST" complition:^(NSDictionary *response) {
        if ([response objectForKey:@"Success"]) {
          [self performSegueWithIdentifier:@"RegistrationToThankYou" sender:nil];
        }
    } failure:^(NSError *error, NSDictionary *response) {
    }];
    
}

- (IBAction)btnBackTapped:(id)sender {
    [self.view endEditing:YES];
    if (isUpdate) {
        [[[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:@"Do you want to save your information? If you press “Back” you will lose all entered information, do you want to proceed?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil] show];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Methods

- (void)btnRemoveCertificateTapped:(UIButton*)sender {
    totalCertificateCount--;
    UIView *currentView = sender.superview;
    NSInteger index = [_scrlCertificationView.subviews indexOfObject:currentView];
    CGRect frame = CGRectZero;
    for (NSInteger i = 0; i < [_scrlCertificationView.subviews count]; i++) {
        UIView *vw = [_scrlCertificationView.subviews objectAtIndex:i];
        if ([vw isKindOfClass:[currentView class]]) {
            if (i != index) {
                frame = vw.frame;
                if (i > index) {
                    frame.origin.y -= currentView.frame.size.height;
                    vw.frame = frame;
                }
            }
        }
    }
    [currentView removeFromSuperview];
    [_scrlCertificationView setContentSize:CGSizeMake(_scrlCertificationView.contentSize.width, CGRectGetMaxY(frame))];
    if (totalCertificateCount <= 3) {
        CGRect sframe = _scrlCertificationView.frame;
        sframe.size.height = CGRectGetMaxY(frame);
        if (totalCertificateCount == 3) {
            sframe.size.height = 232;
        }
        _scrlCertificationView.frame = sframe;
        frame = _vwTermsView.frame;
        frame.origin.y = CGRectGetMaxY(sframe);
        _vwTermsView.frame = frame;
        [_mainScrlView setContentSize:CGSizeMake(768, CGRectGetMaxY(_vwTermsView.frame))];
    }
    [_scrlCertificationView setContentOffset:CGPointMake(0, _scrlCertificationView.contentSize.height - _scrlCertificationView.frame.size.height - 5) animated:YES];
}

- (void)addCertificationView {
    AddCertificateView *aCertView = [[[NSBundle mainBundle] loadNibNamed:@"AddCertificateView" owner:self options:nil] firstObject];
    aCertView.parentView = self;
    [aCertView.btnRemove addTarget:self action:@selector(btnRemoveCertificateTapped:) forControlEvents:UIControlEventTouchUpInside];
    CGRect frame = aCertView.frame;
    frame.origin.y = totalCertificateCount * frame.size.height;
    aCertView.frame = frame;
    totalCertificateCount++;
    [_scrlCertificationView addSubview:aCertView];
    if (totalCertificateCount <= 3) {
        frame = _scrlCertificationView.frame;
        frame.size.height = CGRectGetMaxY(aCertView.frame);
        if (totalCertificateCount == 3) {
            frame.size.height = 232;
        }
        _scrlCertificationView.frame = frame;
        frame = _vwTermsView.frame;
        frame.origin.y = CGRectGetMaxY(_scrlCertificationView.frame);
        _vwTermsView.frame = frame;
        [_mainScrlView setContentSize:CGSizeMake(768, CGRectGetMaxY(_vwTermsView.frame))];
    }
    [_scrlCertificationView setContentSize:CGSizeMake(0, CGRectGetMaxY(aCertView.frame))];
    [_scrlCertificationView setContentOffset:CGPointMake(0, _scrlCertificationView.contentSize.height - _scrlCertificationView.frame.size.height) animated:YES];
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        if ([textField isEqual:_txtPhone] || [textField isEqual:_txtMobile]) {
            if (textField.text.length == 5) {
                NSString *aStr = [textField.text substringWithRange:NSMakeRange(1, 2)];
                textField.text = aStr;
                return NO;
            }
            else if (textField.text.length == 7) {
                NSString *aStr = [textField.text substringWithRange:NSMakeRange(0, 5)];
                textField.text = aStr;
                return NO;
            }
            else if (textField.text.length == 11) {
                NSString *aStr = [textField.text substringWithRange:NSMakeRange(0, 9)];
                textField.text = aStr;
                return NO;
            }
        }
        return YES;
    }
    if ([textField isEqual:_txtPhone] || [textField isEqual:_txtMobile]) {
        NSCharacterSet *numericCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        if ([string rangeOfCharacterFromSet:numericCharacterSet].location == NSNotFound) {
            return NO;
        }
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 14) {
            return NO;
        }
        NSString *aStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (aStr.length == 3) {
            aStr = [NSString stringWithFormat:@"(%@)", aStr];
            textField.text = aStr;
            return NO;
        }
        else if (aStr.length == 6) {
            aStr = [NSString stringWithFormat:@"%@ %@",textField.text, string];
            textField.text = aStr;
            return NO;
        }
        else if (aStr.length == 10) {
            aStr = [NSString stringWithFormat:@"%@-%@",textField.text, string];
            textField.text = aStr;
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


@end
