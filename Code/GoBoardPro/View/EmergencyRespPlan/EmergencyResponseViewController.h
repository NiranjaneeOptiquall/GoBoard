//
//  EmergencyResponseViewController.h
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmergencyResponseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIWebViewDelegate> {
    NSMutableArray *allSearchData,*allSopArrList,*mutArrEmergencies;
    NSIndexPath *selectedIndexPath;
}
@property (assign, nonatomic) BOOL isBtnERPListHidden;
@property (weak, nonatomic) IBOutlet UITableView *tblEmergencyList;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRecords;
@property (strong, nonatomic) IBOutlet UITableView *tblERPCategory;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;


@property (strong, nonatomic) NSMutableArray *mutArrCategoryHierarchy;
@property (strong, nonatomic) NSDictionary *dictERPCategory;
@property (weak, nonatomic) IBOutlet UIButton *btnERPList;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
- (IBAction)unwindBackToERPListScreen:(UIStoryboardSegue*)segue;

- (IBAction)btnBackTapped:(UIButton *)sender;
- (IBAction)btnERPListTapped:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIWebView *viewWeb;
@property (strong, nonatomic) IBOutlet UITextView *txtDescription;
@property (strong, nonatomic) IBOutlet UIWebView *viewWebDescription;

@property (weak, nonatomic) IBOutlet UIButton *btnSearchTag;
@property (weak, nonatomic) IBOutlet UITextField *txtSearchTag;
@property (weak, nonatomic) IBOutlet UILabel *lblSearchNote;

@end
