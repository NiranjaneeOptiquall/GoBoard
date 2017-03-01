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
#import "SignatureView.h"
#import "FormsInProgressView.h"
#import "FormsHistory.h"
#import "OfflineResponseTypeValues.h"

@interface DynamicFormsViewController ()<UITextViewDelegate,UIPopoverControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,FormsInProgressDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    int tempInt;
   UITextField *currentTextField;
    CGFloat contentHight;
    CGRect rect;
    NSMutableArray *imageArray;
    NSMutableArray *arrOfBtnTitleString;
    UIView *viewActivity;
    NSString * thankYouFlag,*tempstrDataType,*aStrInProgressFormId,*strisInProgress;
    CGFloat questionHight;
    NSInteger  totalSizeOFUploadedVideo;

}
@property (nonatomic, assign) BOOL shouldHideActivityIndicator;

@property(nonatomic,retain)SignatureView *signatureView;
@end

@implementation DynamicFormsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
totalSizeOFUploadedVideo=0;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
  

    _shouldHideActivityIndicator = YES;
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"isFormHistory"]isEqualToString:@"yes"])
    {
        //**********get data of forms/survey  in progress**********//

        NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"indexpath"];
        NSMutableArray * arrOfForms = [NSMutableArray new];
        NSFetchRequest *request =[[NSFetchRequest alloc]init];
      
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"fromSuveyViewC" ] isEqualToString:@"YES"]) {
       request = [[NSFetchRequest alloc] initWithEntityName:@"SurveyInProgress"];
        }
        else if (_isSurvey){
            request = [[NSFetchRequest alloc] initWithEntityName:@"SurveyInProgress"];
        }
        else{
     request = [[NSFetchRequest alloc] initWithEntityName:@"FormsInProgress"];
        }
        arrOfForms = [NSMutableArray arrayWithArray:[gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil]];

        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:TRUE];
        [arrOfForms sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];

         arrOfForms = [[[arrOfForms reverseObjectEnumerator] allObjects] mutableCopy];
        
        _objFormOrSurvey  = [arrOfForms objectAtIndex:[str intValue]];
  
    }
    

            _lblTitle.text = [_objFormOrSurvey valueForKey:@"name"];
    
            imageArray =[NSMutableArray new];
            arrOfBtnTitleString=[NSMutableArray new];
            
    //********** set header instruction label**********//
  
            if ([[_objFormOrSurvey valueForKey:@"instructions"] isEqualToString:@""]) {
                [_lblInstruction setText:@""];
                
            }else{
                [_lblInstruction setText:[_objFormOrSurvey valueForKey:@"instructions"]];
            }
            
            if ([[_objFormOrSurvey valueForKey:@"isAllowInProgress"]boolValue]) {
                
                _btnSubmitLater.hidden = NO;
            }
    
    [[NSUserDefaults standardUserDefaults]setValue:[_objFormOrSurvey valueForKey:@"date"] forKey:@"lockalDate"]; // This NSUserDefaults is used for remove particular form/survey from local database after online saveInProgress / online final submission

            [self fetchQuestion];
    
  _tblForm.contentInset=UIEdgeInsetsMake(0, 0, 70, 0);
   
}

-(void)dismissKeyboard
{
   [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchQuestion {
    
    NSMutableArray *mutArray;
    NSArray *arrOfSelectetCeckBox = [NSArray new];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
    NSArray *array = [[_objFormOrSurvey valueForKey:@"questionList"] sortedArrayUsingDescriptors:@[sort]];

    mutArrQuestions = [[NSMutableArray alloc] init];
    
    for (SurveyQuestions *question in array) {
        NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
        
        if([question valueForKey:@"mandatory"]!=nil)
        {
            [aDict setObject:[question valueForKey:@"mandatory"] forKey:@"isMandatory"];
        }
        else{
            [aDict setObject:@"" forKey:@"isMandatory"];

        }
        if([question valueForKey:@"existingResponseBool"]!=nil)
        {
            [aDict setObject:[question valueForKey:@"existingResponseBool"] forKey:@"existingResponseBool"];
        }
        else{
            [aDict setObject:@"" forKey:@"existingResponseBool"];
        }
        if ([[question valueForKey:@"responseList"] count] >0) {
            for (NSDictionary *aSubDict in [question valueForKey:@"responseList"]) {
                [aDict setObject:aSubDict forKey:@"responses"];
            }
        }
        else{
            [aDict setObject:@"" forKey:@"responses"];
        }

        [aDict setObject:[question valueForKey:@"question"] forKey:@"question"];
        [aDict setObject:[question valueForKey:@"questionId"] forKey:@"questionId"];
        [aDict setObject:[question valueForKey:@"responseType"] forKey:@"responseType"];
        [aDict setObject:[question valueForKey:@"sequence"] forKey:@"sequence"];

        
        [aDict setObject:@"" forKey:@"answer"];
        
        //****** check if existingResponse is present or not for in progress forms********//
        
        if([question valueForKey:@"existingResponse"]!=nil)
        {
            [aDict setObject:[question valueForKey:@"existingResponse"] forKey:@"existingResponse"];
            if ([question valueForKey:@"existingResponseIds"]!=nil) {
                [aDict setObject:[question valueForKey:@"existingResponseIds"] forKey:@"existingResponseId"];
            }
            else{
                [aDict setObject:@"" forKey:@"existingResponseId"];
            }
        }
        else{
            [aDict setObject:@"" forKey:@"existingResponse"];
            [aDict setObject:@"" forKey:@"existingResponseId"];
        }
        if ([question valueForKey:@"existingResponse"]!=nil  && [[question valueForKey:@"responseType"]isEqualToString:@"uploadFile"]) {
            if ([question valueForKey:@"detailImageVideoText"]!=nil) {
                [aDict setObject:[question valueForKey:@"detailImageVideoText"] forKey:@"answer"];
            }
        }
        if([question valueForKey:@"existingResponse"]!=nil  && [[question valueForKey:@"responseType"]isEqualToString:@"checkboxList"])
        {
            mutArray =[NSMutableArray new];
            NSString *strippedInput =[[question valueForKey:@"existingResponse"] stringByReplacingOccurrencesOfString:@"," withString:@";"];
            arrOfSelectetCeckBox = [strippedInput componentsSeparatedByString:@";"];
            for(NSString *str in arrOfSelectetCeckBox)
            {
                [mutArray addObject:str];
            }
        }
        else if ([question valueForKey:@"existingResponse"]!=nil  && [[question valueForKey:@"responseType"]isEqualToString:@"radioButtonList"]){
            mutArray =[NSMutableArray new];
            NSString *strippedInput =[[question valueForKey:@"existingResponse"] stringByReplacingOccurrencesOfString:@"," withString:@";"];
            arrOfSelectetCeckBox = [strippedInput componentsSeparatedByString:@";"];
            for(NSString *str in arrOfSelectetCeckBox)
            {
                [mutArray addObject:str];
            }
        }
        NSSortDescriptor *sortRespType = [NSSortDescriptor sortDescriptorWithKey:@"sequence.intValue" ascending:YES];
        NSArray *arrayRespType = [[[question valueForKey:@"responseList"] allObjects] sortedArrayUsingDescriptors:@[sortRespType]];
        NSMutableArray *mutArrResponseType = [NSMutableArray array];
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"fromInProgress"] isEqualToString:@"YES"]) {
            if (mutArray.count != 0) {
            for (int i=0; i<mutArray.count; i++) {
                        for (int j=0; j<arrayRespType.count; j++) {
                                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                if ([[[arrayRespType valueForKey:@"name"] objectAtIndex:j] isEqualToString:[mutArray objectAtIndex:i]]) {
                    [dict setObject:[[arrayRespType valueForKey:@"value"] objectAtIndex:j] forKey:@"value"];
                    [dict setObject:[[arrayRespType valueForKey:@"name"] objectAtIndex:j] forKey:@"name"];
                    [dict setObject:[[arrayRespType valueForKey:@"name"] objectAtIndex:j] forKey:@"sequence"];
                    if ([[question valueForKey:@"responseType"]isEqualToString:@"radioButtonList"]) {
                        if ([[mutArrResponseType valueForKey:@"name"] containsObject:[[arrayRespType valueForKey:@"name"] objectAtIndex:j]]) {
                            [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isSelected"];
                        }
                        else{
                            [dict setObject:[NSNumber numberWithBool:YES] forKey:@"isSelected"];
                        }
                    }
                    else{
                        [dict setObject:[NSNumber numberWithBool:YES] forKey:@"isSelected"];
                    }
                    }
                    else{
                        [dict setObject:[[arrayRespType valueForKey:@"value"] objectAtIndex:j] forKey:@"value"];
                        [dict setObject:[[arrayRespType valueForKey:@"name"] objectAtIndex:j] forKey:@"name"];
                        [dict setObject:[[arrayRespType valueForKey:@"sequence"] objectAtIndex:j] forKey:@"sequence"];
                        [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isSelected"];
                    }
                
                if ([[mutArrResponseType valueForKey:@"value"] containsObject:[[arrayRespType valueForKey:@"value"] objectAtIndex:j]]) {
                    if ([[[mutArrResponseType valueForKey:@"isSelected"] objectAtIndex:j] isEqual:[NSNumber numberWithBool:NO]] ) {
                            [mutArrResponseType replaceObjectAtIndex:j withObject:dict];
                    }
                }
                else{
                    [mutArrResponseType addObject:dict];
                }
            }
        }
                mutArray =[NSMutableArray new];
            }
            else{
                   for (int j=0; j<arrayRespType.count; j++) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];

                [dict setObject:[[arrayRespType valueForKey:@"value"] objectAtIndex:j] forKey:@"value"];
                [dict setObject:[[arrayRespType valueForKey:@"name"] objectAtIndex:j] forKey:@"name"];
                [dict setObject:[[arrayRespType valueForKey:@"sequence"] objectAtIndex:j] forKey:@"sequence"];
                [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isSelected"];
                [mutArrResponseType addObject:dict];
            }
            }
 }
        else{
             for (int j=0; j<arrayRespType.count; j++) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:[[arrayRespType valueForKey:@"value"] objectAtIndex:j] forKey:@"value"];
            [dict setObject:[[arrayRespType valueForKey:@"name"] objectAtIndex:j] forKey:@"name"];
            [dict setObject:[[arrayRespType valueForKey:@"sequence"] objectAtIndex:j] forKey:@"sequence"];

            [mutArrResponseType addObject:dict];
             }
        }
        [aDict setObject:mutArrResponseType forKey:@"responseList"];
        [mutArrQuestions addObject:aDict];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ThankYouScreen"]) {
        ThankYouViewController *thanksVC = (ThankYouViewController*)segue.destinationViewController;
        if (_isSurvey) {
            [[NSUserDefaults standardUserDefaults]setValue:@"survey" forKey:@"Forms/Surveys"];

            if ([thankYouFlag isEqualToString:@"submitLater"]) {
                thanksVC.strMsg = @"Thank you. Your Survey has been saved to submit later.";
                thanksVC.strBackTitle = @"Back to Survey";
            }else{
                thanksVC.strMsg = @"Your Survey has been submitted.";
                thanksVC.strBackTitle = @"Back to Survey";
            }
        }
        else if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"fromSuveyViewC" ] isEqualToString:@"YES"]) {
            
            [[NSUserDefaults standardUserDefaults]setValue:@"survey" forKey:@"Forms/Surveys"];
            
            if ([thankYouFlag isEqualToString:@"submitLater"]) {
                thanksVC.strMsg = @"Thank you. Your Survey has been saved to submit later.";
                thanksVC.strBackTitle = @"Back to Survey";
            }else{
                thanksVC.strMsg = @"Your Survey has been submitted.";
                thanksVC.strBackTitle = @"Back to Survey";
            }
            
            
        }
        else if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"fromSugestionViewC"] isEqualToString:@"YES"]){
            if ([thankYouFlag isEqualToString:@"submitLater"]) {
                thanksVC.strMsg = @"Thank you. Your Suggestion has been saved to submit later.";
                thanksVC.strBackTitle = @"Back to Suggestion";
            }else{
                thanksVC.strMsg = @"Your Suggestion has been submitted.";
                thanksVC.strBackTitle = @"Back to Suggestion";
            }
        }
        else {
            [[NSUserDefaults standardUserDefaults]setValue:@"form" forKey:@"Forms/Surveys"];

            if ([thankYouFlag isEqualToString:@"submitLater"]) {
                thanksVC.strMsg = @"Thank you. Your Form has been saved to submit later.";
                thanksVC.strBackTitle = @"Back to Forms";
            }else{
                thanksVC.strMsg = @"Your Form has been submitted.";
                thanksVC.strBackTitle = @"Back to Forms";
            }
           
        }
    }
}

//chetan kasundra changes starts
//change the Alert Message

- (IBAction)btnBackTapped:(id)sender {
    
        [[[UIAlertView alloc] initWithTitle:@"WARNING" message:@"If you press \"Back\" you will lose your information. Do you want to proceed?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil] show];

}


//chages ends


- (IBAction)btnSubmitTapped:(id)sender {
    [self.view endEditing:YES];
    [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"isBack"];
    NSMutableArray *mutArrReq = [NSMutableArray array];
    NSMutableArray *isManArray=[NSMutableArray new]; // For Storing  mandatory question value
    
    int intVal=0;// Varaible used for replacing "NO" atIndexPath
    BOOL flag=NO;
    
    for(int i=0;i<mutArrQuestions.count;i++)
    {
        if([[[mutArrQuestions valueForKey:@"isMandatory"]objectAtIndex:i]boolValue]){
            
            if(![[[mutArrQuestions valueForKey:@"responseType"]objectAtIndex:i]isEqualToString:@"content"]){
                [isManArray addObject:@"YES"];
                flag =YES;
            }
            else{
                [isManArray addObject:@"NO"];
            }

          
        }
    }
    
   // int contetntcount=0;
    for (NSDictionary *aDict in mutArrQuestions) {
        
        if (![aDict[@"existingResponse"] isEqualToString:@""] && [aDict[@"answer"] isEqualToString:@""])//checking existing responce is present while no any ans given/edit for in progress form/survey final submission
        {
            if ([aDict[@"responseType"] isEqualToString:@"checkboxList"]) {
          //      NSMutableDictionary *dict = [NSMutableDictionary dictionary];
         
                int i=0;
                NSMutableString *strTemp=[[NSMutableString alloc]init];
                NSMutableString *strTempID=[[NSMutableString alloc]init];
                
                // create separate entry for each option selected. So if 2 options are selected then two entries of same question will be there with different response.
                NSArray *arySelectedOptions = [aDict[@"responseList"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected == YES"]];
                for (NSDictionary *dictResponse in arySelectedOptions) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setObject:aDict[@"questionId"] forKey:@"QuestionId"];
                    [dict setObject:aDict[@"question"] forKey:@"QuestionText"];
                    [dict setObject:aDict[@"responseType"] forKey:@"ResponseType"];
                    
                        [dict setObject:aDict[@"existingResponseBool"] forKey:@"existingResponseBool"];
                        [dict setObject:aDict[@"responseList"] forKey:@"responses"];
                        [dict setObject:aDict[@"sequence"] forKey:@"sequence"];
                        [dict setObject:aDict[@"isMandatory"] forKey:@"IsMandatory"];
                    
                    if([arySelectedOptions valueForKey:@"isSelected"])
                    {
                        
                        [strTemp appendString:[NSString stringWithFormat:@"%@,",[dictResponse valueForKey:@"name"]]];
                        [strTempID appendString:[NSString stringWithFormat:@"%@,",[dictResponse valueForKey:@"value"]]];
                        i++;
                        
                    }
                    
                    if(i==arySelectedOptions.count)
                    {
                        
                        [strTemp deleteCharactersInRange:NSMakeRange([strTemp length]-1, 1)];
                        [dict setValue:strTemp forKey:@"ResponseText"];
                        [dict setObject:strTempID forKey:@"ResponseId"];
                        
                        if ([[aDict valueForKey:@"isMandatory"]boolValue] && ![aDict[@"responseType"] isEqualToString:@"content"]) {
                            if(isManArray.count>0)
                            {
                                [isManArray replaceObjectAtIndex:intVal withObject:@"NO"];
                            }
                        }
                        else if ([[aDict valueForKey:@"isMandatory"]boolValue] && [aDict[@"responseType"] isEqualToString:@"content"]){
                          //  intVal++;
                        }
                        
                        [mutArrReq addObject:dict];
                    }
                    
                }
    
            }
            
          
                else
            {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                
                [dict setObject:aDict[@"questionId"] forKey:@"QuestionId"];
                [dict setObject:aDict[@"question"] forKey:@"QuestionText"];
                [dict setObject:aDict[@"responseType"] forKey:@"ResponseType"];
                
                
                [dict setObject:aDict[@"existingResponseBool"] forKey:@"existingResponseBool"];
              //  [dict setObject:aDict[@"ResponseType"] forKey:@"responseType"];
                [dict setObject:aDict[@"responseList"] forKey:@"responses"];
                [dict setObject:aDict[@"sequence"] forKey:@"sequence"];
                [dict setObject:aDict[@"isMandatory"] forKey:@"IsMandatory"];
                


                if ([aDict[@"responseType"] isEqualToString:@"dropdown"]) {
                    
                    NSPredicate *aPredicate =[NSPredicate predicateWithFormat:@"name ==[cd] %@", [aDict objectForKey:@"existingResponse"]];
                    NSDictionary *resp = [[aDict[@"responseList"] filteredArrayUsingPredicate:aPredicate]firstObject];
                    [dict setObject:aDict[@"existingResponse"] forKey:@"ResponseText"];
                    [dict setObject:resp[@"value"] forKey:@"ResponseId"];
                    
                }
                else if ([aDict[@"responseType"] isEqualToString:@"date"]) {
//                    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
//                    //[aFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
//                    [aFormatter setDateFormat:@"MM/dd/yyyy"];
                    [dict setObject:aDict[@"existingResponse"] forKey:@"ResponseText"];
                }
                else if ([aDict[@"responseType"] isEqualToString:@"radioButtonList"]) {
                  //  NSDictionary *resp = [aDict[@"responseList"] objectAtIndex:[aDict[@"existingResponse"] integerValue]];
                    NSDictionary *resp=[NSDictionary new];
                    for (int i=0; i<[aDict[@"responseList"] count]; i++) {
                        
                        if ([[[[aDict valueForKey:@"responseList"] valueForKey:@"name"] objectAtIndex:i] isEqualToString:aDict[@"existingResponse"]]) {
                            resp = [aDict[@"responseList"] objectAtIndex:i];
                        
                        }
                    }
                    [dict setObject:aDict[@"existingResponse"] forKey:@"ResponseText"];
                   [dict setObject:resp[@"value"] forKey:@"ResponseId"];
                }

                else if ([aDict[@"responseType"] isEqualToString:@"time"]) {
//                    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
//                    [aFormatter setDateFormat:@"hh:mm a"];
//                    NSDate *dt = [aFormatter dateFromString:aDict[@"existingResponse"]];
                    
                    [dict setObject:aDict[@"existingResponse"] forKey:@"ResponseText"];
                }
       
                else if ([aDict[@"responseType"] isEqualToString:@"uploadFile"]) {
                    
                    [dict setObject:aDict[@"existingResponse"] forKey:@"ResponseText"];
                  //  [dict setObject:aDict[@"answer"] forKey:@"UploadFileResponseData"];
                    
                }
                else {
                    [dict setObject:aDict[@"existingResponse"] forKey:@"ResponseText"];
                }
                if ([[aDict valueForKey:@"isMandatory"]boolValue] && ![aDict[@"responseType"] isEqualToString:@"content"]) {
                    if(isManArray.count>0)
                    {
                        [isManArray replaceObjectAtIndex:intVal withObject:@"NO"];
                    }
                }
                else if ([[aDict valueForKey:@"isMandatory"]boolValue] && [aDict[@"responseType"] isEqualToString:@"content"]){
                    //intVal++;
                }
                
                [mutArrReq addObject:dict];
            }

            }
        else if ([aDict[@"answer"] isEqualToString:@""] && [[aDict valueForKey:@"isMandatory"]boolValue] && [aDict[@"responseType"] isEqualToString:@"uploadFile"])
        {
 

        }
        else if ([[aDict valueForKey:@"isMandatory"]boolValue] && [aDict[@"responseType"] isEqualToString:@"content"]){
            [isManArray replaceObjectAtIndex:intVal withObject:@"NO"];

        }
        else{
            if ([aDict[@"responseType"] isEqualToString:@"checkboxList"]) {
                
                int i=0;
                NSMutableString *strTemp=[[NSMutableString alloc]init];
                NSMutableString *strTempID=[[NSMutableString alloc]init];

                // create separate entry for each option selected. So if 2 options are selected then two entries of same question will be there with different response.
                NSArray *arySelectedOptions = [aDict[@"responseList"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected == YES"]];
                for (NSDictionary *dictResponse in arySelectedOptions) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setObject:aDict[@"questionId"] forKey:@"QuestionId"];
                    [dict setObject:aDict[@"question"] forKey:@"QuestionText"];
                    [dict setObject:aDict[@"responseType"] forKey:@"ResponseType"];

                    
                    [dict setObject:aDict[@"existingResponseBool"] forKey:@"existingResponseBool"];
                    [dict setObject:aDict[@"responseList"] forKey:@"responses"];
                    [dict setObject:aDict[@"sequence"] forKey:@"sequence"];
                    [dict setObject:aDict[@"isMandatory"] forKey:@"IsMandatory"];
                    
                    if([arySelectedOptions valueForKey:@"isSelected"])
                    {
                        
                        [strTemp appendString:[NSString stringWithFormat:@"%@,",[dictResponse valueForKey:@"name"]]];
                         [strTempID appendString:[NSString stringWithFormat:@"%@,",[dictResponse valueForKey:@"value"]]];
                        i++;
                        
                    }
                    
                    if(i==arySelectedOptions.count)
                    {
                        
                        [strTemp deleteCharactersInRange:NSMakeRange([strTemp length]-1, 1)];
                        [dict setValue:strTemp forKey:@"ResponseText"];
                        [dict setObject:strTempID forKey:@"ResponseId"];
                        if ([[aDict valueForKey:@"isMandatory"]boolValue] && ![aDict[@"responseType"] isEqualToString:@"content"]) {
                            if(isManArray.count>0)
                            {
                                [isManArray replaceObjectAtIndex:intVal withObject:@"NO"];
                            }
                        }
                        else if ([[aDict valueForKey:@"isMandatory"]boolValue] && [aDict[@"responseType"] isEqualToString:@"content"]){
                          //  intVal++;
                        }
                        
                        [mutArrReq addObject:dict];
                    }
                    
                }
            }
            
            else if (![aDict[@"answer"] isEqualToString:@""] && [[aDict valueForKey:@"isMandatory"]boolValue]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                
                [dict setObject:aDict[@"questionId"] forKey:@"QuestionId"];
                [dict setObject:aDict[@"question"] forKey:@"QuestionText"];
                [dict setObject:aDict[@"responseType"] forKey:@"ResponseType"];

                [dict setObject:aDict[@"existingResponseBool"] forKey:@"existingResponseBool"];
                [dict setObject:aDict[@"responseList"] forKey:@"responses"];
                [dict setObject:aDict[@"sequence"] forKey:@"sequence"];
                [dict setObject:aDict[@"isMandatory"] forKey:@"IsMandatory"];
                
                
                if ([aDict[@"responseType"] isEqualToString:@"dropdown"]) {
                    
                    NSPredicate *aPredicate =[NSPredicate predicateWithFormat:@"name ==[cd] %@", [aDict objectForKey:@"answer"]];
                    NSDictionary *resp = [[aDict[@"responseList"] filteredArrayUsingPredicate:aPredicate]firstObject];
                    [dict setObject:aDict[@"answer"] forKey:@"ResponseText"];
                    [dict setObject:resp[@"value"] forKey:@"ResponseId"];
                    
                }
                else if ([aDict[@"responseType"] isEqualToString:@"date"]) {
                    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
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
                    
                    [dict setObject:[aFormatter stringFromDate:dt] forKey:@"ResponseText"];
                }
                
                 else if ([aDict[@"responseType"] isEqualToString:@"uploadFile"]) {
                     
                     [dict setObject:aDict[@"existingResponse"] forKey:@"ResponseText"];
                     [dict setObject:aDict[@"answer"] forKey:@"UploadFileResponseData"];

                 }
                
                else {
                    [dict setObject:aDict[@"answer"] forKey:@"ResponseText"];
                }
                    if ([[aDict valueForKey:@"isMandatory"]boolValue] && ![aDict[@"responseType"] isEqualToString:@"content"]) {
                if(isManArray.count>0)
                {
                    [isManArray replaceObjectAtIndex:intVal withObject:@"NO"];
                }
                    }
                    else if ([[aDict valueForKey:@"isMandatory"]boolValue] && [aDict[@"responseType"] isEqualToString:@"content"]){
                    }
                [mutArrReq addObject:dict];
            }
            else if (![aDict[@"answer"] isEqualToString:@""]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:aDict[@"questionId"] forKey:@"QuestionId"];
                [dict setObject:aDict[@"question"] forKey:@"QuestionText"];
                [dict setObject:aDict[@"responseType"] forKey:@"ResponseType"];

                [dict setObject:aDict[@"existingResponseBool"] forKey:@"existingResponseBool"];
                [dict setObject:aDict[@"responseList"] forKey:@"responses"];
                [dict setObject:aDict[@"sequence"] forKey:@"sequence"];
                [dict setObject:aDict[@"isMandatory"] forKey:@"IsMandatory"];
                
                if ([aDict[@"responseType"] isEqualToString:@"dropdown"]) {
                    
                    NSPredicate *aPredicate =[NSPredicate predicateWithFormat:@"name ==[cd] %@", [aDict objectForKey:@"answer"]];
                    NSDictionary *resp = [[aDict[@"responseList"] filteredArrayUsingPredicate:aPredicate]firstObject];
                    [dict setObject:aDict[@"answer"] forKey:@"ResponseText"];
                    [dict setObject:resp[@"value"] forKey:@"ResponseId"];
                }
                else if ([aDict[@"responseType"] isEqualToString:@"date"]) {
                    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
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
                    [dict setObject:[aFormatter stringFromDate:dt] forKey:@"ResponseText"];
                }
                else if ([aDict[@"responseType"] isEqualToString:@"uploadFile"]) {
                    
                    [dict setObject:aDict[@"existingResponse"] forKey:@"ResponseText"];
                    [dict setObject:aDict[@"answer"] forKey:@"UploadFileResponseData"];
                    
                }
                else {
                    [dict setObject:aDict[@"answer"] forKey:@"ResponseText"];
                }
                [mutArrReq addObject:dict];
            }
            else if ([aDict[@"answer"] isEqualToString:@""] && ![[aDict valueForKey:@"isMandatory"]boolValue]){
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:aDict[@"questionId"] forKey:@"QuestionId"];
                [dict setObject:aDict[@"question"] forKey:@"QuestionText"];
                [dict setObject:aDict[@"responseType"] forKey:@"ResponseType"];

                [dict setObject:aDict[@"existingResponseBool"] forKey:@"existingResponseBool"];
                [dict setObject:aDict[@"responseList"] forKey:@"responses"];
                [dict setObject:aDict[@"sequence"] forKey:@"sequence"];
                [dict setObject:aDict[@"isMandatory"] forKey:@"IsMandatory"];
                
                
                
                if ([aDict[@"responseType"] isEqualToString:@"dropdown"]) {
                    
                     [dict setObject:@"" forKey:@"ResponseText"];
                    [dict setObject:@"" forKey:@"ResponseId"];
                }
                else if ([aDict[@"responseType"] isEqualToString:@"date"]) {
               
                    [dict setObject:@"" forKey:@"ResponseText"];
                }
                else if ([aDict[@"responseType"] isEqualToString:@"radioButtonList"]) {
                    [dict setObject:@""forKey:@"ResponseText"];
                    [dict setObject:@"" forKey:@"ResponseId"];
                }
                else if ([aDict[@"responseType"] isEqualToString:@"time"]) {
                 
                    [dict setObject:@"" forKey:@"ResponseText"];
                }
                else if ([aDict[@"responseType"] isEqualToString:@"uploadFile"]) {
                    
                    [dict setObject:@"" forKey:@"ResponseText"];
                    [dict setObject:@"" forKey:@"UploadFileResponseData"];
                    
                }
                else {
                    [dict setObject:@"" forKey:@"ResponseText"];
                }
                [mutArrReq addObject:dict];
            }
        }

        if ([[aDict valueForKey:@"isMandatory"]boolValue]) {
             intVal=intVal+1;
        }
       
    }
    
    if (mutArrReq.count>0 && ![isManArray containsObject:@"YES"]) {
        
            NSString *strUserId = @"", *strIDKeyName, *strIdValue, *strWebServiceName = @"";
            if ([User checkUserExist]) {
            strUserId = [[User currentUser] userId];
            }
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"fromSuveyViewC" ] isEqualToString:@"YES"]) {
            
            strIdValue = [_objFormOrSurvey valueForKey:@"surveyId"];
            strIDKeyName = @"SurveyId";
            strWebServiceName = SURVEY_HISTORY_POST;
            
        }
        else if (_isSurvey){
            
            strIdValue = [_objFormOrSurvey valueForKey:@"surveyId"];
            strIDKeyName = @"SurveyId";
            strWebServiceName = SURVEY_HISTORY_POST;
            
        }
        else {
            strIDKeyName = @"FormId";
            strIdValue = [_objFormOrSurvey valueForKey:@"formId"];
            strWebServiceName = FORM_HISTORY_POST;
            
        }
        
            NSString *aStrClientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
        aStrInProgressFormId=nil;
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"fromInProgressSubmit"] isEqualToString:@"YES"]) {
            aStrInProgressFormId = [[NSUserDefaults standardUserDefaults] objectForKey:@"aStrInProgressFormId"];
            [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"fromInProgressSubmit"];
            
        }
        else{
            aStrInProgressFormId =@"0";
        }
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"largeFileSiz"] isEqualToString:@"YES"]) {
            [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"largeFileSiz"];
            
            UIAlertController * alertForData=[UIAlertController alertControllerWithTitle:@"" message:@"Wow, this is a big file! Thanks for your patience." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * alertction=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                strisInProgress=@"0";
                NSDictionary *dictReq = @{@"UserId":strUserId, strIDKeyName:strIdValue, @"Details":mutArrReq, @"ClientId":aStrClientId,@"IsInProgress":@0,@"CurrentHistoryHeaderId":aStrInProgressFormId};
                [gblAppDelegate callWebService:strWebServiceName parameters:dictReq httpMethod:[SERVICE_HTTP_METHOD objectForKey:strWebServiceName] complition:^(NSDictionary *response) {
                    
                    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"offlineToOnline"] isEqualToString:@"YES"]) {
                        [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"offlineToOnline"];
                        [self deleteSelectedFromSync:@"" DateAndTime:[[NSUserDefaults standardUserDefaults] valueForKey:@"lockalDate"]];
                        [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"lockalDate"];
                    }
                    
                    thankYouFlag=@"submit";
                    [self performSegueWithIdentifier:@"ThankYouScreen" sender:nil];
                } failure:^(NSError *error, NSDictionary *response) {
                    NSLog(@"%@",aStrInProgressFormId);
                    thankYouFlag=@"submit";
                    [self saveDataToLocal:dictReq];
                    
                }];
                

            }];
            [alertForData addAction:alertction];
            [self presentViewController:alertForData animated:YES completion:nil];
        }
        else{
           
            strisInProgress=@"0";
            NSDictionary *dictReq = @{@"UserId":strUserId, strIDKeyName:strIdValue, @"Details":mutArrReq, @"ClientId":aStrClientId,@"IsInProgress":@0,@"CurrentHistoryHeaderId":aStrInProgressFormId};
            [gblAppDelegate callWebService:strWebServiceName parameters:dictReq httpMethod:[SERVICE_HTTP_METHOD objectForKey:strWebServiceName] complition:^(NSDictionary *response) {
                
                if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"offlineToOnline"] isEqualToString:@"YES"]) {
                    [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"offlineToOnline"];
                    [self deleteSelectedFromSync:@"" DateAndTime:[[NSUserDefaults standardUserDefaults] valueForKey:@"lockalDate"]];
                    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"lockalDate"];
                }
                
                thankYouFlag=@"submit";
                [self performSegueWithIdentifier:@"ThankYouScreen" sender:nil];
            } failure:^(NSError *error, NSDictionary *response) {
                NSLog(@"%@",aStrInProgressFormId);
                thankYouFlag=@"submit";
                [self saveDataToLocal:dictReq];
                
            }];

        }
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

- (BOOL)isNetworkReachable {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];//[Reachability reachabilityWithHostName:@"http://www.google.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if (remoteHostStatus == NotReachable) {
        return NO;
    }
    return YES;
}
- (IBAction)btnSubmitLater:(id)sender {
    [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"isBack"];

        [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"isBack"];
        
        NSMutableArray *mutArrReq = [NSMutableArray array];
    
        BOOL flag=NO;
        
        
        for (NSDictionary *aDict in mutArrQuestions) {
            
            if (![aDict[@"existingResponse"] isEqualToString:@""] && [aDict[@"answer"] isEqualToString:@""]){
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:aDict[@"questionId"] forKey:@"QuestionId"];
                [dict setObject:aDict[@"question"] forKey:@"QuestionText"];
                [dict setObject:aDict[@"responseType"] forKey:@"ResponseType"];
                
                [dict setObject:aDict[@"existingResponseBool"] forKey:@"existingResponseBool"];
                [dict setObject:aDict[@"responseList"] forKey:@"responses"];
                [dict setObject:aDict[@"sequence"] forKey:@"sequence"];
                [dict setObject:aDict[@"isMandatory"] forKey:@"IsMandatory"];
                
                if ([aDict[@"responseType"] isEqualToString:@"checkboxList"]) {
                    
                    int i=0;
                    NSMutableString *strTemp=[[NSMutableString alloc]init];
                    NSMutableString *strTempID=[[NSMutableString alloc]init];
                    
                    NSArray *arySelectedOptions = [aDict[@"responseList"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected == YES"]];
                    for (NSDictionary *dictResponse in arySelectedOptions) {
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        [dict setObject:aDict[@"questionId"] forKey:@"QuestionId"];
                        [dict setObject:aDict[@"question"] forKey:@"QuestionText"];
                        [dict setObject:aDict[@"responseType"] forKey:@"ResponseType"];
                        
                        [dict setObject:aDict[@"existingResponse"] forKey:@"ResponseText"];
                        [dict setObject:aDict[@"existingResponseBool"] forKey:@"existingResponseBool"];
                        [dict setObject:aDict[@"responseList"] forKey:@"responses"];
                        [dict setObject:aDict[@"sequence"] forKey:@"sequence"];
                        [dict setObject:aDict[@"isMandatory"] forKey:@"IsMandatory"];
                        
                        if([arySelectedOptions valueForKey:@"isSelected"])
                        {
                            
                            [strTemp appendString:[NSString stringWithFormat:@"%@,",[dictResponse valueForKey:@"name"]]];
                            [strTempID appendString:[NSString stringWithFormat:@"%@,",[dictResponse valueForKey:@"value"]]];
                            i++;
                            
                        }
                        
                        if(i==arySelectedOptions.count)
                        {
                            
                            [strTemp deleteCharactersInRange:NSMakeRange([strTemp length]-1, 1)];
                            [dict setValue:strTemp forKey:@"ResponseText"];
                            [dict setObject:strTempID forKey:@"ResponseId"];
                            
                            [mutArrReq addObject:dict];
                        }
                        
                    }
                    
                }
  
                else{
                    if ([aDict[@"responseType"] isEqualToString:@"dropdown"]) {
                        
                        NSPredicate *aPredicate =[NSPredicate predicateWithFormat:@"name ==[cd] %@", [aDict objectForKey:@"existingResponse"]];
                        NSDictionary *resp = [[aDict[@"responseList"] filteredArrayUsingPredicate:aPredicate]firstObject];
                        [dict setObject:aDict[@"responseList"] forKey:@"ResponseText"];
                        [dict setObject:resp[@"value"] forKey:@"ResponseId"];
                        [dict setObject:aDict[@"existingResponse"] forKey:@"ResponseText"];

                    }
                    else if ([aDict[@"responseType"] isEqualToString:@"date"]) {
                            [dict setObject:aDict[@"existingResponse"] forKey:@"ResponseText"];
                    }
                    else if ([aDict[@"responseType"] isEqualToString:@"radioButtonList"]) {
                        NSDictionary *resp=[NSDictionary new];
                        for (int i=0; i<[aDict[@"responseList"] count]; i++) {
                            
                            if ([[[[aDict valueForKey:@"responseList"] valueForKey:@"name"] objectAtIndex:i] isEqualToString:aDict[@"existingResponse"]]) {
                                resp = [aDict[@"responseList"] objectAtIndex:i];
                            }
                        }
                        [dict setObject:aDict[@"existingResponse"]  forKey:@"ResponseText"];
                        [dict setObject:resp[@"value"] forKey:@"ResponseId"];
                                           }
                    else if ([aDict[@"responseType"] isEqualToString:@"time"]) {
                        
                        [dict setObject:aDict[@"existingResponse"] forKey:@"ResponseText"];
                    }
                    else if ([aDict[@"responseType"] isEqualToString:@"uploadFile"]) {
                        
                        [dict setObject:aDict[@"existingResponse"] forKey:@"ResponseText"];
                        [dict setObject:aDict[@"answer"] forKey:@"UploadFileResponseData"];
                        
                    }
                    else {
                        [dict setObject:aDict[@"existingResponse"] forKey:@"ResponseText"];
                    }
                    [mutArrReq addObject:dict];
                    
                }
                
            }
            
            else if (![aDict[@"answer"] isEqualToString:@""]){
                
                if ([aDict[@"responseType"] isEqualToString:@"checkboxList"]) {
                    
                    int i=0;
                    NSMutableString *strTemp=[[NSMutableString alloc]init];
                    NSMutableString *strTempID=[[NSMutableString alloc]init];
                    
                    NSArray *arySelectedOptions = [aDict[@"responseList"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected == YES"]];
                    for (NSDictionary *dictResponse in arySelectedOptions) {
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        [dict setObject:aDict[@"questionId"] forKey:@"QuestionId"];
                        [dict setObject:aDict[@"question"] forKey:@"QuestionText"];
                        [dict setObject:aDict[@"responseType"] forKey:@"ResponseType"];

                        [dict setObject:aDict[@"existingResponseBool"] forKey:@"existingResponseBool"];
                        [dict setObject:aDict[@"responseList"] forKey:@"responses"];
                        [dict setObject:aDict[@"sequence"] forKey:@"sequence"];
                        [dict setObject:aDict[@"isMandatory"] forKey:@"IsMandatory"];
                        
                        if([arySelectedOptions valueForKey:@"isSelected"])
                        {
                            
                            [strTemp appendString:[NSString stringWithFormat:@"%@,",[dictResponse valueForKey:@"name"]]];
                            [strTempID appendString:[NSString stringWithFormat:@"%@,",[dictResponse valueForKey:@"value"]]];
                            i++;
                            
                        }
                        [dict setObject:strTemp forKey:@"ResponseText"];

                        if(i==arySelectedOptions.count)
                        {
                            
                            [strTemp deleteCharactersInRange:NSMakeRange([strTemp length]-1, 1)];
                            [dict setValue:strTemp forKey:@"ResponseText"];
                            [dict setObject:strTempID forKey:@"ResponseId"];
                            
                            [mutArrReq addObject:dict];
                        }
                        
                    }
                }
                else   {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setObject:aDict[@"questionId"] forKey:@"QuestionId"];
                    [dict setObject:aDict[@"question"] forKey:@"QuestionText"];
                    [dict setObject:aDict[@"responseType"] forKey:@"ResponseType"];
                    
                    [dict setObject:aDict[@"existingResponseBool"] forKey:@"existingResponseBool"];
                    [dict setObject:aDict[@"responseList"] forKey:@"responses"];
                    [dict setObject:aDict[@"sequence"] forKey:@"sequence"];
                    [dict setObject:aDict[@"isMandatory"] forKey:@"IsMandatory"];
                    
                    
                    
                    if ([aDict[@"responseType"] isEqualToString:@"dropdown"]) {
                        if (![aDict[@"answer"] isEqualToString:@""]) {
                            NSPredicate *aPredicate =[NSPredicate predicateWithFormat:@"name ==[cd] %@", [aDict objectForKey:@"answer"]];
                            NSDictionary *resp = [[aDict[@"responseList"] filteredArrayUsingPredicate:aPredicate]firstObject];
                            [dict setObject:aDict[@"answer"] forKey:@"ResponseText"];
                            [dict setObject:resp[@"value"] forKey:@"ResponseId"];
                            
                        }
                        else{
                            [dict setObject:@"" forKey:@"ResponseText"];
                            [dict setObject:@"" forKey:@"ResponseId"];
                        }
                    }
                    else if ([aDict[@"responseType"] isEqualToString:@"date"]) {
                        NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
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
                        [dict setObject:[aFormatter stringFromDate:dt] forKey:@"ResponseText"];
                    }
                    else if ([aDict[@"responseType"] isEqualToString:@"uploadFile"]) {
                        
                        [dict setObject:aDict[@"existingResponse"] forKey:@"ResponseText"];
                        [dict setObject:aDict[@"answer"] forKey:@"UploadFileResponseData"];
                        
                    }
                    
                    else {
                        [dict setObject:aDict[@"answer"] forKey:@"ResponseText"];
                    }
                    [mutArrReq addObject:dict];
                }
                
            }
            else if ([aDict[@"answer"] isEqualToString:@""]){
                
                if ([aDict[@"responseType"] isEqualToString:@"checkboxList"]) {
                    
                    int i=0;
                    NSMutableString *strTemp=[[NSMutableString alloc]init];
                    
                    NSMutableString *strTempID=[[NSMutableString alloc]init];
                    NSArray *arySelectedOptions = [aDict[@"responseList"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected == YES"]];
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

                    [dict setObject:aDict[@"questionId"] forKey:@"QuestionId"];
                    [dict setObject:aDict[@"question"] forKey:@"QuestionText"];
                    [dict setObject:aDict[@"responseType"] forKey:@"ResponseType"];
                    
                    [dict setObject:aDict[@"existingResponseBool"] forKey:@"existingResponseBool"];
                    [dict setObject:aDict[@"responseList"] forKey:@"responses"];
                    [dict setObject:aDict[@"sequence"] forKey:@"sequence"];
                    [dict setObject:aDict[@"isMandatory"] forKey:@"IsMandatory"];

                    for (NSDictionary *dictResponse in arySelectedOptions) {
                        
                        if([arySelectedOptions valueForKey:@"isSelected"])
                        {
                            [strTemp appendString:[NSString stringWithFormat:@"%@,",[dictResponse valueForKey:@"name"]]];
                            [strTempID appendString:[NSString stringWithFormat:@"%@,",[dictResponse valueForKey:@"value"]]];
                            i++;
                            
                        }
                        [dict setObject:strTemp forKey:@"ResponseText"];

                        if(i==arySelectedOptions.count)
                        {
                            
                            [strTemp deleteCharactersInRange:NSMakeRange([strTemp length]-1, 1)];
                            [dict setValue:strTemp forKey:@"ResponseText"];
                            [dict setObject:strTempID forKey:@"ResponseId"];
                            
                        }
                        
                    }
                    [mutArrReq addObject:dict];

                }
                
                else   {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setObject:aDict[@"questionId"] forKey:@"QuestionId"];
                    [dict setObject:aDict[@"question"] forKey:@"QuestionText"];
                    [dict setObject:aDict[@"responseType"] forKey:@"ResponseType"];
                    
                    [dict setObject:aDict[@"existingResponseBool"] forKey:@"existingResponseBool"];
                    [dict setObject:aDict[@"responseList"] forKey:@"responses"];
                    [dict setObject:aDict[@"sequence"] forKey:@"sequence"];
                    [dict setObject:aDict[@"isMandatory"] forKey:@"IsMandatory"];
                    
                    if ([aDict[@"responseType"] isEqualToString:@"dropdown"]) {
                        
                        [dict setObject:@"" forKey:@"ResponseText"];
                        [dict setObject:@"" forKey:@"ResponseId"];
                        
                    }
                    else if ([aDict[@"responseType"] isEqualToString:@"date"]) {
                        
                        [dict setObject:@"" forKey:@"ResponseText"];
                    }
                    else if ([aDict[@"responseType"] isEqualToString:@"radioButtonList"]) {
                        [dict setObject:@"" forKey:@"ResponseText"];
                        [dict setObject:@"" forKey:@"ResponseId"];
                    }
                    else if ([aDict[@"responseType"] isEqualToString:@"time"]) {
                        
                        [dict setObject:@"" forKey:@"ResponseText"];
                    }
                    
                    else if ([aDict[@"responseType"] isEqualToString:@"uploadFile"]) {
                        
                        [dict setObject:@"" forKey:@"ResponseText"];
                        [dict setObject:@"" forKey:@"UploadFileResponseData"];
                        
                    }
                    else {
                        [dict setObject:@"" forKey:@"ResponseText"];
                    }
                    [mutArrReq addObject:dict];
                }
                
            }
            
        }
        
        if (mutArrReq.count>0) {
            
            NSString *strUserId = @"", *strIDKeyName, *strIdValue, *strWebServiceName = @"";
            if ([User checkUserExist]) {
                strUserId = [[User currentUser] userId];
            }
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"fromSuveyViewC" ] isEqualToString:@"YES"]) {
                
                strIdValue = [_objFormOrSurvey valueForKey:@"surveyId"];
                strIDKeyName = @"SurveyId";
                strWebServiceName = SURVEY_HISTORY_POST;
                
            }
            else if (_isSurvey) {
                
                strIdValue = [_objFormOrSurvey valueForKey:@"surveyId"];
                strIDKeyName = @"SurveyId";
                strWebServiceName = SURVEY_HISTORY_POST;
                
            }
            else {
                strIDKeyName = @"FormId";
                strIdValue = [_objFormOrSurvey valueForKey:@"formId"];
                strWebServiceName = FORM_HISTORY_POST;
                
            }
            
            NSString *aStrClientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
            aStrInProgressFormId=nil;
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"fromInProgressSubmit"] isEqualToString:@"YES"]) {
                aStrInProgressFormId = [[NSUserDefaults standardUserDefaults] objectForKey:@"aStrInProgressFormId"];
                [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"fromInProgressSubmit"];
                
            }
            else{
                aStrInProgressFormId =@"0";
            }
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"largeFileSiz"] isEqualToString:@"YES"]) {
                [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"largeFileSiz"];
                UIAlertController * alertForData=[UIAlertController alertControllerWithTitle:@"" message:@"Wow, this is a big file! Thanks for your patience." preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction * alertction=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    
                    strisInProgress=@"1";
                    NSDictionary *dictReq = @{@"UserId":strUserId, strIDKeyName:strIdValue, @"Details":mutArrReq, @"ClientId":aStrClientId,@"IsInProgress":@1,@"CurrentHistoryHeaderId":aStrInProgressFormId};
                    [gblAppDelegate callWebService:strWebServiceName parameters:dictReq httpMethod:[SERVICE_HTTP_METHOD objectForKey:strWebServiceName] complition:^(NSDictionary *response) {
                        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"offlineToOnline"] isEqualToString:@"YES"]) {
                            [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"offlineToOnline"];
                            [self deleteSelectedFromSync:@"" DateAndTime:[[NSUserDefaults standardUserDefaults] valueForKey:@"lockalDate"]];
                            [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"lockalDate"];
                        }
                        thankYouFlag=@"submitLater";
                        [self performSegueWithIdentifier:@"ThankYouScreen" sender:nil];
                    } failure:^(NSError *error, NSDictionary *response) {
                        thankYouFlag=@"submitLater";
                        [self saveDataToLocal:dictReq];
                        
                    }];

                    
                    
                }];
                [alertForData addAction:alertction];
                [self presentViewController:alertForData animated:YES completion:nil];
            }
            else{
                
                strisInProgress=@"1";
                NSDictionary *dictReq = @{@"UserId":strUserId, strIDKeyName:strIdValue, @"Details":mutArrReq, @"ClientId":aStrClientId,@"IsInProgress":@1,@"CurrentHistoryHeaderId":aStrInProgressFormId};
                [gblAppDelegate callWebService:strWebServiceName parameters:dictReq httpMethod:[SERVICE_HTTP_METHOD objectForKey:strWebServiceName] complition:^(NSDictionary *response) {
                    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"offlineToOnline"] isEqualToString:@"YES"]) {
                        [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"offlineToOnline"];
                        [self deleteSelectedFromSync:@"" DateAndTime:[[NSUserDefaults standardUserDefaults] valueForKey:@"lockalDate"]];
                        [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"lockalDate"];
                    }
                    thankYouFlag=@"submitLater";
                    [self performSegueWithIdentifier:@"ThankYouScreen" sender:nil];
                } failure:^(NSError *error, NSDictionary *response) {
                    thankYouFlag=@"submitLater";
                    [self saveDataToLocal:dictReq];
                    
                }];

            }
            
         
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
-(void)deleteSelectedFromSync:(NSString*)formId DateAndTime:(NSString*)dateAndTime{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SubmitFormAndSurvey" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date==%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"lockalDate"]];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *items = [gblAppDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items)
    {
        [gblAppDelegate.managedObjectContext deleteObject:managedObject];
    }

}

-(NSString*)dateFormatterOffline:(NSString*)currentDate{
    NSString *myString = [NSString stringWithFormat:@"%@",currentDate];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    NSDate *yourDate = [dateFormatter dateFromString:myString];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    NSString * Date=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:yourDate]];
    
    return Date;
}

- (void)saveDataToLocal:(NSDictionary*)aDict {
    
    [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"isInOfflineFormOrSurvey"];

    [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"isBack"];

    [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"fromInProgressInOffline"];

    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"saveToInProgressoffline"] isEqualToString:@"YES"]) {
        
        [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"saveToInProgressoffline"];
        [self deleteSelectedFromSync:@"" DateAndTime:[[NSUserDefaults standardUserDefaults] valueForKey:@"lockalDate"]];

    }

    
    SubmitFormAndSurvey *objRecord = [NSEntityDescription insertNewObjectForEntityForName:@"SubmitFormAndSurvey" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    NSString *strUserId = @"";
    if ([User checkUserExist]) {
        strUserId = [[User currentUser] userId];
    }
    objRecord.userId=strUserId;
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"fromSuveyViewC" ] isEqualToString:@"YES"]) {
        objRecord.type =@"1";
        objRecord.typeId = [_objFormOrSurvey valueForKey:@"surveyId"];
    }
    else if (_isSurvey) {
        objRecord.type =@"1";
        objRecord.typeId = [_objFormOrSurvey valueForKey:@"surveyId"];
    }
    else {
        objRecord.type =@"2";
        objRecord.typeId =[_objFormOrSurvey valueForKey:@"formId"];
    }
    objRecord.categoryId = [_objFormOrSurvey valueForKey:@"categoryId"];

    objRecord.userId = [aDict objectForKey:@"UserId"];
    objRecord.clientId = [aDict objectForKey:@"ClientId"];
    objRecord.headerId = aStrInProgressFormId;
    objRecord.isInProgressId = strisInProgress;
    NSString *strdate=[NSString stringWithFormat:@"%@",[NSDate date]];
    objRecord.date=[self dateFormatterOffline:strdate];
    
    NSMutableSet *questionSet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"Details"]) {
        QuestionDetails *aQuestion = [NSEntityDescription insertNewObjectForEntityForName:@"QuestionDetails" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        aQuestion.questionId =[NSString stringWithFormat:@"%@",[dict objectForKey:@"QuestionId"]] ;
        aQuestion.questionText = [NSString stringWithFormat:@"%@",[dict objectForKey:@"QuestionText"]];
        aQuestion.responseText =[NSString stringWithFormat:@"%@",[dict objectForKey:@"ResponseText"]] ;
        aQuestion.detailImageVideoText =[NSString stringWithFormat:@"%@",[dict objectForKey:@"UploadFileResponseData"]] ;
        aQuestion.responseId =[NSString stringWithFormat:@"%@",[dict objectForKey:@"ResponseId"]] ;

        aQuestion.formOrSurvey = objRecord;
        aQuestion.existingResponseBool=[NSString stringWithFormat:@"%@",[dict objectForKey:@"existingResponseBool"]];
        aQuestion.isMandatory=[NSString stringWithFormat:@"%@",[dict objectForKey:@"IsMandatory"]];
        aQuestion.responseType=[NSString stringWithFormat:@"%@",[dict objectForKey:@"ResponseType"]];
        
        NSMutableSet *responseTypeSet = [NSMutableSet set];
        NSMutableArray * sortArray=[[NSMutableArray alloc]init];
        [sortArray addObjectsFromArray:[dict objectForKey:@"responses"]];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"value" ascending:TRUE];
        [sortArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];

        
        
        if (![sortArray isKindOfClass:[NSNull class]]) {
            for (NSDictionary*dictResponseType in [dict objectForKey:@"responses"]) {
                OfflineResponseTypeValues *responseType = [NSEntityDescription insertNewObjectForEntityForName:@"OfflineResponseTypeValues" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                responseType.value = [dictResponseType objectForKey:@"value"];
                responseType.name = [dictResponseType objectForKey:@"name"];
                responseType.sequence =[NSString stringWithFormat:@"%@",[dictResponseType objectForKey:@"sequence"]];
                
                [responseTypeSet addObject:responseType];
            }
        }
        
        aQuestion.responseList = responseTypeSet;
        
        aQuestion.sequence=[NSString stringWithFormat:@"%@",[dict objectForKey:@"sequence"]];
        
        
        
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
            else{
                [sender setSelected:YES];

            }
        }
        [aDict setObject:[NSString stringWithFormat:@"%ld", (long)sender.tag] forKey:@"answer"];
    }
}

- (void)textViewDidBeginEditing:(UITextField *)textField
{
    currentTextField = textField;
}

- (void)textViewDidEndEditing:(UITextField *)textField
{
    currentTextField = nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mutArrQuestions count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DynamicFormCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSLog(@"cell:%@",aCell);
    if (!aCell) {
        aCell=[[DynamicFormCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    aCell.lblQuestion.backgroundColor=[UIColor clearColor];
    [imageArray addObject:@"temp"];
    [arrOfBtnTitleString addObject:@""];
  
    
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

    
    CGRect newFrame;
    
   /* If "responseType" is equal to "content" then expand lable and show htmlAttributes sting  */
    
    if([[aDict valueForKey:@"responseType"]isEqualToString:@"content"])
    {
        /* Append span for setting content text degault color white*/
        
        /* NSString *temp is holding blanck space for text Alignem */
        
        NSString *span=@"<span style=\"color:white; font-size:17px\">";
  
         NSString *spanEnd=@"</span>";
         NSString *temp=@".";
        
        NSString *strContent=[NSString stringWithFormat:@"%@",[aDict objectForKey:@"question"]];
        
        strContent=[span stringByAppendingString:strContent];
        strContent=[strContent stringByAppendingString:spanEnd];
        
        strContent=[strContent stringByAppendingString:temp];
        
        aCell.lblQuestion.attributedText=[self attributedText:strContent];
        
       
        aCell.lblQuestion.numberOfLines=0;
        
       CGSize maximumLabelSize=CGSizeMake(654, 1500);
       
        CGSize expectedLabelSize= [aCell.lblQuestion.text sizeWithFont:aCell.lblQuestion.font constrainedToSize:maximumLabelSize lineBreakMode:aCell.lblQuestion.lineBreakMode];
        
       [aCell.lblQuestion sizeToFit];
       //[aCell.lblQuestion sizeThatFits:expectedLabelSize];
        contentHight=aCell.lblQuestion.frame.size.height;
        
        newFrame = aCell.lblQuestion.frame;
        newFrame.size.height = expectedLabelSize.height;
        newFrame.size.width=expectedLabelSize.width;
        aCell.lblQuestion.frame = CGRectMake(aCell.lblQuestion.frame.origin.x, aCell.lblQuestion.frame.origin.y, aCell.frame.size.width-(aCell.lblQuestion.frame.origin.x*2),aCell.lblQuestion.frame.size.height);
        

    }
    else
    {
        [aCell.lblQuestion setText:[aDict objectForKey:@"question"]];
        
        aCell.lblQuestion.numberOfLines=0;
        aCell.lblQuestion.lineBreakMode=NSLineBreakByWordWrapping;
    //    CGSize maximumLabelSize=CGSizeMake(654, 50);
        
       CGFloat lblWidth = aCell.lblQuestion.frame.size.width;
        CGRect lblTextSize = [aCell.lblQuestion.text boundingRectWithSize:CGSizeMake(lblWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:aCell.lblQuestion.font} context:nil];

        newFrame = aCell.lblQuestion.frame;
        newFrame.size.height = lblTextSize.size.height;
        aCell.lblQuestion.frame = newFrame;
        questionHight=lblTextSize.size.height;
  }
    
    [aCell.btnCheckMark setHidden:YES];
    [aCell.btnCheckMark addTarget:self action:@selector(btnCheckMarkTapped:) forControlEvents:UIControlEventTouchUpInside];
    [aCell.vwTextArea setHidden:YES];
    [aCell.vwButtonList setHidden:YES];
    [aCell.vwTextBox setHidden:YES];
    [aCell.btnSignature setHidden:YES];
     [aCell.largeTxtBgView setHidden:YES];
    [aCell.btnUploadFile setHidden:YES];
    [aCell.lblUploadFile setHidden:YES];

    
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
            
            [lblName setText:[dict objectForKey:@"name"]];
            lblName.numberOfLines=0;
            [lblName setFont:[UIFont systemFontOfSize:13.0]];
          
            
            [lblName setTextColor:[UIColor whiteColor]];
          
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
            
            if ([[aDict objectForKey:@"responseType"] isEqualToString:@"radioButtonList"]) {
                [aBtn setSelected:[dict[@"isSelected"] boolValue]];
           
        if (![aDict[@"answer"] isEqualToString:@""]) {
                
                if ([aDict[@"answer"] integerValue] == index) {
                    
                    [self btnListTypeTapped:aBtn];
                }
                
            }
  }
        
            index++;
        }
        
        CGRect frameCheck  = aCell.vwButtonList.frame;
        frameCheck.origin.y=aCell.lblQuestion.frame.origin.y+aCell.lblQuestion.frame.size.height + 10;
        aCell.vwButtonList.frame=frameCheck;
    }
   
    else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"textbox"]) {
        CGRect frame  = aCell.vwTextBox.frame;
        frame.origin.y=aCell.lblQuestion.frame.origin.y+aCell.lblQuestion.frame.size.height + 10;
        aCell.vwTextBox.frame=frame;
        [aCell.vwTextBox setHidden:NO];
        [aCell.btnUploadFile setHidden:YES];
        [aCell.lblUploadFile setHidden:YES];
        [aCell.txvView setDelegate:self];
        [aCell.txvView setText:[aDict objectForKey:@"answer"]];
        if (![[aDict objectForKey:@"answer"] isEqualToString:@""]) {
            [aCell.txvView setText:[aDict objectForKey:@"answer"]];

        }
        else{
         if([aDict objectForKey:@"existingResponse"]!=nil && ![[aDict objectForKey:@"existingResponse"] isEqualToString:@""])
        {
            
            aCell.txvView.text = [NSString stringWithFormat:@"%@",[aDict objectForKey:@"existingResponse"]];
        }
        }
    }
    else if ([[aDict objectForKey:@"responseType"]isEqualToString:@"longtext"])//for large text
    {  CGRect frame  = aCell.largeTxtBgView.frame;
        frame.origin.y=aCell.lblQuestion.frame.origin.y+aCell.lblQuestion.frame.size.height + 10;
        aCell.largeTxtBgView.frame=frame;
        
        [aCell.vwTextBox setHidden:YES];
        [aCell.largeTxtBgView setHidden:NO];
        [aCell.largeTxtView setDelegate:self];
        [aCell.vwTextArea setHidden:YES];
        [aCell.lblUploadFile setHidden:YES];
   
         aCell.largeTxtBgView.frame=CGRectMake(aCell.largeTxtBgView.frame.origin.x, aCell.lblQuestion.frame.origin.y+aCell.lblQuestion.frame.size.height+10, aCell.largeTxtBgView.frame.size.width, aCell.largeTxtBgView.frame.size.height);
        [aCell.largeTxtView setText:[aDict objectForKey:@"answer"]];
        if (![[aDict objectForKey:@"answer"] isEqualToString:@""]) {
            [aCell.largeTxtView setText:[aDict objectForKey:@"answer"]];

        }
        else{
       if([aDict objectForKey:@"existingResponse"]!=nil && ![[aDict objectForKey:@"existingResponse"] isEqualToString:@""])
        {
            
            aCell.largeTxtView.text = [NSString stringWithFormat:@"%@",[aDict objectForKey:@"existingResponse"]];
        }
        }
    }
    else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"uploadFile"]) //for upload file button
    {
        CGRect frame  = aCell.btnUploadFile.frame;
        frame.origin.y=aCell.lblQuestion.frame.origin.y+aCell.lblQuestion.frame.size.height + 10;
        aCell.btnUploadFile.frame=frame;
        [aCell.btnUploadFile setHidden:NO];
        [aCell.lblQuestion setHidden:NO];
        [aCell.lblUploadFile setHidden:YES];
        aCell.btnUploadFile.tag=indexPath.row;
        [aCell.btnUploadFile addTarget:self action:@selector(fileUpload:) forControlEvents:UIControlEventTouchUpInside];
        if([aDict objectForKey:@"existingResponse"]!=nil && ![[aDict objectForKey:@"existingResponse"] isEqualToString:@""])
        {
            [aCell.lblUploadFile setHidden:NO];

        }else if ([aDict objectForKey:@"answer"]!=nil && ![[aDict objectForKey:@"answer"] isEqualToString:@""]){
            [aCell.lblUploadFile setHidden:NO];
        }
    }
    else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"content"]) {
        [aCell.btnCheckMark setHidden:YES];
        [aCell.vwTextArea setHidden:YES];
        [aCell.vwButtonList setHidden:YES];
        [aCell.vwTextBox setHidden:YES];
        [aCell.largeTxtBgView setHidden:YES];
        [aCell.btnSignature setHidden:YES];
        [aCell.btnUploadFile setHidden:YES];
        [aCell.lblUploadFile setHidden:YES];

    }
    else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"signature"]) {
        CGRect frame  = aCell.btnSignature.frame;
        frame.origin.y=aCell.lblQuestion.frame.origin.y+aCell.lblQuestion.frame.size.height + 10;
        aCell.btnSignature.frame=frame;
        
        [aCell.lblQuestion setHidden:NO];
        [aCell.btnSignature setHidden:NO];
        [aCell.btnSignature setTitle:[aDict objectForKey:@"question"] forState:UIControlStateNormal];
        [aCell.btnUploadFile setHidden:YES];
        [aCell.lblUploadFile setHidden:YES];

        [aCell.btnSignature addTarget:self action:@selector(signatureAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [arrOfBtnTitleString replaceObjectAtIndex:indexPath.row withObject:[aDict objectForKey:@"question"]];
        
        aCell.btnSignature.tag=indexPath.row;
        
        if (![[aDict objectForKey:@"answer"] isEqualToString:@""] || ![[aDict objectForKey:@"existingResponse"] isEqualToString:@""]) {
            [aCell.btnSignature setTitle:@"Edit Participant's Signature" forState:UIControlStateNormal];
            
        }
        else{
            [aCell.btnSignature setTitle:@"Sign here" forState:UIControlStateNormal];

        }
        
    }
    else if (![[aDict valueForKey:@"responseType"] isEqualToString:@"checkbox"]) {
        CGRect frame  = aCell.vwTextArea.frame;
        frame.origin.y=aCell.lblQuestion.frame.origin.y+aCell.lblQuestion.frame.size.height + 10;
        aCell.vwTextArea.frame=frame;
        
        [aCell.vwTextArea setHidden:NO];
        [aCell.txtField setDelegate:self];
        [aCell.btnUploadFile setHidden:YES];
        [aCell.lblUploadFile setHidden:YES];

        [aCell.txtField setText:[aDict objectForKey:@"answer"]];
        if (![[aDict objectForKey:@"answer"] isEqualToString:@""]) {
            [aCell.txtField setText:[aDict objectForKey:@"answer"]];

        }
        else{
            if([aDict objectForKey:@"existingResponse"]!=nil && ![[aDict objectForKey:@"existingResponse"] isEqualToString:@""])
            {
                aCell.txtField.text = [NSString stringWithFormat:@"%@",[aDict objectForKey:@"existingResponse"]];
            }
        }
        
        if ([[aDict objectForKey:@"responseType"] isEqualToString:@"textbox"]) {
            [aCell.imvTypeIcon setHidden:YES];
            [aCell.btnUploadFile setHidden:YES];
            [aCell.lblUploadFile setHidden:YES];

            [aCell.txtField setKeyboardType:UIKeyboardTypeAlphabet];
        }
        else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"numeric"]) {
            CGRect frame  = aCell.txtField.frame;
            frame.origin.y=aCell.lblQuestion.frame.origin.y+aCell.lblQuestion.frame.size.height + 5;
            aCell.txtField.frame=frame;
            
            [aCell.imvTypeIcon setHidden:YES];
            [aCell.btnUploadFile setHidden:YES];
            [aCell.lblUploadFile setHidden:YES];

            [aCell.txtField setKeyboardType:UIKeyboardTypeNumberPad];
            
            if (![[aDict objectForKey:@"answer"] isEqualToString:@""]) {
                [aCell.txtField setText:[aDict objectForKey:@"answer"]];
                
            }
            else{
                if([aDict objectForKey:@"existingResponse"]!=nil && ![[aDict objectForKey:@"existingResponse"] isEqualToString:@""])
                {
                    aCell.txtField.text = [NSString stringWithFormat:@"%@",[aDict objectForKey:@"existingResponse"]];
                }

            }
            

        }
        else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"time"]) {

            [aCell.imvTypeIcon setHidden:NO];
            [aCell.btnUploadFile setHidden:YES];
            [aCell.lblUploadFile setHidden:YES];

            [aCell.imvTypeIcon setImage:[UIImage imageNamed:@"time.png"]];
            if (![[aDict objectForKey:@"answer"] isEqualToString:@""]) {
                [aCell.txtField setText:[aDict objectForKey:@"answer"]];
                
            }
            else{
                if([aDict objectForKey:@"existingResponse"]!=nil && ![[aDict objectForKey:@"existingResponse"] isEqualToString:@""])
                {
                    aCell.txtField.text = [NSString stringWithFormat:@"%@",[aDict objectForKey:@"existingResponse"]];
                }
            }
            
            
        }
        else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"dropdown"]) {

            [aCell.imvTypeIcon setHidden:NO];
            [aCell.btnUploadFile setHidden:YES];
            [aCell.lblUploadFile setHidden:YES];

            [aCell.imvTypeIcon setImage:[UIImage imageNamed:@"arrow.png"]];
            if (![[aDict objectForKey:@"answer"] isEqualToString:@""]) {
                [aCell.txtField setText:[aDict objectForKey:@"answer"]];
                
            }
            else{
                
                if([aDict objectForKey:@"existingResponse"]!=nil && ![[aDict objectForKey:@"existingResponse"] isEqualToString:@""])
                {
                    aCell.txtField.text = [NSString stringWithFormat:@"%@",[aDict objectForKey:@"existingResponse"]];
                }
            }
         
                  }
        else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"date"]) {

            
            [aCell.imvTypeIcon setHidden:NO];
            [aCell.btnUploadFile setHidden:YES];
            [aCell.lblUploadFile setHidden:YES];

            [aCell.imvTypeIcon setImage:[UIImage imageNamed:@"date.png"]];
            
            if (![[aDict objectForKey:@"answer"] isEqualToString:@""]) {
                [aCell.txtField setText:[aDict objectForKey:@"answer"]];
                
            }
            else{
                if([aDict objectForKey:@"existingResponse"]!=nil && ![[aDict objectForKey:@"existingResponse"] isEqualToString:@""])
                {
                    aCell.txtField.text = [NSString stringWithFormat:@"%@",[aDict objectForKey:@"existingResponse"]];
                }
            }
         
            
        }
    }
    else {

        
        [aCell.btnCheckMark setHidden:NO];
        [aCell.lblUploadFile setHidden:YES];

        if (![[aDict objectForKey:@"answer"] isEqualToString:@""]) {
            if ([[aDict objectForKey:@"answer"] isEqualToString:@"true"]) {
                [aCell.btnCheckMark setSelected:YES];
            }else{
                [aCell.btnCheckMark setSelected:NO];

            }
        }
        else{
            if ([[aDict objectForKey:@"answer"] isEqualToString:@"true"]) {
                [aCell.btnCheckMark setSelected:YES];
            }
            else if ([[aDict objectForKey:@"existingResponse"] isEqualToString:@"true"]){
                [aCell.btnCheckMark setSelected:YES];
            }
            else if ([[aDict objectForKey:@"answer"] isEqualToString:@""]){
                [aCell.btnCheckMark setSelected:NO];
            }
        }
        
     
    }
    [aCell setBackgroundColor:[UIColor clearColor]];
    return aCell;
}


- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSInteger rows;
    
    CGFloat height = 50;
    NSDictionary *aDict = [mutArrQuestions objectAtIndex:indexPath.row];
 //   CGRect frame = [[aDict objectForKey:@"question"] boundingRectWithSize:CGSizeMake(650,100) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0]} context:nil];
    height = questionHight + 26;
    
    if ([[aDict objectForKey:@"responseType"] isEqualToString:@"checkboxList"] || [[aDict objectForKey:@"responseType"] isEqualToString:@"radioButtonList"]) {
        rows = [[aDict objectForKey:@"responseList"] count] / 2;
        if ([[aDict objectForKey:@"responseList"] count] % 2 == 1) {
            rows += 1;
        }
        height += 44*rows;
    }
    else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"checkbox"]) {
        
        height +=10;
        
        
    }
    else if ([[aDict objectForKey:@"responseType"]isEqualToString:@"longtext"])//for long text view
    {
        height +=75+104;
    }

    else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"textbox"]) {
        
        height +=75;
        
        
    }
    else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"numeric"]) {
        
         height +=75;
    }
    else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"time"]) {
        
        
         height +=75;
    }
    else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"dropdown"]) {
      
        
         height +=75;
    }
    else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"date"]) {
        
        
         height +=75;
    }

    else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"content"]) {
        
        height=0;
        height += contentHight+10;
        
    }
    else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"signature"]) {
        
        height +=65;
    }
    else if ([[aDict objectForKey:@"responseType"] isEqualToString:@"uploadFile"]) {
        
        height +=95;
    }
    return height;
}

- (NSIndexPath *)indexPathForView:(UIView*)view {
    DynamicFormCell *aCell = (DynamicFormCell*)[view superview];
    while (![aCell isKindOfClass:[DynamicFormCell class]]) {
        aCell = (DynamicFormCell *)[aCell superview];
    }
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


/*
    Button Action Name:-(void)signatureAction:(UIButton*)button
    Purpose: On click it will display a view where user can perform signature
    Parameter: UIButton button
    Return Type: NULL
 */

-(void)signatureAction:(UIButton*)button
{
    NSMutableDictionary *aDict = [mutArrQuestions objectAtIndex:button.tag];
    
    _signatureView.btntag=[NSString stringWithFormat:@"%ld",(long)button.tag];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"isForm"];
    if (!_signatureView)
        _signatureView = [[SignatureView alloc] initWithNibName:@"SignatureView" bundle:nil];
    __weak SignatureView *weakSignature = _signatureView;
    
      weakSignature.txtName.hidden=YES;
    
    [_signatureView setCompletion:^{
        if (weakSignature.tempDrawImage.image) {
            
            
            [button setTitle:@"Edit Participant's Signature" forState:UIControlStateNormal];
            
            NSString *tempstr=@"data:image/png;base64,";
            NSString  *strSignature = @"";
            
            strSignature=[UIImagePNGRepresentation(_signatureView.tempDrawImage.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
           [imageArray replaceObjectAtIndex:button.tag withObject:strSignature];
            
            _signatureView.arrTempSignatureImage=imageArray;
    
            tempstr=[tempstr stringByAppendingString:strSignature];
            
             [aDict setObject:tempstr forKey:@"answer"];
            
        }
        else
        {
            [button setTitle:[arrOfBtnTitleString objectAtIndex:button.tag] forState:UIControlStateNormal];
            [aDict setObject:@"" forKey:@"answer"];
            [aDict setObject:@"" forKey:@"existingResponse"];
        }
    }];
    if([aDict valueForKey:@"existingResponse"]==nil)
    {
        [_signatureView showPopOverWithSender:button base62String:@""];
    }else{
        [_signatureView showPopOverWithSender:button base62String:[aDict objectForKey:@"existingResponse"]];
    }
    
}


/*
    Method name:-(NSAttributedString*)attributedText:(NSString*)str
    Purpose: Read the HTML text and return plane text
    Parameter: NSString str
    Return type:NSAttributedString attributedString
 */

-(NSAttributedString*)attributedText:(NSString*)str
{
    
   
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [str dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
   
    
    
    return  attributedString;
    

}
-(void)fileUpload:(UIButton*)sender{
    [self.view endEditing:YES];

    currentIndex=sender.tag;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Capture Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Select Photo",@"Select Video",nil];

   rect = [self.view convertRect:CGRectMake(self.view.frame.size.width/2-80, self.view.frame.size.height/2-240, sender.frame.size.width, sender.frame.size.height) toView:_parentVC.view];
   rect = [self.view convertRect:rect toView:_parentVC.view];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (buttonIndex == 0) {
            [self showPhotoLibrary:@"image"];
        }else if (buttonIndex == 1){
            [self showPhotoLibrary:@"video"];
        }
        
        
    }];
}
- (void)showPhotoLibrary:(NSString*)str {
    
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    if ([str isEqualToString:@"image"]) {
        [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imgPicker setDelegate:self];
        [imgPicker setAllowsEditing:YES];
        
    }else if ([str isEqualToString:@"video"]){
        [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        imgPicker.delegate = self;
        imgPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
        imgPicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        imgPicker.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
        imgPicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }
    
    popOver = [[UIPopoverController alloc] initWithContentViewController:imgPicker];
    [popOver setPopoverContentSize:CGSizeMake(320, 480)];
    [popOver setDelegate:self];
    [popOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    __block NSString *strEncoded = nil;
    NSMutableDictionary *aDict = [mutArrQuestions objectAtIndex:currentIndex];
    
    if ([info objectForKey:UIImagePickerControllerOriginalImage]) {
        _imgBodilyFluid = [info objectForKey:UIImagePickerControllerOriginalImage];

            strEncoded = [UIImageJPEGRepresentation(_imgBodilyFluid, 1.0) base64EncodedStringWithOptions:0];
        tempstrDataType=@"data:image/gif;base64,";
        [aDict setObject:strEncoded forKey:@"answer"];
        [aDict setObject:tempstrDataType forKey:@"existingResponse"];

    }
    else if ([info objectForKey: UIImagePickerControllerMediaType]){
        NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
        if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
            NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
            NSString *moviePath = [videoUrl path];
            
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
            }
       
                NSData *zipFileData = [NSData dataWithContentsOfFile:moviePath];
                strEncoded = [zipFileData base64EncodedStringWithOptions:0];
            NSURL * mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
            NSDictionary * properties = [[NSFileManager defaultManager] attributesOfItemAtPath:mediaURL.path error:nil];

             //      NSString * validationSize=@"4000096"; //in byte limit for 4Mb
             NSString * validationSize=@"15000000";//in byte limit for 15Mb
            NSLog(@"%ld %ld", (long)[properties fileSize],(long)[validationSize integerValue]);
            NSInteger  tempVideoSize=[[NSString stringWithFormat:@"%llu",[properties fileSize]] integerValue];
            totalSizeOFUploadedVideo = totalSizeOFUploadedVideo + tempVideoSize;
            NSLog(@">> %ld >> %ld",(long)tempVideoSize,(long)totalSizeOFUploadedVideo);
            if (totalSizeOFUploadedVideo > [validationSize integerValue]) {
                [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"largeFileSiz"];
            }
            else{
                [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"largeFileSiz"];

            }
            if (totalSizeOFUploadedVideo > 70000000) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    alert(@"WARNING", @"You can not upload total size of file(files) more than 70MB.")
                    
                });

            }
            else if ([properties fileSize] > [validationSize integerValue]) {
             
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    alert(@"WARNING", @"Please upload file size less than 15 MB.")
                    
                });
           
            }
            else{
            tempstrDataType=@"data:video/mp4;base64,";
            [aDict setObject:strEncoded forKey:@"answer"];
            [aDict setObject:tempstrDataType forKey:@"existingResponse"];

            }
                   }
    }

    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library saveImage:_imgBodilyFluid toAlbum:@"Connect2" withCompletionBlock:^(NSError *error) {
            if (error!=nil)
            {
                NSLog(@"error: %@", [error description]);
            }               [gblAppDelegate.navigationController dismissViewControllerAnimated:YES completion:^{
            }];
        }];
    }else{
        if (popOver)
        {
            

            [popOver dismissPopoverAnimated:YES];
        }
        else
        {

            [gblAppDelegate.navigationController dismissViewControllerAnimated:YES completion:^{
            }];
        }
    }
    DynamicFormCell *aCell = [_tblForm dequeueReusableCellWithIdentifier:@"cell"];
    [aCell.lblUploadFile setHidden:NO];
    [self.tblForm reloadData];
}
-(void)inProgressForm:(NSMutableArray *)arr
{
    NSLog(@"%@",arr);
}
- (void)hideActivityIndicator {
    if (_shouldHideActivityIndicator) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if (viewActivity) {
            [indicatorView stopAnimating];
            [viewActivity removeFromSuperview];
            indicatorView = nil;
            viewActivity = nil;
        }
    }
    
}

- (void)showActivityIndicator {
    if (_shouldHideActivityIndicator) {
        [self showActivityIndicatorWithMessage:nil];
    }
}

- (void)showActivityIndicatorWithMessage:(NSString*)strMessage {
    [self showActivityIndicatorWithMessage:strMessage atPosition:ActivityIndicatorPositionCenter];
}


- (void)showActivityIndicatorWithMessage:(NSString*)strMessage atPosition:(ActivityIndicatorPosition)pos {
    if (!viewActivity) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        viewActivity = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [viewActivity setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]];
        indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicatorView startAnimating];
        if (strMessage && strMessage.length > 0) {
            NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"HelveticaNeue-Light" size:11] forKey: NSFontAttributeName];
            
            // iOS 7 method to mesure height of string instead if sizeWithFont: as it is deprecated
            float height = [strMessage boundingRectWithSize:CGSizeMake(viewActivity.frame.size.width - 6, 30) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin  attributes:stringAttributes context:nil].size.height;
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, viewActivity.frame.size.width - 6, height)];
            lbl.numberOfLines = 0;
            [lbl setBackgroundColor:[UIColor clearColor]];
            [lbl setTextColor:[UIColor whiteColor]];
            [lbl setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11]];
            [lbl setTextAlignment:NSTextAlignmentCenter];
            [lbl setText:strMessage];
            float a = ((viewActivity.frame.size.height - indicatorView.frame.size.height - height - 5) / 2) + (indicatorView.frame.size.height / 2);
            indicatorView.center = CGPointMake(viewActivity.center.x, a);
            lbl.center = CGPointMake(viewActivity.center.x, viewActivity.frame.size.height - indicatorView.frame.origin.y - (height/2));
            [viewActivity addSubview:lbl];
        }
        else {
            indicatorView.center = viewActivity.center;
        }
        
        [viewActivity addSubview:indicatorView];
        [viewActivity.layer setCornerRadius:6.0];
        if (pos == ActivityIndicatorPositionCenter) {
            viewActivity.center = self.view.center;
        }
        else if (pos == ActivityIndicatorPositionBottom) {
            viewActivity.center = CGPointMake(self.view.center.x, self.view.bounds.size.height - (viewActivity.bounds.size.height / 2) - 55);
        }
        else if (pos == ActivityIndicatorPositionTop) {
            viewActivity.center = CGPointMake(self.view.center.x, (viewActivity.bounds.size.height / 2) + 80);
        }
        
        [self.view addSubview:viewActivity];
    }
}


@end
