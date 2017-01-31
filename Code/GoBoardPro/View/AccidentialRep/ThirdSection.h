//
//  ThirdSection.h
//  GoBoardPro
//
//  Created by ind558 on 30/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ThirdSectionFrameDelegate <NSObject>

-(void)adjustFramingForEmergencyView;

@end

@class AccidentReportViewController;
@interface ThirdSection : UIView<UIPopoverControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIAlertViewDelegate> {
    NSInteger totalBodilyFluidCount, totalEmergencyPersonnelCount;
    
//    NSMutableArray *mutArrBodilyFluidViews;
    UIPopoverController *popOver;
    
    
}

@property (nonatomic, assign)  NSInteger totalBodilyFluidCount, totalEmergencyPersonnelCount;
@property (nonatomic, assign) BOOL isShowEmergencyResponse;

@property (strong, nonatomic) NSMutableArray *mutArrEmergencyViews;
@property (weak, nonatomic) IBOutlet UIView *vwFixedContent;
@property (weak, nonatomic) IBOutlet UIButton *btnAddEmergencyPersonnel;
@property (strong, nonatomic) IBOutlet UIButton *btnDeleteEmergencyPersonnel;

@property (weak, nonatomic) AccidentReportViewController *parentVC;

- (IBAction)btnAddEmergencyPersonnel:(id)sender;
- (IBAction)btnDeleteEmergencyPersonnel:(UIButton *)sender;

- (void)resetSelfFrame;
- (void)addEmergencyPersonnel;
- (void)initialSetUp;
- (BOOL)isThirdSectionValidationSuccess;

@property (strong, nonatomic) id <ThirdSectionFrameDelegate> delegate;

@end
