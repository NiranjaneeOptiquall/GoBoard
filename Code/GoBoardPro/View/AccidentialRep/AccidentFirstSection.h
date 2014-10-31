//
//  AccidentFirstSection.h
//  GoBoardPro
//
//  Created by ind558 on 29/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonInformation.h"
#import "BodyPartInjury.h"
#import "BodilyFluidView.h"

@class AccidentReportViewController;

@interface AccidentFirstSection : UIView

@property (weak, nonatomic) IBOutlet PersonInformation *vwPersonalInfo;
@property (weak, nonatomic) IBOutlet BodyPartInjury *vwBodyPartInjury;
@property (weak, nonatomic) IBOutlet BodilyFluidView *vwBodilyFluid;

@property (weak, nonatomic) AccidentReportViewController *parentVC;
- (BOOL)validateAccidentFirstSection;
@end
