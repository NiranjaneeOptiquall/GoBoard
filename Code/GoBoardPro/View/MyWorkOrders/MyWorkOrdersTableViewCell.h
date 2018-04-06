//
//  MyWorkOrdersTableViewCell.h
//  GoBoardPro
//
//  Created by Optiquall Solutions on 13/12/17.
//  Copyright © 2017 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWorkOrdersTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgCheckBox;
@property (weak, nonatomic) IBOutlet UILabel *lblItemTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnView;
@property (weak, nonatomic) IBOutlet UIButton *btnAddnotes;

@property (weak, nonatomic) IBOutlet UILabel *lblWorkOrderNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblGeneralEquipment;
@property (weak, nonatomic) IBOutlet UILabel *lblGeneralEquipmentId;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblImage;
@property (weak, nonatomic) IBOutlet UILabel *lblDateSubmitted;
@property (weak, nonatomic) IBOutlet UILabel *lblAssignTo;
@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdated;
@property (weak, nonatomic) IBOutlet UILabel *lblUpdatedBy;
@property (weak, nonatomic) IBOutlet UILabel *lblNotes;
@property (weak, nonatomic) IBOutlet UIView *viewDetailBG;

@end
