//
//  GraphListViewController.h
//  GoBoardPro
//
//  Created by ind558 on 10/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface GraphListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *mutArrGraphList;
    NSInteger row;
}
@property (weak, nonatomic) IBOutlet UITableView *tblGraphList;

- (IBAction)unwindBackToGraphListScreen:(UIStoryboardSegue*)segue;

@end
