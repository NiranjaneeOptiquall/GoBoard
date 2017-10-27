//
//  FormsInProgressView.m
//  GoBoardPro
//
//  Created by Inversedime on 29/11/16.
//  Copyright © 2016 IndiaNIC. All rights reserved.
//

#import "FormsInProgressView.h"
#import "AppDelegate.h"
#import "DynamicFormsViewController.h"
#import "FormsHistory.h"
#import "WebSerivceCall.h"
#import "FormsInProgress.h"
@implementation FormsInProgressView
{
    NSMutableArray *arrOfForms;
    
//    DynamicFormsViewController *Dyobj;
    
}

- (void) setDelegate:(id)newDelegate{
    _delegate = newDelegate;
}


- (void)drawRect:(CGRect)rect {
       [self fetchData];
}

-(void)fetchData{
    ////********** fetch all in progress forms/surveys from locale database**********//

    arrOfForms = [NSMutableArray new];
    NSFetchRequest *request = [NSFetchRequest new];
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isSurvey"] isEqualToString:@"YES"]) {
        request = [[NSFetchRequest alloc] initWithEntityName:@"SurveyInProgress"];
    }else{
        request = [[NSFetchRequest alloc] initWithEntityName:@"FormsInProgress"];
    }

    arrOfForms = [NSMutableArray arrayWithArray:[gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil]];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:TRUE];// sort data by date
    [arrOfForms sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    arrOfForms = [[[arrOfForms reverseObjectEnumerator] allObjects] mutableCopy];// set array latest date upside
    
    
    [_tblFormsInProgress setFrame:CGRectMake(_tblFormsInProgress.frame.origin.x, _tblFormsInProgress.frame.origin.y, _tblFormsInProgress.frame.size.width,(70.0f*([arrOfForms count]+1)))];
    
    
    [_tblFormsInProgress reloadData];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 70)];
    UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 70)];
    imageView.image=[UIImage imageNamed:@"headerBaground.png"];
    [view addSubview:imageView];
    UILabel * title=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, tableView.frame.size.width-40, 25)];

    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isSurvey"] isEqualToString:@"YES"]) {
       
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"OfflineForListTitle"] isEqualToString:@"YES"]) {

            title.text=@"Surveys in Offline";
        }
        else{
             title.text=@"Surveys in Progress";
        }
    }
    else if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"fromInProgress"] isEqualToString:@"YES"]){
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"OfflineForListTitle"] isEqualToString:@"YES"]) {
            title.text=@"Forms in Offline";

        }
        else{
            title.text=@"Forms in Progress";

        }
    }
    else if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"fromSugestionViewC"] isEqualToString:@"YES"]){
          title.text=@"Suggestion in Progress";
    }
    
    title.textColor=[UIColor whiteColor];
    title.backgroundColor=[UIColor clearColor];
    title.font=[UIFont systemFontOfSize:20];
    [view addSubview:title];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 70.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    
    return  arrOfForms.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *obj = [arrOfForms objectAtIndex:indexPath.row];
    UILabel *labelText = nil;
    UILabel *labelline = nil;
    UILabel *labelTime = [[UILabel alloc]init];
    UIButton * deleteButton=nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.row == 0 || indexPath.row % 2 == 0) {
        [cell setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    }
    else {
        [cell setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
    }
 
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor =[UIColor blackColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0];
    cell.backgroundColor=[UIColor whiteColor];
    
    UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,3,35,35) ];
    imageView.image=[UIImage imageNamed:@"list_icon.png"];
    [cell.contentView addSubview:imageView];
    
    labelText = [[UILabel alloc]initWithFrame:CGRectMake(61,8,tableView.frame.size.width-150,20)];
    labelText.font =[UIFont systemFontOfSize:20.0];
    labelText.text = [obj valueForKey:@"name"];
     [cell.contentView addSubview:labelText];
    
    labelTime = [[UILabel alloc]initWithFrame:CGRectMake(61,labelText.frame.size.height + 18,200,20)];
    labelTime.font =[UIFont systemFontOfSize:15.0];
    labelTime.text =[NSString stringWithFormat:@"%@",[self dateFormatter:[obj valueForKey:@"date"]]];
    labelTime.backgroundColor=[UIColor whiteColor];
    [cell.contentView addSubview:labelTime];
    
    labelline = [[UILabel alloc] initWithFrame:CGRectMake(0, labelTime.frame.origin.y+labelTime.frame.size.height+11, _tblFormsInProgress.frame.size.width,1)];
    labelline.backgroundColor = [UIColor darkGrayColor];
    [cell.contentView addSubview:labelline];
    deleteButton=[[UIButton alloc]initWithFrame:CGRectMake(tableView.frame.size.width-90 , 8, 80, 30)];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"update_profile_btn@2x.png"] forState:UIControlStateNormal];
    [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteButton.tag=indexPath.row;
    [deleteButton addTarget:self action:@selector(deleteClicked:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.tag=indexPath.row;

     [cell.contentView addSubview:deleteButton];

    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *obj = [arrOfForms objectAtIndex:indexPath.row];
 //   NSManagedObject *_objFormOrSurvey=[arrOfForms objectAtIndex:indexPath.row];
//    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
 //NSArray *array = [[_objFormOrSurvey valueForKey:@"questionList"] sortedArrayUsingDescriptors:@[sort]];
    NSLog(@"%@",arrOfForms);
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[obj valueForKey:@"inProgressFormId"]] forKey:@"aStrInProgressFormId"];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"aStrInProgressFormId"]);

    NSString *strIndexPath = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
     [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"isFormHistory"];
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"indexpath"]!=nil) {
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"indexpath"];
    }
    
    [[NSUserDefaults standardUserDefaults]setValue:strIndexPath forKey:@"indexpath"];
   
  
    UIViewController *viewController = [self viewController];
    

        if(viewController)
        {

            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *viewControllerObject = [storyboard instantiateViewControllerWithIdentifier:@"DYFormsView"];
            [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"OfflineForListTitle"];

              [self removeFromSuperview];
            if ([viewController class] != [viewControllerObject class]) {
                [viewController.navigationController pushViewController:viewControllerObject animated:NO];
            }
            
        }
}

- (UIViewController*)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    
    return nil;
}
-(NSString*)dateFormatter:(NSString*)date{
    NSString *myString = [NSString stringWithFormat:@"%@",date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:SS.SSS'Z'";
    NSDate *yourDate = [dateFormatter dateFromString:myString];
    dateFormatter.dateFormat = @"MM/dd/yyyy hh:mm a";
    NSString * Date=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:yourDate]];
    
    return Date;
}

-(void)deleteClicked:(UIButton*)sender{
    //********** forms/survey  in progress delete**********//
    [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"guestUserBack"];

     NSManagedObject *obj = [arrOfForms objectAtIndex:sender.tag];
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"fromInProgressInOffline"] isEqualToString:@"YES"]) {

            [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"offlineInProgress"];

        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isSurvey"] isEqualToString:@"YES"]) {
            [self deleteSelectedRow:[obj valueForKey:@"surveyId"] DateAndTime:[NSString stringWithFormat:@"%@",[obj valueForKey:@"date"]]];
        }
        else{
            [self deleteSelectedRow:[obj valueForKey:@"formId"] DateAndTime:[NSString stringWithFormat:@"%@",[obj valueForKey:@"date"]]];
        }
    }
    else{
        
        if ([self isNetworkReachable]) {
            
            [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"removeInProgress"];
            [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"OfflineForListTitle"];

            [self callServiceForDelete:YES buttonIndex:sender.tag complition:nil];
            
        }
        else {
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:MSG_NO_INTERNET delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }

        
    }
    

}
-(void)deleteSelectedRow:(NSString*)formId DateAndTime:(NSString*)dateAndTime{
    //********** delete  forms/survey  in progress (offline)**********//

    NSFetchRequest *request=nil;
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isSurvey"] isEqualToString:@"YES"]) {
        
        request = [[NSFetchRequest alloc] initWithEntityName:@"SurveyInProgress"];

         [request setPredicate:[NSPredicate predicateWithFormat:@"date == %@ ",dateAndTime]];
        
    }else{
        request = [[NSFetchRequest alloc] initWithEntityName:@"FormsInProgress"];

         [request setPredicate:[NSPredicate predicateWithFormat:@"date == %@ ",dateAndTime]];
    }
    
  

    [request setIncludesPropertyValues:NO];
    NSArray *aryRecords = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    for (NSManagedObject *rec in aryRecords) {
        [gblAppDelegate.managedObjectContext deleteObject:rec];
    }
    [gblAppDelegate.managedObjectContext save:nil];

    [self deleteSelectedFromSync:formId DateAndTime:dateAndTime];
    
}

-(void)deleteSelectedFromSync:(NSString*)formId DateAndTime:(NSString*)dateAndTime{

    
NSFetchRequest *request=request = [[NSFetchRequest alloc] initWithEntityName:@"SubmitFormAndSurvey"];
 
    [request setPredicate:[NSPredicate predicateWithFormat:@"date == %@ ",dateAndTime]];

 
    NSArray *aryRecords = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    for (NSManagedObject *rec in aryRecords) {
        [gblAppDelegate.managedObjectContext deleteObject:rec];
    }
    [gblAppDelegate.managedObjectContext save:nil];
    
    if (arrOfForms.count == 1) {

            [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"offlineInProgress"];
        [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"fromInProgressSubmit"];
        [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"OfflineForListTitle"];

    
        [self removeFromSuperview];
    }
    else{
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isSurvey"] isEqualToString:@"YES"]) {
            [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"fromSuveyViewC"];
            [self fetchData];
        }
            else{
                [self fetchData];
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
- (void)callServiceForDelete:(BOOL)waitUntilDone buttonIndex:(NSInteger)button complition:(void(^)(void))complition {
 
    //********** delete forms/survey  in progress (online)**********//

    
    __block BOOL isWSComplete = NO;
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isSurvey"] isEqualToString:@"YES"]) {
        
        [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?surveyHistoryHeaderId=%@", SURVEY_SETUP,[[arrOfForms valueForKey:@"inProgressFormId"]objectAtIndex:button]] parameters:nil httpMethod:@"DELETE" complition:^(NSDictionary *response) {
            

            isWSComplete = YES;
            if (complition)
                complition();
        } failure:^(NSError *error, NSDictionary *response) {
            isWSComplete = YES;
            if (complition)
                complition();
            NSLog(@"%@", response);
        }];
        if (waitUntilDone) {
            while (!isWSComplete) {
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
            }
        }
        
        
    }else{
        
        [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?formHistoryHeaderId=%@", FORM_SETUP,[[arrOfForms valueForKey:@"inProgressFormId"]objectAtIndex:button]] parameters:nil httpMethod:@"DELETE" complition:^(NSDictionary *response) {
            
            
            isWSComplete = YES;
            if (complition)
                complition();
        } failure:^(NSError *error, NSDictionary *response) {
            isWSComplete = YES;
            if (complition)
                complition();
            NSLog(@"%@", response);
        }];
        if (waitUntilDone) {
            while (!isWSComplete) {
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
            }
        }
        
    }
    
    if (arrOfForms.count == 1) {
        [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"removeInProgress"];
        [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"OfflineForListTitle"];

        [self removeFromSuperview];
    }
    else{
        [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"removeInProgress"];
        [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"OfflineForListTitle"];

        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isSurvey"] isEqualToString:@"YES"]) {
            [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"fromSuveyViewC"];
            
            
            [[WebSerivceCall webServiceObject]callServiceForSurvey:YES withSurveyId:[[NSUserDefaults standardUserDefaults] valueForKey:@"surveyIdForDelete"] complition:^{
                [self fetchData];
            }];
        }
        else{
            NSLog(@"%ld",button);
            [self callServiceForForms:YES buttonIndex:button complition:nil];
              [self fetchData];
        }
    }
    
    

}
- (void)callServiceForForms:(BOOL)waitUntilDone buttonIndex:(NSInteger)button complition:(void(^)(void))complition {
    

    
 
    __block BOOL isWSComplete = NO;
    NSString *aStrClientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
    NSString *strUserId = @"";
    if ([User checkUserExist]) {
        strUserId = [[User currentUser] userId];
    }
    
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?ClientId=%@&UserId=%@&formId=%@", FORM_SETUP, aStrClientId, strUserId,[[arrOfForms valueForKey:@"formId"] objectAtIndex:button]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:FORM_SETUP] complition:^(NSDictionary *response) {
        
        [self deleteAllForms];
        [self insertForms:response];
    
        
        isWSComplete = YES;
        if (complition)
            complition();
    } failure:^(NSError *error, NSDictionary *response) {
        isWSComplete = YES;
        if (complition)
            complition();
        NSLog(@"%@", response);
    }];
    if (waitUntilDone) {
        while (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
}
- (void)deleteAllForms {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"FormsInProgress"];
    [request setIncludesPropertyValues:NO];
    NSArray *aryRecords = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    for (NSManagedObject *rec in aryRecords) {
        [gblAppDelegate.managedObjectContext deleteObject:rec];
    }
    [gblAppDelegate.managedObjectContext save:nil];


    
}

- (void)insertForms:(NSDictionary*)Dict {
    NSMutableArray *arrFormHistory = [NSMutableArray new];
    [arrFormHistory addObjectsFromArray:[Dict valueForKey:@"FormHistory"]];
    for (NSDictionary *aDict in arrFormHistory) {
        
        FormsInProgress *form = [NSEntityDescription insertNewObjectForEntityForName:@"FormsInProgress" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        
        form.formId = [[NSUserDefaults standardUserDefaults]valueForKey:@"formId"];
        if (![[Dict objectForKey:@"FormInstructions"] isKindOfClass:[NSNull class]]) {
            form.instructions = [Dict objectForKey:@"FormInstructions"];
        }
        else {
            form.instructions = @"";
        }
        if (![[Dict objectForKey:@"Link"] isKindOfClass:[NSNull class]]) {
            form.link = [Dict objectForKey:@"Link"];
        }
        else {
            form.link = @"";
        }
        form.name = [Dict objectForKey:@"FormName"];
        form.typeId = [[Dict objectForKey:@"FormTypeId"] stringValue];
        form.userTypeId = [[Dict objectForKey:@"FormUserTypeId"] stringValue];
        
        form.categoryId=[[Dict objectForKey:@"FormCategoryId"]stringValue];
        
        if (![[Dict objectForKey:@"FormCategoryName"] isKindOfClass:[NSNull class]])
        {
            form.categoryName=[Dict objectForKey:@"FormCategoryName"];
        }
        
        form.date=[NSString stringWithFormat:@"%@", [aDict valueForKey:@"Date"]];
        form.inProgressFormId=[NSString stringWithFormat:@"%@", [aDict valueForKey:@"Id"]];
        
        form.isAllowInProgress =[NSString stringWithFormat:@"%@", [aDict valueForKey:@"IsInProgress"]];
        NSMutableSet *aSetQuestions = [NSMutableSet set];
        if (![[aDict objectForKey:@"Questions"] isKindOfClass:[NSNull class]]) {
            for (NSDictionary *dictQuest in [aDict objectForKey:@"Questions"]) {
                SurveyQuestions *aQuestion = [NSEntityDescription insertNewObjectForEntityForName:@"SurveyQuestions" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                aQuestion.mandatory=[[dictQuest objectForKey:@"IsMandatory"] stringValue];
                aQuestion.questionId = [[dictQuest objectForKey:@"Id"] stringValue];
                aQuestion.question = [dictQuest objectForKey:@"Question"];
                aQuestion.responseType = [dictQuest objectForKey:@"ResponseType"];
                aQuestion.sequence = [dictQuest objectForKey:@"Sequence"];
                if (![[dictQuest objectForKey:@"ExistingResponse"] isKindOfClass:[NSNull class]])
                {
                    aQuestion.existingResponse = [dictQuest objectForKey:@"ExistingResponse"];
                }
                if (![[dictQuest objectForKey:@"ExistingResponseIds"] isKindOfClass:[NSNull class]])
                {
                    aQuestion.existingResponseIds = [dictQuest objectForKey:@"ExistingResponseIds"];
                }
                aQuestion.existingResponseBool = [[dictQuest objectForKey:@"ExistingResponseBool"]stringValue];
                NSMutableSet *responseTypeSet = [NSMutableSet set];
                if (![[dictQuest objectForKey:@"Responses"] isKindOfClass:[NSNull class]]) {
                    for (NSDictionary*dictResponseType in [dictQuest objectForKey:@"Responses"]) {
                        SurveyResponseTypeValues *responseType = [NSEntityDescription insertNewObjectForEntityForName:@"SurveyResponseTypeValues" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                        responseType.value = [[dictResponseType objectForKey:@"Id"] stringValue];
                        responseType.name = [dictResponseType objectForKey:@"Name"];
                        responseType.sequence = [[dictResponseType objectForKey:@"Sequence"] stringValue];
                        responseType.question = aQuestion;
                        [responseTypeSet addObject:responseType];
                    }
                }
                aQuestion.responseList = responseTypeSet;
                aQuestion.formInProgressList = form;
                [aSetQuestions addObject:aQuestion];
            }
        }
        form.questionList = aSetQuestions;
        [gblAppDelegate.managedObjectContext insertObject:form];
        [gblAppDelegate.managedObjectContext save:nil];
    }
    
  
    
    
}
- (IBAction)btnDissmissView:(id)sender {
    [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"guestUserBack"];
    [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"OfflineForListTitle"];

    [self removeFromSuperview];
}

@end
