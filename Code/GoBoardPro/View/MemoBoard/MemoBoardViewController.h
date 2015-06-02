//
//  MemoBoardViewController.h
//  GoBoardPro
//
//  Created by ind558 on 11/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface MemoBoardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate, UIPopoverControllerDelegate> {
    NSMutableArray *mutArrMemoList;
    UIPopoverController *popOver;
    NSMutableArray *mutArrSelectedMemo;
    NSMutableArray *mutArrMemoListTemp;
}
@property (weak, nonatomic) IBOutlet UITableView *tblMemoList;
@property (weak, nonatomic) IBOutlet UIView *vwPopOver;
@property (weak, nonatomic) IBOutlet UITextView *txvPopOver;

- (IBAction)btnBackTapped:(id)sender;
- (IBAction)btnDeleteTapped:(id)sender;

@end
