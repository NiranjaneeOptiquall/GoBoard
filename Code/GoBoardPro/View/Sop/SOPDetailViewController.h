//
//  SOPDetailViewController.h
//  GoBoardPro
//
//  Created by ind558 on 26/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOPDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *mutArrSOPList;
}
@property (weak, nonatomic) IBOutlet UILabel *lblSOPCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblSOPParentCategory;

@property (weak, nonatomic) IBOutlet UILabel *lblSOPTitle;
@property (weak, nonatomic) IBOutlet UITableView *tblSOPList;
@end
