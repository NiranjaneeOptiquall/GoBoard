//
//  EmergencyResponseViewController.h
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmergencyResponseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *mutArrEmergencies;
    NSIndexPath *selectedIndexPath;
}

@property (weak, nonatomic) IBOutlet UITableView *tblEmergencyList;
- (IBAction)unwindBackToEmergencyListScreen:(UIStoryboardSegue*)segue;
@end
