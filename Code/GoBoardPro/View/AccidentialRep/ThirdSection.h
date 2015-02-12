//
//  ThirdSection.h
//  GoBoardPro
//
//  Created by ind558 on 30/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccidentReportViewController;
@interface ThirdSection : UIView<UIPopoverControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIAlertViewDelegate> {
    NSInteger totalBodilyFluidCount, totalEmergencyPersonnelCount;
    
//    NSMutableArray *mutArrBodilyFluidViews;
    UIPopoverController *popOver;
}
@property (strong, nonatomic) NSMutableArray *mutArrEmergencyViews;
@property (weak, nonatomic) IBOutlet UIView *vwFixedContent;
@property (weak, nonatomic) IBOutlet UIButton *btnAddEmergencyPersonnel;
@property (strong, nonatomic) IBOutlet UIButton *btnDeleteEmergencyPersonnel;

@property (weak, nonatomic) AccidentReportViewController *parentVC;


- (IBAction)btnActnWitnessPresentYes:(UIButton *)sender;
- (IBAction)btnActnWitnessPresentNo:(UIButton *)sender;

- (IBAction)btnAddEmergencyPersonnel:(id)sender;
- (IBAction)btnDeleteEmergencyPersonnel:(UIButton *)sender;

- (void)initialSetUp;
- (BOOL)isThirdSectionValidationSuccess;
@end
