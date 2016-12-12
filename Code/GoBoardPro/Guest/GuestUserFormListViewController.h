//
//  GuestUserFormListViewController.h
//  GoBoardPro
//
//  Created by Inversedime on 05/12/16.
//  Copyright © 2016 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuestUserFormListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *mutArrFormList;
    NSInteger selectedIndex;
}

@property (weak, nonatomic) IBOutlet UIImageView *imvIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblFormTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRecord;
@property (weak, nonatomic) IBOutlet UITableView *tblFormList;

@property (assign, nonatomic) NSInteger guestFormType;


@end
