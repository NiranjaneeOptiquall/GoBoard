//
//  AdminTaskListViewController.h
//  GoBoardPro
//
//  Created by ind558 on 13/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface AdminTaskListViewController : UIViewController<DropDownValueDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *mutArrTaskList;
}

@property (weak, nonatomic) IBOutlet UITextField *txtFacility;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UITableView *tblTaskList;
@end
