//
//  GuestFormCell.h
//  GoBoardPro
//
//  Created by Inversedime on 29/11/16.
//  Copyright © 2016 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuestFormCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *btnFormInProgress;

@property (strong, nonatomic) IBOutlet UILabel *lblFormsCount;


@property (strong, nonatomic) IBOutlet UILabel *lblFormName;
@property (strong, nonatomic) IBOutlet UILabel *aLblInstruction;
@property (strong, nonatomic) IBOutlet UIButton *btnGuestUserFormCount;
@property (strong, nonatomic) IBOutlet UILabel *lblGuestUserShowCount;

@end
