//
//  facilityListingTableViewCell.h
//  GoBoardPro
//
//  Created by Optiquall Solutions on 06/10/17.
//  Copyright © 2017 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface facilityListingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblFacility;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheck;
@property (weak, nonatomic) IBOutlet UIWebView *logWebView;

@end
