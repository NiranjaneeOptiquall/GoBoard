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
@property (weak, nonatomic) IBOutlet UILabel *lblCapicity;
@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdate;
@property (weak, nonatomic) IBOutlet UITextField *txtCount;
@property (weak, nonatomic) IBOutlet UIButton *btnIncreaseCount;
@property (weak, nonatomic) IBOutlet UILabel *lblDevider;
@end
