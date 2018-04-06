//
//  SOPViewController.h
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface SOPViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,UIWebViewDelegate> {
    NSMutableArray *mutArrSOPList , * allSopArrList,*allSearchData, *tempArr,*allDataForLinkedSopErp;
    
}
@property (assign, nonatomic) BOOL isBtnSOPListHidden;
@property (strong, nonatomic) NSMutableArray *mutArrCategoryHierarchy;
@property (strong, nonatomic) NSDictionary *dictSOPCategory;
@property (weak, nonatomic) IBOutlet UITableView *tblSOPList;
@property (weak, nonatomic) IBOutlet UIButton *btnSOPList;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITableView *tblSOPCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRecords;
- (IBAction)unwindBackToSOPListScreen:(UIStoryboardSegue*)segue;
- (IBAction)btnBackTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrlView;
@property (weak, nonatomic) IBOutlet UILabel *lblSearchNote;

@property (weak, nonatomic) IBOutlet UIView *scrollBGview;

@property (strong, nonatomic) IBOutlet UIWebView *viewWeb;
@property (strong, nonatomic) IBOutlet UIWebView *viewWebDescription;
@property (strong, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtSearchTag;
@property (weak, nonatomic) IBOutlet UIButton *btnSearchTag;

@end
