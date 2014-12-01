//
//  DynamicFormsViewController.h
//  GoBoardPro
//
//  Created by ind558 on 29/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"


@class SurveyList;
@interface DynamicFormsViewController : UIViewController <UITableViewDataSource, UITextFieldDelegate, DropDownValueDelegate> {
    NSMutableArray *mutArrQuestions;
}
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITableView *tblForm;

@property (weak, nonatomic) SurveyList *survey;

- (IBAction)btnBackTapped:(id)sender;
@end
