//
//  AccidentFirstSection.h
//  GoBoardPro
//
//  Created by ind558 on 29/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonInformation.h"
#import "BodyPartInjury.h"
#import "BodilyFluidView.h"
#import "AccidentPerson.h"

@class AccidentReportViewController;

@interface AccidentFirstSection : UIView<UIPopoverControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
    UIPopoverController *popOver;
}

@property (weak, nonatomic) IBOutlet PersonInformation *vwPersonalInfo;
@property (weak, nonatomic) IBOutlet BodyPartInjury *vwBodyPartInjury;
@property (weak, nonatomic) IBOutlet BodilyFluidView *vwBodilyFluid;
@property (weak, nonatomic) IBOutlet UIButton *btnCaptureImage;
@property (strong, nonatomic) UIImage *imgBodilyFluid;
@property (assign, nonatomic) BOOL isCaptureCameraVisible;

@property (weak, nonatomic) AccidentReportViewController *parentVC;
- (BOOL)validateAccidentFirstSectionWith:(NSArray*)firstAid;

- (IBAction)btnAttachPhotoTapped:(UIButton *)sender;
- (NSDictionary*)getAccidentPerson;
@end
