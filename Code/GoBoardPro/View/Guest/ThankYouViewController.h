//
//  ThankYouViewController.h
//  GoBoardPro
//
//  Created by ind558 on 18/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThankYouViewController : UIViewController

@property (nonatomic, strong) NSString *strMsg;
@property (nonatomic, strong) NSString *strBackTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property(nonatomic,strong) NSString * thankyouText;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
- (IBAction)btnBackTapped:(id)sender;
@end
