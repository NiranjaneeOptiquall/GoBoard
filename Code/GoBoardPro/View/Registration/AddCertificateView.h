//
//  AddCertificateView.h
//  GoBoardPro
//
//  Created by ind558 on 24/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface AddCertificateView : UIView<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UIActionSheetDelegate> {
    UIPopoverController *popOver;
}
@property (weak, nonatomic) IBOutlet UITextField *txtCertificateName;
@property (weak, nonatomic) IBOutlet UITextField *txtExpDate;
@property (weak, nonatomic) IBOutlet UIButton *btnCaptureImage;
@property (weak, nonatomic) UIViewController *parentView;
@property (weak, nonatomic) IBOutlet UIButton *btnRemove;

@property (strong, nonatomic) UIImage *imgCertificate;
- (IBAction)btnSelectExpDate:(id)sender;
- (IBAction)btnCaptureCertificatieImageTapped:(id)sender;


@end
