//
//  TableViewHeader.h
//  DemoTreeLikeTableView
//
//  Created by Inversedime on 22/11/16.
//  Copyright © 2016 Optiquall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewHeader : UIView
@property (strong, nonatomic) IBOutlet UIButton *buttonAction;
@property (strong, nonatomic) IBOutlet UILabel *lblCategory;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *minusImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblInProgressCount;
@property (weak, nonatomic) IBOutlet UILabel *lblOfflineInProgressCount;
@property (weak, nonatomic) IBOutlet UIButton *btnInProgressCount;
@property (weak, nonatomic) IBOutlet UIButton *btnOfflineCount;

@end
