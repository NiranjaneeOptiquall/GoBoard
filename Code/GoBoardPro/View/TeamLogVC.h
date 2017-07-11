//
//  TeamLogVC.h
//  GoBoardPro
//
//  Created by E2M183 on 2/10/16.
//  Copyright © 2016 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamLogVC : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tblViewteamLog;
@property (strong, nonatomic) IBOutlet UILabel *lblNoRecords;
@property (nonatomic,strong)NSMutableArray *mutArrTeamLog;
- (IBAction)toggleDailyLogBtnAction:(id)sender;
- (IBAction)btnBackTapped:(id)sender;
- (IBAction)btnViewCommentsTapped:(id)sender;
@end
