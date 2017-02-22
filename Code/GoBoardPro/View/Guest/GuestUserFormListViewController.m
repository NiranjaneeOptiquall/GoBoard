//
//  GuestUserFormListViewController.m
//  GoBoardPro
//
//  Created by Inversedime on 05/12/16.
//  Copyright © 2016 IndiaNIC. All rights reserved.
//

#import "GuestUserFormListViewController.h"
#import"WebViewController.h"
#import "DynamicFormsViewController.h"
#import "Reachability.h"
#import "GuestFormCell.h"
#import "FormsInProgressView.h"
#import "FormsInProgress.h"

@interface GuestUserFormListViewController ()

@end

@implementation GuestUserFormListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    NSString *aStrClientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
//    [self setUpInitials:aStrClientId];
    // Do any additional setup after loading the view.
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"fromInProgressSubmit"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"fromSuveyViewC"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"fromSugestionViewC"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"fromSugestionViewC"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"fromInProgress"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isFormHistory"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"guestUserBack"];

}
-(void)viewWillAppear:(BOOL)animated{
    NSString *aStrClientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];

    [self setUpInitials:aStrClientId];


}
-(void)viewDidLayoutSubviews{
    /*
     Funaction viewDidLayoutSubviews
     Purpose :reload table with piced up string from dropdown
     Parameter :
     Return : nsuserdefault
     */
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"guestUserBack"] isEqualToString:@"YES"]) {
        
        [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"guestUserBack"];
        [self viewWillAppear:NO];
        
    }

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowDynamicForm"]) {
        DynamicFormsViewController *aDynamicView = (DynamicFormsViewController*)segue.destinationViewController;
        aDynamicView.objFormOrSurvey = [mutArrFormList objectAtIndex:selectedIndex];
        if (_guestFormType == 1 || _guestFormType == 5) {
            aDynamicView.isSurvey = YES;
        }
        else {
            aDynamicView.isSurvey = NO;
            
        }
    }
    //   else if ([self shouldPerformSegueWithIdentifier:@"GoToLink" sender:sender]) {
    //            WebViewController *webVC = (WebViewController*)segue.destinationViewController;
    //           webVC.strRequestURL = [sender valueForKey:@"link"];
    //           webVC.strInstruction = [sender valueForKey:@"instructions"];
    //           webVC.guestFormType = self.guestFormType;
    //        }
    //
    //    }
    
}


#pragma mark - Methods

- (void)setUpInitials:(NSString*)aStrClientId {
    if (_guestFormType == 1) {
        // Configure for Take a Survey screen
        [_imvIcon setImage:[UIImage imageNamed:@"take_a_survey.png"]];
        [_lblFormTitle setText:@"Guest Survey"];
        [self callService];
    }
    else if (_guestFormType == 2) {
        // Configure for Complete Form screen
        [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"fromInProgress"];

        [_imvIcon setImage:[UIImage imageNamed:@"complete_a_form.png"]];
        [_lblFormTitle setText:@"Guest Forms"];
        [[WebSerivceCall webServiceObject] callServiceForForms:NO complition:^{
            [self fetchFormList];
            [_tblFormList reloadData];
        }];
    }
    else if (_guestFormType == 3) {
        // Configure for Make a Suggestion screen
        [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"fromSugestionViewC"];
        [_imvIcon setImage:[UIImage imageNamed:@"make_a_suggestion.png"]];
        [_lblFormTitle setText:@"Guest Suggestion"];
        [[WebSerivceCall webServiceObject] callServiceForForms:NO complition:^{
            [self fetchFormList];
            [_tblFormList reloadData];
        }];
    }
    else if (_guestFormType == 4) {
        // Configure for User Forms
        [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"fromInProgress"];
        [_imvIcon setImage:[UIImage imageNamed:@"complete_a_form.png"]];
        [_lblFormTitle setText:@"User Form List"];
        [[WebSerivceCall webServiceObject] callServiceForForms:NO complition:^{
            [self fetchFormList];
            [_tblFormList reloadData];
        }];
    }
    else if (_guestFormType == 5) {
        // Configure for User Survey
        [_imvIcon setImage:[UIImage imageNamed:@"complete_a_form.png"]];
        [_lblFormTitle setText:@"User Surveys"];
        [self callService];
    }
}

- (void)callService {
    [[WebSerivceCall webServiceObject] callServiceForSurvey:NO complition:^{
        [self fetchSurveyList];
        [_tblFormList reloadData];
    }];
}

- (void)fetchSurveyList {
    //surveyUserTypeId are 1 = Guest 2 = User
    NSString *strSurveyUserType = @"1";
    if ([User checkUserExist]) {
        strSurveyUserType = @"2";
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SurveyList"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K ==[cd] %@", @"userTypeId", strSurveyUserType];
    [request setPredicate:predicate];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
    NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"surveyId" ascending:YES];
    [request setSortDescriptors:@[sort,sort1]];
    mutArrFormList = [NSMutableArray arrayWithArray:[gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil]];
    if ([mutArrFormList count] == 0) {
        [_lblNoRecord setHidden:NO];
        [_lblNoRecord setText:@"No survey available."];
    }
}

- (void)fetchFormList {
    //surveyUserTypeId are : 1 = Guest , 2 = User
    NSString *strFormUserType = @"1";
    if ([User checkUserExist]) {
        strFormUserType = @"2";
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"FormsList"];
    NSPredicate *predicate;

    if (_guestFormType == 3) {
        predicate = [NSPredicate predicateWithFormat:@"userTypeId ==[cd] %@ AND typeId ==[cd] %@", strFormUserType, [NSString stringWithFormat:@"%ld", (long)_guestFormType]];
    }
    else {
        predicate = [NSPredicate predicateWithFormat:@"userTypeId ==[CD] %@ AND NOT (typeId ==[cd] %@)",strFormUserType,[NSString stringWithFormat:@"%d", 3]];
        
    }
    [request setPredicate:predicate];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
    NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"formId" ascending:YES];
    [request setSortDescriptors:@[sort,sort1]];
    mutArrFormList = [NSMutableArray arrayWithArray:[gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil]];
    if ([mutArrFormList count] == 0) {
        [_lblNoRecord setHidden:NO];
        [_lblNoRecord setText:@"No form available."];
    }
    
    
}

#pragma mark - IBActions


- (IBAction)btnBackTapped:(id)sender {
    [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"backFromGuestUserListView"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnLinkTapped:(UIButton*)btn {
    UITableViewCell *aCell = (UITableViewCell*)[btn superview];
    while (![aCell isKindOfClass:[UITableViewCell class]]) {
        aCell = (UITableViewCell*)[aCell superview];
    }
    selectedIndex = [[_tblFormList indexPathForCell:aCell] row];
    [self performSegueWithIdentifier:@"SurveyLinkDetail" sender:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mutArrFormList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GuestFormCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 0 || indexPath.row % 2 == 0) {
        [aCell setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    }
    else {
        [aCell setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
    }
    
    
    NSManagedObject *obj = [mutArrFormList objectAtIndex:indexPath.row];
    UILabel *aLbl = (UILabel *)[aCell.contentView viewWithTag:2];
    [aLbl setText:[obj valueForKey:@"Name"]];
  
    
    UIView *aView = [aCell.contentView viewWithTag:4];
    CGRect frame = aView.frame;
    frame.origin.y = aCell.frame.size.height - 3;
    frame.size.height = 3;
    [aView setFrame:frame];
    
    
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isSurvey"] isEqualToString:@"YES"]) {
            [aCell.btnGuestFormInProgressTitle setTitle:@"Survey in progress" forState:UIControlStateNormal];
        }
        else if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"fromSugestionViewC"] isEqualToString:@"YES"]){
            
            [aCell.btnGuestFormInProgressTitle setTitle:@"Suggestion in progress" forState:UIControlStateNormal];

        }
        else{
            [aCell.btnGuestFormInProgressTitle setTitle:@"Form in progress" forState:UIControlStateNormal];
    
        }
     aCell.btnGuestUserFormCount.tag = indexPath.row;
        [aCell.btnGuestUserFormCount addTarget:self action:@selector(formsInProgressList:) forControlEvents:UIControlEventTouchUpInside];
    
    aCell.lblGuestUserShowCount.layer.cornerRadius = aCell.lblGuestUserShowCount.frame.size.height/2;
    aCell.lblGuestUserShowCount.layer.masksToBounds = YES;

        if ([[[mutArrFormList valueForKey:@"inProgressCount"]objectAtIndex:indexPath.row]integerValue]>0) {
    
            aCell.lblGuestUserShowCount.hidden = NO;
            aCell.btnGuestUserFormCount.hidden = NO;
            aCell.btnGuestFormInProgressTitle.hidden = NO;
         
            [aCell.lblGuestUserShowCount setText:[NSString stringWithFormat:@"%@",[[mutArrFormList valueForKey:@"inProgressCount"]objectAtIndex:indexPath.row]]];
            aCell.lblFormsCount.textColor=[UIColor whiteColor];
        }
        else{
            aCell.lblGuestUserShowCount.hidden = YES;
            aCell.btnGuestUserFormCount.hidden = YES;
            aCell.btnGuestFormInProgressTitle.hidden = YES;
    
        }
    
        NSLog(@"%ld",(long)aCell.btnFormInProgress.tag);
    
    return aCell;
}
- (BOOL)isNetworkReachable {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];//[Reachability reachabilityWithHostName:@"http://www.google.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if (remoteHostStatus == NotReachable) {
        return NO;
    }
    return YES;
}

//********** forms/survey  in progress button clicke action (online)**********//

-(void)formsInProgressList:(UIButton*)button{
    
    if ([self isNetworkReachable]) {
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld",(long)button.tag] forKey:@"indexForFormSelected"];
          NSLog(@"%ld",[[[NSUserDefaults standardUserDefaults] valueForKey:@"indexForFormSelected"] integerValue]);
        [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"fromInProgressSubmit"];
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isSurvey"] isEqualToString:@"YES"]) {
            
            FormsInProgressView *formView = [[[NSBundle mainBundle] loadNibNamed:@"FormsInProgressView" owner:self options:nil] objectAtIndex:0];
            NSString *surveyId = [[mutArrFormList valueForKey:@"surveyId"]objectAtIndex:button.tag];
            [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"fromSuveyViewC"];
            [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"fromInProgress"];
            [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"fromSugestionViewC"];
            
            [[WebSerivceCall webServiceObject]callServiceForSurvey:YES withSurveyId:surveyId complition:^{
                [self.view addSubview:formView];
            }];
        }
        
        else{
            [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"fromSuveyViewC"];
            [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"fromInProgress"];
            [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"fromSugestionViewC"];
            [self callServiceForForms:YES buttonIndex:button.tag complition:nil];
            
        }
    
    }
    else {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:MSG_NO_INTERNET delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
 
}
- (void)callServiceForForms:(BOOL)waitUntilDone buttonIndex:(NSInteger)button complition:(void(^)(void))complition {
    
    
    FormsInProgressView *formView = [[[NSBundle mainBundle] loadNibNamed:@"FormsInProgressView" owner:self options:nil] objectAtIndex:0];
    
    
    

    if([[NSUserDefaults standardUserDefaults]valueForKey:@"formId"]!=nil)
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"formId"];
    }
    [[NSUserDefaults standardUserDefaults]setValue:[[mutArrFormList valueForKey:@"formId"]objectAtIndex:button]forKey:@"formId"];
    
    __block BOOL isWSComplete = NO;
    NSString *aStrClientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
    NSString *strUserId = @"";
    if ([User checkUserExist]) {
        strUserId = [[User currentUser] userId];
    }
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?ClientId=%@&UserId=%@&formId=%@", FORM_SETUP, aStrClientId, strUserId,[[mutArrFormList valueForKey:@"formId"]objectAtIndex:button]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:FORM_SETUP] complition:^(NSDictionary *response) {
        [self deleteAllForms];
        [self insertForms:response];
        [self.view addSubview:formView];
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

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    typeId 1 = Link: sends user to the provided URL and open it in native browser
    //    typeId 2 = Form: displays form within the app
    //    typeId 2 = Make A Suggestion: displays form within the app
    [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"fromGuestUserView"];
    NSLog(@"%@",[mutArrFormList objectAtIndex:indexPath.row]);
    
    NSManagedObject *obj = [mutArrFormList objectAtIndex:indexPath.row];
    if ([[obj valueForKey:@"typeId"] integerValue] == 1) {
        //        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[obj valueForKey:@"link"]]]) {
        //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[obj valueForKey:@"link"]]];
        //        }
        //[self performSegueWithIdentifier:@"GoToLink" sender:obj];
        [self initWithIdentifier:@"GoToLink" sender:obj];
    }
    else {
        selectedIndex = indexPath.row;
        [self performSegueWithIdentifier:@"ShowDynamicForm" sender:nil];
    }
}
-(void)initWithIdentifier:(NSString*)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"GoToLink"])
    {
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable)
        {
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:@"We're sorry.  This link is not available while working offline.  Please connect to the internet and try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.tag = 1;
            [alert show];
        }
        else
        {
            WebViewController *webVC =[self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
            webVC.strRequestURL = [sender valueForKey:@"link"];
            webVC.strInstruction = [sender valueForKey:@"instructions"];
            webVC.guestFormType = self.guestFormType;
            [self.navigationController pushViewController:webVC animated:YES];
        }
        
    }
}


@end
