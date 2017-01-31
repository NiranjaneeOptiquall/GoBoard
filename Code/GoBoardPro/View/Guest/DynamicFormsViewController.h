//
//  DynamicFormsViewController.h
//  GoBoardPro
//
//  Created by ind558 on 29/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "AccidentReportViewController.h"
#import "FormsHistory.h"




@interface DynamicFormsViewController : UIViewController <UITableViewDataSource, UITextFieldDelegate, DropDownValueDelegate, DatePickerDelegate, UITextViewDelegate> {
    NSMutableArray *mutArrQuestions;
    NSInteger currentIndex;
    BOOL isUpdate;
    UIPopoverController *popOver;
    UIActivityIndicatorView *indicatorView;
    
}
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITableView *tblForm;
@property (strong, nonatomic) IBOutlet UILabel *lblInstruction;
@property (weak, nonatomic) AccidentReportViewController *parentVC;
@property (strong, nonatomic) UIImage *imgBodilyFluid;
@property(nonatomic,retain)NSMutableArray *tempArray;

@property (weak, nonatomic) NSManagedObject *objFormOrSurvey;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmitLater;
@property(nonatomic,retain)FormsHistory *forms;

@property (assign, nonatomic) BOOL isSurvey;

- (IBAction)btnBackTapped:(id)sender;
- (IBAction)btnSubmitTapped:(id)sender;
@end
