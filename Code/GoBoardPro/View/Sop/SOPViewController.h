//
//  SOPViewController.h
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface SOPViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *mutArrSOPList;
    
}
@property (strong, nonatomic) NSMutableArray *mutArrCategoryHierarchy;
@property (strong, nonatomic) NSDictionary *dictSOPCategory;
@property (weak, nonatomic) IBOutlet UITableView *tblSOPList;
@property (weak, nonatomic) IBOutlet UIButton *btnSOPList;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITableView *tblSOPCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRecords;
- (IBAction)unwindBackToSOPListScreen:(UIStoryboardSegue*)segue;
- (IBAction)btnBackTapped:(id)sender;
- (IBAction)btnSOPListTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UIWebView *viewWeb;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;

@end
