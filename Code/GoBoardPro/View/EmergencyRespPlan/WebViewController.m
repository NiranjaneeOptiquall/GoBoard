//
//  WebViewController.m
//  GoBoardPro
//
//  Created by ind558 on 31/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_webDetailView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_strRequestURL]]];
    
    if ([_strInstruction isEqualToString:@""]) {
       [_lblInstruction setText:@"No instructions available."];
    }else{
        [_lblInstruction setText:_strInstruction];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnBackTapped:(id)sender {
    [_webDetailView setDelegate:nil];
    [gblAppDelegate hideActivityIndicator];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - WebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [gblAppDelegate showActivityIndicator];
    isWebLoaded = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    isWebLoaded = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (isWebLoaded)
            [gblAppDelegate hideActivityIndicator];
    });
    
}
@end
