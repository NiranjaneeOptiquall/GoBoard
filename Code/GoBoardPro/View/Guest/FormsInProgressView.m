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

@implementation FormsInProgressView
{
    NSMutableArray *arrOfForms;
    
//    DynamicFormsViewController *Dyobj;
    
}

- (void) setDelegate:(id)newDelegate{
    _delegate = newDelegate;
}


- (void)drawRect:(CGRect)rect {
    arrOfForms = [NSMutableArray new];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"FormsList"];
    arrOfForms = [NSMutableArray arrayWithArray:[gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil]];
    
    NSLog(@"%@",arrOfForms);

   
    
    [_tblFormsInProgress setFrame:CGRectMake(_tblFormsInProgress.frame.origin.x, _tblFormsInProgress.frame.origin.y, _tblFormsInProgress.frame.size.width,(42.0f*([arrOfForms count])))];
    
    [_tblFormsInProgress reloadData];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
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
    labelline = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-0.5, _tblFormsInProgress.frame.size.width,0.4 )];
    labelline.backgroundColor = [UIColor darkGrayColor];
    [cell.contentView addSubview:labelline];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor =[UIColor blackColor];
   // cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0];
    
    UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(26,3,35,35) ];
    imageView.image=[UIImage imageNamed:@"list_icon.png"];
    [cell.contentView addSubview:imageView];
    
    labelText = [[UILabel alloc]initWithFrame:CGRectMake(81,8,tableView.frame.size.width-50,20)];
    labelText.font =[UIFont systemFontOfSize:20.0];
    labelText.text = [obj valueForKey:@"name"];
     [cell.contentView addSubview:labelText];
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSManagedObject *_objFormOrSurvey=[arrOfForms objectAtIndex:indexPath.row];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
    NSArray *array = [[_objFormOrSurvey valueForKey:@"questionList"] sortedArrayUsingDescriptors:@[sort]];
    NSLog(@"%@",[arrOfForms objectAtIndex:indexPath.row]);
    
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

- (IBAction)btnDissmissView:(id)sender {
  [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"removeInProgress"];
    [self removeFromSuperview];
}
//-(void)callServiceForForms:(BOOL)waitUntilDone complition:(void(^)(void))complition {
//    
//    
//   
//   // NSManagedObject *obj = [mutArrFormList objectAtIndex:button];
//    if([[NSUserDefaults standardUserDefaults]valueForKey:@"formId"]!=nil)
//    {
//        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"formId"];
//    }
//    [[NSUserDefaults standardUserDefaults]setValue:[NSManagedObject valueForKey:@"formId"] forKey:@"formId"];
//    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"formId"]);
//    __block BOOL isWSComplete = NO;
//    NSString *aStrClientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
//    NSString *strUserId = @"";
//    if ([User checkUserExist]) {
//        strUserId = [[User currentUser] userId];
//    }
//    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?ClientId=%@&UserId=%@&formId=%@", FORM_SETUP, aStrClientId, strUserId,[NSManagedObject valueForKey:@"formId"]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:FORM_SETUP] complition:^(NSDictionary *response) {
//        [self deleteAllForms];
//        [self insertForms:response];
//       
//        isWSComplete = YES;
//        if (complition)
//            complition();
//    } failure:^(NSError *error, NSDictionary *response) {
//        isWSComplete = YES;
//        if (complition)
//            complition();
//        NSLog(@"%@", response);
//    }];
//    if (waitUntilDone) {
//        while (!isWSComplete) {
//            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
//        }
//    }
//}
//- (void)insertForms:(NSDictionary*)aDict {
//    NSMutableArray *arrFormHistory = [NSMutableArray new];
//    [arrFormHistory addObjectsFromArray:[aDict valueForKey:@"FormHistries"]];
//    for (int i=0; i<arrFormHistory.count; i++) {
//        
//        FormsList *form = [NSEntityDescription insertNewObjectForEntityForName:@"FormsList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
//        
//        form.formId = [[NSUserDefaults standardUserDefaults]valueForKey:@"formId"];
//        if (![[aDict objectForKey:@"FormInstructions"] isKindOfClass:[NSNull class]]) {
//            form.instructions = [aDict objectForKey:@"FormInstructions"];
//        }
//        else {
//            form.instructions = @"";
//        }
//        if (![[aDict objectForKey:@"Link"] isKindOfClass:[NSNull class]]) {
//            form.link = [aDict objectForKey:@"Link"];
//        }
//        else {
//            form.link = @"";
//        }
//        form.name = [aDict objectForKey:@"FormName"];
//        form.typeId = [[aDict objectForKey:@"FormTypeId"] stringValue];
//        form.userTypeId = [[aDict objectForKey:@"FormUserTypeId"] stringValue];
//        // form.sequence=[aDict objectForKey:@"Sequence"] ;
//        form.categoryId=[[aDict objectForKey:@"FormCategoryId"]stringValue];
//        form.isAllowInProgress =[[aDict valueForKey:@"FormIsAllowInProgress"]stringValue];
//        if (![[aDict objectForKey:@"FormCategoryName"] isKindOfClass:[NSNull class]])
//        {
//            form.categoryName=[aDict objectForKey:@"FormCategoryName"];
//        }
//        
//        //form.inProgressCount = [NSString stringWithFormat:@"%@",[aDict valueForKey:@"InProgressCount"]];
//        form.isAllowInProgress =[NSString stringWithFormat:@"%@", [[aDict valueForKey:@"FormHistries"]valueForKey:@"IsInProgress"]];
//        
//        
//        for (NSDictionary *aDict in arrFormHistory) {
//            NSMutableSet *aSetQuestions = [NSMutableSet set];
//            if (![[aDict objectForKey:@"Questions"] isKindOfClass:[NSNull class]]) {
//                for (NSDictionary *dictQuest in [aDict objectForKey:@"Questions"]) {
//                    SurveyQuestions *aQuestion = [NSEntityDescription insertNewObjectForEntityForName:@"SurveyQuestions" inManagedObjectContext:gblAppDelegate.managedObjectContext];
//                    aQuestion.mandatory=[[dictQuest objectForKey:@"IsMandatory"] stringValue];
//                    aQuestion.questionId = [[dictQuest objectForKey:@"Id"] stringValue];
//                    aQuestion.question = [dictQuest objectForKey:@"Question"];
//                    aQuestion.responseType = [dictQuest objectForKey:@"ResponseType"];
//                    aQuestion.sequence = [dictQuest objectForKey:@"Sequence"];
//                    if (![[dictQuest objectForKey:@"ExistingResponse"] isKindOfClass:[NSNull class]])
//                    {
//                        aQuestion.existingResponse = [dictQuest objectForKey:@"ExistingResponse"];
//                    }
//                    aQuestion.existingResponse = [[dictQuest objectForKey:@"ExistingResponseBool"]stringValue];
//                    NSMutableSet *responseTypeSet = [NSMutableSet set];
//                    if (![[dictQuest objectForKey:@"Responses"] isKindOfClass:[NSNull class]]) {
//                        for (NSDictionary*dictResponseType in [dictQuest objectForKey:@"Responses"]) {
//                            SurveyResponseTypeValues *responseType = [NSEntityDescription insertNewObjectForEntityForName:@"SurveyResponseTypeValues" inManagedObjectContext:gblAppDelegate.managedObjectContext];
//                            responseType.value = [[dictResponseType objectForKey:@"Id"] stringValue];
//                            responseType.name = [dictResponseType objectForKey:@"Name"];
//                            responseType.sequence = [[dictResponseType objectForKey:@"Sequence"] stringValue];
//                            responseType.question = aQuestion;
//                            [responseTypeSet addObject:responseType];
//                        }
//                    }
//                    aQuestion.responseList = responseTypeSet;
//                    aQuestion.formList = form;
//                    [aSetQuestions addObject:aQuestion];
//                }
//            }
//            form.questionList = aSetQuestions;
//            
//        }
//        [gblAppDelegate.managedObjectContext insertObject:form];
//        [gblAppDelegate.managedObjectContext save:nil];
//    }
//    
//    
//}
//- (void)deleteAllForms {
//    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"FormsList"];
//    [request setIncludesPropertyValues:NO];
//    NSArray *aryRecords = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
//    for (NSManagedObject *rec in aryRecords) {
//        [gblAppDelegate.managedObjectContext deleteObject:rec];
//    }
//    [gblAppDelegate.managedObjectContext save:nil];
//}
@end
