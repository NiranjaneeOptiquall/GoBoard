//
//  DynamicFormsViewController.m
//  GoBoardPro
//
//  Created by ind558 on 29/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "DynamicFormsViewController.h"
#import "SurveyQuestions.h"
#import "SubmitFormAndSurvey.h"
#import "QuestionDetails.h"
#import "DynamicFormCell.h"

@interface DynamicFormsViewController ()

@end

@implementation DynamicFormsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchQuestion];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchQuestion {
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
    NSArray *array = [[_objFormOrSurvey valueForKey:@"questionList"] sortedArrayUsingDescriptors:@[sort]];
    mutArrQuestions = [[NSMutableArray alloc] init];
    for (SurveyQuestions *question in array) {
        NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
        [aDict setObject:[question valueForKey:@"question"] forKey:@"question"];
        [aDict setObject:[question valueForKey:@"questionId"] forKey:@"questionId"];
        [aDict setObject:[question valueForKey:@"responseType"] forKey:@"responseType"];
        [aDict setObject:[question valueForKey:@"sequence"] forKey:@"sequence"];
        [aDict setObject:@"" forKey:@"answer"];
        NSSortDescriptor *sortRespType = [NSSortDescriptor sortDescriptorWithKey:@"value" ascending:YES];
        NSArray *arrayRespType = [[[question valueForKey:@"responseList"] allObjects] sortedArrayUsingDescriptors:@[sortRespType]];
        NSMutableArray *mutArrResponseType = [NSMutableArray array];
        for (NSManagedObject *respType in arrayRespType) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:[respType valueForKey:@"value"] forKey:@"value"];
            [dict setObject:[respType valueForKey:@"name"] forKey:@"name"];
            [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isSelected"];
            [mutArrResponseType addObject:dict];
        }
        [aDict setObject:mutArrResponseType forKey:@"responseList"];
        [mutArrQuestions addObject:aDict];
    }
    NSLog(@"%@", mutArrQuestions);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnBackTapped:(id)sender {
    if (isUpdate) {
        [[[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:@"Do you want to save your information? If you press “Back” you will lose all entered information, do you want to proceed?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil] show];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)btnSubmitTapped:(id)sender {
    [self.view endEditing:YES];
    NSMutableArray *mutArrReq = [NSMutableArray array];
    for (NSDictionary *aDict in mutArrQuestions) {
        if ([aDict[@"responseType"] isEqualToString:@"checkboxList"]) {
            // create separate entry for each option selected. So if 2 options are selected then two entries of same question will be there with different response.
            NSArray *arySelectedOptions = [aDict[@"responseList"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected == YES"]];
            for (NSDictionary *dictResponse in arySelectedOptions) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:aDict[@"questionId"] forKey:@"QuestionId"];
                [dict setObject:aDict[@"question"] forKey:@"QuestionText"];
                [dict setObject:dictResponse[@"name"] forKey:@"ResponseText"];
                [dict setObject:dictResponse[@"value"] forKey:@"ResponseId"];
                [mutArrReq addObject:dict];
            }
        }
        else if (![aDict[@"answer"] isEqualToString:@""]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:aDict[@"questionId"] forKey:@"QuestionId"];
            [dict setObject:aDict[@"question"] forKey:@"QuestionText"];
            if ([aDict[@"responseType"] isEqualToString:@"dropdown"]) {
                NSDictionary *resp = [[aDict[@"responseList"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name MATCHES[cd] %@", [aDict objectForKey:@"answer"]]] firstObject];
                [dict setObject:aDict[@"answer"] forKey:@"ResponseText"];
                [dict setObject:resp[@"value"] forKey:@"ResponseId"];
            }
            else if ([aDict[@"responseType"] isEqualToString:@"date"]) {
                NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
                [aFormatter setDateFormat:@"MM/dd/yyyy"];
                NSDate *aDate = [aFormatter dateFromString:aDict[@"answer"]];
                [aFormatter setDateFormat:@"yyyy-MM-dd"];
                [dict setObject:[aFormatter stringFromDate:aDate] forKey:@"ResponseText"];
            }
            else if ([aDict[@"responseType"] isEqualToString:@"radioButtonList"]) {
                NSDictionary *resp = [aDict[@"responseList"] objectAtIndex:[aDict[@"answer"] integerValue]];
                [dict setObject:resp[@"name"] forKey:@"ResponseText"];
                [dict setObject:resp[@"value"] forKey:@"ResponseId"];
            }
            else {
                [dict setObject:aDict[@"answer"] forKey:@"ResponseText"];
            }
            [mutArrReq addObject:dict];
        }
    }
    NSString *strUserId = @"", *strIDKeyName, *strIdValue, *strWebServiceName = @"";
    if ([User checkUserExist]) {
        strUserId = [[User currentUser] userId];
    }
    if (!_isSurvey) {
        strIDKeyName = @"FormId";
        strIdValue = [_objFormOrSurvey valueForKey:@"formId"];
        strWebServiceName = FORM_HISTORY_POST;
    }
    else {
        strIdValue = [_objFormOrSurvey valueForKey:@"surveyId"];
        strIDKeyName = @"SurveyId";
        strWebServiceName = SURVEY_HISTORY_POST;
    }
    NSString *aStrClientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
    NSDictionary *dictReq = @{@"UserId":strUserId, strIDKeyName:strIdValue, @"Details":mutArrReq, @"ClientId":aStrClientId};
    [gblAppDelegate callWebService:strWebServiceName parameters:dictReq httpMethod:[SERVICE_HTTP_METHOD objectForKey:strWebServiceName] complition:^(NSDictionary *response) {
        [[[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:@"Your response has been saved. Thank you." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    } failure:^(NSError *error, NSDictionary *response) {
        [self saveDataToLocal:dictReq];
    }];
}

- (void)saveDataToLocal:(NSDictionary*)aDict {
    SubmitFormAndSurvey *objRecord = [NSEntityDescription insertNewObjectForEntityForName:@"SubmitFormAndSurvey" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    objRecord.type = (_isSurvey) ? @"1":@"2";
    objRecord.typeId = (_isSurvey) ? [_objFormOrSurvey valueForKey:@"surveyId"]:[_objFormOrSurvey valueForKey:@"formId"];
    objRecord.userId = [aDict objectForKey:@"UserId"];
    objRecord.clientId = [aDict objectForKey:@"ClientId"];
    
    NSMutableSet *questionSet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"Details"]) {
        QuestionDetails *aQuestion = [NSEntityDescription insertNewObjectForEntityForName:@"QuestionDetails" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        aQuestion.questionId = [dict objectForKey:@"QuestionId"];
        aQuestion.questionText = [dict objectForKey:@"QuestionText"];
        aQuestion.responseText = [dict objectForKey:@"ResponseText"];
        aQuestion.responseId = [dict objectForKey:@"ResponseId"];
        aQuestion.formOrSurvey = objRecord;
        [questionSet addObject:aQuestion];
    }
    objRecord.questionList = questionSet;
    [gblAppDelegate.managedObjectContext insertObject:objRecord];
    [gblAppDelegate.managedObjectContext save:nil];
    [[[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:@"Your response has been saved. Thank you." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

- (void)btnCheckMarkTapped:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    NSIndexPath *indexPath = [self indexPathForView:sender];
    NSMutableDictionary *aDict = [mutArrQuestions objectAtIndex:indexPath.row];
    if (sender.isSelected) {
        [aDict setObject:@"true" forKey:@"answer"];
    }
    else {
        [aDict setObject:@"false" forKey:@"answer"];
    }
}

- (void)btnListTypeTapped:(UIButton*)sender {
    isUpdate = YES;
    NSIndexPath *indexPath = [self indexPathForView:sender];
    NSMutableDictionary *aDict = [mutArrQuestions objectAtIndex:indexPath.row];
    if ([aDict[@"responseType"] isEqualToString:@"checkboxList"]) {
        [sender setSelected:!sender.selected];
        [aDict[@"responseList"][sender.tag] setObject:[NSNumber numberWithBool:sender.isSelected] forKey:@"isSelected"];
    }
    else if ([aDict[@"responseType"] isEqualToString:@"radioButtonList"]) {
        for (UIButton *aBtn in sender.superview.subviews) {
            [aBtn setSelected:NO];
        }
        [sender setSelected:YES];
        [aDict setObject:[NSString stringWithFormat:@"%ld", (long)sender.tag] forKey:@"answer"];
    }
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mutArrQuestions count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DynamicFormCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *aDict = [mutArrQuestions objectAtIndex:indexPath.row];
    [aCell.lblQuestion setText:[aDict objectForKey:@"question"]];
    [aCell.btnCheckMark setHidden:YES];
    [aCell.btnCheckMark addTarget:self action:@selector(btnCheckMarkTapped:) forControlEvents:UIControlEventTouchUpInside];
    [aCell.vwTextArea setHidden:YES];
    [aCell.vwButtonList setHidden:YES];
    for (UIButton *btn in aCell.vwButtonList.subviews) {
        [btn removeFromSuperview];
    }
    if ([[aDict objectForKey:@"responseType"] isEqualToString:@"checkboxList"] || [[aDict objectForKey:@"responseType"] isEqualToString:@"radioButtonList"]) {
        [aCell.vwButtonList setHidden:NO];
        NSInteger rows = [[aDict objectForKey:@"responseList"] count] / 2;
        if ([[aDict objectForKey:@"responseList"] count] % 2 == 1) {
            rows += 1;
        }
        float height = 44;
        float vwHeight = 44*rows;
        CGRect frame = aCell.vwButtonList.frame;
        frame.size.height = vwHeight;
        [aCell.vwButtonList setFrame:frame];
        
        NSString *strImageName = @"unchecked_white_radiobutton.png", *strSelectedImageName = @"checked_white_radiobutton.png";
        if ([[aDict objectForKey:@"responseType"] isEqualToString:@"checkboxList"]) {
            strImageName = @"check_box.png";
            strSelectedImageName = @"selected_check_box.png";
        }
        float x = 0, y = 0, width = 360;
        NSInteger index = 0;
        for (NSDictionary *dict in [aDict objectForKey:@"responseList"]) {
            
            UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (index % 2 == 0) {
                x = 0;
                y = height * (index / 2);
            }
            else {
                x = 364;
            }
            [aBtn setFrame:CGRectMake(x, y, width, height)];
            [aBtn setImage:[UIImage imageNamed:strImageName] forState:UIControlStateNormal];
            [aBtn setImage:[UIImage imageNamed:strSelectedImageName] forState:UIControlStateSelected];
            [aBtn setTitle:[dict objectForKey:@"name"] forState:UIControlStateNormal];
            [aBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
            [aBtn addTarget:self action:@selector(btnListTypeTapped:) forControlEvents:UIControlEventTouchUpInside];
            [aBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [aBtn setTag:index];
            [aCell.vwButtonList addSubview:aBtn];
            if ([[aDict objectForKey:@"responseType"] isEqualToString:@"checkboxList"]) {
                [aBtn setSelected:[dict[@"isSelected"] boolValue]];
            }
            else if ([aDict[@"answer"] integerValue] == index) {
                [self btnListTypeTapped:aBtn];
            }
            index++;
        }
    }
    else if (![[aDict objectForKey:@"responseType"] isEqualToString:@"checkbox"]) {
        [aCell.vwTextArea setHidden:NO];
        [aCell.txtField setDelegate:self];
        [aCell.txtField setText:[aDict objectForKey:@"answer"]];
        if ([[aDict objectForKey:@"responseType"] isEqualToString:@"textbox"]) {
            [aCell.imvTypeIcon setHidden:YES];
            [aCell.txtField setKeyboardType:UIKeyboardTypeAlphabet];
        }
        else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"numeric"]) {
            [aCell.imvTypeIcon setHidden:YES];
            [aCell.txtField setKeyboardType:UIKeyboardTypeNumberPad];
        }
        else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"time"]) {
            [aCell.imvTypeIcon setHidden:NO];
            [aCell.imvTypeIcon setImage:[UIImage imageNamed:@"time.png"]];
        }
        else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"dropdown"]) {
            [aCell.imvTypeIcon setHidden:NO];
            [aCell.imvTypeIcon setImage:[UIImage imageNamed:@"arrow.png"]];
        }
        else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"date"]) {
            [aCell.imvTypeIcon setHidden:NO];
            [aCell.imvTypeIcon setImage:[UIImage imageNamed:@"date.png"]];
        }
    }
    else {
        [aCell.btnCheckMark setHidden:NO];
        if ([[aDict objectForKey:@"answer"] isEqualToString:@"true"]) {
            [aCell.btnCheckMark setSelected:YES];
        }
        else {
            [aCell.btnCheckMark setSelected:NO];
        }
    }
    
    //UIView *aView = [aCell.contentView viewWithTag:4];
    //CGRect frame = aView.frame;
    //frame.origin.y = aCell.frame.size.height - 3;
    //frame.size.height = 3;
    //[aView setFrame:frame];
    [aCell setBackgroundColor:[UIColor clearColor]];
    return aCell;
}


- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 50;
    NSDictionary *aDict = [mutArrQuestions objectAtIndex:indexPath.row];
    CGRect frame = [[aDict objectForKey:@"question"] boundingRectWithSize:CGSizeMake(650,100) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0]} context:nil];
    height = frame.size.height + 26;
    
    if ([[aDict objectForKey:@"responseType"] isEqualToString:@"checkboxList"] || [[aDict objectForKey:@"responseType"] isEqualToString:@"radioButtonList"]) {
        NSInteger rows = [[aDict objectForKey:@"responseList"] count] / 2;
        if ([[aDict objectForKey:@"responseList"] count] % 2 == 1) {
            rows += 1;
        }
        height += 44*rows;
    }
    else if (![[aDict objectForKey:@"responseType"] isEqualToString:@"checkbox"]) {
        height += 75;
    }
    
    return height;
}

- (NSIndexPath *)indexPathForView:(UIView*)view {
    DynamicFormCell *aCell = (DynamicFormCell*)[view superview];
    while (![aCell isKindOfClass:[DynamicFormCell class]]) {
        aCell = (DynamicFormCell *)[aCell superview];
    }
    NSIndexPath *indexPath = [_tblForm indexPathForCell:aCell];
    return indexPath;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSIndexPath *indexPath = [self indexPathForView:textField];
    currentIndex = indexPath.row;
    NSDictionary *aDict = [mutArrQuestions objectAtIndex:indexPath.row];
    if ([[aDict objectForKey:@"responseType"] isEqualToString:@"time"]) {
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        [datePopOver setDelegate:self];
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_NONE option:DATE_SELECTION_TIME_ONLY updateField:textField];
        return NO;
    }
    else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"dropdown"]) {
        DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
        dropDown.delegate = self;
        [dropDown showDropDownWith:[aDict objectForKey:@"responseList"] view:textField key:@"name"];
        return NO;
    }
    else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"date"]) {
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        [datePopOver setDelegate:self];
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_NONE option:DATE_SELECTION_DATE_ONLY updateField:textField];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    isUpdate = YES;
    NSMutableDictionary *aDict = [mutArrQuestions objectAtIndex:currentIndex];
    [aDict setObject:textField.text forKey:@"answer"];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSDictionary *aDict = [mutArrQuestions objectAtIndex:currentIndex];
    if ([[aDict objectForKey:@"responseType"] isEqualToString:@"numeric"]) {
        NSCharacterSet *numericCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        if ([string rangeOfCharacterFromSet:numericCharacterSet].location == NSNotFound) {
            return NO;
        }
    }
    return YES;
}

- (void)dropDownControllerDidSelectValue:(id)value atIndex:(NSInteger)index sender:(id)sender {
    isUpdate = YES;
    NSIndexPath *indexPath = [self indexPathForView:sender];
    NSMutableDictionary *aDict = [mutArrQuestions objectAtIndex:indexPath.row];
    [aDict setObject:[value valueForKey:@"name"] forKey:@"answer"];
    [sender setText:[value valueForKey:@"name"]];
}


- (void)datePickerDidSelect:(NSDate*)date forObject:(id)field {
    isUpdate = YES;
    NSMutableDictionary *aDict = [mutArrQuestions objectAtIndex:currentIndex];
    [aDict setObject:[field text] forKey:@"answer"];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
