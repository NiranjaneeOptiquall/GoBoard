//
//  CreateWorkOrderTableViewCell.h
//  GoBoardPro
//
//  Created by Optiquall Solutions on 23/12/17.
//  Copyright © 2017 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateWorkOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblId;
@property (weak, nonatomic) IBOutlet UILabel *lblFileName;
@property (weak, nonatomic) IBOutlet UILabel *lblFileType;
//@property (weak, nonatomic) IBOutlet UILabel *lblPartName;
//@property (weak, nonatomic) IBOutlet UILabel *lblCost;
//@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
//@property (weak, nonatomic) IBOutlet UILabel *lblItemTitle;
//@property (weak, nonatomic) IBOutlet UIImageView *imgCheckBox;
@property (weak, nonatomic) IBOutlet UIButton *btnViewImageVideo;
@property (weak, nonatomic) IBOutlet UIButton *btnDeleteImageVideo;
@end
