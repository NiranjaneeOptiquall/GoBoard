//
//  SOPDetailViewController.h
//  GoBoardPro
//
//  Created by ind558 on 26/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface SOPDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSDictionary *dictSOPDetails;
    NSInteger selectedRow;
}
@property (weak, nonatomic) IBOutlet UILabel *lblSOPCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblSOPParentCategory;

@property (weak, nonatomic) IBOutlet UILabel *lblSOPTitle;
@property (weak, nonatomic) IBOutlet UITableView *tblSOPList;
@property (weak, nonatomic) IBOutlet UITableView *tblSOPCategory;

@property (strong, nonatomic) NSDictionary *dictSopCategry;
@property (strong, nonatomic) NSMutableArray *mutArrCategoryHierarchy;
@end
