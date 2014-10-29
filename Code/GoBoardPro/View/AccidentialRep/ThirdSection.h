//
//  ThirdSection.h
//  GoBoardPro
//
//  Created by ind558 on 30/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdSection : UIView<UIPopoverControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    NSInteger totalBodilyFluidCount, totalEmergencyPersonnelCount;
    NSMutableArray *mutArrEmergencyViews;
//    NSMutableArray *mutArrBodilyFluidViews;
    UIPopoverController *popOver;
}

@property (weak, nonatomic) IBOutlet UIView *vwFixedContent;
@property (weak, nonatomic) IBOutlet UIButton *btnAddEmergencyPersonnel;
//@property (weak, nonatomic) IBOutlet UIButton *btnCaptureImage;

//@property (strong, nonatomic) UIImage *imgBodilyFluid;

//- (IBAction)btnAttachPhotoTapped:(UIButton *)sender;
//- (IBAction)btnAddMoreBodilyFluidTapped:(id)sender;
- (IBAction)btnAddEmergencyPersonnel:(id)sender;
- (void)initialSetUp;
- (BOOL)isThirdSectionValidationSuccess;
@end
