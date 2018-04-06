//
//  UtilizationHeaderView.h
//  GoBoardPro
//
//  Created by ind558 on 18/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UtilizationHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *btnDecreaseCount;
@property (weak, nonatomic) IBOutlet UILabel *lblFacilityArea;
@property (weak, nonatomic) IBOutlet UILabel *lblCapicity;
@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdate;
@property (weak, nonatomic) IBOutlet UITextField *txtCount;
@property (weak, nonatomic) IBOutlet UIButton *btnIncreaseCount;
@property (weak, nonatomic) IBOutlet UILabel *lblDevider;
@property (weak, nonatomic) IBOutlet UIButton *btnMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnCountRemainSame;
//@property (weak, nonatomic) IBOutlet UIButton *btnTapReadyToSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnClosed;
@property (weak, nonatomic) IBOutlet UIImageView *imgReadyToSubmit;
@property (weak, nonatomic) IBOutlet UIImageView *imgTimeExide;

@property (weak, nonatomic) IBOutlet UIButton *btnOptions;
@property (weak, nonatomic) IBOutlet UILabel *LblReadyToSubmit;
@property (weak, nonatomic) IBOutlet UIImageView *imgClosedIndicator;
@property (assign, nonatomic) NSInteger section;
@end
