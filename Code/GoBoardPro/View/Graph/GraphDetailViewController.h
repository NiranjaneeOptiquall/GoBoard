//
//  GraphDetailViewController.h
//  GoBoardPro
//
//  Created by ind558 on 07/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface GraphDetailViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate,DropDownValueDelegate, DatePickerDelegate, UICollectionViewDataSource> {
    NSMutableArray *mutArrGraphTypes;
    NSMutableArray *mutArrDataSource;
    NSArray *xTitles, *xAxisTitles;
    NSArray *aryLocation;
    NSString *selectedLocationValue;
    NSArray *aryColumns;
}

@property (weak, nonatomic) IBOutlet UILabel *lblGraphTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtStartDate;
@property (weak, nonatomic) IBOutlet UITextField *txtEndDate;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UIView *vwGraphDisplay;
@property (weak, nonatomic) IBOutlet UITableView *tblGraphColor;
@property (weak, nonatomic) IBOutlet UIView *vwDropDownBack;
@property (weak, nonatomic) IBOutlet UIView *vwGraphBack;
@property (weak, nonatomic) IBOutlet UITableView *tblStatistics;
@property (weak, nonatomic) IBOutlet UILabel *lblXValue;
@property (weak, nonatomic) IBOutlet UICollectionView *colViewData;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlStatistics;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlColHeader;

@property (assign, nonatomic) NSInteger graphType;
@end