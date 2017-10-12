//
//  DailyLogViewController.h
//  GoBoardPro
//
//  Created by ind558 on 10/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface DailyLogViewController : UIViewController <UITextViewDelegate, UITableViewDataSource, UITableViewDelegate,DropDownValueDelegate> {
    NSMutableArray *mutArrDailyList, * selectedFacilityArr;
    NSArray *aryFacilities;
    BOOL isUpdate;
}
@property (nonatomic,assign) BOOL boolISWSCallNeeded;
@property (strong, nonatomic) IBOutlet UILabel *lblCharacterCount;
@property (weak, nonatomic) IBOutlet UITableView *tblDailyLog;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRecords;
@property (weak, nonatomic) IBOutlet UILabel *lblLogPlaceholder;
@property (weak, nonatomic) IBOutlet UITextView *txvDailyLog;
@property (strong, nonatomic) IBOutlet UIView *viewSelectPos;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong, nonatomic) IBOutlet UITextField *txtPosition;
@property (strong, nonatomic) IBOutlet UIButton *btnToggleTeam;
@property (weak, nonatomic) IBOutlet UITableView *tblFacilityListing;
@property (weak, nonatomic) IBOutlet UILabel *lblMyLog;

- (IBAction)btnBackTapped:(UIButton *)sender;
- (IBAction)btnSubmitTapped:(id)sender;
- (IBAction)btnToggleTeamTapped:(id)sender;
@end
