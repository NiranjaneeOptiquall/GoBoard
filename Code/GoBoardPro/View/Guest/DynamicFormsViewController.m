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
#import "ThankYouViewController.h"
#import "FormCustomButton.h"

@interface DynamicFormsViewController ()
{
    int tempInt;
}

@end

@implementation DynamicFormsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

   _tblForm.contentInset=UIEdgeInsetsMake(0, 0, 50, 0);
    _lblTitle.text = [_objFormOrSurvey valueForKey:@"name"];
    
  //  NSString *str=[_objFormOrSurvey valueForKey:@"question"];
    if ([[_objFormOrSurvey valueForKey:@"instructions"] isEqualToString:@""]) {
        [_lblInstruction setText:@"No instructions available."];

    }else{
         [_lblInstruction setText:[_objFormOrSurvey valueForKey:@"instructions"]];    }
   
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
        
        
        if([question valueForKey:@"mandatory"]!=nil)
        {
            [aDict setObject:[question valueForKey:@"mandatory"] forKey:@"isMandatory"];
        }
            
        
        [aDict setObject:[question valueForKey:@"question"] forKey:@"question"];
        [aDict setObject:[question valueForKey:@"questionId"] forKey:@"questionId"];
        [aDict setObject:[question valueForKey:@"responseType"] forKey:@"responseType"];
        [aDict setObject:[question valueForKey:@"sequence"] forKey:@"sequence"];
        [aDict setObject:@"" forKey:@"answer"];
        NSSortDescriptor *sortRespType = [NSSortDescriptor sortDescriptorWithKey:@"sequence.intValue" ascending:YES];
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
-(void)viewWillAppear:(BOOL)animated
{
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ThankYouScreen"]) {
        ThankYouViewController *thanksVC = (ThankYouViewController*)segue.destinationViewController;
        if (_isSurvey) {
            thanksVC.strMsg = @"Your Survey has been submitted.";
            thanksVC.strBackTitle = @"Back to Survey";
        }
        else {
            thanksVC.strMsg = @"Your Form has been submitted.";
            thanksVC.strBackTitle = @"Back to Forms";
        }
    }
}

//chetan kasundra changes starts
//change the Alert Message

- (IBAction)btnBackTapped:(id)sender {
//    if (isUpdate)
//    {
        [[[UIAlertView alloc] initWithTitle:@"WARNING" message:@"If you press \"Back\" you will lose your information. Do you want to proceed?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil] show];
//    }
//    else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}


//chages ends


- (IBAction)btnSubmitTapped:(id)sender {
    [self.view endEditing:YES];
   
    NSMutableArray *mutArrReq = [NSMutableArray array];
    NSMutableArray *isManArray=[NSMutableArray new]; // For Storing  mandatory question value
    
    
    int intVal=0;// Varaible used for replacing "NO" atIndexPath
    BOOL flag=NO;
    
    
    for(int i=0;i<mutArrQuestions.count;i++)
    {
        if([[[mutArrQuestions valueForKey:@"isMandatory"]objectAtIndex:i]boolValue])
        {
            [isManArray addObject:@"YES"];
            
            flag =YES;
        }
        
    }
    
    
    for (NSDictionary *aDict in mutArrQuestions) {
        
        if ([aDict[@"responseType"] isEqualToString:@"checkboxList"]) {
            
            int i=0;
             NSMutableString *strTemp=[[NSMutableString alloc]init];
            
            // create separate entry for each option selected. So if 2 options are selected then two entries of same question will be there with different response.
            NSArray *arySelectedOptions = [aDict[@"responseList"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected == YES"]];
            for (NSDictionary *dictResponse in arySelectedOptions) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:aDict[@"questionId"] forKey:@"QuestionId"];
                [dict setObject:aDict[@"question"] forKey:@"QuestionText"];
                
                
                if([arySelectedOptions valueForKey:@"isSelected"])
                {
                    
                    [strTemp appendString:[NSString stringWithFormat:@"%@,",[dictResponse valueForKey:@"name"]]];
                    i++;
                    
                }
                
                if(i==arySelectedOptions.count)
                {
                 
                    [strTemp deleteCharactersInRange:NSMakeRange([strTemp length]-1, 1)];
                    [dict setValue:strTemp forKey:@"ResponseText"];
                    [dict setObject:dictResponse[@"value"] forKey:@"ResponseId"];
                    
                    if(isManArray.count>0)
                    {
                        [isManArray replaceObjectAtIndex:intVal++ withObject:@"NO"];
                    }
                    
                    [mutArrReq addObject:dict];
                }
                
            }
        }
        
        else if (![aDict[@"answer"] isEqualToString:@""] && [[aDict valueForKey:@"isMandatory"]boolValue]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            
                [dict setObject:aDict[@"questionId"] forKey:@"QuestionId"];
                [dict setObject:aDict[@"question"] forKey:@"QuestionText"];
                if ([aDict[@"responseType"] isEqualToString:@"dropdown"]) {
                    
                    NSPredicate *aPredicate =[NSPredicate predicateWithFormat:@"name ==[cd] %@", [aDict objectForKey:@"answer"]];
                    NSDictionary *resp = [[aDict[@"responseList"] filteredArrayUsingPredicate:aPredicate]firstObject];
                    [dict setObject:aDict[@"answer"] forKey:@"ResponseText"];
                    [dict setObject:resp[@"value"] forKey:@"ResponseId"];
                }
                else if ([aDict[@"responseType"] isEqualToString:@"date"]) {
                    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
                    //[aFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
                    [aFormatter setDateFormat:@"MM/dd/yyyy"];
                    [dict setObject:[aFormatter stringFromDate:aDict[@"answerDate"]] forKey:@"ResponseText"];
                }
                else if ([aDict[@"responseType"] isEqualToString:@"radioButtonList"]) {
                    NSDictionary *resp = [aDict[@"responseList"] objectAtIndex:[aDict[@"answer"] integerValue]];
                    [dict setObject:resp[@"name"] forKey:@"ResponseText"];
                    [dict setObject:resp[@"value"] forKey:@"ResponseId"];
                }
                else if ([aDict[@"responseType"] isEqualToString:@"time"]) {
                    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
                    [aFormatter setDateFormat:@"hh:mm a"];
                    NSDate *dt = [aFormatter dateFromString:aDict[@"answer"]];
                    //[aFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
                    [dict setObject:[aFormatter stringFromDate:dt] forKey:@"ResponseText"];
                }
                else {
                    [dict setObject:aDict[@"answer"] forKey:@"ResponseText"];
                }
            
                if(isManArray.count>0)
                {
                    [isManArray replaceObjectAtIndex:intVal++ withObject:@"NO"];
                }
            
                [mutArrReq addObject:dict];
            }

        
        
        else if (![aDict[@"answer"] isEqualToString:@""]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:aDict[@"questionId"] forKey:@"QuestionId"];
            [dict setObject:aDict[@"question"] forKey:@"QuestionText"];
            if ([aDict[@"responseType"] isEqualToString:@"dropdown"]) {
                
                NSPredicate *aPredicate =[NSPredicate predicateWithFormat:@"name ==[cd] %@", [aDict objectForKey:@"answer"]];
                NSDictionary *resp = [[aDict[@"responseList"] filteredArrayUsingPredicate:aPredicate]firstObject];
                [dict setObject:aDict[@"answer"] forKey:@"ResponseText"];
                [dict setObject:resp[@"value"] forKey:@"ResponseId"];
            }
            else if ([aDict[@"responseType"] isEqualToString:@"date"]) {
                NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
                //[aFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
                [aFormatter setDateFormat:@"MM/dd/yyyy"];
                [dict setObject:[aFormatter stringFromDate:aDict[@"answerDate"]] forKey:@"ResponseText"];
            }
            else if ([aDict[@"responseType"] isEqualToString:@"radioButtonList"]) {
                NSDictionary *resp = [aDict[@"responseList"] objectAtIndex:[aDict[@"answer"] integerValue]];
                [dict setObject:resp[@"name"] forKey:@"ResponseText"];
                [dict setObject:resp[@"value"] forKey:@"ResponseId"];
            }
            else if ([aDict[@"responseType"] isEqualToString:@"time"]) {
                NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
                [aFormatter setDateFormat:@"hh:mm a"];
                NSDate *dt = [aFormatter dateFromString:aDict[@"answer"]];
                //[aFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
                [dict setObject:[aFormatter stringFromDate:dt] forKey:@"ResponseText"];
            }
            else {
                [dict setObject:aDict[@"answer"] forKey:@"ResponseText"];
            }
            [mutArrReq addObject:dict];
        }


        
    }
    
    if (mutArrReq.count>0 && ![isManArray containsObject:@"YES"]) {
        
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
            [self performSegueWithIdentifier:@"ThankYouScreen" sender:nil];
            } failure:^(NSError *error, NSDictionary *response) {
            [self saveDataToLocal:dictReq];
            }];
            }
        
  
    else
    {
        if (!_isSurvey) {
            if(flag)
            {
                 alert(@"", @"Please complete required fields marked with a red *");
            }
            else
            {
                alert(@"", @"Please enter some data to submit form");
            }
            

        }
        else {
            if(flag)
            {
                alert(@"", @"Please complete required fields marked with a red *");
            }
            else
            {
                alert(@"", @"Please enter some data to submit survey");
            }
            

        }
    }
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
       // aQuestion.isMandatory=[dict objectForKey:@"IsMandatory"];
        aQuestion.questionId = [dict objectForKey:@"QuestionId"];
        aQuestion.questionText = [dict objectForKey:@"QuestionText"];
        aQuestion.responseText = [dict objectForKey:@"ResponseText"];
        aQuestion.responseId = [dict objectForKey:@"ResponseId"];
        aQuestion.formOrSurvey = objRecord;
        [questionSet addObject:aQuestion];
    }
    objRecord.questionList = questionSet;
    [gblAppDelegate.managedObjectContext insertObject:objRecord];
    if ([gblAppDelegate.managedObjectContext save:nil]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:MSG_ADDED_TO_SYNC delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alert.tag = 1;
        [alert show];
        
    }
}

- (void)btnCheckMarkTapped:(UIButton *)sender
{
    isUpdate=YES;
    [sender setSelected:!sender.isSelected];
    NSIndexPath *indexPath = [self indexPathForView:sender];
    NSMutableDictionary *aDict = [mutArrQuestions objectAtIndex:indexPath.row];
    if (sender.isSelected) {
        [aDict setObject:@"true" forKey:@"answer"];
    }
    else {
        
        if([[aDict valueForKey:@"isMandatory"]boolValue])
        {
            [aDict setObject:@"" forKey:@"answer"];
        }
        else
        {
            [aDict setObject:@"false" forKey:@"answer"];
        }
        
    }
}

- (void)btnListTypeTapped:(FormCustomButton*)sender {
    isUpdate = YES;
//NSIndexPath *indexPath = [self indexPathForView:sender];
    NSIndexPath *indexPath = sender.indexPath;
    NSMutableDictionary *aDict = [mutArrQuestions objectAtIndex:indexPath.row];
    if ([aDict[@"responseType"] isEqualToString:@"checkboxList"]) {
        [sender setSelected:!sender.selected];
        [aDict[@"responseList"][sender.tag] setObject:[NSNumber numberWithBool:sender.isSelected] forKey:@"isSelected"];
    }
    else if ([aDict[@"responseType"] isEqualToString:@"radioButtonList"]) {
        for (UIView *aView in sender.superview.subviews) {
            if ([aView isKindOfClass:[UIButton class]]) {
                UIButton *aBtn = (UIButton *)aView;
                [aBtn setSelected:NO];
            }
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
    NSLog(@"cell:%@",aCell);
  NSDictionary *aDict = [mutArrQuestions objectAtIndex:indexPath.row];
    BOOL isMandatory=[[aDict valueForKey:@"isMandatory"]boolValue];
    
    if(isMandatory)
    {
        aCell.lblForIsMandatory.hidden=NO;
    }
    else
    {
       aCell.lblForIsMandatory.hidden=YES;
    }
    
[aCell.lblQuestion setText:[aDict objectForKey:@"question"]];
    
//aCell.lblQuestion.text=@"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been simply dummy text of the printing ";
    
    CGSize maximumLabelSize = CGSizeMake(654, 50);
    
    CGSize expectedLabelSize = [aCell.lblQuestion.text sizeWithFont:aCell.lblQuestion.font constrainedToSize:maximumLabelSize lineBreakMode:aCell.lblQuestion.lineBreakMode];
    CGRect newFrame = aCell.lblQuestion.frame;
    newFrame.size.height = expectedLabelSize.height;
    aCell.lblQuestion.frame = newFrame;
    

    [aCell.btnCheckMark setHidden:YES];
    [aCell.btnCheckMark addTarget:self action:@selector(btnCheckMarkTapped:) forControlEvents:UIControlEventTouchUpInside];
    [aCell.vwTextArea setHidden:YES];
    [aCell.vwButtonList setHidden:YES];
    [aCell.vwTextBox setHidden:YES];
    for (UIView *view in aCell.vwButtonList.subviews) {
        [view removeFromSuperview];
    }
    if ([[aDict objectForKey:@"responseType"] isEqualToString:@"checkboxList"] || [[aDict objectForKey:@"responseType"] isEqualToString:@"radioButtonList"]) {
        [aCell.vwButtonList setHidden:NO];
        NSInteger rows = [[aDict objectForKey:@"responseList"]count]/2;
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
        float x = 0, y = 0, width = 44;
        
        NSInteger index = 0;
        for (NSDictionary *dict in [aDict objectForKey:@"responseList"]) {
            
            FormCustomButton *aBtn = [FormCustomButton buttonWithType:UIButtonTypeCustom];
            UILabel *lblName = [[UILabel alloc]init];
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
            [lblName setFrame:CGRectMake(x+45, y, 364 - width, height)];
            //[lblName setText:@"[UIApplication endIgnoringInteractionEvents] called without matching -beginIgnoring"];
            [lblName setText:[dict objectForKey:@"name"]];
            lblName.numberOfLines=2;
            [lblName setFont:[UIFont systemFontOfSize:13.0]];
            //
            
            [lblName setTextColor:[UIColor whiteColor]];
           // [lblName setBackgroundColor:[UIColor greenColor]];
            //[aBtn setTitle:[dict objectForKey:@"name"] forState:UIControlStateNormal];
           // [aBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
            [aBtn addTarget:self action:@selector(btnListTypeTapped:) forControlEvents:UIControlEventTouchUpInside];
            [aBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [aBtn setTag:index];
            [aBtn setIndexPath:indexPath];
            
            [aCell.vwButtonList addSubview:aBtn];
            [aCell.vwButtonList addSubview:lblName];
            if ([[aDict objectForKey:@"responseType"] isEqualToString:@"checkboxList"]) {
                [aBtn setSelected:[dict[@"isSelected"] boolValue]];
            }
            else if (![aDict[@"answer"] isEqualToString:@""]) {
                
                if ([aDict[@"answer"] integerValue] == index) {
                
                    [self btnListTypeTapped:aBtn];
                }
                
            }
            index++;
        }
    }
    else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"textbox"]) {
        [aCell.vwTextBox setHidden:NO];
        [aCell.txvView setDelegate:self];
        [aCell.txvView setText:[aDict objectForKey:@"answer"]];
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
   
    NSInteger rows;
    
    CGFloat height = 50;
    NSDictionary *aDict = [mutArrQuestions objectAtIndex:indexPath.row];
    CGRect frame = [[aDict objectForKey:@"question"] boundingRectWithSize:CGSizeMake(650,100) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0]} context:nil];
    height = frame.size.height + 26;
    
    if ([[aDict objectForKey:@"responseType"] isEqualToString:@"checkboxList"] || [[aDict objectForKey:@"responseType"] isEqualToString:@"radioButtonList"]) {
        rows = [[aDict objectForKey:@"responseList"] count] / 2;
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
   // CGPoint boundsCenter = CGRectOffset(view.bounds, view.frame.size.width/2, view.frame.size.height/2).origin;

    //CGPoint viewPosition = [[view superview] convertPoint:boundsCenter toView:self.tblForm];
   // NSIndexPath *indexPath = [_tblForm indexPathForRowAtPoint:viewPosition];
    NSIndexPath *indexPath = [_tblForm indexPathForRowAtPoint:aCell.center];
    return indexPath;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.view endEditing:YES];
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
    if ([string isEqualToString:@""]) {
        return YES;
    }
    NSDictionary *aDict = [mutArrQuestions objectAtIndex:currentIndex];
    if ([[aDict objectForKey:@"responseType"] isEqualToString:@"numeric"]) {
        
        NSCharacterSet *numericCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        if ([string rangeOfCharacterFromSet:numericCharacterSet].location == NSNotFound) {
            return NO;
        }
        
//        NSCharacterSet *numericCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"-.0123456789"];
//        if ([string rangeOfCharacterFromSet:numericCharacterSet].location == NSNotFound) {
//            return NO;
//        }
//
//        NSString *aStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
//        if ([string isEqualToString:@"-"]) {
//            
//            if (aStr.length > 1)
//            {
//                return NO;
//            }
//            return YES;
//        }
//        
//        if ([string isEqualToString:@"."]) {
//        
//            if ([textField.text rangeOfString:@"."].length > 0 || ([textField.text containsString:@"-"] && textField.text.length < 2) || (![textField.text containsString:@"-"] && textField.text.length < 1) )
//            {
//                return NO;
//            }
//            return YES;
//        }
//        
//        if ([[aStr componentsSeparatedByString:@"."] count] > 1)
//        {
//             if([[[aStr componentsSeparatedByString:@"."] lastObject] length] > 2)
//             {
//                 return NO;
//             }
//            return YES;
//        }

    }
    return YES;
}

#pragma mark - UITextView Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self.view endEditing:YES];
    NSIndexPath *indexPath = [self indexPathForView:textView];
    currentIndex = indexPath.row;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    isUpdate = YES;
    NSMutableDictionary *aDict = [mutArrQuestions objectAtIndex:currentIndex];
    [aDict setObject:textView.text forKey:@"answer"];
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
    [aDict setObject:date forKey:@"answerDate"];
    [aDict setObject:[field text] forKey:@"answer"];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        [self performSegueWithIdentifier:@"ThankYouScreen" sender:nil];
    }
    else if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
