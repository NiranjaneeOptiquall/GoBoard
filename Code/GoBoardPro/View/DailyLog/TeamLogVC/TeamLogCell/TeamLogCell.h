//
//  TeamLogCell.h
//  GoBoardPro
//
//  Created by E2M183 on 2/11/16.
//  Copyright © 2016 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamLogCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel *lblPosition;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;

@property (weak, nonatomic) IBOutlet UIWebView *webViewDesc;

@property (strong, nonatomic) IBOutlet UITextView *txtViewUsername;
@property (strong, nonatomic) IBOutlet UITextView *txtViewPosition;
@property (strong, nonatomic) IBOutlet UITextView *txtViewDate;
@property (strong, nonatomic) IBOutlet UIButton *btnViewComments;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cnstTxtViewUserNameHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cnstTextViewPositionHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cnstTextViewDateHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cnstLblDescriptionTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstWebDescriptionTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstWebDescriptionHeight;

@end
