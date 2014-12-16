//
//  GuestHomeViewController.h
//  GoBoardPro
//
//  Created by ind558 on 23/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface GuestFormViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *mutArrFormList;
    NSInteger selectedIndex;
}

@property (weak, nonatomic) IBOutlet UIImageView *imvIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblFormTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRecord;
@property (weak, nonatomic) IBOutlet UITableView *tblFormList;

@property (assign, nonatomic) NSInteger guestFormType;
- (IBAction)btnBackTapped:(id)sender;
@end
