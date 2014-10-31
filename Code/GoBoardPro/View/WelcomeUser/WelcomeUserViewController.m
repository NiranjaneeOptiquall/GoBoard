//
//  WelcomeUserViewController.m
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "WelcomeUserViewController.h"

@interface WelcomeUserViewController ()

@end

@implementation WelcomeUserViewController

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

- (IBAction)btnSubmitTapped:(id)sender {
    if ([_txtFacility isTextFieldBlank] || [_txtLocation isTextFieldBlank] || [_txtPosition isTextFieldBlank]) {
        alert(@"", @"Please completed all required fields.");
        return;
    }
    [self performSegueWithIdentifier:@"welcomeToUserHome" sender:nil];
}

- (IBAction)btnUpdateProfileTapped:(id)sender {
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
    dropDown.delegate = self;
    if ([textField isEqual:_txtFacility]) {
        [dropDown showDropDownWith:FACILITY_VALUES view:textField key:@"title"];
    }
    else if ([textField isEqual:_txtLocation]) {
        [dropDown showDropDownWith:LOCATION_VALUES view:textField key:@"title"];
    }
    else if ([textField isEqual:_txtPosition]) {
        [dropDown showDropDownWith:POSITION_VALUES view:textField key:@"title"];
    }
    return NO;
}


- (void)dropDownControllerDidSelectValue:(id)value atIndex:(NSInteger)index sender:(id)sender {
    [sender setText:[value objectForKey:@"title"]];
}
@end
