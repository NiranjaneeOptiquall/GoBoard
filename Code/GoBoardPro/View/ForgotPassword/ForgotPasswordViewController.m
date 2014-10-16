//
//  ForgotPasswordViewController.m
//  GoBoardPro
//
//  Created by ind558 on 23/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [_txtEmailId becomeFirstResponder];
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

- (IBAction)btnSubmitTapped:(id)sender {
    if ([[_txtEmailId text] isEqualToString:@""]) {
        alert(@"Forgot Password", @"Please enter email id");
        return;
    }
    else if (![gblAppDelegate validateEmail:[_txtEmailId text]]) {
        alert(@"Forgot Password", @"Please enter valid email id");
        [_txtEmailId becomeFirstResponder];
        return;
    }
    [_txtEmailId resignFirstResponder];
    alert(@"Password Recovery", @"We have sent you an email with password recovery link");
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    [self btnSubmitTapped:nil];
    return YES;
}
@end
