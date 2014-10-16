//
//  AccidentReportViewController.m
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "AccidentReportViewController.h"


@interface AccidentReportViewController ()

@end

@implementation AccidentReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [personalInfoView removeObserver:self forKeyPath:@"frame"];
    [bodyPartView removeObserver:self forKeyPath:@"frame"];
    [thirdSection removeObserver:self forKeyPath:@"frame"];
    [finalSection removeObserver:self forKeyPath:@"frame"];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqual:personalInfoView]) {
        CGRect frame = bodyPartView.frame;
        frame.origin.y = CGRectGetMaxY(personalInfoView.frame);
        bodyPartView.frame = frame;
        
        frame = thirdSection.frame;
        frame.origin.y = CGRectGetMaxY(bodyPartView.frame);
        thirdSection.frame = frame;
        
        frame = finalSection.frame;
        frame.origin.y = CGRectGetMaxY(thirdSection.frame);
        finalSection.frame = frame;
    }
    else if ([object isEqual:bodyPartView]) {
        CGRect frame = thirdSection.frame;
        frame.origin.y = CGRectGetMaxY(bodyPartView.frame);
        thirdSection.frame = frame;
        
        frame = finalSection.frame;
        frame.origin.y = CGRectGetMaxY(thirdSection.frame);
        finalSection.frame = frame;
    }
    else if ([object isEqual:thirdSection]) {
        CGRect frame = finalSection.frame;
        frame.origin.y = CGRectGetMaxY(thirdSection.frame);
        finalSection.frame = frame;
    }
    CGRect frame = finalSection.frame;
    [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
}

#pragma mark - IBActions & Selectors

- (void)btnFinalSubmitTapped:(id)sender {
    if (![personalInfoView isPersonalInfoValidationSuccess]) {
        return;
    }
    else if (![bodyPartView isBodyPartInjuredInfoValidationSuccess]) {
        return;
    }
    else if (![thirdSection isThirdSectionValidationSuccess]) {
        return;
    }
    else if (![finalSection isFinalSectionValidationSuccess]) {
        return;
    }
}

#pragma mark - Methods

- (void)addViews {
    personalInfoView = (PersonInformation*)[[[NSBundle mainBundle] loadNibNamed:@"PersonInformation" owner:self options:nil] firstObject];
    [personalInfoView setBackgroundColor:[UIColor clearColor]];
    CGRect frame = personalInfoView.frame;
    frame.origin.y = 166;
    personalInfoView.frame = frame;
    [_scrlMainView addSubview:personalInfoView];
    [personalInfoView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [_scrlMainView sendSubviewToBack:personalInfoView];
    
    bodyPartView = (BodyPartInjury*)[[[NSBundle mainBundle] loadNibNamed:@"BodyPartInjury" owner:self options:nil] firstObject];
    [bodyPartView setBackgroundColor:[UIColor clearColor]];
     frame = bodyPartView.frame;
    frame.origin.y = CGRectGetMaxY(personalInfoView.frame);
    bodyPartView.frame = frame;
    [_scrlMainView addSubview:bodyPartView];
    [bodyPartView manageData];
    [bodyPartView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    
    thirdSection = (ThirdSection*)[[[NSBundle mainBundle] loadNibNamed:@"ThirdSection" owner:self options:nil] firstObject];
    frame = thirdSection.frame;
    frame.origin.y = CGRectGetMaxY(bodyPartView.frame);
    thirdSection.frame = frame;
    [_scrlMainView addSubview:thirdSection];
    [thirdSection addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    
    
    finalSection = (FinalSection*)[[[NSBundle mainBundle] loadNibNamed:@"FinalSection" owner:self options:nil] firstObject];
    [finalSection setBackgroundColor:[UIColor clearColor]];
    frame = finalSection.frame;
    frame.origin.y = CGRectGetMaxY(thirdSection.frame);
    finalSection.frame = frame;
    [_scrlMainView addSubview:finalSection];
    [finalSection addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [finalSection.btnFinalSubmit addTarget:self action:@selector(btnFinalSubmitTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_scrlMainView setContentSize:CGSizeMake(_scrlMainView.frame.size.width, CGRectGetMaxY(frame))];
}


//#pragma mark - UITableViewDatasource
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 5;
//}
//
//- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    return aCell;
//}

@end
