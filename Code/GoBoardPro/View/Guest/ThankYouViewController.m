//
//  ThankYouViewController.m
//  GoBoardPro
//
//  Created by ind558 on 18/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "ThankYouViewController.h"

@implementation ThankYouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblMessage.text = _strMsg;
    [_btnBack setTitle:_strBackTitle forState:UIControlStateNormal];
}

- (IBAction)btnBackTapped:(id)sender {
    for (id vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[NSClassFromString(@"GuestFormViewController") class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}
@end
