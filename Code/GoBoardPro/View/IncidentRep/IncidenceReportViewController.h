//
//  IncidenceReportViewController.h
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface IncidenceReportViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblBadgeMisconduct;
@property (weak, nonatomic) IBOutlet UILabel *lblBadgeCustomerService;
@property (weak, nonatomic) IBOutlet UILabel *lblBadgeOther;

@end
