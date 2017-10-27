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
    mutArrDeletedCertificates = [[NSMutableArray alloc] init];
    NSLog(@"%@",[[User currentUser] userStatusCheck]);

    if (![[User currentUser] isAcceptedTermsAndConditions]) {
//        if ([[[User currentUser] termsAndConditions] isKindOfClass:[NSString class]])
//            _txvTerms.text = [[User currentUser] termsAndConditions];
        NSString *aStrPathOfAcceptibleUsePolicy = [[NSBundle mainBundle] pathForResource:@"Acceptible Use Policy HTML_20150301" ofType:@"html"];
        
        NSURL *aUrl = [NSURL fileURLWithPath:aStrPathOfAcceptibleUsePolicy];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:aUrl];
        
        [_vwWeb loadRequest:request];
        
        //NSString *aStr1 = [NSString stringWithContentsOfFile:aStrPathOfAcceptibleUsePolicy encoding:NSUTF8StringEncoding error:nil];

        //[_vwWeb loadHTMLString:aStr1 baseURL:nil];
    }
   else if (![[[User currentUser] userStatusCheck] isEqualToString:@"Active"]){
       [[User currentUser] setIsAcceptedTermsAndConditions:false];

    NSString *aStrPathOfAcceptibleUsePolicy = [[NSBundle mainBundle] pathForResource:@"Acceptible Use Policy HTML_20150301" ofType:@"html"];
        
        NSURL *aUrl = [NSURL fileURLWithPath:aStrPathOfAcceptibleUsePolicy];
        
NSURLRequest *request = [NSURLRequest requestWithURL:aUrl];
        
[_vwWeb loadRequest:request];
        
    }
    else {
        [_vwTerms setHidden:YES];
        CGRect frame = _btnSubmit.frame;
        frame.origin.y = CGRectGetMinY(_vwTerms.frame);
        _btnSubmit.frame = frame;
        frame = _lblSubmit.frame;
        frame.origin.y = CGRectGetMinY(_vwTerms.frame);
        _lblSubmit.frame = frame;
    }
    [self getCertificateList];

    [_btnLikeToRcvTextMSG.titleLabel setNumberOfLines:2];
    [_btnLikeToRcvTextMSG.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)getCertificateList {
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?ClientId=%@", @"ClientRequirement", [[User currentUser] clientId]] parameters:nil httpMethod:@"GET" complition:^(NSDictionary *response) {
        NSLog(@"%@",response);
        _aryCertificates = [response objectForKey:@"ClientRequirements"];
        [self getUserInfo];
    } failure:^(NSError *error, NSDictionary *response) {
        
    }];
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
      NSString *aStrRcvMSG = (_btnLikeToRcvTextMSG.isSelected) ? @"true" : @"false";
    if ([_txtFitstName isTextFieldBlank] || [_txtLastName isTextFieldBlank] || [_txtEmail isTextFieldBlank]) {
        alert(@"", MSG_REQUIRED_FIELDS);
        return;
    }
    else if (![gblAppDelegate validateEmail:[_txtEmail text]]) {
        [_txtEmail becomeFirstResponder];
        alert(@"", @"Please enter valid Email address");
        return;
    }
    else if ([aStrRcvMSG isEqualToString:@"true"]){
        if ([_txtMobile.text isEqualToString:@""]
            ) {
            alert(@"", @"Mobile number is required for receiving text messages");
            return;
        }
        else if ([_txtMobile.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0 && ![_txtMobile.text isValidPhoneNumber]) {
            alert(@"", @"Please enter valid Mobile Number");
            return;
        }
    }

    else if ([_txtPhone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0 &&![_txtPhone.text isValidPhoneNumber]) {
        alert(@"", @"Please enter valid Phone Number");
        return;
    }
    else if ([_txtMobile.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0 && ![_txtMobile.text isValidPhoneNumber]) {
        alert(@"", @"Please enter valid Mobile Number");
        return;
    }
 //   else if ([_txtPassword isTextFieldBlank]) {
//        alert(@"", MSG_REQUIRED_FIELDS);
//        return;
//    }
    else if ([_txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0 && ![_txtPassword.text isValidPassword]) {
        alert(@"", @"Password must be between 8-16 characters with the use of both upper- and lower-case letters (case sensitivity) and inclusion of one or more numerical digits");
        return;
    }
    else if (![_txtPassword.text isEqualToString:_txtConfirmPassword.text]) {
        alert(@"", @"Password and Confirm Password does not match");
        [_txtConfirmPassword becomeFirstResponder];
        return;
    }
    NSMutableArray *aMutArrCertificate = [NSMutableArray array];
    for (AddCertificateView *certificate in _scrlCertificationView.subviews) {
        if ([certificate isKindOfClass:[AddCertificateView class]]) {
            id aPhotoData, fileName, strDropDownId,strExpDate,strCertificateId,strIsNoExpiration;
            if (certificate.imgCertificate) {
                NSData *aData = UIImageJPEGRepresentation(certificate.imgCertificate, 1.0);
                aPhotoData = [aData base64EncodedStringWithOptions:0];
                certificate.strCertificateFileName = [NSString stringWithFormat:@"%@_%ld", [[User currentUser] userId], (long)[[NSDate date] timeIntervalSince1970]];
            }
            else {
                aPhotoData = [NSNull null];
            }
            
            if (certificate.strCertificateFileName) {
                fileName = certificate.strCertificateFileName;
            }
            else {
                fileName = [NSNull null];
            }
            
            if (certificate.strDropDownId) {
                strDropDownId = certificate.strDropDownId;
            }
            else{
               
                alert(@"", @"Please select Certificate");
                [certificate.txtCertificateName becomeFirstResponder];
                return;
            }
            if (!certificate.btnNoExpDate.selected) {
                if (certificate.txtExpDate.trimText.length >0) {
                    strExpDate = certificate.txtExpDate.text;
                }else{
                    
                    alert(@"", @"Please select Expiration Date");
                    [certificate btnSelectExpDate:certificate.btnExpDate];
                    return;
                    
                }
                strIsNoExpiration = @"false";
            }
            else{
                strExpDate= @"";
                  strIsNoExpiration = @"true";
            }
           
            if (certificate.strCertificateId) {
                strCertificateId = certificate.strCertificateId;
            }else{
                strCertificateId = [NSNull null];
            }
            
            [aMutArrCertificate addObject:@{@"RequirementId":strDropDownId, @"ExpirationDate": strExpDate, @"Id":strCertificateId, @"FileName":fileName, @"Photo":aPhotoData, @"IsDeleted":@"false", @"IsNoExpiration":strIsNoExpiration}];
            
        }
    }
    
    BOOL isDuplicate = NO;
    
    for (int i = 0 ; i < aMutArrCertificate.count; i++) {
        
        NSString *aStrRequirementId = [[aMutArrCertificate objectAtIndex:i]objectForKey:@"RequirementId"];
        
        for (int j = i+1 ; j <= aMutArrCertificate.count-1; j++) {
            
            if ([aStrRequirementId isEqualToString:[[aMutArrCertificate objectAtIndex:j] objectForKey:@"RequirementId"]]) {
                isDuplicate = YES;
                
            }
        }
    }
    if (isDuplicate) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[gblAppDelegate appName] message:@"You cannot enter same certificate more than once." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }else{
        
        [aMutArrCertificate addObjectsFromArray:mutArrDeletedCertificates];
        
        NSString *aStrRcvMSG = (_btnLikeToRcvTextMSG.isSelected) ? @"true" : @"false";
        id aTerms;
        if ([[User currentUser] isAcceptedTermsAndConditions]) {
            aTerms = [NSNull null];
        }
        else {
            aTerms = (_btnAgreeTerms.isSelected) ? @"true" : @"false";
        }
        NSDictionary *aDictParam = @{@"Id":[[User currentUser] userId], @"FirstName":_txtFitstName.trimText, @"MiddleInitial":_txtMiddleName.trimText, @"LastName":_txtLastName.trimText, @"Email":[_txtEmail trimText], @"Phone":_txtPhone.trimText, @"Mobile":_txtMobile.trimText, @"Password":[_txtPassword trimText], @"Certifications":aMutArrCertificate, @"ReceiveTextMessages":aStrRcvMSG, @"AcceptedTermsAndConditions":aTerms};
        [gblAppDelegate callWebService:USER_SERVICE parameters:aDictParam httpMethod:@"PUT" complition:^(NSDictionary *response) {
        
            [self updateUser];
            [[[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:MSG_PROFILE_UPDATE_SUCCESS delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        } failure:^(NSError *error, NSDictionary *response) {
            
        }];
    }
}

- (void)updateUser {
    [[User currentUser] setFirstName:_txtFitstName.text];
    [[User currentUser] setMiddleInitials:_txtMiddleName.text];
    [[User currentUser] setLastName:_txtLastName.text];
    [[User currentUser] setEmail:_txtEmail.text];
    [[User currentUser] setPhone:_txtPhone.text];
    [[User currentUser] setMobile:_txtMobile.text];
    [[User currentUser] setUserStatusCheck:@"Active"];
    if (![[User currentUser] isAcceptedTermsAndConditions]) {
        [[User currentUser] setIsAcceptedTermsAndConditions:_btnAgreeTerms.isSelected];
    }
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

- (IBAction)btnLikeToRcvTextMSGTapped:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
}

- (IBAction)btnPasswordHintTapped:(id)sender {
    alert(@"", @"Password must be between 8-16 characters with the use of both upper- and lower-case letters (case sensitivity) and inclusion of one or more numerical digits");
}

- (IBAction)btnAgreeTermsTapped:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
}

#pragma mark - Methods

- (void)getUserInfo {
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@", USER_SERVICE, [[User currentUser]userId]] parameters:nil httpMethod:@"GET" complition:^(NSDictionary *response) {
        if ([[response objectForKey:@"Success"] boolValue]) {
            if([response objectForKey:@"FirstName"] && ![[response objectForKey:@"FirstName"]isKindOfClass:[NSNull class]]) {
                _txtFitstName.text = [response objectForKey:@"FirstName"];
            }
            if([response objectForKey:@"MiddleInitial"] && ![[response objectForKey:@"MiddleInitial"]isKindOfClass:[NSNull class]]) {
                _txtMiddleName.text = [response objectForKey:@"MiddleInitial"];
            }
            if([response objectForKey:@"LastName"] && ![[response objectForKey:@"LastName"]isKindOfClass:[NSNull class]]) {
                _txtLastName.text = [response objectForKey:@"LastName"];
            }
            if([response objectForKey:@"Email"] && ![[response objectForKey:@"Email"]isKindOfClass:[NSNull class]]) {
                _txtEmail.text = [response objectForKey:@"Email"];
            }
            if([response objectForKey:@"Phone"] && ![[response objectForKey:@"Phone"]isKindOfClass:[NSNull class]]) {
                _txtPhone.text = [response objectForKey:@"Phone"];
            }
            if([response objectForKey:@"Mobile"] && ![[response objectForKey:@"Mobile"]isKindOfClass:[NSNull class]]) {
                _txtMobile.text = [response objectForKey:@"Mobile"];
            }
            [_btnLikeToRcvTextMSG setSelected:[[response objectForKey:@"ReceiveTextMessages"] boolValue]];
            if ([response objectForKey:@"Certifications"] && ![[response objectForKey:@"Certifications"]isKindOfClass:[NSNull class]]) {
                for (NSDictionary *aDict in [response objectForKey:@"Certifications"]) {
                    AddCertificateView *certificate = [self addCertificationView];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Id == %d", [[aDict objectForKey:@"RequirementId"] integerValue]];
                    NSDictionary *aDictCert = [[_aryCertificates filteredArrayUsingPredicate:predicate]firstObject];
                    certificate.txtCertificateName.text = [aDictCert objectForKey:@"Name"];
                    certificate.strDropDownId = [[aDict objectForKey:@"RequirementId"] stringValue];
                    certificate.strCertificateId = [[aDict objectForKey:@"Id"] stringValue];
                    certificate.strCertificateFileName = [aDict objectForKey:@"FileName"];
                    [certificate.txtCertificateName setUserInteractionEnabled:NO];
                    NSDateFormatter *aDateFormatter = [[NSDateFormatter alloc] init];
                    NSString *aStrDate = [[[aDict objectForKey:@"ExpirationDate"] componentsSeparatedByString:@"."] firstObject];
                    [aDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                    //[aDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
                    NSDate *aDate = [aDateFormatter dateFromString:aStrDate];
                    [aDateFormatter setDateFormat:@"MM/dd/yyyy"];
                   
                    if ([[[aDict objectForKey:@"IsNoExpiration"] stringValue] isEqualToString:@"1"]) {
                            certificate.btnNoExpDate.selected = YES;
                         certificate.txtExpDate.text = @"";
                        certificate.btnExpDate.userInteractionEnabled = NO;
                    }
                    else{
                            certificate.btnNoExpDate.selected = NO;
                         certificate.txtExpDate.text = [aDateFormatter stringFromDate:aDate];
                         certificate.btnExpDate.userInteractionEnabled = YES;
                    }
                    certificate.expDate= [aDateFormatter stringFromDate:aDate];
                    //                    certificate.imgCertificate =
                }
            }
            [self updateUser];
        }
    } failure:^(NSError *error, NSDictionary *response) {
        
    }];
    
}

- (void)btnRemoveCertificateTapped:(UIButton*)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:@"Are you sure you want to delete this certification?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alert setTag:2];
    [alert show];
    totalCertificateCount--;
    UIView *currentView = sender.superview;
    removeCertificateIndex = [_scrlCertificationView.subviews indexOfObject:currentView];
}

- (void)removeCertificate {
    CGRect frame = CGRectZero;
    AddCertificateView *currentView = [_scrlCertificationView.subviews objectAtIndex:removeCertificateIndex];
    for (NSInteger i = 0; i < [_scrlCertificationView.subviews count]; i++) {
        UIView *vw = [_scrlCertificationView.subviews objectAtIndex:i];
        if ([vw isKindOfClass:[currentView class]]) {
            if (i != removeCertificateIndex) {
                frame = vw.frame;
                if (i > removeCertificateIndex) {
                    frame.origin.y -= currentView.frame.size.height;
                    vw.frame = frame;
                }
            }
        }
    }
    NSString * strExpiration = @"false";
    if (currentView.btnNoExpDate.isSelected) {
        strExpiration = @"true";
    }
    else{
        strExpiration = @"false";
    }
    if (currentView.strCertificateId) {
        [mutArrDeletedCertificates addObject:@{@"RequirementId": currentView.strDropDownId, @"ExpirationDate":currentView.txtExpDate.trimText, @"Id":currentView.strCertificateId, @"FileName":currentView.strCertificateFileName, @"Photo":[NSNull null], @"IsDeleted":@"true",@"IsNoExpiration":strExpiration}];
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
        frame = _vwSubmit.frame;
        frame.origin.y = CGRectGetMaxY(sframe);
        _vwSubmit.frame = frame;
        [_mainScrlView setContentSize:CGSizeMake(768, CGRectGetMaxY(_vwSubmit.frame))];
    }
    [_scrlCertificationView setContentOffset:CGPointMake(0, _scrlCertificationView.contentSize.height - _scrlCertificationView.frame.size.height - 5) animated:YES];
}

- (AddCertificateView*)addCertificationView {
    AddCertificateView *aCertView = [[[NSBundle mainBundle] loadNibNamed:@"AddCertificateView" owner:self options:nil] firstObject];
    aCertView.parentView = self;
    CGRect frame = aCertView.frame;
    [aCertView.btnRemove addTarget:self action:@selector(btnRemoveCertificateTapped:) forControlEvents:UIControlEventTouchUpInside];
  //  [aCertView.btnNoExpDate addTarget:self action:@selector(btnNoExpDateTapped:) forControlEvents:UIControlEventTouchUpInside];
    frame.origin.y = totalCertificateCount * frame.size.height;
    aCertView.frame = frame;
    totalCertificateCount++;
    [_scrlCertificationView addSubview:aCertView];
    [_scrlCertificationView setContentSize:CGSizeMake(0, CGRectGetMaxY(frame)+ 10)];
    if (totalCertificateCount <= 3) {
        frame = _scrlCertificationView.frame;
        frame.size.height = CGRectGetMaxY(aCertView.frame);
        if (totalCertificateCount == 3) {
            frame.size.height = 232;
        }
        _scrlCertificationView.frame = frame;
        frame = _vwSubmit.frame;
        frame.origin.y = CGRectGetMaxY(_scrlCertificationView.frame);
        _vwSubmit.frame = frame;
        [_mainScrlView setContentSize:CGSizeMake(768, CGRectGetMaxY(_vwSubmit.frame))];
    }
    if (totalCertificateCount > 3) {
    [_scrlCertificationView setContentOffset:CGPointMake(0, _scrlCertificationView.contentSize.height - _scrlCertificationView.frame.size.height - 5) animated:YES];    
    }
    return aCertView;
}


//-(void)btnNoExpDateTapped:(UIButton*)sender
//{
//    
//   
//}


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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 2) {
        if (buttonIndex == 0) {
            [self removeCertificate];
        }
    }
    else if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
