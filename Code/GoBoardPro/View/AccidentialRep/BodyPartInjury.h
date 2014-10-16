//
//  BodyPartInjury.h
//  GoBoardPro
//
//  Created by ind558 on 29/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface BodyPartInjury : UIView<UITableViewDataSource, UITableViewDelegate, DropDownValueDelegate> {
    NSMutableArray *mutArrBodyPart;
    NSInteger bodyPartIndex;
    NSInteger selectedBodyPart;
}

@property (weak, nonatomic) IBOutlet UITextField *txtEnjuryType;
@property (weak, nonatomic) IBOutlet UITextField *txtActionTaken;
@property (weak, nonatomic) IBOutlet UIButton *btnGeneralInjury;
@property (weak, nonatomic) IBOutlet UIButton *btnBodyPartInjury;
@property (weak, nonatomic) IBOutlet UIImageView *imvOtherInjuryBG;
@property (weak, nonatomic) IBOutlet UITextField *txtOtherInjury;
@property (weak, nonatomic) IBOutlet UIView *vwInjuryDetails;
@property (weak, nonatomic) IBOutlet UITableView *tblInjuredBodyPartList;
@property (weak, nonatomic) IBOutlet UITableView *tblAddedInjuryList;
@property (weak, nonatomic) IBOutlet UITextField *txtCareProvided;
@property (weak, nonatomic) IBOutlet UIImageView *imvBodyPart;
@property (weak, nonatomic) IBOutlet UILabel *lblBodyPart;
@property (weak, nonatomic) IBOutlet UILabel *lblBodyPartNote;
@property (weak, nonatomic) IBOutlet UIView *vwHumanFigure;
@property (weak, nonatomic) IBOutlet UIButton *btnHead;
@property (weak, nonatomic) IBOutlet UIButton *btnLeftHand;
@property (weak, nonatomic) IBOutlet UIButton *btnMidBody;
@property (weak, nonatomic) IBOutlet UIButton *btnRightHand;
@property (weak, nonatomic) IBOutlet UIButton *btnRightLeg;
@property (weak, nonatomic) IBOutlet UIButton *btnLeftLeg;
@property (weak, nonatomic) IBOutlet UIView *vwInjuryListHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblNoInjuryAdded;

@property (strong, nonatomic) NSMutableArray *mutArrInjuryList;

- (IBAction)btnInjuryTypeGeneralTapped:(UIButton *)sender;
- (IBAction)btnInjuryTypeBodyPartTapped:(UIButton *)sender;
- (IBAction)btnAddAnotherInjuryTapped:(id)sender;
- (IBAction)btnInjureadBodyPartTapped:(UIButton *)sender;
- (void)manageData;
- (BOOL)isBodyPartInjuredInfoValidationSuccess;

@end
