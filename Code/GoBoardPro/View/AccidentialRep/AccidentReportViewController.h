//
//  AccidentReportViewController.h
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonInformation.h"
#import "BodyPartInjury.h"
#import "ThirdSection.h"
#import "FinalSection.h"

@interface AccidentReportViewController : UIViewController {
    PersonInformation *personalInfoView;
    BodyPartInjury *bodyPartView;
    ThirdSection *thirdSection;
    FinalSection *finalSection;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrlMainView;




@end
