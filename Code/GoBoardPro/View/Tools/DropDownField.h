//
//  DropDownField.h
//  GoBoardPro
//
//  Created by ind558 on 07/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownField : UIView
@property (weak, nonatomic) IBOutlet UITextField *txtDropdownField;
@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UIButton *btnRemoveDropdown;

@property (strong, nonatomic) NSString *strDorpdownId;

@end
