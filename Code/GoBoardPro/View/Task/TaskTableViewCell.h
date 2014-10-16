//
//  TaskTableViewCell.h
//  GoBoardPro
//
//  Created by ind558 on 26/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTask;
@property (weak, nonatomic) IBOutlet UIButton *btnKeyboardIcon;
@property (weak, nonatomic) IBOutlet UIButton *btnNo;
@property (weak, nonatomic) IBOutlet UIButton *btnYes;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckBox;
@property (weak, nonatomic) IBOutlet UITextField *txtTemp;
@property (weak, nonatomic) IBOutlet UILabel *lblFarenhite;

@end
