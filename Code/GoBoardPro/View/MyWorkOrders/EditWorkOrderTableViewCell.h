//
//  EditWorkOrderTableViewCell.h
//  GoBoardPro
//
//  Created by Optiquall Solutions on 08/01/18.
//  Copyright © 2018 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditWorkOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblId;
@property (weak, nonatomic) IBOutlet UILabel *lblFileName;
@property (weak, nonatomic) IBOutlet UILabel *lblFileType;
@property (weak, nonatomic) IBOutlet UILabel *lblPartName;
@property (weak, nonatomic) IBOutlet UILabel *lblCost;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UILabel *lblItemTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheckBox;
@property (weak, nonatomic) IBOutlet UILabel *lblF_ULogNum;
@property (weak, nonatomic) IBOutlet UILabel *lblF_UName;
@property (weak, nonatomic) IBOutlet UILabel *lblF_UStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblF_UInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblF_UDateTime;
@property (weak, nonatomic) IBOutlet UIButton *btnF_UDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnF_UView;
@property (weak, nonatomic) IBOutlet UIButton *btnF_UEdit;
@property (weak, nonatomic) IBOutlet UILabel *lblF_UQ1;
@property (weak, nonatomic) IBOutlet UILabel *lblF_UQ2;
@property (weak, nonatomic) IBOutlet UILabel *lblF_UQ3;
@property (weak, nonatomic) IBOutlet UILabel *lblF_UQ4;
@property (weak, nonatomic) IBOutlet UIButton *btnViewImageVideo;
@property (weak, nonatomic) IBOutlet UIButton *btnDeleteImageVideo;
@property (weak, nonatomic) IBOutlet UILabel *lblNoteDate;
@property (weak, nonatomic) IBOutlet UILabel *lblNoteStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblNoteDesc;

@end
