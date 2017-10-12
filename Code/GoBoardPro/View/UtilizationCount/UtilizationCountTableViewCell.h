//
//  UtilizationCountTableViewCell.h
//  GoBoardPro
//
//  Created by ind558 on 29/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UtilizationCountTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnDecreaseCount;
@property (weak, nonatomic) IBOutlet UILabel *lblFacilityArea;
@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdate;
@property (weak, nonatomic) IBOutlet UITextField *txtCount;
@property (weak, nonatomic) IBOutlet UIButton *btnIncreaseCount;
@property (weak, nonatomic) IBOutlet UILabel *lblDevider;
@property (weak, nonatomic) IBOutlet UIButton *btnCountRemainSame;
@property (weak, nonatomic) IBOutlet UIButton *btnKeyboard;
@property (weak, nonatomic) IBOutlet UILabel *LblReadyToSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnClosed;
@property (weak, nonatomic) IBOutlet UIButton *btnOptions;
@property (weak, nonatomic) IBOutlet UIImageView *imgTimeExide;
@property (weak, nonatomic) IBOutlet UIImageView *imgReadyToSubmit;

@end
