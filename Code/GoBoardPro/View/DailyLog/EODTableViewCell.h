//
//  EODTableViewCell.h
//  GoBoardPro
//
//  Created by Optiquall Solutions on 29/12/16.
//  Copyright © 2016 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EODTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *checkMarkButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;

@end
