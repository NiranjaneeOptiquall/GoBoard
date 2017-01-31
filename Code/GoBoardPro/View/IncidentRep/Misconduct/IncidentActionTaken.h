//
//  IncidentActionTaken.h
//  GoBoardPro
//
//  Created by ind558 on 02/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface IncidentActionTaken : UIView <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnFacilitySuspension;
@property (weak, nonatomic) IBOutlet UITextField *txtFacilitySuspensionFrom;
@property (weak, nonatomic) IBOutlet UITextField *txtFacilitySuspensionTill;
@property (weak, nonatomic) IBOutlet UIButton *btnVerbalWarning;
@property (weak, nonatomic) IBOutlet UIButton *btnWrittenWarning;
@property (weak, nonatomic) IBOutlet UIButton *btnSuspension;
@property (weak, nonatomic) IBOutlet UITextField *txtSuspensionFrom;
@property (weak, nonatomic) IBOutlet UITextField *txtSuspensionTill;
@property (weak, nonatomic) IBOutlet UIButton *btnTermination;
@property (weak, nonatomic) IBOutlet UITextField *txtTerminationFrom;
@property (weak, nonatomic) IBOutlet UIView *vwTextContainer;

@property (nonatomic, assign) BOOL shouldHideTextField;

- (IBAction)btnActionTakenTapped:(UIButton *)sender;
@end
