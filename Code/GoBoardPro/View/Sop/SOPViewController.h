//
//  SOPViewController.h
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOPViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *mutArrSOPList;
}
@property (weak, nonatomic) IBOutlet UITableView *tblSOPList;
- (IBAction)unwindBackToSOPListScreen:(UIStoryboardSegue*)segue;
@end
