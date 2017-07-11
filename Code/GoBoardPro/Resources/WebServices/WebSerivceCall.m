
//
//  WebSerivceCall.m
//  GoBoardPro
//
//  Created by ind558 on 10/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "WebSerivceCall.h"
#import "Constants.h"
#import "UtilizationCount.h"
#import "TaskList.h"
#import "TaskResponseTypeValues.h"
#import "ERPCategory.h"
#import "ERPSubcategory.h"
#import "ERPTask.h"
#import "SubmitFormAndSurvey.h"
#import "IncidentReportInfo.h"
#import "NatureList.h"
#import "EquipmentList.h"
#import "RequiredField.h"
#import "ConditionList.h"
#import "ActionTakenList.h"
#import "ActivityList.h"
#import "QuestionDetails.h"
#import "AccidentReportInfo.h"
#import "AbdomenInjuryList.h"
#import "HeadInjuryList.h"
#import "BodyPartInjuryType.h"
#import "CareProvidedType.h"
#import "ArmInjuryList.h"
#import "LeftArmInjuryList.h"
#import "GeneralInjuryType.h"
#import "LegInjuryList.h"
#import "LeftLegInjuryList.h"
#import "Reachability.h"

#import "SurveyList.h"
#import "SurveyInProgress.h"
#import "FormsInProgress.h"
#import "OfflineResponseTypeValues.h"

#import "SurveyQuestions.h"
#import "SurveyResponseTypeValues.h"
#import "FormsList.h"

#import "TeamLog.h"
#import "TeamSubLog.h"
#import "TeamLogTrace.h"

#import "ClientPositions.h"
#import "NSDictionary+NullReplacement.h"
#import "formCategory.h"
#import "GuestFormViewController.h"
#import "UserHomeViewController.h"

@implementation WebSerivceCall

+ (WebSerivceCall *)webServiceObject {
    static WebSerivceCall *object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[WebSerivceCall alloc] init];
    });
    return object;
}


#pragma mark - GetAllData

- (void)getAllData
{
    //[[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"loadingForFirstTime"];

    [self callServiceForHomeSetup:YES complition:nil];
    [self callServiceForEmergencyResponsePlan:YES complition:nil];
    [self callServiceForTaskList:YES complition:nil];
    [self callServiceForUtilizationCount:YES complition:nil];
    
   // [self callServiceForDashboardCount:YES complition:nil];

    [self callServiceForIncidentReport:YES complition:nil];
    [self callServiceForAccidentReport:YES complition:nil];
    [self callServiceForMemos:YES complition:nil];
    [self callServiceForAllClienntPositions:YES complition:nil];

    //**** initialy call for  forms/survey data is cansled because of heavy data take long  time and this webservice call is made on clicke event of form/survey page call****//
   //   [self callServiceForForms:YES complition:nil];
    //   [self callServiceForSurvey:YES complition:nil];
    
    //[self callServiceForSop:YES complition:nil];
    
    //**** initialy call for  Log data is cansled because of count display is depend on this service call*****//
   // [self callServiceForTeamLog:YES complition:nil];
    
 
    //******delete all forms/surveys while client user is changed*****//
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isSameClientForm"] isEqualToString:@"NO"]) {
        [self deleteAllForms];
    }
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isSameClientSurvey"] isEqualToString:@"NO"]) {
        [self deleteAllSurveys];
    }
   
}

#pragma mark - HOME Setup

- (void)callServiceForHomeSetup:(BOOL)waitUntilDone complition:(void (^)(void))completion {
    __block BOOL isWSComplete = NO;
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?userId=%@", HOME_SCREEN_MODULES, [[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:HOME_SCREEN_MODULES] complition:^(NSDictionary *response) {
        NSLog(@"%@",response);
//            NSMutableArray*moduleArr = [NSMutableArray new];
//        
//            for (NSDictionary * tempDic in [response objectForKey:@"Modules"]) {
//                if (([tempDic[@"IsActive"] boolValue] && [tempDic[@"IsAccessAllowed"] boolValue])) {
//                    [moduleArr addObject:tempDic];
//                }
//            }
//            NSLog(@"%@",moduleArr);
//            if (moduleArr.count == 0) {
//                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
//                [gblAppDelegate hideActivityIndicator];
//                gblAppDelegate.shouldHideActivityIndicator = YES;
//            alert(@"", @"We’re sorry. You do not have permission to access this area. Please see your system administrator.");
//                return;
//        
//                  }
      
              
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"Position" ascending:YES];
        gblAppDelegate.mutArrHomeMenus = [response objectForKey:@"Modules"];
        [gblAppDelegate.mutArrHomeMenus sortUsingDescriptors:@[sort]];
        int Pos = 0;
        for (int i = 0; i < gblAppDelegate.mutArrHomeMenus.count; i++) {
            int currentPos = [[gblAppDelegate.mutArrHomeMenus[i] objectForKey:@"Position"] intValue];
            int differance = currentPos - Pos;
            if (differance > 1) {
                for (int j = 0; j < differance-1; j++) {
                    [gblAppDelegate.mutArrHomeMenus insertObject:@{@"IsActive":[NSNumber numberWithBool:NO], @"Position":[NSNumber numberWithInt:Pos+1]} atIndex:i];
                    Pos++;
                    i++;
                }
            }
            Pos = currentPos;
        }
        
        if ([gblAppDelegate.managedObjectContext save:nil]) {
            isWSComplete = YES;
        }
        if (completion) {
            completion();
        }
        
    } failure:^(NSError *error, NSDictionary *response) {
        isWSComplete = YES;
        if (completion) {
            completion();
        }
    }];
    if (waitUntilDone) {
        while (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
}


#pragma mark - Sop

-(void)callServiceForSop:(BOOL)waitUntilDone complition:(void(^)(void))completion {
    
    __block BOOL isWSComplete = NO;
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@",SOP_CATEGORY,[[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:SOP_CATEGORY] complition:^(NSDictionary *response) {
        
        
        [self inserAllSopData:response];
        isWSComplete = YES;
        
        if (completion) {
            completion();
        }
        
        
    } failure:^(NSError *error, NSDictionary *response){
        isWSComplete = YES;
        
        if (completion) {
            completion();
        }
        
    }];
    
    if (waitUntilDone) {
        if (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
    
}
- (void)callServiceForFormInOffline:(BOOL)waitUntilDone withFormId:(NSString*)FormId withFormInstructions:(NSString*)FormInstructions withFormIsAllowInProgress:(NSString*)FormIsAllowInProgress withFormName:(NSString*)FormName complition:(void(^)(void))complition{
  
    
    __block BOOL isWSComplete = NO;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SubmitFormAndSurvey"];
    
    NSArray *aryOfflineData = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    isErrorOccurred = NO;
    __block BOOL isSingleDataSaved = NO;
    NSMutableDictionary * dataDic=[[NSMutableDictionary alloc]init];
    [dataDic setValue:FormId forKey:@"formId"];
    [dataDic setValue:FormInstructions forKey:@"Instructions"];
    [dataDic setValue:FormIsAllowInProgress forKey:@"SurveyIsAllowInProgress"];
    [dataDic setValue:FormName forKey:@"FormName"];

    NSString *strUserId = @"";
    if ([User checkUserExist]) {
        strUserId = [[User currentUser] userId];
    }
    [dataDic setValue:strUserId forKey:@"userId"];

    NSMutableArray *questionArr2 = [[NSMutableArray    alloc]init];
    int j = 0;
    for (SubmitFormAndSurvey *record in aryOfflineData) {
        [dataDic setValue:record.categoryId forKey:@"CategoryId"];

        isSingleDataSaved = NO;
        NSMutableDictionary *questionArr = [[NSMutableDictionary    alloc]init];
        
        NSMutableArray *questionArrReq = [[NSMutableArray    alloc]init];
        
        if ([record.isInProgressId isEqualToString:@"1"] && [record.typeId isEqualToString:FormId] && [record.userId isEqualToString:strUserId])
            
        {
            
            int i = 0;
            for (QuestionDetails *obj in record.questionList.allObjects) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                if (obj.questionId!=nil) {
                    [dict setObject:obj.questionId forKey:@"Id"];
                }
                else{
                    [dict setObject:@"" forKey:@"Id"];
                }
                
                if (obj.questionText!=nil) {
                    [dict setObject:obj.questionText forKey:@"QuestionText"];
                }
                else{
                    [dict setObject:@"" forKey:@"QuestionText"];
                }
                if (obj.responseText!=nil) {
                    [dict setObject:obj.responseText forKey:@"ExistingResponse"];
                }
                else{
                    [dict setObject:@"" forKey:@"ExistingResponse"];
                }
                if (obj.questionId!=nil) {
                    [dict setObject:obj.questionId forKey:@"QuestionId"];
                }
                else{
                    [dict setObject:@"" forKey:@"QuestionId"];
                }
                if (obj.existingResponseBool!=nil) {
                    [dict setObject:obj.existingResponseBool forKey:@"ExistingResponseBool"];
                }
                else{
                    [dict setObject:@"" forKey:@"ExistingResponseBool"];
                }
                if (obj.responseId!=nil) {
                    [dict setObject:obj.responseId forKey:@"ResponseId"];
                }
                else{
                    [dict setObject:@"" forKey:@"ResponseId"];
                }
                if (obj.isMandatory!=nil) {
                    [dict setObject:obj.isMandatory forKey:@"IsMandatory"];
                }
                else{
                    [dict setObject:@"" forKey:@"IsMandatory"];
                }  if (obj.responseType!=nil) {
                    [dict setObject:obj.responseType forKey:@"ResponseType"];
                }
                else{
                    [dict setObject:@"" forKey:@"ResponseType"];
                }
                if (obj.detailImageVideoText!=nil) {
                    [dict setObject:obj.detailImageVideoText forKey:@"detailImageVideoText"];
                }
                else{
                    [dict setObject:@"" forKey:@"detailImageVideoText"];
                }
                if (obj.sequence!=nil) {
                    [dict setObject:obj.sequence forKey:@"sequence"];
                }
                else{
                    [dict setObject:@"" forKey:@"sequence"];
                }
                if (![obj.responseList isKindOfClass:[NSNull class]]) {
                    NSMutableArray * tempArray=[NSMutableArray new];
                    int i=0;
                    for (OfflineResponseTypeValues*dictResponseType in obj.responseList) {
                        NSMutableDictionary * tempDic=[NSMutableDictionary new];
                        
                        [tempDic setObject:dictResponseType.name forKey:@"name"];
                        [tempDic setObject:dictResponseType.value forKey:@"value"];
                        if (dictResponseType.sequence  != nil) {
                            [tempDic setObject:dictResponseType.sequence forKey:@"sequence"];
                            
                        }
                        [tempArray insertObject:tempDic atIndex:i];
                        i=i+1;
                        
                    }
                    [dict setObject:tempArray forKey:@"Responses"];
                    
                }
                else{
                    [dict setObject:@"" forKey:@"Responses"];
                }
                
                [questionArrReq insertObject:dict atIndex:i];
                i=i+1;
            }
            [questionArr setValue:questionArrReq forKey:@"Questions"];
            [questionArr setValue:record.isInProgressId forKey:@"FormsInProgress"];
            [questionArr setValue:record.headerId forKey:@"Id"];
            [questionArr setValue:record.date forKey:@"Date"];
            
            
            [questionArr2 insertObject:questionArr atIndex:j];
            
            j=j+1;
            
        }
        
    }
    [dataDic setValue:questionArr2 forKey:@"FormHistory"];
      
    
    [self deleteAllFormsInProgress];
    
    [self insertFormHistoryInOffLine:dataDic];
    
    isWSComplete = YES;
    if (complition)
        complition();
    
    if (waitUntilDone) {
        while (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
    
}


- (void)callServiceForSurveyInOffline:(BOOL)waitUntilDone withSurveyId:(NSString*)surveyId withSurveyInstructions:(NSString*)SurveyInstructions withSurveyIsAllowInProgress:(NSString*)SurveyIsAllowInProgress withSurveyName:(NSString*)SurveyName complition:(void(^)(void))complition{
    
    __block BOOL isWSComplete = NO;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SubmitFormAndSurvey"];
    
    NSArray *aryOfflineData = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    isErrorOccurred = NO;
    __block BOOL isSingleDataSaved = NO;
    NSMutableDictionary * dataDic=[[NSMutableDictionary alloc]init];
    [dataDic setValue:surveyId forKey:@"SurveyId"];
    [dataDic setValue:SurveyInstructions forKey:@"SurveyInstructions"];
    [dataDic setValue:SurveyIsAllowInProgress forKey:@"SurveyIsAllowInProgress"];
    [dataDic setValue:SurveyName forKey:@"SurveyName"];
    
    NSString *strUserId = @"";
    if ([User checkUserExist]) {
        strUserId = [[User currentUser] userId];
    }
    [dataDic setValue:strUserId forKey:@"userId"];

    NSMutableArray *questionArr2 = [[NSMutableArray    alloc]init];
    int j = 0;
    for (SubmitFormAndSurvey *record in aryOfflineData) {
        [dataDic setValue:record.categoryId forKey:@"CategoryId"];

        isSingleDataSaved = NO;
        NSMutableDictionary *questionArr = [[NSMutableDictionary    alloc]init];
        
        NSMutableArray *questionArrReq = [[NSMutableArray    alloc]init];
        
        if ([record.isInProgressId isEqualToString:@"1"] && [record.typeId isEqualToString:surveyId] && [record.userId isEqualToString:strUserId])
            
        {
            
            int i = 0;
            for (QuestionDetails *obj in record.questionList.allObjects) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                if (obj.questionId!=nil) {
                    [dict setObject:obj.questionId forKey:@"Id"];
                }
                else{
                    [dict setObject:@"" forKey:@"Id"];
                }
                
                if (obj.questionText!=nil) {
                    [dict setObject:obj.questionText forKey:@"QuestionText"];
                }
                else{
                    [dict setObject:@"" forKey:@"QuestionText"];
                }
                if (obj.responseText!=nil) {
                    [dict setObject:obj.responseText forKey:@"ExistingResponse"];
                }
                else{
                    [dict setObject:@"" forKey:@"ExistingResponse"];
                }
                if (obj.questionId!=nil) {
                    [dict setObject:obj.questionId forKey:@"QuestionId"];
                }
                else{
                    [dict setObject:@"" forKey:@"QuestionId"];
                }
                if (obj.existingResponseBool!=nil) {
                    [dict setObject:obj.existingResponseBool forKey:@"ExistingResponseBool"];
                }
                else{
                    [dict setObject:@"" forKey:@"ExistingResponseBool"];
                }
                if (obj.responseId!=nil) {
                    [dict setObject:obj.responseId forKey:@"ResponseId"];
                }
                else{
                    [dict setObject:@"" forKey:@"ResponseId"];
                }
                if (obj.isMandatory!=nil) {
                    [dict setObject:obj.isMandatory forKey:@"IsMandatory"];
                }
                else{
                    [dict setObject:@"" forKey:@"IsMandatory"];
                }  if (obj.responseType!=nil) {
                    [dict setObject:obj.responseType forKey:@"ResponseType"];
                }
                else{
                    [dict setObject:@"" forKey:@"ResponseType"];
                }
                if (obj.sequence!=nil) {
                    [dict setObject:obj.sequence forKey:@"sequence"];
                }
                else{
                    [dict setObject:@"" forKey:@"sequence"];
                }

                
                
                if (![obj.responseList isKindOfClass:[NSNull class]]) {
                    NSMutableArray * tempArray=[NSMutableArray new];
                    int i=0;
                    for (OfflineResponseTypeValues*dictResponseType in obj.responseList) {
                        NSMutableDictionary * tempDic=[NSMutableDictionary new];

                        [tempDic setObject:dictResponseType.name forKey:@"name"];
                        [tempDic setObject:dictResponseType.value forKey:@"value"];
                        if (dictResponseType.sequence  != nil) {
                            [tempDic setObject:dictResponseType.sequence forKey:@"sequence"];

                        }
                        [tempArray insertObject:tempDic atIndex:i];
                        i=i+1;

                    }
                    [dict setObject:tempArray forKey:@"Responses"];

                }
                else{
                   [dict setObject:@"" forKey:@"Responses"];
                }
                
                if (obj.detailImageVideoText!=nil) {
                    [dict setObject:obj.detailImageVideoText forKey:@"detailImageVideoText"];
                }
                else{
                    [dict setObject:@"" forKey:@"detailImageVideoText"];
                }
                
                
                [questionArrReq insertObject:dict atIndex:i];
                i=i+1;
            }
            
            [questionArr setValue:questionArrReq forKey:@"Questions"];
            [questionArr setValue:record.isInProgressId forKey:@"IsInProgress"];
            [questionArr setValue:record.headerId forKey:@"Id"];
            [questionArr setValue:record.date forKey:@"Date"];
            
            
            [questionArr2 insertObject:questionArr atIndex:j];
            
            j=j+1;
            
        }
        
    }
    [dataDic setValue:questionArr2 forKey:@"SurveyHistory"];
    
    
    [self deleteAllSurveysInProgress];
    
    [self insertSurveyHistoryInOffLine:dataDic];
    
    isWSComplete = YES;
    if (complition)
        complition();
    
    if (waitUntilDone) {
        while (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
    
}
- (void)insertFormHistoryInOffLine:(NSDictionary*)Dict{
    
    NSMutableArray *arrSurveyHistory = [NSMutableArray new];
    [arrSurveyHistory addObjectsFromArray:[Dict valueForKey:@"FormHistory"]];
    for (NSDictionary *aDict in arrSurveyHistory) {
        
        FormsInProgress *form = [NSEntityDescription insertNewObjectForEntityForName:@"FormsInProgress" inManagedObjectContext:gblAppDelegate.managedObjectContext];
           form.userId=[Dict objectForKey:@"userId"];
        form.formId = [Dict objectForKey:@"formId"];
        if (![[Dict objectForKey:@"Instructions"] isKindOfClass:[NSNull class]]) {
            form.instructions = [Dict objectForKey:@"Instructions"];
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
        form.categoryId=[NSString stringWithFormat:@"%@",[Dict objectForKey:@"CategoryId"]];
        form.categorySequence=[[Dict objectForKey:@"categorySequence"]stringValue];
        
        if (![[Dict objectForKey:@"FormCategoryName"] isKindOfClass:[NSNull class]])
        {
            form.categoryName=[Dict objectForKey:@"FormCategoryName"];
        }
        form.date=[NSString stringWithFormat:@"%@", [aDict valueForKey:@"Date"]];
        form.inProgressFormId=[NSString stringWithFormat:@"%@", [aDict valueForKey:@"Id"]];
        
        form.isAllowInProgress =[NSString stringWithFormat:@"%@", [Dict valueForKey:@"SurveyIsAllowInProgress"]];
        
        NSMutableSet *aSetQuestions = [NSMutableSet set];
        if (![[aDict objectForKey:@"Questions"] isKindOfClass:[NSNull class]]) {
            for (NSDictionary *dictQuest in [aDict objectForKey:@"Questions"]) {
                SurveyQuestions *aQuestion = [NSEntityDescription insertNewObjectForEntityForName:@"SurveyQuestions" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                aQuestion.mandatory=[dictQuest objectForKey:@"IsMandatory"] ;
                aQuestion.questionId = [dictQuest objectForKey:@"QuestionId"];
                aQuestion.question = [dictQuest objectForKey:@"QuestionText"];
                aQuestion.responseType = [dictQuest objectForKey:@"ResponseType"];
                NSNumber * sequ=[NSNumber numberWithInt:[[dictQuest objectForKey:@"sequence"] intValue]];
                aQuestion.sequence = sequ;
                if (![[dictQuest objectForKey:@"ExistingResponse"] isKindOfClass:[NSNull class]])
                {
                    aQuestion.existingResponse = [dictQuest objectForKey:@"ExistingResponse"];
                }
                if (![[dictQuest objectForKey:@"ExistingResponseIds"] isKindOfClass:[NSNull class]])
                {
                    aQuestion.existingResponseIds = [dictQuest objectForKey:@"ExistingResponseIds"];
                }
                if (![[dictQuest objectForKey:@"detailImageVideoText"] isKindOfClass:[NSNull class]])
                {
                    aQuestion.detailImageVideoText = [dictQuest objectForKey:@"detailImageVideoText"];
                }
                aQuestion.existingResponseBool = [dictQuest objectForKey:@"ExistingResponseBool"];
                
                NSMutableSet *responseTypeSet = [NSMutableSet set];
                if (![[dictQuest objectForKey:@"Responses"] isKindOfClass:[NSNull class]]) {
                    for (NSDictionary*dictResponseType in [dictQuest objectForKey:@"Responses"]) {
                        SurveyResponseTypeValues *responseType = [NSEntityDescription insertNewObjectForEntityForName:@"SurveyResponseTypeValues" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                        responseType.value = [NSString stringWithFormat:@"%@",[dictResponseType objectForKey:@"value"]];
                        responseType.name = [NSString stringWithFormat:@"%@",[dictResponseType objectForKey:@"name"]];
                        responseType.sequence =[NSString stringWithFormat:@"%@",[dictResponseType objectForKey:@"sequence"]]  ;
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
- (void)insertSurveyHistoryInOffLine:(NSDictionary*)Dict {
    
    NSMutableArray *arrSurveyHistory = [NSMutableArray new];
    [arrSurveyHistory addObjectsFromArray:[Dict valueForKey:@"SurveyHistory"]];
    for (NSDictionary *aDict in arrSurveyHistory) {
        
        SurveyInProgress *survey = [NSEntityDescription insertNewObjectForEntityForName:@"SurveyInProgress" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        survey.userId=[Dict objectForKey:@"userId"];
        survey.surveyId = [Dict objectForKey:@"SurveyId"];
        if (![[Dict objectForKey:@"SurveyInstructions"] isKindOfClass:[NSNull class]]) {
            survey.instructions = [Dict objectForKey:@"SurveyInstructions"];
        }
        else {
            survey.instructions = @"";
        }
        if (![[Dict objectForKey:@"Link"] isKindOfClass:[NSNull class]]) {
            survey.link = [Dict objectForKey:@"Link"];
        }
        else {
            survey.link = @"";
        }
        survey.name = [Dict objectForKey:@"SurveyName"];
        survey.typeId = [[Dict objectForKey:@"SurveyTypeId"] stringValue];
        survey.userTypeId = [[Dict objectForKey:@"SurveyUserTypeId"] stringValue];
        survey.categoryId=[NSString stringWithFormat:@"%@",[Dict objectForKey:@"CategoryId"]];
        survey.categorySequence=[[Dict objectForKey:@"categorySequence"]stringValue];
        
        
        
        if (![[Dict objectForKey:@"SurveyCategoryName"] isKindOfClass:[NSNull class]])
        {
            survey.categoryName=[Dict objectForKey:@"SurveyCategoryName"];
        }
        survey.date=[NSString stringWithFormat:@"%@", [aDict valueForKey:@"Date"]];
        survey.inProgressFormId=[NSString stringWithFormat:@"%@", [aDict valueForKey:@"Id"]];
        
        survey.isAllowInProgress =[NSString stringWithFormat:@"%@", [Dict valueForKey:@"SurveyIsAllowInProgress"]];
        
        NSMutableSet *aSetQuestions = [NSMutableSet set];
        if (![[aDict objectForKey:@"Questions"] isKindOfClass:[NSNull class]]) {
            for (NSDictionary *dictQuest in [aDict objectForKey:@"Questions"]) {
                SurveyQuestions *aQuestion = [NSEntityDescription insertNewObjectForEntityForName:@"SurveyQuestions" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                aQuestion.mandatory=[dictQuest objectForKey:@"IsMandatory"] ;
                aQuestion.questionId = [dictQuest objectForKey:@"QuestionId"];
                aQuestion.question = [dictQuest objectForKey:@"QuestionText"];
                aQuestion.responseType = [dictQuest objectForKey:@"ResponseType"];
                NSNumber * sequ=[NSNumber numberWithInt:[[dictQuest objectForKey:@"sequence"] intValue]];
                aQuestion.sequence = sequ;
                if (![[dictQuest objectForKey:@"ExistingResponse"] isKindOfClass:[NSNull class]])
                {
                    aQuestion.existingResponse = [dictQuest objectForKey:@"ExistingResponse"];
                }
                if (![[dictQuest objectForKey:@"ExistingResponseIds"] isKindOfClass:[NSNull class]])
                {
                    aQuestion.existingResponseIds = [dictQuest objectForKey:@"ExistingResponseIds"];
                }
                if (![[dictQuest objectForKey:@"detailImageVideoText"] isKindOfClass:[NSNull class]])
                {
                    aQuestion.detailImageVideoText = [dictQuest objectForKey:@"detailImageVideoText"];
                }
                aQuestion.existingResponseBool = [dictQuest objectForKey:@"ExistingResponseBool"];
                
                NSMutableSet *responseTypeSet = [NSMutableSet set];
             
                    if (![[dictQuest objectForKey:@"Responses"] isKindOfClass:[NSNull class]]) {
                        for (NSDictionary*dictResponseType in [dictQuest objectForKey:@"Responses"]) {
                            SurveyResponseTypeValues *responseType = [NSEntityDescription insertNewObjectForEntityForName:@"SurveyResponseTypeValues" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                            responseType.value = [NSString stringWithFormat:@"%@",[dictResponseType objectForKey:@"value"]];
                            responseType.name = [NSString stringWithFormat:@"%@",[dictResponseType objectForKey:@"name"]];
                            responseType.sequence =[NSString stringWithFormat:@"%@",[dictResponseType objectForKey:@"sequence"]]  ;
                            responseType.question = aQuestion;
                            [responseTypeSet addObject:responseType];
                        }
                    }

                aQuestion.responseList = responseTypeSet;
                aQuestion.surveyInProgressList = survey;
                [aSetQuestions addObject:aQuestion];
            }
        }
        survey.questionList = aSetQuestions;
        [gblAppDelegate.managedObjectContext insertObject:survey];
        [gblAppDelegate.managedObjectContext save:nil];
    }
    
}
-(void)callServiceForSurvey:(BOOL)waitUntilDone withSurveyId:(NSString *)surveyId complition:(void (^)(void))complition
{
    __block BOOL isWSComplete = NO;
    NSString *aStrClientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
    NSString *strUserId = @"";
    if ([User checkUserExist]) {
        strUserId = [[User currentUser] userId];
    }
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?ClientId=%@&UserId=%@&surveyId=%@", SURVEY_SETUP, aStrClientId, strUserId,surveyId] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:SURVEY_SETUP] complition:^(NSDictionary *response) {
        [self deleteAllSurveysInProgress];
        [self insertSurveyHistory:response];

        NSLog(@"%@",response);
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
- (void)insertSurveyHistory:(NSDictionary*)Dict {
    
    NSMutableArray *arrSurveyHistory = [NSMutableArray new];
    [arrSurveyHistory addObjectsFromArray:[Dict valueForKey:@"SurveyHistory"]];
    for (NSDictionary *aDict in arrSurveyHistory) {
        
        SurveyInProgress *survey = [NSEntityDescription insertNewObjectForEntityForName:@"SurveyInProgress" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        survey.surveyId = [[Dict objectForKey:@"SurveyId"] stringValue];
        if (![[Dict objectForKey:@"SurveyInstructions"] isKindOfClass:[NSNull class]]) {
            survey.instructions = [Dict objectForKey:@"SurveyInstructions"];
        }
        else {
            survey.instructions = @"";
        }
        if (![[Dict objectForKey:@"Link"] isKindOfClass:[NSNull class]]) {
            survey.link = [Dict objectForKey:@"Link"];
        }
        else {
            survey.link = @"";
        }
        survey.name = [Dict objectForKey:@"SurveyName"];
        survey.typeId = [[Dict objectForKey:@"SurveyTypeId"] stringValue];
        survey.userTypeId = [[Dict objectForKey:@"SurveyUserTypeId"] stringValue];
        survey.categoryId=[[Dict objectForKey:@"SurveyCategoryId"]stringValue];
        survey.categorySequence=[[Dict objectForKey:@"categorySequence"]stringValue];

        if (![[Dict objectForKey:@"SurveyCategoryName"] isKindOfClass:[NSNull class]])
        {
            survey.categoryName=[Dict objectForKey:@"SurveyCategoryName"];
        }
        survey.date=[NSString stringWithFormat:@"%@", [aDict valueForKey:@"Date"]];
        survey.inProgressFormId=[NSString stringWithFormat:@"%@", [aDict valueForKey:@"Id"]];

        survey.isAllowInProgress =[NSString stringWithFormat:@"%@", [aDict valueForKey:@"IsInProgress"]];
        
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
                aQuestion.surveyInProgressList = survey;
                [aSetQuestions addObject:aQuestion];
            }
        }
        survey.questionList = aSetQuestions;
        [gblAppDelegate.managedObjectContext insertObject:survey];
        [gblAppDelegate.managedObjectContext save:nil];
    }
    
}


-(void)inserAllSopData:(NSDictionary *)aDictSop
{
    
    NSString *strDocumentPath = [NSString stringWithFormat:@"%@",gblAppDelegate.applicationDocumentsDirectory.path];
    NSString *strSopFilePath = [strDocumentPath stringByAppendingPathComponent:@"SopCategory.txt"];
    NSString *aStrJSON = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:aDictSop options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    [aStrJSON writeToFile:strSopFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark - Emergency Response Plan

- (void)callServiceForEmergencyResponsePlan:(BOOL)waitUntilDone complition:(void (^)(void))completion {
    __block BOOL isWSComplete = NO;
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@", ERP_CATEGORY, [[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:ERP_CATEGORY] complition:^(NSDictionary *response) {
        if ([response objectForKey:@"ErpCategories"] != [NSNull null]) {
            [self deleteAllERPData];
            [self inserAllERPData:[response objectForKey:@"ErpCategories"]];
        }
        if ([gblAppDelegate.managedObjectContext save:nil]) {
            isWSComplete = YES;
        }
        if (completion) {
            completion();
        }
        
    } failure:^(NSError *error, NSDictionary *response) {
        isWSComplete = YES;
        if (completion) {
            completion();
        }
    }];
    if (waitUntilDone) {
        while (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
}

- (void)deleteAllERPData {
    NSFetchRequest * allCategory = [[NSFetchRequest alloc] init];
    [allCategory setEntity:[NSEntityDescription entityForName:@"ERPCategory" inManagedObjectContext:gblAppDelegate.managedObjectContext]];
    [allCategory setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSError * error = nil;
    NSArray * categories = [gblAppDelegate.managedObjectContext executeFetchRequest:allCategory error:&error];
    //error handling goes here
    for (NSManagedObject * cate in categories) {
        [gblAppDelegate.managedObjectContext deleteObject:cate];
    }
    NSError *saveError = nil;
    [gblAppDelegate.managedObjectContext save:&saveError];
}

- (void)inserAllERPData:(NSArray *)aryResponse {
    for (NSDictionary *aDict in aryResponse) {
        ERPCategory *aCategory = [NSEntityDescription insertNewObjectForEntityForName:@"ERPCategory" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        aCategory.title = [aDict objectForKey:@"Title"];
        aCategory.categoryId = [NSString stringWithFormat:@"%ld", (long)[[aDict objectForKey:@"Id"] integerValue]];
        NSMutableSet *subcategories = [NSMutableSet set];
        for (NSDictionary *aDictSubCate in [aDict objectForKey:@"Subcategories"]) {
            ERPSubcategory *aSubCate = [NSEntityDescription insertNewObjectForEntityForName:@"ERPSubcategory" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            aSubCate.title = [aDictSubCate objectForKey:@"Title"];
            aSubCate.subCateId = [NSString stringWithFormat:@"%ld", (long)[[aDictSubCate objectForKey:@"Id"] integerValue]];
            NSMutableSet *taskList = [NSMutableSet set];
            for (NSDictionary *aTask in [aDictSubCate objectForKey:@"Tasks"]) {
                ERPTask *task = [NSEntityDescription insertNewObjectForEntityForName:@"ERPTask" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                task.taskID = [NSString stringWithFormat:@"%ld", (long)[[aTask objectForKey:@"Id"] integerValue]];
                task.task = [aTask objectForKey:@"Description"];
                if (![aTask objectForKey:@"AttachmentLink"] || [[aTask objectForKey:@"AttachmentLink"] isKindOfClass:[NSNull class]]) {
                    task.attachmentLink = @"";
                }
                else {
                    task.attachmentLink = [aTask objectForKey:@"AttachmentLink"];
                }
                
                task.erpTitle = aSubCate;
                [taskList addObject:task];
            }
            aSubCate.erpTasks = taskList;
            aSubCate.erpHeader = aCategory;
            [subcategories addObject:aSubCate];
        }
        aCategory.erpTitles = subcategories;
        [gblAppDelegate.managedObjectContext insertObject:aCategory];
    }
}
#pragma mark - UtilizationCount

- (BOOL)callServiceForUtilizationCount:(BOOL)waitUntilDone complition:(void (^)(void))completion {
    __block BOOL isWSComplete = NO;

                //PositionID Removed
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?facilityId=%@", UTILIZATION_COUNT, [[[User currentUser] selectedFacility] value]] parameters:nil httpMethod:@"GET" complition:^(NSDictionary *response) {
        [self deleteAllCountLocation];
        [self insertAllCountLocation:[response objectForKey:@"Locations"]];
        isWSComplete = YES;
        if (completion) {
            completion();
        }
    } failure:^(NSError *error, NSDictionary *response) {
        isWSComplete = YES;
        if (completion) {
            completion();
        }
    }];
    if (waitUntilDone) {
        while (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
    return isWSComplete;
}

- (void)deleteAllCountLocation {
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"UtilizationCount" inManagedObjectContext:gblAppDelegate.managedObjectContext]];
    [request setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSError * error = nil;
    NSArray * allRecords = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:&error];
    //error handling goes here
    for (NSManagedObject * rec in allRecords) {
        [gblAppDelegate.managedObjectContext deleteObject:rec];
    }
    NSError *saveError = nil;
    [gblAppDelegate.managedObjectContext save:&saveError];
}

- (void)insertAllCountLocation:(NSArray *)arrLocations {
    for (NSDictionary *aDict in arrLocations) {
        UtilizationCount *location = [NSEntityDescription insertNewObjectForEntityForName:@"UtilizationCount" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        location.locationId = [[aDict objectForKey:@"Id"] stringValue];
        location.name = [aDict objectForKey:@"Name"];
        location.sequence = [aDict objectForKey:@"Sequence"];
        if ([[aDict objectForKey:@"Message"] isKindOfClass:[NSNull class]])
            location.message = @"";
        else
            location.message = [aDict objectForKey:@"Message"];
        if ([[aDict objectForKey:@"LastCount"] isKindOfClass:[NSNull class]])
            location.lastCount = @"0";
        else
            location.lastCount = [[aDict objectForKey:@"LastCount"] stringValue];
        if ([[aDict objectForKey:@"LastCountDateTime"] isKindOfClass:[NSNull class]])
            location.lastCountDateTime = @"";
        else {
            NSString *aStrDate = [[[aDict objectForKey:@"LastCountDateTime"] componentsSeparatedByString:@"."] firstObject];
            location.lastCountDateTime = aStrDate;
        }
        
        location.capacity = [[aDict objectForKey:@"Capacity"] stringValue];
        NSMutableSet *set = [NSMutableSet set];
        if (![[aDict objectForKey:@"Sublocations"] isKindOfClass:[NSNull class]]) {
            for (NSDictionary *aDictSubLoc in [aDict objectForKey:@"Sublocations"]) {
                UtilizationCount *subLoc = [NSEntityDescription insertNewObjectForEntityForName:@"UtilizationCount" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                subLoc.name = [aDictSubLoc objectForKey:@"Name"];
                subLoc.sequence = [aDictSubLoc objectForKey:@"Sequence"];
                if ([[aDictSubLoc objectForKey:@"LastCount"] isKindOfClass:[NSNull class]])
                    subLoc.lastCount = @"0";
                else
                    subLoc.lastCount = [[aDictSubLoc objectForKey:@"LastCount"] stringValue];
                if ([[aDictSubLoc objectForKey:@"LastCountDateTime"] isKindOfClass:[NSNull class]])
                    subLoc.lastCountDateTime = @"";
                else {
                    NSString *aStrDate = [[[aDictSubLoc objectForKey:@"LastCountDateTime"] componentsSeparatedByString:@"."] firstObject];
                    subLoc.lastCountDateTime = aStrDate;
                }
                subLoc.locationId = [[aDictSubLoc objectForKey:@"Id"] stringValue];
                subLoc.location = location;
                [set addObject:subLoc];
            }
        }
        location.sublocations = [NSOrderedSet orderedSetWithArray:set.allObjects];
        [gblAppDelegate.managedObjectContext insertObject:location];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}

#pragma mark - Task

- (void)callServiceForTaskList:(BOOL)waitUntilDone complition:(void (^)(void))completion {
    __block BOOL isWSComplete = NO;

    NSString *strLocationIds = [[[[User currentUser] mutArrSelectedLocations] valueForKey:@"value"] componentsJoinedByString:@","];
    NSString *strPositionIds = [[[[User currentUser] mutArrSelectedPositions] valueForKey:@"value"] componentsJoinedByString:@","];
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?facilityId=%@&locationIds=%@&positionIds=%@&userId=%@", TASK, [[[User currentUser] selectedFacility] value], strLocationIds, strPositionIds, [[User currentUser] userId]] parameters:nil httpMethod:@"GET" complition:^(NSDictionary *response) {
        NSLog(@"%@", response);
        [self deleteAllTask];
        [self insertAllTask:[response objectForKey:@"Tasks"]];
        if (completion) {
            completion();
        }
        isWSComplete = YES;
    } failure:^(NSError *error, NSDictionary *response) {
        isWSComplete = YES;
        if (completion) {
            completion();
        }
    }];
    if (waitUntilDone) {
        while (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
}

- (void)deleteAllTask {
    NSFetchRequest * allTask = [[NSFetchRequest alloc] init];
    [allTask setEntity:[NSEntityDescription entityForName:@"TaskList" inManagedObjectContext:gblAppDelegate.managedObjectContext]];
    [allTask setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSError * error = nil;
    NSArray * tasks = [gblAppDelegate.managedObjectContext executeFetchRequest:allTask error:&error];
    //error handling goes here
    for (NSManagedObject * task in tasks) {
        [gblAppDelegate.managedObjectContext deleteObject:task];
    }
    NSError *saveError = nil;
    [gblAppDelegate.managedObjectContext save:&saveError];
}

- (void)insertAllTask:(NSArray*)aryTask {
    for (NSDictionary *aDict in aryTask) {
        TaskList *aList = [NSEntityDescription insertNewObjectForEntityForName:@"TaskList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        aList.isCompleted = [aDict objectForKey:@"Completed"];
        aList.desc = [aDict objectForKey:@"Description"];
        aList.name = [aDict objectForKey:@"Name"];
        aList.taskId = [[aDict objectForKey:@"Id"] stringValue];
        aList.sequence = [aDict objectForKey:@"Sequence"];
        aList.location = [aDict objectForKey:@"Location"];
        aList.taskType = [aDict objectForKey:@"TaskType"];

        
//#warning edited by Imaginovation
        aList.comment = [aDict objectForKey:@"Comment"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        
        NSDate *aDate = [formatter dateFromString:[[aDict[@"TaskDateTime"] componentsSeparatedByString:@"."] firstObject]];
        aList.taskDateTime = aDate;
        
        NSDate *aDateExpirationTime = [formatter dateFromString:[[aDict[@"ExpirationTime"] componentsSeparatedByString:@"."] firstObject]];
        aList.expirationTime = aDateExpirationTime;
       
        if ([[aDict objectForKey:@"Response"] isKindOfClass:[NSNull class]]) {
            aList.response = @"";
        }
        else {
            aList.response = [aDict objectForKey:@"Response"];
        }
        
        aList.responseType = [aDict objectForKey:@"ResponseType"];
        NSMutableSet *aSet = [NSMutableSet set];
        if (![[aDict objectForKey:@"ResponseTypeValues"] isKindOfClass:[NSNull class]] && [[aDict objectForKey:@"ResponseTypeValues"] count] > 0) {
            for (NSDictionary *dictType in [aDict objectForKey:@"ResponseTypeValues"]) {
                TaskResponseTypeValues *typeValues = [NSEntityDescription insertNewObjectForEntityForName:@"TaskResponseTypeValues" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                typeValues.value = [dictType objectForKey:@"Value"];
                typeValues.code = [dictType objectForKey:@"Code"];
                typeValues.typeId = [[dictType objectForKey:@"Id"] stringValue];
                typeValues.task = aList;
                [aSet addObject:typeValues];
            }
            aList.responseTypeValues = aSet;
        }
        aList.isCommentAreaSupervisor = [aDict objectForKey:@"IsCommentAreaSupervisor"];
        aList.isCommentBuildingSupervisor = [aDict objectForKey:@"IsCommentBuildingSupervisor"];
        aList.isCommentGoBoardGroup = [aDict objectForKey:@"IsCommentGoBoardGroup"];
        aList.isCommentTask = [aDict objectForKey:@"IsCommentTask"];
        aList.isCommentWorkOrder = [aDict objectForKey:@"IsCommentWorkOrder"];
        [gblAppDelegate.managedObjectContext insertObject:aList];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}

#pragma mark - IncidentReport

- (void)callServiceForIncidentReport:(BOOL)waitUntilDone complition:(void(^)(void))complition {
    __block BOOL isWSComplete = NO;
    NSLog(@"%@",[NSString stringWithFormat:@"%@/%@", INCIDENT_REPORT_SETUP, [[User currentUser] userId]]);
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@", INCIDENT_REPORT_SETUP, [[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:INCIDENT_REPORT_SETUP] complition:^(NSDictionary *response) {
        [self deleteAllIncidentReports];
        [self insertIncidentReportSettings:[response objectForKey:@"IncidentReportSetup"]];
        isWSComplete = YES;
        if (complition)
            complition();
    } failure:^(NSError *error, NSDictionary *response) {
        isWSComplete = YES;
        if (complition)
            complition();
    }];
    if (waitUntilDone) {
        while (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
}

- (void)deleteAllIncidentReports {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"IncidentReportInfo"];
    [request setIncludesPropertyValues:NO];
    NSArray *aryRecords = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    for (NSManagedObject *rec in aryRecords) {
        [gblAppDelegate.managedObjectContext deleteObject:rec];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}

- (void)insertIncidentReportSettings:(NSArray*)arrReports {
    for (NSDictionary *aDict in arrReports) {
        IncidentReportInfo *report = [NSEntityDescription insertNewObjectForEntityForName:@"IncidentReportInfo" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        report.reportType = [aDict objectForKey:@"ReportType"];
        if ([[aDict objectForKey:@"Instructions"] isKindOfClass:[NSNull class]]) {
            report.instructions = @"";
        }
        else {
            report.instructions = [aDict objectForKey:@"Instructions"];
        }
            
        
        report.descriptionLbl = [aDict objectForKey:@"Description"];
        report.notificationField1 = [aDict objectForKey:@"NotificationField1"];
        report.notificationField2 = [aDict objectForKey:@"NotificationField2"];
        report.notificationField3 = [aDict objectForKey:@"NotificationField3"];
        report.notificationField4 = [aDict objectForKey:@"NotificationField4"];
        report.notificationField1Color = [aDict objectForKey:@"NotificationField1Color"];
        report.notificationField2Color = [aDict objectForKey:@"NotificationField2Color"];
        report.notificationField3Color = [aDict objectForKey:@"NotificationField3Color"];
        report.notificationField4Color = [aDict objectForKey:@"NotificationField4Color"];
        report.personInvolved1 = [aDict objectForKey:@"PersonInvolved1"];
        report.personInvolved2 = [aDict objectForKey:@"PersonInvolved2"];
        report.personInvolved3 = [aDict objectForKey:@"PersonInvolved3"];
        
        report.affiliation1 = [aDict objectForKey:@"Affiliation1"];
        report.affiliation2 = [aDict objectForKey:@"Affiliation2"];
        report.affiliation3 = [aDict objectForKey:@"Affiliation3"];
        report.affiliation4 = [aDict objectForKey:@"Affiliation4"];
        report.affiliation5 = [aDict objectForKey:@"Affiliation5"];
        report.affiliation6 = [aDict objectForKey:@"Affiliation6"];
        report.showAffiliation = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowAffiliation"] boolValue]];
        report.showGender = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowGender"] boolValue]];
        report.showEmergencyPersonnel = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowEmergencyPersonnel"] boolValue]];
        report.showMemberIdAndDriverLicense = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowMemberId"] boolValue]];
        report.showManagementFollowup = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowManagementFollowup"] boolValue]];
        report.showDateOfBirth = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowDateOfBirth"] boolValue]];
        report.showPhotoIcon = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowPhotoIcon"] boolValue]];
        report.showMinor = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowMinor"] boolValue]];
        report.showConditions = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowConditions"] boolValue]];
        report.showEmployeeId = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowEmployeeId"] boolValue]];
        report.showGuestId = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowGuestId"] boolValue]];
        report.showNotificationField1 = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowNotificationField1"] boolValue]];
        report.showNotificationField2 = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowNotificationField2"] boolValue]];
        report.showNotificationField3 = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowNotificationField3"] boolValue]];
        report.showNotificationField4 = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowNotificationField4"] boolValue]];
        
        report.notificationField1Alert = [NSNumber numberWithBool:[[aDict objectForKey:@"NotificationField1Alert"] boolValue]];
        report.notificationField2Alert = [NSNumber numberWithBool:[[aDict objectForKey:@"NotificationField2Alert"] boolValue]];
        report.notificationField3Alert = [NSNumber numberWithBool:[[aDict objectForKey:@"NotificationField3Alert"] boolValue]];
        report.notificationField4Alert = [NSNumber numberWithBool:[[aDict objectForKey:@"NotificationField4Alert"] boolValue]];
        
        // Add ActionTaker
        NSMutableSet *actionSet = [NSMutableSet set];
        for (NSDictionary *dict in [aDict objectForKey:@"ActionTakenList"]) {
            ActionTakenList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"ActionTakenList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            obj.actionId = [[dict objectForKey:@"Id"] stringValue];
            obj.name = [dict objectForKey:@"Name"];
            obj.emergencyPersonnel = [[dict objectForKey:@"EmergencyPersonnel"] stringValue];
            obj.sequence=[[dict objectForKey:@"Sequence"] stringValue];
            obj.incidentType = report;
            [actionSet addObject:obj];
        }
        report.actionList = actionSet;
        
        NSMutableSet *activitySet = [NSMutableSet set];
        for (NSDictionary *dict in [aDict objectForKey:@"ActivityList"]) {
            ActivityList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"ActivityList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            obj.activityId = [[dict objectForKey:@"Id"] stringValue];
            obj.name = [dict objectForKey:@"Name"];
            obj.incidentType = report;
            obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
            [activitySet addObject:obj];
        }
        report.activityList = activitySet;
        
        NSMutableSet *conditionSet = [NSMutableSet set];
        for (NSDictionary *dict in [aDict objectForKey:@"ConditionList"]) {
            ConditionList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"ConditionList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            obj.conditionId = [[dict objectForKey:@"Id"] stringValue];
            obj.name = [dict objectForKey:@"Name"];
            obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
            obj.incidentType = report;
            [conditionSet addObject:obj];
        }
        report.conditionList = conditionSet;
        
        NSMutableSet *equipmentSet = [NSMutableSet set];
        for (NSDictionary *dict in [aDict objectForKey:@"EquipmentList"]) {
            EquipmentList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"EquipmentList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            obj.equipmentId = [[dict objectForKey:@"Id"] stringValue];
            obj.name = [dict objectForKey:@"Name"];
            obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
            obj.incidentType = report;
            [equipmentSet addObject:obj];
        }
        report.equipmentList = equipmentSet;
        
        NSMutableSet *natureSet = [NSMutableSet set];
        for (NSDictionary *dict in [aDict objectForKey:@"NatureList"]) {
            NatureList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"NatureList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            obj.natureId = [[dict objectForKey:@"Id"] stringValue];
            obj.name = [dict objectForKey:@"Name"];
            obj.sequence=[[dict objectForKey:@"Sequence"] stringValue];
            obj.incidentType = report;
            [natureSet addObject:obj];
        } 
        report.natureList = natureSet;
        
        NSMutableSet *requiredSet = [NSMutableSet set];
        for (NSString *aStr in [aDict objectForKey:@"PersonInvolvedRequiredFields"]) {
            RequiredField *obj = [NSEntityDescription insertNewObjectForEntityForName:@"RequiredField" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            obj.type = REQUIRED_TYPE_PERSON;
            obj.name = aStr;
            obj.incidentType = report;
            [requiredSet addObject:obj];
        }
        for (NSString *aStr in [aDict objectForKey:@"EmergencyResponseRequiredFields"]) {
            RequiredField *obj = [NSEntityDescription insertNewObjectForEntityForName:@"RequiredField" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            obj.type = REQUIRED_TYPE_EMERGENCY;
            obj.name = aStr;
            obj.incidentType = report;
            [requiredSet addObject:obj];
        }
        for (NSString *aStr in [aDict objectForKey:@"WitnessRequiredFields"]) {
            RequiredField *obj = [NSEntityDescription insertNewObjectForEntityForName:@"RequiredField" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            obj.type = REQUIRED_TYPE_WITNESS;
            obj.name = aStr;
            obj.incidentType = report;
            [requiredSet addObject:obj];
        }
        for (NSString *aStr in [aDict objectForKey:@"EmployeeRequiredFields"]) {
            RequiredField *obj = [NSEntityDescription insertNewObjectForEntityForName:@"RequiredField" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            obj.type = REQUIRED_TYPE_EMPLOYEE;
            obj.name = aStr;
            obj.incidentType = report;
            [requiredSet addObject:obj];
        }
        report.requiredFields = requiredSet;
        
        [gblAppDelegate.managedObjectContext insertObject:report];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}


#pragma mark - AccidentReport

- (void)callServiceForAccidentReport:(BOOL)waitUntilDone complition:(void(^)(void))complition {
    __block BOOL isWSComplete = NO;
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@", ACCIDENT_REPORT_SETUP, [[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:ACCIDENT_REPORT_SETUP] complition:^(NSDictionary *response) {
        [self deleteAllAccidentReports];
        [self insertAccidentReportSettings:[response objectForKey:@"AccidentReportSetup"]];
        isWSComplete = YES;
        if (complition)
            complition();
    } failure:^(NSError *error, NSDictionary *response) {
        isWSComplete = YES;
        if (complition)
            complition();
    }];
    if (waitUntilDone) {
        while (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
}

- (void)deleteAllAccidentReports {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AccidentReportInfo"];
    [request setIncludesPropertyValues:NO];
    NSArray *aryRecords = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    for (NSManagedObject *rec in aryRecords) {
        [gblAppDelegate.managedObjectContext deleteObject:rec];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}



- (void)insertAccidentReportSettings:(NSMutableDictionary*)aDict {
    AccidentReportInfo *report = [NSEntityDescription insertNewObjectForEntityForName:@"AccidentReportInfo" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    if ([[aDict objectForKey:@"Instructions"] isKindOfClass:[NSNull class]]) {
        report.instructions = @"";
    }
    else {
        report.instructions = [aDict objectForKey:@"Instructions"];
    }
    report.notificationField1 = [aDict objectForKey:@"NotificationField1"];
    report.notificationField2 = [aDict objectForKey:@"NotificationField2"];
    report.notificationField3 = [aDict objectForKey:@"NotificationField3"];
    report.notificationField4 = [aDict objectForKey:@"NotificationField4"];
    report.notificationField1Color = [aDict objectForKey:@"NotificationField1Color"];
    report.notificationField2Color = [aDict objectForKey:@"NotificationField2Color"];
    report.notificationField3Color = [aDict objectForKey:@"NotificationField3Color"];
    report.notificationField4Color = [aDict objectForKey:@"NotificationField4Color"];
    report.personInvolved1 = [aDict objectForKey:@"PersonInvolved1"];
    report.personInvolved2 = [aDict objectForKey:@"PersonInvolved2"];
    report.personInvolved3 = [aDict objectForKey:@"PersonInvolved3"];
    
    report.affiliation1 = [aDict objectForKey:@"Affiliation1"];
    report.affiliation2 = [aDict objectForKey:@"Affiliation2"];
    report.affiliation3 = [aDict objectForKey:@"Affiliation3"];
    report.affiliation4 = [aDict objectForKey:@"Affiliation4"];
    report.affiliation5 = [aDict objectForKey:@"Affiliation5"];
    report.affiliation6 = [aDict objectForKey:@"Affiliation6"];

    report.titleDescription = [aDict objectForKey:@"Description"];
    report.additionalInformationLabel = [aDict objectForKey:@"AdditionalInformationLabel"];
    report.staffMembersWrittenAccountLabel = [aDict objectForKey:@"StaffMembersWrittenAccountLabel"];
    report.showAdditionalInformation = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowAdditionalInformation"] boolValue]];
    report.showStaffMembersWrittenAccount = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowStaffMembersWrittenAccount"] boolValue]];
    
    report.refusedCareStatement = [aDict objectForKey:@"RefusedCareStatement"];
    report.selfCareStatement = [aDict objectForKey:@"SelfCareStatement"];
    report.showAffiliation = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowAffiliation"] boolValue]];
    report.showGender = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowGender"] boolValue]];
    report.showEmergencyPersonnel = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowEmergencyPersonnel"] boolValue]];
    report.showMemberIdAndDriverLicense = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowMemberId"] boolValue]];
    report.showManagementFollowup = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowManagementFollowup"] boolValue]];
    report.showDateOfBirth = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowDateOfBirth"] boolValue]];
    report.showPhotoIcon = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowPhotoIcon"] boolValue]];
    report.showMinor = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowMinor"] boolValue]];
    report.showNotificationField1 =  [NSNumber numberWithBool:[[aDict objectForKey:@"ShowNotificationField1"] boolValue]];
    report.showNotificationField2 =  [NSNumber numberWithBool:[[aDict objectForKey:@"ShowNotificationField2"] boolValue]];
    report.showNotificationField3 =  [NSNumber numberWithBool:[[aDict objectForKey:@"ShowNotificationField3"] boolValue]];
    report.showNotificationField4 =  [NSNumber numberWithBool:[[aDict objectForKey:@"ShowNotificationField4"] boolValue]];
    
    report.notificationField1Alert = [NSNumber numberWithBool:[[aDict objectForKey:@"NotificationField1Alert"] boolValue]];
    report.notificationField2Alert = [NSNumber numberWithBool:[[aDict objectForKey:@"NotificationField2Alert"] boolValue]];
    report.notificationField3Alert = [NSNumber numberWithBool:[[aDict objectForKey:@"NotificationField3Alert"] boolValue]];
    report.notificationField4Alert = [NSNumber numberWithBool:[[aDict objectForKey:@"NotificationField4Alert"] boolValue]];
    
    report.showConditions = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowConditions"] boolValue]];
    report.showEmployeeId = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowEmployeeId"] boolValue]];
    report.showBloodbornePathogens = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowBloodbornePathogens"] boolValue]];
    report.showCommunicationAndNotification = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowCommunicationAndNotification"] boolValue]];
    report.showParticipantSignature = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowParticipantSignature"] boolValue]];
    report.showRefusedSelfCareText = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowRefusedCareText"] boolValue]];
    report.showSelfCareText = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowSelfCareText"] boolValue]];
    report.showGuestId = [NSNumber numberWithBool:[[aDict objectForKey:@"ShowGuestId"] boolValue]];
    // Add ActionTaker
    NSMutableSet *actionSet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"ActionTakenList"]) {
        ActionTakenList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"ActionTakenList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.actionId = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [actionSet addObject:obj];
    }
    report.actionList = actionSet;
    
    NSMutableSet *activitySet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"ActivityList"]) {
        ActivityList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"ActivityList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.activityId = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [activitySet addObject:obj];
    }
    report.activityList = activitySet;
    
    NSMutableSet *conditionSet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"ConditionList"]) {
        ConditionList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"ConditionList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.conditionId = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [conditionSet addObject:obj];
    }
    report.conditionList = conditionSet;
    
    NSMutableSet *equipmentSet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"EquipmentList"]) {
        EquipmentList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"EquipmentList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.equipmentId = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [equipmentSet addObject:obj];
    }
    report.equipmentList = equipmentSet;
    
    NSMutableSet *careSet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"CareProvidedList"]) {
        CareProvidedType *obj = [NSEntityDescription insertNewObjectForEntityForName:@"CareProvidedType" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.careProvidedID = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.refusedCare = [[dict objectForKey:@"RefusedCare"] stringValue];
        obj.selfCare = [[dict objectForKey:@"SelfCare"] stringValue];
        obj.firstAid = [[dict objectForKey:@"FirstAid"] stringValue];
        obj.emergencyPersonnel = [[dict objectForKey:@"EmergencyPersonnel"] stringValue];
        obj.emergencyResponse = [[dict objectForKey:@"EmergencyResponse"] stringValue];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [careSet addObject:obj];
    }
    report.careProviderList = careSet;
    
    
    NSMutableSet *generalInjurySet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"GeneralInjuryTypeList"]) {
        GeneralInjuryType *obj = [NSEntityDescription insertNewObjectForEntityForName:@"GeneralInjuryType" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.typeId = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [generalInjurySet addObject:obj];
    }
    report.generalInjuryType = generalInjurySet;
    
    NSMutableSet *bodyPartSet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"BodyPartInjuryTypeList"]) {
        BodyPartInjuryType *obj = [NSEntityDescription insertNewObjectForEntityForName:@"BodyPartInjuryType" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.typeId = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [bodyPartSet addObject:obj];
    }
    report.bodypartInjuryType = bodyPartSet;
    
    NSMutableSet *headInjurySet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"HeadInjuryLocationList"]) {
        HeadInjuryList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"HeadInjuryList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.value = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [headInjurySet addObject:obj];
    }
    report.headInjuryList = headInjurySet;
    
    NSMutableSet *abdomenInjurySet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"AbdomenInjuryLocationList"]) {
        AbdomenInjuryList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"AbdomenInjuryList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.value = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [abdomenInjurySet addObject:obj];
    }
    report.abdomenInjuryList = abdomenInjurySet;
    
    NSMutableSet *rightArmInjurySet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"RightArmInjuryLocationList"]) {
        ArmInjuryList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"RightArmInjuryList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.value = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [rightArmInjurySet addObject:obj];
    }
    report.rightArmInjuryList = rightArmInjurySet;
    
    
    NSMutableSet *leftArmInjurySet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"LeftArmInjuryLocationList"]) {
        LeftArmInjuryList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"LeftArmInjuryList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        
        obj.value = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [leftArmInjurySet addObject:obj];
    }
    report.leftArmInjuryList = leftArmInjurySet;
    
    NSMutableSet *rightLegInjurySet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"RightLegInjuryLocationList"]) {
        LegInjuryList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"RightLegInjuryList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.value = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [rightLegInjurySet addObject:obj];
    }
    report.rightLegInjuryList = rightLegInjurySet;
    
    NSMutableSet *leftLegInjurySet = [NSMutableSet set];
    for (NSDictionary *dict in [aDict objectForKey:@"LeftLegInjuryLocationList"]) {
        LeftLegInjuryList *obj = [NSEntityDescription insertNewObjectForEntityForName:@"LeftLegInjuryList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.value = [[dict objectForKey:@"Id"] stringValue];
        obj.name = [dict objectForKey:@"Name"];
        obj.sequence = [[dict objectForKey:@"Sequence"] stringValue];
        obj.accidentInfo = report;
        [leftLegInjurySet addObject:obj];
    }
    report.leftLegInjuryList = leftLegInjurySet;
    
    NSMutableSet *requiredSet = [NSMutableSet set];
    for (NSString *aStr in [aDict objectForKey:@"PersonInvolvedRequiredFields"]) {
        RequiredField *obj = [NSEntityDescription insertNewObjectForEntityForName:@"RequiredField" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.type = REQUIRED_TYPE_PERSON;
        obj.name = aStr;
        obj.accidentInfo = report;
        [requiredSet addObject:obj];
    }
    for (NSString *aStr in [aDict objectForKey:@"EmergencyResponseRequiredFields"]) {
        RequiredField *obj = [NSEntityDescription insertNewObjectForEntityForName:@"RequiredField" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.type = REQUIRED_TYPE_EMERGENCY;
        obj.name = aStr;
        obj.accidentInfo = report;
        [requiredSet addObject:obj];
    }
    for (NSString *aStr in [aDict objectForKey:@"FirstAidRequiredFields"]) {
        RequiredField *obj = [NSEntityDescription insertNewObjectForEntityForName:@"RequiredField" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.type = REQUIRED_TYPE_FIRST_AID;
        obj.name = aStr;
        obj.accidentInfo = report;
        [requiredSet addObject:obj];
    }
    for (NSString *aStr in [aDict objectForKey:@"WitnessRequiredFields"]) {
        RequiredField *obj = [NSEntityDescription insertNewObjectForEntityForName:@"RequiredField" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.type = REQUIRED_TYPE_WITNESS;
        obj.name = aStr;
        obj.accidentInfo = report;
        [requiredSet addObject:obj];
    }
    for (NSString *aStr in [aDict objectForKey:@"EmployeeRequiredFields"]) {
        RequiredField *obj = [NSEntityDescription insertNewObjectForEntityForName:@"RequiredField" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        obj.type = REQUIRED_TYPE_EMPLOYEE;
        obj.name = aStr;
        obj.accidentInfo = report;
        [requiredSet addObject:obj];
    }
    report.requiredFields = requiredSet;
    
    [gblAppDelegate.managedObjectContext insertObject:report];
    [gblAppDelegate.managedObjectContext save:nil];
}



#pragma mark - Survey

- (void)callServiceForSurvey:(BOOL)waitUntilDone complition:(void(^)(void))complition {
    __block BOOL isWSComplete = NO;
    if ([self isNetworkReachable]) {

    NSString *aStrClientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
    NSString *strUserId = @"";
    NSString *strFacilityId =[[NSUserDefaults standardUserDefaults] objectForKey:@"facilityId"];

    if ([User checkUserExist]) {
        strUserId = [[User currentUser] userId];
    }
        NSString * isAdmin;
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"IsAdmin"] integerValue] == 0) {
            isAdmin= @"False";
        }
        else{
            isAdmin= @"True";
        }
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?ClientId=%@&UserId=%@&facilityId=%@&isAdmin=%@", SURVEY_SETUP, aStrClientId, strUserId,strFacilityId,isAdmin] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:SURVEY_SETUP] complition:^(NSDictionary *response) {
        [self deleteAllSurveys];
        [self insertSurvey:[response objectForKey:@"Surveys"]];
        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"isSameClientSurvey"];
        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"isFirstTimeDataSurveyDone"];

        isWSComplete = YES;
        if (complition)
            complition();
    } failure:^(NSError *error, NSDictionary *response) {
        isWSComplete = YES;
        if (complition)
            complition();
        isWSComplete = YES;

    
        NSLog(@"%@", response);
    }];
    if (waitUntilDone) {
        while (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
}
    else {
        
            
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isSameClientSurvey"] isEqualToString:@"NO"]) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Problem in loading survey. Please try again" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self cancelLoading];
            }]];
            dispatch_async(dispatch_get_main_queue(), ^ {
                [ [[UIApplication sharedApplication] keyWindow]. rootViewController presentViewController:alertController animated:YES completion:nil];
            });
        }
        else{
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"To see updated data please check your internet connection." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
             
                isWSComplete = NO;
                if (complition)
                    complition();
            }]];
            dispatch_async(dispatch_get_main_queue(), ^ {
                [ [[UIApplication sharedApplication] keyWindow]. rootViewController presentViewController:alertController animated:YES completion:nil];
            });
            
        }
  
    }
    

}


- (void)deleteAllSurveys {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SurveyList"];
    [request setIncludesPropertyValues:NO];
    NSArray *aryRecords = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    for (NSManagedObject *rec in aryRecords) {
        [gblAppDelegate.managedObjectContext deleteObject:rec];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}
- (void)deleteAllFormsInProgress {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"FormsInProgress"];
    [request setIncludesPropertyValues:NO];
    NSArray *aryRecords = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    for (NSManagedObject *rec in aryRecords) {
        [gblAppDelegate.managedObjectContext deleteObject:rec];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}
- (void)deleteAllSurveysInProgress {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SurveyInProgress"];
    [request setIncludesPropertyValues:NO];
    NSArray *aryRecords = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    for (NSManagedObject *rec in aryRecords) {
        [gblAppDelegate.managedObjectContext deleteObject:rec];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}
- (void)insertSurvey:(NSArray*)array {
    for (NSDictionary *aDict in array) {
        SurveyList *survey = [NSEntityDescription insertNewObjectForEntityForName:@"SurveyList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        survey.surveyId = [[aDict objectForKey:@"Id"] stringValue];
        if (![[aDict objectForKey:@"Instructions"] isKindOfClass:[NSNull class]]) {
            survey.instructions = [aDict objectForKey:@"Instructions"];
        }
        else {
            survey.instructions = @"";
        }
        if (![[aDict objectForKey:@"Link"] isKindOfClass:[NSNull class]]) {
            survey.link = [aDict objectForKey:@"Link"];
        }
        else {
            survey.link = @"";
        }
        survey.name = [aDict objectForKey:@"Name"];
        survey.typeId = [[aDict objectForKey:@"SurveyTypeId"] stringValue];
        survey.userTypeId = [[aDict objectForKey:@"SurveyUserTypeId"] stringValue];
        survey.sequence=[aDict objectForKey:@"Sequence"];
        survey.categoryId=[[aDict objectForKey:@"CategoryId"]stringValue];
        survey.categoryName=[aDict objectForKey:@"CategoryName"];
        survey.categorySequence=[NSString stringWithFormat:@"%@",[aDict objectForKey:@"CategorySequence"]];
        survey.inProgressCount = [NSString stringWithFormat:@"%@",[aDict valueForKey:@"InProgressCount"]];
        survey.isAllowInProgress =[NSString stringWithFormat:@"%@", [aDict valueForKey:@"IsAllowInProgress"]];
        NSMutableSet *aSetQuestions = [NSMutableSet set];
        if (![[aDict objectForKey:@"Questions"] isKindOfClass:[NSNull class]]) {
            for (NSDictionary *dictQuest in [aDict objectForKey:@"Questions"]) {
                SurveyQuestions *aQuestion = [NSEntityDescription insertNewObjectForEntityForName:@"SurveyQuestions" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                

                 aQuestion.mandatory=[[dictQuest objectForKey:@"IsMandatory"] stringValue];
                aQuestion.questionId = [[dictQuest objectForKey:@"Id"] stringValue];
                aQuestion.question = [dictQuest objectForKey:@"Question"];
                aQuestion.responseType = [dictQuest objectForKey:@"ResponseType"];
                aQuestion.sequence = [dictQuest objectForKey:@"Sequence"];
                NSMutableSet *responseTypeSet = [NSMutableSet set];
                if (![[dictQuest objectForKey:@"Responses"] isKindOfClass:[NSNull class]]) {
                    for (NSDictionary*dictResponseType in [dictQuest objectForKey:@"Responses"]) {
                        SurveyResponseTypeValues *responseType = [NSEntityDescription insertNewObjectForEntityForName:@"SurveyResponseTypeValues" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                        responseType.value = [[dictResponseType objectForKey:@"Id"] stringValue];
                        responseType.name = [dictResponseType objectForKey:@"Name"];
                        responseType.sequence = [[dictResponseType objectForKey:@"Sequence"] stringValue];
                        responseType.question = aQuestion;
                        //responseType.mandatory=aQuestion;
                        [responseTypeSet addObject:responseType];
                    }
                }
                aQuestion.responseList = responseTypeSet;
                aQuestion.survey = survey;
                [aSetQuestions addObject:aQuestion];
            }
        }
        survey.questionList = aSetQuestions;
        [gblAppDelegate.managedObjectContext insertObject:survey];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}


#pragma mark Reachability

- (BOOL)isNetworkReachable {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];//[Reachability reachabilityWithHostName:@"http://www.google.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if (remoteHostStatus == NotReachable) {
        return NO;
    }
    return YES;
}

#pragma mark - Dashboard Count

-(void)callServiceForDashboardCount:(BOOL)waitUntilDone complition:(void(^)(NSDictionary * aDict))complition
{
    __block BOOL isWSComplete = NO;
    
        NSString *strLocationIds = [[[[User currentUser] mutArrSelectedLocations] valueForKey:@"value"] componentsJoinedByString:@","];
    
    NSMutableArray *arrOfPosition = [NSMutableArray new];
    
   // NSString *aStrFacilityID = [[User currentUser]selectedFacility].value;
    
   // NSString *aStrUserID = [[User currentUser]userId];
    
    NSMutableArray *arr=  [[User currentUser]mutArrSelectedPositions];
    
  //  NSString *aStrClientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
    
    NSString * isAdmin;
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"IsAdmin"] integerValue] == 0) {
        isAdmin= @"False";
    }
    else{
        isAdmin= @"True";
    }
    
    for (UserPosition *p in arr) {
        
        [arrOfPosition addObject:p.value];
    }
    NSString *aPositionId = [arrOfPosition componentsJoinedByString:@","];
    //  int clientId, int? userId, int facilityId,  string positionIds,bool isAdmin
    NSString *strUrl =[NSString stringWithFormat:@"%@?clientId=%@&userId=%@&facilityId=%@&positionIds=%@&locationIds=%@&isAdmin=%@",HOME_SCREEN_MODULES,[[User currentUser] clientId],[[User currentUser]userId],[[User currentUser]selectedFacility].value,aPositionId,strLocationIds,isAdmin];



    [gblAppDelegate callWebService:strUrl parameters:nil httpMethod:@"GET" complition:^(NSDictionary *response) {

        NSLog(@"%@",response);
        [[NSUserDefaults standardUserDefaults]setInteger:[[[response valueForKey:@"DashboardCount"] valueForKey:@"FormInprogressCount"]integerValue] forKey:@"FormToalCount"];
        [[NSUserDefaults standardUserDefaults]setInteger:[[[response valueForKey:@"DashboardCount"] valueForKey:@"SurveyInprogressCount"]integerValue] forKey:@"SurveyToalCount"];
        [ [NSUserDefaults standardUserDefaults]setInteger:[[[response valueForKey:@"DashboardCount"] valueForKey:@"TeamLogCount"]integerValue] forKey:@"TeamLogCount"];
        [[NSUserDefaults standardUserDefaults]setInteger:[[[response valueForKey:@"DashboardCount"] valueForKey:@"TaskCount"]integerValue] forKey:@"TaskToalCount"];
        [[NSUserDefaults standardUserDefaults]setInteger:[[[response valueForKey:@"DashboardCount"] valueForKey:@"MemoCount"]integerValue] forKey:@"MemoToalCount"];

        isWSComplete = YES;
        if (complition)
            complition(response);
    } failure:^(NSError *error, NSDictionary *response) {
        isWSComplete = YES;
        if (complition)
            complition(response);
        
    }];
    if (waitUntilDone) {
        while (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }


}
#pragma mark - Forms

- (void)callServiceForForms:(BOOL)waitUntilDone complition:(void(^)(void))complition {
    __block BOOL isWSComplete = NO;

    if ([self isNetworkReachable]) {
        
        
        NSString *aStrClientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
        NSString *strUserId = @"";
        NSString *strFacilityId =[[NSUserDefaults standardUserDefaults] objectForKey:@"facilityId"];
        if ([User checkUserExist]) {
            strUserId = [[User currentUser] userId];
        }
        NSString * isAdmin;
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"IsAdmin"] integerValue] == 0) {
            isAdmin= @"False";
        }
        else{
             isAdmin= @"True";
        }
        [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?ClientId=%@&UserId=%@&facilityId=%@&isAdmin=%@", FORM_SETUP, aStrClientId, strUserId,strFacilityId,isAdmin] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:FORM_SETUP] complition:^(NSDictionary *response) {
            
            [self deleteAllForms];
            
            [self insertForms:[response objectForKey:@"Forms"]];
            [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"isSameClientForm"];
            [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"isFirstTimeDataFormDone"];

            isWSComplete = YES;
            if (complition)
                complition();
            
        } failure:^(NSError *error, NSDictionary *response) {
//            NSLog(@"%@",error);
//            NSLog(@"%@",response);
            isWSComplete = YES;
            if (complition)
                complition();
         
            
//            NSLog(@"%@", response);
        }];
        if (waitUntilDone) {
            while (!isWSComplete) {
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
            }
        }

        
        
    }
    else {
            
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isSameClientForm"] isEqualToString:@"NO"]) {

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Problem in loading forms. Please try again" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self cancelLoading];
            }]];
            dispatch_async(dispatch_get_main_queue(), ^ {
                [ [[UIApplication sharedApplication] keyWindow]. rootViewController presentViewController:alertController animated:YES completion:nil];
            });
        }
        else{
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"To see updated data please check your internet connection." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                isWSComplete = YES;
                if (complition)
                    complition();
                
            }]];
            dispatch_async(dispatch_get_main_queue(), ^ {
                [ [[UIApplication sharedApplication] keyWindow]. rootViewController presentViewController:alertController animated:YES completion:nil];
            });
            
        }

    }


  }

-(void)cancelLoading{

    [[NSNotificationCenter defaultCenter]postNotificationName:@"goBackToHome" object:nil];


}
- (void)deleteAllForms {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"FormsList"];
    [request setIncludesPropertyValues:NO];
    NSArray *aryRecords = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    for (NSManagedObject *rec in aryRecords) {
        [gblAppDelegate.managedObjectContext deleteObject:rec];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}

- (void)insertForms:(NSArray*)array {
    for (NSDictionary *aDict in array) {

            FormsList *form = [NSEntityDescription insertNewObjectForEntityForName:@"FormsList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            form.formId = [[aDict objectForKey:@"Id"] stringValue];
            if (![[aDict objectForKey:@"Instructions"] isKindOfClass:[NSNull class]]) {
                form.instructions = [aDict objectForKey:@"Instructions"];
            }
            else {
                form.instructions = @"";
            }
            if (![[aDict objectForKey:@"Link"] isKindOfClass:[NSNull class]]) {
                form.link = [aDict objectForKey:@"Link"];
            }
            else {
                form.link = @"";
            }
            form.name = [aDict objectForKey:@"Name"];
            form.typeId = [[aDict objectForKey:@"FormTypeId"] stringValue];
            form.userTypeId = [[aDict objectForKey:@"FormUserTypeId"] stringValue];
    //    NSLog(@"form.typeId = %@ form.userTypeId = %@",form.typeId,form.userTypeId);
            form.sequence=[aDict objectForKey:@"Sequence"] ;
            form.categoryId=[[aDict objectForKey:@"CategoryId"]stringValue];
            form.categoryName=[aDict objectForKey:@"CategoryName"];
        form.categorySequence=[NSString stringWithFormat:@"%@",[aDict objectForKey:@"CategorySequence"]];
            form.inProgressCount = [NSString stringWithFormat:@"%@",[aDict valueForKey:@"InProgressCount"]];
            form.isAllowInProgress =[NSString stringWithFormat:@"%@", [aDict valueForKey:@"IsAllowInProgress"]];
        
            
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
                    aQuestion.formList = form;
                    [aSetQuestions addObject:aQuestion];
                }
            }
            form.questionList = aSetQuestions;
            [gblAppDelegate.managedObjectContext insertObject:form];
        
        [gblAppDelegate.managedObjectContext save:nil];
        }
        
      
}



#pragma mark - MemoBoard

- (void)callServiceForMemos:(BOOL)waitUntilDone complition:(void (^)(void))completion {
    __block BOOL isWSComplete = NO;
    [gblAppDelegate callAsynchronousWebService:[NSString stringWithFormat:@"%@?userId=%@", MEMO, [[User currentUser] userId]] parameters:nil httpMethod:@"GET" complition:^(NSDictionary *response) {
        gblAppDelegate.mutArrMemoList = [response objectForKey:@"Memos"];
        isWSComplete = YES;
        if (completion)
            completion();
    } failure:^(NSError *error, NSDictionary *response) {
        isWSComplete = YES;
        if (completion)
            completion();
        
    }];
    if (waitUntilDone) {
        while (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
}


#pragma mark - Team Log

- (void)callServiceForTeamLog:(BOOL)waitUntilDone complition:(void(^)(void))complition {
    __block BOOL isWSComplete = NO;
    NSString *aStrFacilityID = [[User currentUser]selectedFacility].value;
    NSString *aStrUserID = [[User currentUser]userId];
    NSString *aStrURL;

        aStrURL = [NSString stringWithFormat:@"%@?userId=%@&facilityId=%@&positionIds=&isTeamLog=False",DAILY_LOG,aStrUserID,aStrFacilityID];
   
    [gblAppDelegate callAsynchronousWebService:aStrURL parameters:nil httpMethod:@"GET" complition:^(NSDictionary *response) {
        
               [self deleteAllTeamLogs];
        [self insertTeamLog:response[@"DailyLogs"]];

        [self updateLogCountInDashboard];
        isWSComplete = YES;
        if (complition)
            complition();
    } failure:^(NSError *error, NSDictionary *response) {
        isWSComplete = YES;
        if (complition)
            complition();
    }];

}

- (void)callServiceForTeamLogInBackground:(BOOL)waitUntilDone complition:(void(^)(NSDictionary * aDict))complition {
    __block BOOL isWSComplete = NO;
    
    NSMutableArray *arrOfPosition = [NSMutableArray new];
    
    NSString *aStrFacilityID = [[User currentUser]selectedFacility].value;
    
    NSString *aStrUserID = [[User currentUser]userId];
    
    NSMutableArray *arr=  [[User currentUser]mutArrSelectedPositions];
    
    for (UserPosition *p in arr) {
        
        [arrOfPosition addObject:p.value];
    }
    NSString *aPositionId = [arrOfPosition componentsJoinedByString:@","];
    
    NSString *strUrl =[NSString stringWithFormat:@"DailyLog/GetLogsCount?userId=%@&facilityId=%@&positionIds=%@",aStrUserID,aStrFacilityID,aPositionId];
    
    [gblAppDelegate callAsynchronousWebService:strUrl parameters:nil httpMethod:@"GET" complition:^(NSDictionary *response) {
        
        
        isWSComplete = YES;
        if (complition)
            complition(response);
    } failure:^(NSError *error, NSDictionary *response) {
        isWSComplete = YES;
        if (complition)
            complition(response);
    }];
    if (waitUntilDone) {
        while (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
}

-(NSString *)getPositionsID
{
    NSMutableString *aStrSelectedPositions = [NSMutableString stringWithString:@""];;
    for (UserPosition *aObj in [[User currentUser]mutArrSelectedPositions])
    {
        [aStrSelectedPositions appendFormat:@"%@,",aObj.value];
    }
    NSString *aStrID;
    if (aStrSelectedPositions.length>2) {
        aStrID = [aStrSelectedPositions substringWithRange:NSMakeRange(0, aStrSelectedPositions.length-1)];
        return aStrID;
    }
    else
        return @"";
    
}

- (void)deleteAllTeamLogs {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"TeamLog"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"(shouldSync != 1 OR (ANY teamSubLog.shouldSync != 1))"]];
    [request setIncludesPropertyValues:NO];
    NSArray *aryRecords = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    for (NSManagedObject *rec in aryRecords) {
        [gblAppDelegate.managedObjectContext deleteObject:rec];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}

-(void)updateLogCountInDashboard
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"TeamLogTrace"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"userId==[cd]%@",[[User currentUser]userId]]];
    NSArray *aArrLogs = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    if (aArrLogs.count>0)
    {
        TeamLogTrace *aTeamLogTraceObj = aArrLogs[0];
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"TeamLog"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"teamLogId > %@",aTeamLogTraceObj.teamLogId]];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"teamLogId" ascending:NO]];
        
        NSArray *aArrayTeamLogs  =[gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
        if (aArrayTeamLogs.count>0) {
            gblAppDelegate.teamLogCountAfterLogin = aArrayTeamLogs.count;
            
            TeamLog *aTeamLog = aArrayTeamLogs[0];
            aTeamLogTraceObj.userId= [[User currentUser]userId];
            aTeamLogTraceObj.byuserId = aTeamLog.userId;
            aTeamLogTraceObj.date = aTeamLog.date;
            aTeamLogTraceObj.teamLogId  = aTeamLog.teamLogId;
            [gblAppDelegate.managedObjectContext save:nil];

        }
        else
            gblAppDelegate.teamLogCountAfterLogin = 0;
        
    }
    else
    {
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"TeamLog"];
        
        request.fetchLimit = 1;
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"teamLogId" ascending:NO]];
        NSArray *aArrayTeamLogs  =[gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
        if (aArrayTeamLogs.count>0) {
            TeamLogTrace *aTeamLogTraceObj = (TeamLogTrace *)[NSEntityDescription
                                                              insertNewObjectForEntityForName:@"TeamLogTrace" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            
            TeamLog *aTeamLog = aArrayTeamLogs[0];
            aTeamLogTraceObj.userId= [[User currentUser]userId];
            aTeamLogTraceObj.byuserId = aTeamLog.userId;
            aTeamLogTraceObj.date = aTeamLog.date;
            aTeamLogTraceObj.teamLogId  = aTeamLog.teamLogId;
            
            [gblAppDelegate.managedObjectContext save:nil];
        }
    }
}


- (void)insertTeamLog:(NSArray*)array {
    for (NSDictionary *aDict in array) {
        
        [aDict dictionaryByReplacingNullsWithBlanks];
        
        TeamLog *aTeamLogObj = [NSEntityDescription insertNewObjectForEntityForName:@"TeamLog" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        aTeamLogObj.facilityId = [aDict[@"FacilityId"] stringValue];
        aTeamLogObj.positionId = [aDict[@"PositionId"] stringValue];
        
        
        aTeamLogObj.teamLogId =aDict[@"Id"];
        
        aTeamLogObj.userId = [aDict[@"UserId"] stringValue];
        aTeamLogObj.isTeamLog = [aDict[@"IsTeamLog"] stringValue];
        NSArray *aArrDailLog =aDict[@"DailyLogDetails"];
        
        NSMutableDictionary *aMutDictLogDetails =aArrDailLog[0];
        
        aMutDictLogDetails = [aMutDictLogDetails dictionaryByReplacingNullsWithBlanks];
        aTeamLogObj.desc = aMutDictLogDetails[@"Description"];
        aTeamLogObj.username = aMutDictLogDetails[@"UserName"];
        aTeamLogObj.headerId = [NSString stringWithFormat:@"%@",aMutDictLogDetails[@"Id"]];
        if (![aMutDictLogDetails[@"IncludeInEndOfDayReport"]boolValue]) {
            aTeamLogObj.includeInEndOfDayReport = @"false";
        }else{
            aTeamLogObj.includeInEndOfDayReport = @"true";
        }
        
        aTeamLogObj.date =[gblAppDelegate getLocalDate:aMutDictLogDetails[@"Date"]];
        aTeamLogObj.shouldSync = [NSNumber numberWithInt:0];
        NSArray *aArrDailLogDetails =aDict[@"DailyLogTeamDetails"];
        
        for (NSDictionary *aSubDict in aArrDailLogDetails) {
            
            NSMutableDictionary *aMutDictFiltered = [aSubDict dictionaryByReplacingNullsWithBlanks];
            
            TeamSubLog *aTeamSubLogObj = (TeamSubLog *)[NSEntityDescription insertNewObjectForEntityForName:@"TeamSubLog" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            
            aTeamSubLogObj.desc = aMutDictFiltered[@"Description"];
            
            aTeamSubLogObj.date =[gblAppDelegate getLocalDate:aSubDict[@"Date"]];
            aTeamSubLogObj.userId = [aMutDictFiltered[@"UserId"]stringValue];
            aTeamSubLogObj.username =aMutDictFiltered[@"UserName"];
            aTeamSubLogObj.shouldSync = [NSNumber numberWithInt:0];
            
            [aTeamLogObj addTeamSubLogObject:aTeamSubLogObj];
            
        }
    }
    
    [gblAppDelegate.managedObjectContext save:nil];
}
#pragma mark - Client Positions

- (void)callServiceForAllClienntPositions:(BOOL)waitUntilDone complition:(void(^)(void))complition {
    __block BOOL isWSComplete = NO;
    NSString *aStrClientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
    NSString *strUserId = @"";
    if ([User checkUserExist]) {
        strUserId = [[User currentUser] userId];
    }
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?ClientId=%@&UserId=%@&facilityId=0", CLIENT_POSITIONS, aStrClientId, strUserId] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:CLIENT_POSITIONS] complition:^(NSDictionary *response) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [gblAppDelegate hideActivityIndicator];
        gblAppDelegate.shouldHideActivityIndicator = YES;
              [self deleteAllPositions];
        [self insertPositions:[response objectForKey:@"FacilityPositions"]];
        isWSComplete = YES;
        if (complition)
            complition();
    } failure:^(NSError *error, NSDictionary *response) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [gblAppDelegate hideActivityIndicator];
        gblAppDelegate.shouldHideActivityIndicator = YES;
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


- (void)deleteAllPositions {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ClientPositions"];
    [request setIncludesPropertyValues:NO];
    NSArray *aryRecords = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    for (NSManagedObject *rec in aryRecords) {
        [gblAppDelegate.managedObjectContext deleteObject:rec];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}


- (void)insertPositions:(NSArray*)array {
    for (NSDictionary *aDict in array) {
        ClientPositions *aClientPosition = [NSEntityDescription insertNewObjectForEntityForName:@"ClientPositions" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        aClientPosition.name = aDict[@"Name"];
        aClientPosition.positionId = aDict[@"Id"];

    }
    [gblAppDelegate.managedObjectContext save:nil];
}


@end
