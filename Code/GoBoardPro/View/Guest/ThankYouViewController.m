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
    [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"offlineInProgress"];
    [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"guestUserBack"];

    for (id vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[NSClassFromString(@"GuestFormViewController") class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
        else if ([vc isKindOfClass:[NSClassFromString(@"GuestUserFormListViewController") class]])
        {   [self.navigationController popToViewController:vc animated:YES];

    }
    else if ([vc isKindOfClass:[NSClassFromString(@"MyWorkOrdersViewController") class]])
    {[self.navigationController popToViewController:vc animated:YES];
    }
    else{
        NSArray *viewControllers = [self.navigationController viewControllers];
        [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-3] animated:NO];
        
    }
}
    
}
@end
