//
//  AdminTaskListViewController.h
//  GoBoardPro
//
//  Created by ind558 on 13/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "UserFacility.h"
#import "UserLocation.h"
#import "UserLocation1.h"

@interface AdminTaskListViewController : UIViewController<DropDownValueDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *mutArrTaskList;
    UserFacility *selectedFacility;
    UserLocation *selectedLocation;
    NSMutableArray *arySelectedPostion;
    NSMutableArray *arySelectedLocation;
    NSMutableArray *aryFilterPostion;
    NSArray *aryFacilities, *aryLocation;
}

@property (weak, nonatomic) IBOutlet UILabel *lblNoRecords;
@property (weak, nonatomic) IBOutlet UITextField *txtFacility;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UITableView *tblTaskList;
@end
