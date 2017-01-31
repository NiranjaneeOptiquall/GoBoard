//
//  TeamLogCommentsVC.h
//  GoBoardPro
//
//  Created by E2M183 on 2/11/16.
//  Copyright © 2016 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "TeamLog.h"
@interface TeamLogCommentsVC : UIViewController<HPGrowingTextViewDelegate>
{
    UIView *containerView;
    HPGrowingTextView *textView;
    UILabel *lblCount;

}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cnstTextViewHeight;
@property (strong, nonatomic) IBOutlet UITextView *txtViewLog;
@property (nonatomic,strong)TeamLog *teamLogObj;
@property (nonatomic,strong)NSMutableArray *mutArrComments;
@property (strong, nonatomic) IBOutlet UITableView *tblViewComments;
@property (strong, nonatomic) IBOutlet UILabel *lblPosition;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong, nonatomic) IBOutlet UILabel *lblNoRecords;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cnstTxtViewLogHeight;
@property (strong, nonatomic) IBOutlet UILabel *lblComments;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;

- (IBAction)btnBackTapped:(id)sender;
- (IBAction)btnSubmitTapped:(id)sender;
@end
