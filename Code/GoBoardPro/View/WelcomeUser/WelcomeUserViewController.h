//
//  WelcomeUserViewController.h
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "UserLocation.h"
#import "UserPosition.h"
#import "UserFacility.h"
#import "UserLocation1.h"

@interface WelcomeUserViewController : UIViewController<UITextFieldDelegate, DropDownValueDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSArray *aryFacilities, *aryPositions;
    NSMutableArray *aryLocation,*aryPositionId;
    NSString * flag;
    UserFacility *selectedFacility;
    UserLocation *selectedLocation;
    UserPosition *selectedPosition;
    UserLocation1 *selectedLocation1;
}
@property (weak, nonatomic) IBOutlet UITextField *txtFacility;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UITextField *txtPosition;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UITableView *tblLocation;
@property (weak, nonatomic) IBOutlet UITableView *tblPosition;
@property (weak, nonatomic) IBOutlet UIView *vwFacility;
@property (weak, nonatomic) IBOutlet UILabel *lblAcceptTerms;
@property (strong, nonatomic) IBOutlet UILabel *lblVersion;
@property (retain,nonatomic) NSTimer* idleTimer;

- (IBAction)btnSubmitTapped:(id)sender;
- (IBAction)btnUpdateProfileTapped:(id)sender;
@end
