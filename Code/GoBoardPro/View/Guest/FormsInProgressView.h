//
//  FormsInProgressView.h
//  GoBoardPro
//
//  Created by Inversedime on 29/11/16.
//  Copyright © 2016 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicFormsViewController.h"
#import "FormsList.h"
#import "SurveyQuestions.h"
#import "SurveyResponseTypeValues.h"
#import "Reachability.h"

@protocol FormsInProgressDelegate
-(void)inProgressForm:(NSMutableArray*)arr;
@end

@interface FormsInProgressView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tblFormsInProgress;
@property(nonatomic,retain) NSString *formId;
@property(nonatomic,retain)NSDictionary *dictFormsInProgress;
@property (nonatomic, retain) id <FormsInProgressDelegate> delegate;
@property(nonatomic,retain)DynamicFormsViewController *DYView;
@property(nonatomic,retain)NSManagedObject *managedObject;

@end
