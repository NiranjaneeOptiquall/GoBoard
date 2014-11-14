//
//  WebViewController.h
//  GoBoardPro
//
//  Created by ind558 on 31/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface WebViewController : UIViewController <UIWebViewDelegate> {
    BOOL isWebLoaded;
}

@property (weak, nonatomic) IBOutlet UIWebView *webDetailView;

@property (strong, nonatomic) NSString *strRequestURL;

- (IBAction)btnBackTapped:(id)sender;
@end
