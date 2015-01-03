//
//  UpdateProfileViewController.h
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "Constants.h"

@interface UpdateProfileViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate> {
    NSInteger totalCertificateCount;
    NSString *strPreviousText;
    BOOL isUpdate;
    NSInteger removeCertificateIndex;
    NSMutableArray *mutArrDeletedCertificates;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrlCertificationView;
@property (weak, nonatomic) IBOutlet UITextField *txtFitstName;
@property (weak, nonatomic) IBOutlet UITextField *txtMiddleName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *mainScrlView;
@property (weak, nonatomic) IBOutlet UIView *vwSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnLikeToRcvTextMSG;
@property (weak, nonatomic) IBOutlet UITextView *txvTerms;
@property (weak, nonatomic) IBOutlet UIButton *btnAgreeTerms;
@property (weak, nonatomic) IBOutlet UIView *vwTerms;
@property (strong, nonatomic) NSArray *aryCertificates;
@property (weak, nonatomic) IBOutlet UILabel *lblSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

- (IBAction)btnAddMoreCertification:(id)sender;
- (IBAction)btnSubmitTapped:(id)sender;
- (IBAction)btnBackTapped:(id)sender;
- (IBAction)btnLikeToRcvTextMSGTapped:(UIButton *)sender;
- (IBAction)btnPasswordHintTapped:(id)sender;
- (IBAction)btnAgreeTermsTapped:(UIButton *)sender;
@end
