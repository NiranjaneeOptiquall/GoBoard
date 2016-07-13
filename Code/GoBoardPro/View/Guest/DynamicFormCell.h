//
//  DynamicFormCell.h
//  GoBoardPro
//
//  Created by ind558 on 01/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicFormCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblQuestion;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckMark;
@property (weak, nonatomic) IBOutlet UIView *vwTextArea;
@property (weak, nonatomic) IBOutlet UITextField *txtField;
@property (weak, nonatomic) IBOutlet UIImageView *imvTypeIcon;
@property (weak, nonatomic) IBOutlet UIView *vwButtonList;
@property (weak, nonatomic) IBOutlet UILabel *lblDevider;
@property (weak, nonatomic) IBOutlet UIView *vwTextBox;
@property (weak, nonatomic) IBOutlet UITextView *txvView;
@property (weak, nonatomic) IBOutlet UILabel *lblForIsMandatory;
@end
