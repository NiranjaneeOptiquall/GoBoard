//
//  GuestHomeViewController.m
//  GoBoardPro
//
//  Created by ind558 on 23/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "GuestFormViewController.h"
#import"WebViewController.h"
#import "DynamicFormsViewController.h"
#import "Reachability.h"
#import "TableViewHeader.h"
#import "FormsInProgressView.h"
#import "GuestFormCell.h"
#import "FormsList.h"
#import "FormsInProgress.h"
#import "SubmitFormAndSurvey.h"
#import "SurveyQuestions.h"
#import "SurveyResponseTypeValues.h"
#import "WebSerivceCall.h"
#import "UserHomeViewController.h"

@interface GuestFormViewController ()
{
    NSMutableArray *arrForCat,* imageArray;
    NSMutableDictionary *catDictData;
    NSMutableArray *arrForAllData;
    NSString *buttonIndex;
    WebSerivceCall *webcall;
    NSMutableArray *formArray,*tempCatArray,*tempCatName,*tempCatSequence,*data,*tempData;
    NSInteger atSection;
    NSString *txtPath;
    UIActivityIndicatorView *indicatorView;
    UIView *viewActivity;
    NSString  *flagWaitUntilDataFetch,*flagForImage;
    NSMutableDictionary * countArrOffline;

}
@property (nonatomic, assign) BOOL shouldHideActivityIndicator;
@end

@implementation GuestFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    flagForImage=nil;

    _shouldHideActivityIndicator = YES;

   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(navigateToHome:) name:@"goBackToHome" object:nil];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isSurvey"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"fromInProgressSubmit"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"fromSuveyViewC"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"fromInProgress"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Forms/Surveys"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"lastAccessedByUser"];
      [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isAllowSharedEdit"];
    
    NSString *aStrClientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
  
    data=[[NSMutableArray alloc]init];
    tempData=[[NSMutableArray alloc]init];
    arrayForBool=[[NSMutableArray alloc]init];
    arrForCat = [NSMutableArray new];
    arrForAllData = [NSMutableArray new];
    formArray =[NSMutableArray new];

    [self setUpInitialsReload:aStrClientId];
    
}
-(void)navigateToHome:(NSNotification*)notification{
    
    UserHomeViewController  *userView  =  [self.storyboard instantiateViewControllerWithIdentifier:@"UserHome"];

    [self.navigationController pushViewController:userView animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"fromInProgressSubmit"];
    [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"fromSuveyViewC"];
    [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"fromInProgress"];
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isBack"] isEqualToString:@"no"]) {

        [_tblFormList reloadData];
    }
//********* user is back from submitting or save in progress the form/survey should increment/decrement count of in progress*********//
    
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"isBack"]isEqualToString:@"yes"])
    {
        [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"isBack"];
        [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"isBackDone"];
        flagForImage=@"YES";

        NSString *aStrClientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
     
        data=[[NSMutableArray alloc]init];
        tempData=[[NSMutableArray alloc]init];
        arrayForBool=[[NSMutableArray alloc]init];
        arrForCat = [NSMutableArray new];
        arrForAllData = [NSMutableArray new];
        formArray =[NSMutableArray new];
   [self setUpInitialsReload:aStrClientId];
        
    }
    else{

        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Forms/Surveys"] isEqualToString:@"survey"]) {

            [self fetchSurveyList];
        }
        else if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Forms/Surveys"] isEqualToString:@"form"]){
            [self fetchFormList];
            
        }
                [self.tblFormList reloadData];
    }
 
    
}
-(void)viewDidAppear:(BOOL)animated{
  

}

-(BOOL)waitUntilDataFetch{
    
    
    if ([flagWaitUntilDataFetch isEqualToString:@"NO"]) {
        
    }
    
    flagWaitUntilDataFetch=@"YES";


    if (arrayForBool.count==0) {
          return NO;
    }
    else{
          return YES;
    }
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        if ([segue.identifier isEqualToString:@"ShowDynamicForm"]) {
        DynamicFormsViewController *aDynamicView = (DynamicFormsViewController*)segue.destinationViewController;

               NSMutableArray *aMutbArray  = [[data valueForKey:@"categoryFormList"]objectAtIndex:selectedSection];
        
        

        aDynamicView.objFormOrSurvey = [aMutbArray objectAtIndex:selectedIndex];
            
        if (_guestFormType == 1 || _guestFormType == 5) {
            aDynamicView.isSurvey = YES;
        }
        else {
            aDynamicView.isSurvey = NO;
            
        }
    }

    
}


#pragma mark - Methods

- (void)setUpInitialsReload:(NSString*)aStrClientId {
    if (_guestFormType == 1) {
        // Configure for Take a Survey screen
        [_imvIcon setImage:[UIImage imageNamed:@"take_a_survey.png"]];
        [_lblFormTitle setText:@"Guest Survey"];
        [self callService];
    }
    else if (_guestFormType == 2) {
        // Configure for Complete Form screen
        [_imvIcon setImage:[UIImage imageNamed:@"complete_a_form.png"]];
        [_lblFormTitle setText:@"Guest Forms"];
        [[WebSerivceCall webServiceObject] callServiceForForms:NO linkedFormId:@"0" complition:^{
            
            [self fetchFormList];
            [self.tblFormList reloadData];

       }];
    }
    else if (_guestFormType == 3) {
        // Configure for Make a Suggestion screen
        [_imvIcon setImage:[UIImage imageNamed:@"make_a_suggestion.png"]];
        [_lblFormTitle setText:@"Guest Suggestion"];
        [[WebSerivceCall webServiceObject] callServiceForForms:NO linkedFormId:@"0" complition:^{
            [self fetchFormList];
            [self.tblFormList reloadData];

        }];
    }
    else if (_guestFormType == 4) {
        // Configure for User Forms
        [_imvIcon setImage:[UIImage imageNamed:@"complete_a_form.png"]];
        [_lblFormTitle setText:@"User Form List"];
        [[WebSerivceCall webServiceObject] callServiceForForms:NO linkedFormId:@"0" complition:^{
            [self fetchFormList];
            [self.tblFormList reloadData];

       }];
    }
    else if (_guestFormType == 5) {
        // Configure for User Survey
        [_imvIcon setImage:[UIImage imageNamed:@"complete_a_form.png"]];
        [_lblFormTitle setText:@"User Surveys"];
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isSurvey"] isEqualToString:@"YES"]) {
            [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"isSurvey"];
        }
        [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"isSurvey"];
        [self callService];
    }
    
    
}
- (void)setUpInitials:(NSString*)aStrClientId {
    if (_guestFormType == 1) {
        // Configure for Take a Survey screen
        [_imvIcon setImage:[UIImage imageNamed:@"take_a_survey.png"]];
        [_lblFormTitle setText:@"Guest Survey"];
        [self callServiceReload];
    }
    else if (_guestFormType == 2) {
        // Configure for Complete Form screen
        [_imvIcon setImage:[UIImage imageNamed:@"complete_a_form.png"]];
        [_lblFormTitle setText:@"Guest Forms"];
        [self fetchFormList];
    
    }
    else if (_guestFormType == 3) {
        // Configure for Make a Suggestion screen
        [_imvIcon setImage:[UIImage imageNamed:@"make_a_suggestion.png"]];
        [_lblFormTitle setText:@"Guest Suggestion"];
        [self fetchFormList];
       
    }
    else if (_guestFormType == 4) {
        [_imvIcon setImage:[UIImage imageNamed:@"complete_a_form.png"]];
        [_lblFormTitle setText:@"User Form List"];
        [self fetchFormList];
     
    }
    else if (_guestFormType == 5) {
        // Configure for User Survey
        [_imvIcon setImage:[UIImage imageNamed:@"complete_a_form.png"]];
        [_lblFormTitle setText:@"User Surveys"];
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isSurvey"] isEqualToString:@"YES"]) {
            [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"isSurvey"];
        }
        [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"isSurvey"];
        [self callServiceReload];
    }
    
    
}

- (void)callService {
    [[WebSerivceCall webServiceObject] callServiceForSurvey:NO linkedSurveyId:@"0" complition:^{
        [self fetchSurveyList];
        [self.tblFormList reloadData];
    }];
}
- (void)callServiceReload {
        [self fetchSurveyList];

}
- (void)fetchSurveyList {
    [[NSUserDefaults standardUserDefaults]setValue:@"survey" forKey:@"Forms/Surveys"];
    //surveyUserTypeId are 1 = Guest 2 = User
    NSString *strSurveyUserType = @"1";
    if ([User checkUserExist]) {
        strSurveyUserType = @"2";
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SurveyList"];

//  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userTypeId ==[CD] %@ AND NOT (typeId ==[cd] %@)",strSurveyUserType,[NSString stringWithFormat:@"%d", 3]];
    
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userTypeId ==[CD] %@",strSurveyUserType,[NSString stringWithFormat:@"%d", 3]];

    [request setPredicate:predicate];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
    NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"surveyId" ascending:YES];
    
    [request setSortDescriptors:@[sort,sort1]];
    mutArrFormList = [NSMutableArray arrayWithArray:[gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil]];
    
    //********* to get data in category wise dictionary format*********//
    
    for (int i=0; i<[mutArrFormList count]; i++) {
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }
    
    if ([mutArrFormList count] == 0) {
        [_lblNoRecord setHidden:NO];
        [_lblNoRecord setText:@"No survey available."];
    }
    else{
        
        NSMutableArray *allCatArray =[NSMutableArray new];
        NSMutableArray *allCatName =[NSMutableArray new];
        NSMutableArray *allCatSequence =[NSMutableArray new];

        for (int i=0; i<[mutArrFormList count]; i++)
        {
            
            [allCatArray addObject:[[mutArrFormList valueForKey:@"categoryId"]objectAtIndex:i]];
            [allCatName addObject:[[mutArrFormList valueForKey:@"categoryName"]objectAtIndex:i]];
            [allCatSequence addObject:[[mutArrFormList valueForKey:@"categorySequence"]objectAtIndex:i]];

        }
        tempCatArray = [NSMutableArray new];
        tempCatName = [NSMutableArray new];
        tempCatSequence = [NSMutableArray new];

        for (int i=0; i<allCatArray.count; i++) {
            
            if(![tempCatArray containsObject:[allCatArray objectAtIndex:i]])
            {
                
                [tempCatArray addObject:[allCatArray objectAtIndex:i]];
                [tempCatName addObject:[allCatName objectAtIndex:i]];
                [tempCatSequence addObject:[allCatSequence objectAtIndex:i]];

            }
        }
        
        arrForAllData=[NSMutableArray new];
        catDictData=[NSMutableDictionary new];
        data=[[NSMutableArray alloc]init];
        tempData=[[NSMutableArray alloc]init];
        
        
        int count2 = 0;
        for (int i=0; i<tempCatArray.count; i++) {
            int count = 0;
            catDictData=[NSMutableDictionary new];
            arrForAllData=[NSMutableArray new];
            [catDictData setObject:[tempCatArray objectAtIndex:i] forKey:@"categoryId"];
            [catDictData setObject:[tempCatName objectAtIndex:i] forKey:@"categoryName"];
            [catDictData setObject:[tempCatSequence objectAtIndex:i] forKey:@"categorySequence"];
            
            for (int j=0; j<allCatArray.count; j++) {
                
                if ([[allCatArray objectAtIndex:j] isEqualToString:[tempCatArray objectAtIndex:i]]) {
                    
                    
                    
                    
                    [arrForAllData insertObject:[mutArrFormList objectAtIndex:j] atIndex:count];
                    count = count +1;
                    
                }
                
            }
            [catDictData setValue:arrForAllData forKey:@"categoryFormList"];
            
            
            [data insertObject:catDictData atIndex:count2];
            count2 = count2 +1;
        }
        
        NSSortDescriptor *sortByCatSequence = [NSSortDescriptor sortDescriptorWithKey:@"categorySequence" ascending:YES];
        NSArray * sortedData=[NSArray arrayWithObject:sortByCatSequence];
        [data sortUsingDescriptors:sortedData];
        [self hideActivityIndicator];
        
    }
    
    NSFetchRequest *requestOffline = [[NSFetchRequest alloc] initWithEntityName:@"SubmitFormAndSurvey"];
    
    NSArray *aryOfflineData = [gblAppDelegate.managedObjectContext executeFetchRequest:requestOffline error:nil];
    countArrOffline=[[NSMutableDictionary alloc]init];
    NSString *strUserId = @"";
    if ([User checkUserExist]) {
        strUserId = [[User currentUser] userId];
    }
    
    for (int temp = 0 ; temp<tempCatArray.count; temp++) {
        int countInProgressOffline=0;
        for (SubmitFormAndSurvey *record in aryOfflineData) {
           
           
           if ([[tempCatArray objectAtIndex:temp] isEqualToString:record.categoryId] && [strUserId isEqualToString:record.userId] && [record.type isEqualToString:@"1"] && [record.isInProgressId isEqualToString:@"1"]) {
         
                countInProgressOffline=countInProgressOffline+1;
            }
            
        }
        
        [countArrOffline setValue:[NSString stringWithFormat:@"%d",countInProgressOffline] forKey:[tempCatArray objectAtIndex:temp]];
    }
    

    
    [self hideActivityIndicator];
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isBackDone"]isEqualToString:@"yes"]) {
        //*********category persistancy*********//
        [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"isBackDone"];
        
        UIButton * btnForSectionSelected=[[UIButton alloc]init];
        
        NSData *indexData = [[NSUserDefaults standardUserDefaults] objectForKey:@"sectionSelected"];
        
        NSString * str=[NSKeyedUnarchiver unarchiveObjectWithData:indexData];
        
        btnForSectionSelected.tag=[str integerValue];
        
        [self btnClick:btnForSectionSelected];//category persistancy methode
        
    }
  
        if (imageArray.count == 0) {
            //********* Plus minus sign on category section*********//
            imageArray = [NSMutableArray new];
            for (int l = 0; l<[[data valueForKey:@"categoryName"] count]; l++) {
                
                [imageArray setObject:@"YES" atIndexedSubscript:l];
            }
            
        }
    
  
      if (data.count == 0) {
          //********* if data is empty call the methode again*********//
        NSString *aStrClientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
        data=[[NSMutableArray alloc]init];
        tempData=[[NSMutableArray alloc]init];
        arrayForBool=[[NSMutableArray alloc]init];
        arrForCat = [NSMutableArray new];
        arrForAllData = [NSMutableArray new];
        formArray =[NSMutableArray new];
        [self setUpInitialsReload:aStrClientId];
    }
    [_tblFormList reloadData];

}

- (void)fetchFormList {
    [[NSUserDefaults standardUserDefaults]setValue:@"form" forKey:@"Forms/Surveys"];

    //surveyUserTypeId are 1 = Guest 2 = User
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
    
 
    //********* remove shared form if  user selected position is not matched with position assigned to it *********//

    NSMutableArray *tempFormArr = [[NSMutableArray alloc]init];
    [tempFormArr addObjectsFromArray:mutArrFormList];
    for (int a = 0; a<[mutArrFormList count]; a++) {
      
     //   if ([[[mutArrFormList valueForKey:@"typeId"]objectAtIndex:a] isEqualToString:@"4"]) {
            if ([[[mutArrFormList valueForKey:@"publishedToFacilityPositions"]objectAtIndex:a] isEqualToString:@"<null>"] || [[[mutArrFormList valueForKey:@"publishedToFacilityPositions"]objectAtIndex:a] isKindOfClass:[NSNull class]] ) {
                  NSLog(@"contains form no position assigned to %@", [[mutArrFormList valueForKey:@"name"]objectAtIndex:a]);
                // allow display shared form is no position is assigned to it
            }
           else{
        NSString * flag = @"no";
        NSArray * tempFormPositionArr = [[NSArray alloc]init];
        NSArray * tempUserPositionArr = [[NSArray alloc]init];

        tempUserPositionArr =  [[[User currentUser] mutArrSelectedPositions] valueForKey:@"value"];
               NSMutableString * strTemp = [NSMutableString stringWithFormat:@"%@",[[mutArrFormList valueForKey:@"publishedToFacilityPositions"]objectAtIndex:a]];
               if (![strTemp isEqualToString:@""]) {
                   [strTemp deleteCharactersInRange:NSMakeRange([strTemp length]-1, 1)];

               }
               
       tempFormPositionArr  = [strTemp componentsSeparatedByString:@","];

               NSLog(@"FormPosition : %@,,, UserPosition : %@",tempFormPositionArr,tempUserPositionArr);
        for (NSString*position in tempUserPositionArr ) {
            if ([tempFormPositionArr containsObject:position]){
                NSLog(@"contains form : %@",[mutArrFormList objectAtIndex:a]);
                flag = @"yes";
                break;
            }
        }
        if ([flag isEqualToString:@"no"]) {
             NSLog(@"not contains remove to %@",[[mutArrFormList valueForKey:@"name"]objectAtIndex:a]);
            // remove shared form if  user selected position is not matched with position assigned to it
            [tempFormArr removeObject:[mutArrFormList objectAtIndex:a]];
        }
   
        }
             //  }
        NSLog(@"%d",a);
      }
    mutArrFormList = tempFormArr;
  
        //********* to get data in category wise dictionary format*********//
    
    for (int i=0; i<[mutArrFormList count]; i++){
                [arrayForBool addObject:[NSNumber numberWithBool:NO]];
        }
    if ([mutArrFormList count] == 0) {
        [_lblNoRecord setHidden:NO];
         [_lblNoRecord setText:@"No form available."];
    }
    else{
        
        NSMutableArray *allCatArray =[NSMutableArray new];
        NSMutableArray *allCatName =[NSMutableArray new];
        NSMutableArray *allCatSeqence =[NSMutableArray new];

        for (int i=0; i<[mutArrFormList count]; i++)
        {
         
            [allCatArray addObject:[[mutArrFormList valueForKey:@"categoryId"]objectAtIndex:i]];
            [allCatName addObject:[[mutArrFormList valueForKey:@"categoryName"]objectAtIndex:i]];
            [allCatSeqence addObject:[[mutArrFormList valueForKey:@"categorySequence"]objectAtIndex:i]];

        }
       
       tempCatArray = [NSMutableArray new];
         tempCatName = [NSMutableArray new];
        tempCatSequence = [NSMutableArray new];

        
        for (int i=0; i<allCatArray.count; i++) {
            
            if(![tempCatArray containsObject:[allCatArray objectAtIndex:i]])
            {
                
                [tempCatArray addObject:[allCatArray objectAtIndex:i]];
                [tempCatName addObject:[allCatName objectAtIndex:i]];
                [tempCatSequence addObject:[allCatSeqence objectAtIndex:i]];

                
            }
        }
        
        arrForAllData=[NSMutableArray new];
        catDictData=[NSMutableDictionary new];
        data=[[NSMutableArray alloc]init];
        tempData=[[NSMutableArray alloc]init];

        
        int count2 = 0;
        for (int i=0; i<tempCatArray.count; i++) {
            int count = 0;
            catDictData=[NSMutableDictionary new];
            arrForAllData=[NSMutableArray new];
            [catDictData setObject:[tempCatArray objectAtIndex:i] forKey:@"categoryId"];
            [catDictData setObject:[tempCatName objectAtIndex:i] forKey:@"categoryName"];
            [catDictData setObject:[tempCatSequence objectAtIndex:i] forKey:@"categorySequence"];

            
            for (int j=0; j<allCatArray.count; j++) {
                
                if ([[allCatArray objectAtIndex:j] isEqualToString:[tempCatArray objectAtIndex:i]]) {

                    [arrForAllData insertObject:[mutArrFormList objectAtIndex:j] atIndex:count];
                    count = count +1;
                }
            }
            [catDictData setValue:arrForAllData forKey:@"categoryFormList"];
            
            [data insertObject:catDictData atIndex:count2];
            count2 = count2 +1;
        }

    }
    
    NSSortDescriptor *sortByCatSequence = [NSSortDescriptor sortDescriptorWithKey:@"categorySequence" ascending:YES];
    NSArray * sortedData=[NSArray arrayWithObject:sortByCatSequence];
    [data sortUsingDescriptors:sortedData];
    
    
    
    
    NSFetchRequest *requestOffline = [[NSFetchRequest alloc] initWithEntityName:@"SubmitFormAndSurvey"];
    
    NSArray *aryOfflineData = [gblAppDelegate.managedObjectContext executeFetchRequest:requestOffline error:nil];
    countArrOffline=[[NSMutableDictionary alloc]init];
    NSString *strUserId = @"";
    if ([User checkUserExist]) {
        strUserId = [[User currentUser] userId];
    }
    
    for (int temp = 0 ; temp<tempCatArray.count; temp++) {
        int countInProgressOffline=0;
        for (SubmitFormAndSurvey *record in aryOfflineData) {
            
           if ([[tempCatArray objectAtIndex:temp] isEqualToString:record.categoryId] && [strUserId isEqualToString:record.userId] && ![record.type isEqualToString:@"1"] && [record.isInProgressId isEqualToString:@"1"] ) {
        
                countInProgressOffline=countInProgressOffline+1;
            }
            
        }
        
        [countArrOffline setValue:[NSString stringWithFormat:@"%d",countInProgressOffline] forKey:[tempCatArray objectAtIndex:temp]];
    }
    

    
    
    [self hideActivityIndicator];
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isBackDone"]isEqualToString:@"yes"]) {
        //*********category persistancy*********//
        
        [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"isBackDone"];
        
        UIButton * btnForSectionSelected=[[UIButton alloc]init];
        
        NSData *indexData = [[NSUserDefaults standardUserDefaults] objectForKey:@"sectionSelected"];
        
        NSString * str=[NSKeyedUnarchiver unarchiveObjectWithData:indexData];
        
        btnForSectionSelected.tag=[str integerValue];
        
        [self btnClick:btnForSectionSelected]; //category persistancy methode
        
    }
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isBack"]isEqualToString:@"yes"]) {
        
    }

    if (imageArray.count==0) {
        // *********Plus minus sign on category section*********//

        imageArray=[NSMutableArray new];
    for (int l = 0; l<[[data valueForKey:@"categoryName"] count]; l++) {
        
        [imageArray setObject:@"YES" atIndexedSubscript:l];
    }
    }
    
    if (data.count == 0) {
            //********* if data is empty call the methode again*********//
        NSString *aStrClientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
        
        data=[[NSMutableArray alloc]init];
        tempData=[[NSMutableArray alloc]init];
        arrayForBool=[[NSMutableArray alloc]init];
        arrForCat = [NSMutableArray new];
        arrForAllData = [NSMutableArray new];
        formArray =[NSMutableArray new];
        [self setUpInitialsReload:aStrClientId];
    }
    
    [_tblFormList reloadData];
    
}

#pragma mark - IBActions


- (IBAction)btnBackTapped:(id)sender {
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
-(void)viewDidLayoutSubviews{
    /*
     Funaction viewDidLayoutSubviews
     Purpose :reload table with count of in progress forms/surveys
     Parameter :
     Return : nsuserdefault
     */
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"removeInProgress"] isEqualToString:@"YES"]) {
        [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"removeInProgress"];
        [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"isBack"];


        [self viewWillAppear:YES];
    }
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"offlineInProgress"] isEqualToString:@"YES"]) {
        [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"offlineInProgress"];
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Forms/Surveys"] isEqualToString:@"survey"]) {
            
            [self fetchSurveyList];
        }
        else if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Forms/Surveys"] isEqualToString:@"form"]){
            [self fetchFormList];
            
        }

        [_tblFormList reloadData];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [data count];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSLog(@"%lu",(unsigned long)[[[data valueForKey:@"categoryFormList"] objectAtIndex:section] count]);
    return [[[data valueForKey:@"categoryFormList"] objectAtIndex:section] count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GuestFormCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];


    if(!aCell)
    {
        aCell = [[GuestFormCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
    
    /********** If the section supposed to be closed *******************/
    if(!manyCells)
    {
        aCell.backgroundColor=[UIColor clearColor];
        
        aCell.textLabel.text=@"";
        aCell.hidden=YES;
    }
    /********** If the section supposed to be Opened *******************/
    else
    {
        
              NSManagedObject *obj = [[data valueForKey:@"categoryFormList"]objectAtIndex:indexPath.section];
        
                [aCell.lblFormName setText:[[obj valueForKey:@"name"]objectAtIndex:indexPath.row]];
                aCell.textLabel.font=[UIFont systemFontOfSize:15.0f];
                aCell.backgroundColor=[UIColor whiteColor];
                aCell.imageView.image=[UIImage imageNamed:@"point.png"];
                aCell.selectionStyle=UITableViewCellSelectionStyleNone ;
        
        NSString * strId=nil;
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isSurvey"] isEqualToString:@"YES"]) {
            [aCell.btnFormInProgressTitle setTitle:@"Survey in progress" forState:UIControlStateNormal];
            [aCell.btnFormInOfflineTitle setTitle:@"Survey Offline" forState:UIControlStateNormal];
            strId=[[obj valueForKey:@"surveyId"]objectAtIndex:indexPath.row];
        }
        else{
            [aCell.btnFormInProgressTitle setTitle:@"Form in progress" forState:UIControlStateNormal];
            [aCell.btnFormInOfflineTitle setTitle:@"Form offline" forState:UIControlStateNormal];
            strId=[[obj valueForKey:@"formId"]objectAtIndex:indexPath.row];
            

        }
        [aCell.btnFormInProgress addTarget:self action:@selector(formsInProgressList:) forControlEvents:UIControlEventTouchUpInside];
       [aCell.btnFormInOffline addTarget:self action:@selector(formsInProgressListInOffline:) forControlEvents:UIControlEventTouchUpInside];
        aCell.lblFormsCount.layer.cornerRadius = aCell.lblFormsCount.frame.size.height/2;
        aCell.lblFormsCount.layer.masksToBounds = YES;
        aCell.lblFormInOfflineCount.layer.cornerRadius = aCell.lblFormsCount.frame.size.height/2;
        aCell.lblFormInOfflineCount.layer.masksToBounds = YES;

        
        if ([[[obj valueForKey:@"inProgressCount"]objectAtIndex:indexPath.row]integerValue]>0) {
          
            [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"signOutMsg"];

            aCell.lblFormsCount.hidden = NO;
            aCell.btnFormInProgress.hidden = NO;
            aCell.btnFormInProgressTitle.hidden = NO;

            [aCell.lblFormsCount setText:[NSString stringWithFormat:@"%@",[[obj valueForKey:@"inProgressCount"]objectAtIndex:indexPath.row]]];
            
        }
        else{
            aCell.lblFormsCount.hidden = YES;
            aCell.btnFormInProgress.hidden = YES;
            aCell.btnFormInProgressTitle.hidden = YES;
            

        }
        [aCell.lblFormInOfflineCount setHidden:YES];
        [aCell.btnFormInOffline setHidden:YES];
        [aCell.btnFormInOfflineTitle setHidden:YES];

//******** If the offline forms/surveys are saved in sync, get count of synced forms/survey **********//

            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SubmitFormAndSurvey"];
            
            NSArray *aryOfflineData = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
            int countInProgress=0;
        NSString *strUserId = @"";
        if ([User checkUserExist]) {
            strUserId = [[User currentUser] userId];
        }
            
            for (SubmitFormAndSurvey *record in aryOfflineData) {
                
                if ([strId isEqualToString:record.typeId] && [record.isInProgressId isEqualToString:@"1"] && [strUserId isEqualToString:record.userId]) {
                 
                           countInProgress=countInProgress+1;
                        aCell.lblFormInOfflineCount.text=[NSString stringWithFormat:@"%d",countInProgress];
                        [aCell.lblFormInOfflineCount setHidden:NO];
                         [aCell.btnFormInOffline setHidden:NO];
                         [aCell.btnFormInOfflineTitle setHidden:NO];
                }

                
            }
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isSurvey"] isEqualToString:@"YES"]) {
        }
        else{
        if ([[[obj valueForKey:@"isSharedForm"]objectAtIndex:indexPath.row] boolValue]) {
            
            NSLog(@"shared form");
           // aCell.btnFormInProgress.hidden = YES;
           // aCell.btnFormInProgressTitle.hidden = YES;
           // aCell.lblFormsCount.hidden = YES;
            aCell.btnFormInOffline.hidden = YES;
            aCell.btnFormInOfflineTitle.hidden = YES;
            aCell.lblFormInOfflineCount.hidden = YES;
              aCell.imgListIcon.hidden = YES;
            aCell.btnIsSharedForm.hidden = NO;
            if ([[[obj valueForKey:@"inProgressCount"]objectAtIndex:indexPath.row] intValue] > 0) {
                aCell.btnIsSharedForm.selected = YES;
            }
            else{
                aCell.btnIsSharedForm.selected = NO;
            }
        }
        else{
            NSLog(@"no shared form");
             aCell.btnIsSharedForm.hidden = YES;
        }
        }
    }

    UIView *aView = [aCell.contentView viewWithTag:4];
    CGRect frame = aView.frame;
    frame.origin.y = aCell.frame.size.height - 3;
    frame.size.height = 3;
    [aView setFrame:frame];
   aCell.btnFormInProgress.tag = indexPath.section * 1000 + indexPath.row;
    aCell.btnFormInOffline.tag = indexPath.section * 1000 + indexPath.row;
 

    return aCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

#pragma mark - Creating View for TableView Section

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TableViewHeader *aHeaderView = (TableViewHeader *)[[[NSBundle mainBundle] loadNibNamed:@"TableViewHeader" owner:self options:nil] lastObject];
    aHeaderView.lblInProgressCount.layer.cornerRadius=aHeaderView.lblInProgressCount.frame.size.width/2;
    aHeaderView.lblInProgressCount.layer.masksToBounds = YES;
    aHeaderView.lblOfflineInProgressCount.layer.cornerRadius=aHeaderView.lblInProgressCount.frame.size.width/2;
    aHeaderView.lblOfflineInProgressCount.layer.masksToBounds = YES;
    
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Forms/Surveys"] isEqualToString:@"survey"]) {
        [aHeaderView.btnInProgressCount setTitle:@"Survey in progress" forState:UIControlStateNormal];
        [aHeaderView.btnOfflineCount setTitle:@"Survey in offline" forState:UIControlStateNormal];
    }
    else if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Forms/Surveys"] isEqualToString:@"form"]){
        
    [aHeaderView.btnInProgressCount setTitle:@"Forms in progress" forState:UIControlStateNormal];
    [aHeaderView.btnOfflineCount setTitle:@"Forms in offline" forState:UIControlStateNormal];
      

    }
    
    
    
    int inProgressCount=0;
    NSMutableArray * tempArray=[[NSMutableArray alloc]init];
    [tempArray addObjectsFromArray:[[data valueForKey:@"categoryFormList"]objectAtIndex:section]];
    NSLog(@"%@",tempArray);
    
    for (int i = 0; i<tempArray.count; i++) {
        int tempCount=[[[tempArray valueForKey:@"inProgressCount"] objectAtIndex:i] intValue];
        inProgressCount=inProgressCount+tempCount;
    }
    if (inProgressCount > 0) {
        aHeaderView.lblInProgressCount.hidden=NO;
        aHeaderView.btnInProgressCount.hidden=NO;
        
        aHeaderView.lblInProgressCount.text=[NSString stringWithFormat:@"%d",inProgressCount];
    }
    else{
        aHeaderView.lblInProgressCount.hidden=YES;
        aHeaderView.btnInProgressCount.hidden=YES;
        
    }
    
    // for (int temp = 0; temp<tempCatArray.count; temp++) {
    if ([[countArrOffline objectForKey:[[data valueForKey:@"categoryId"] objectAtIndex:section]] integerValue] != 0 ) {
        
        aHeaderView.lblOfflineInProgressCount.text=[NSString stringWithFormat:@"%@",[countArrOffline objectForKey:[[data valueForKey:@"categoryId"] objectAtIndex:section]]];
        aHeaderView.lblOfflineInProgressCount.hidden=NO;
        aHeaderView.btnOfflineCount.hidden=NO;
        
    }
    else{
        aHeaderView.lblOfflineInProgressCount.hidden=YES;
        aHeaderView.btnOfflineCount.hidden=YES;
        
    }
    
    
    //}
    if (section == 0 || section % 2 == 0) {
        [aHeaderView setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    }
    else {
        [aHeaderView setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
    }
    aHeaderView.lblCategory.text = [[data valueForKey:@"categoryName"] objectAtIndex:section];
    //  NSLog(@"%@",[[data valueForKey:@"categoryId"] objectAtIndex:section]);
    UITableViewHeaderFooterView *myHeader = [[UITableViewHeaderFooterView alloc] init];
    myHeader.frame=aHeaderView.frame;
    [myHeader addSubview:aHeaderView];
    [aHeaderView.buttonAction setTag:section];
    [aHeaderView.buttonAction setSelected:YES];
    [aHeaderView.imgView setImage:[UIImage imageNamed:@"add_icon.png"]];
    
    
    
    
    [aHeaderView.buttonAction addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[imageArray objectAtIndex:section] isEqualToString:@"YES"]) {
        [aHeaderView.imgView setImage:[UIImage imageNamed:@"expand_icon@2x.png"]];
        
    }
    else{
        [aHeaderView.imgView setImage:[UIImage imageNamed:@"decrease_icon@2x.png"]];
        
    }
    return myHeader;
    
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
        return 100;
    }
    return 0;
    
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isFormHistory"];
 
    
    NSMutableArray * dataArray=[[data valueForKey:@"categoryFormList"]objectAtIndex:indexPath.section];
    NSLog(@"%@",dataArray);
    NSManagedObject *obj =[dataArray objectAtIndex:indexPath.row];
    if ([[obj valueForKey:@"typeId"] integerValue] == 1) {
 
        [self initWithIdentifier:@"GoToLink" sender:obj];
    }
    else if ([[obj valueForKey:@"typeId"] integerValue] == 4){
      if ([self isNetworkReachable]) {
           selectedIndex = indexPath.row;
            selectedSection = indexPath.section;
           [self performSegueWithIdentifier:@"ShowDynamicForm" sender:nil];
    }
    else {
        alert(@"", @"We’re sorry.  This form is not available while working offline.  Please connect to the internet and try again.");
        return;

    }
   }
    else {
        selectedIndex = indexPath.row;
        selectedSection = indexPath.section;
        [self performSegueWithIdentifier:@"ShowDynamicForm" sender:nil];
    }

    
    NSData *Data = [NSKeyedArchiver archivedDataWithRootObject:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
    [[NSUserDefaults standardUserDefaults] setObject:Data forKey:@"sectionSelected"];
    
    
    
  
}
-(void)callSharedFormHistory:(NSString*)formId{
    //service call
    
    
}
- (void)btnClick:(UIButton *)gestureRecognizer{
    //********* category click expand the section or close the section*********//
//*********category persistancy comming back from detail(dynamic) form/survey view*********//
    
    sectionForheader=gestureRecognizer.tag;
    if ([flagForImage isEqualToString:@"YES"]) {
        flagForImage=@"NO";
        for (int i = 0; i<imageArray.count; i++) {
            if (i == gestureRecognizer.tag) {
                
            }
            else{
               
                    [imageArray replaceObjectAtIndex:i withObject:@"YES"];
            }
        }
        
    }
    else{

                if ([[imageArray objectAtIndex:gestureRecognizer.tag] isEqualToString:@"YES"]) {
                    [imageArray replaceObjectAtIndex:gestureRecognizer.tag withObject:@"NO"];
                }
                else{
                    [imageArray replaceObjectAtIndex:gestureRecognizer.tag withObject:@"YES"];
                    
                }
       
    }
   
    
    atSection = gestureRecognizer.tag;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i=0; i<[mutArrFormList count]; i++) {
            if (indexPath.section==i) {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
          
        }
        [_tblFormList reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.tag] withRowAnimation:UITableViewRowAnimationFade];
        
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

//********** forms/survey  in progress button clicke action (offline)**********//

-(void)formsInProgressListInOffline:(UIButton*)button
{
    [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"OfflineForListTitle"];
   [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"fromInProgressInOffline"];
    [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"fromInProgressSubmit"];
    [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"isFormHistory"];
    [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"fromInProgress"];
    [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"offlineToOnline"];
    [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"saveToInProgressoffline"];

    NSInteger section,row;
    section = button.tag / 1000;
    row = button.tag % 1000;
    NSData *Data = [NSKeyedArchiver archivedDataWithRootObject:[NSString stringWithFormat:@"%ld",(long)section]];
    [[NSUserDefaults standardUserDefaults] setObject:Data forKey:@"sectionSelected"];
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isSurvey"] isEqualToString:@"YES"]) {
        
        FormsInProgressView *formView = [[[NSBundle mainBundle] loadNibNamed:@"FormsInProgressView" owner:self options:nil] objectAtIndex:0];
        NSLog(@"%ld  %ld",section,row);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        NSManagedObject *obj = [[data valueForKey:@"categoryFormList"]objectAtIndex:indexPath.section];
        NSString *surveyId = [[obj valueForKey:@"surveyId"]objectAtIndex:indexPath.row];
        NSString *SurveyInstructions = [[obj valueForKey:@"instructions"]objectAtIndex:indexPath.row];
        NSString *SurveyIsAllowInProgress = [[obj valueForKey:@"isAllowInProgress"]objectAtIndex:indexPath.row];
        NSString *SurveyName = [[obj valueForKey:@"name"]objectAtIndex:indexPath.row];
        
        [[NSUserDefaults standardUserDefaults]setObject:surveyId forKey:@"surveyIdForDelete"];
        [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"fromSuveyViewC"];
        [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"fromInProgress"];
        [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"fromSugestionViewC"];
        
        
        [[WebSerivceCall webServiceObject]callServiceForSurveyInOffline:YES withSurveyId:surveyId withSurveyInstructions:SurveyInstructions withSurveyIsAllowInProgress:SurveyIsAllowInProgress withSurveyName:SurveyName complition:^{
            
            [self.view addSubview:formView];
            
        }];
    }else{
        [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"isSurvey"];
        [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"fromInProgress"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)button.tag] forKey:@"indexForFormSelected"];
          NSLog(@"%ld",[[[NSUserDefaults standardUserDefaults] valueForKey:@"indexForFormSelected"] integerValue]);
        FormsInProgressView *formView = [[[NSBundle mainBundle] loadNibNamed:@"FormsInProgressView" owner:self options:nil] objectAtIndex:0];
        
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        NSManagedObject *obj = [[data valueForKey:@"categoryFormList"]objectAtIndex:indexPath.section];
        NSString *FormId = [[obj valueForKey:@"formId"]objectAtIndex:indexPath.row];
        NSString *FormInstructions = [[obj valueForKey:@"instructions"]objectAtIndex:indexPath.row];
        NSString *FormIsAllowInProgress = [[obj valueForKey:@"isAllowInProgress"]objectAtIndex:indexPath.row];
        NSString *FormName = [[obj valueForKey:@"name"]objectAtIndex:indexPath.row];
        
        [[NSUserDefaults standardUserDefaults]setObject:FormId forKey:@"surveyIdForDelete"];
        
        [[WebSerivceCall webServiceObject]callServiceForFormInOffline:YES withFormId:FormId withFormInstructions:FormInstructions withFormIsAllowInProgress:FormIsAllowInProgress withFormName:FormName complition:^{
            
            [self.view addSubview:formView];
            
        }];
        
        
        
    }

}

//********** forms/survey  in progress button clicke action (online)**********//

-(void)formsInProgressList:(UIButton*)button{
    

    
    [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"fromInProgressInOffline"];
    NSInteger section,row;
    section = button.tag / 1000;
    row = button.tag % 1000;
    
    NSData *Data = [NSKeyedArchiver archivedDataWithRootObject:[NSString stringWithFormat:@"%ld",(long)section]];
    [[NSUserDefaults standardUserDefaults] setObject:Data forKey:@"sectionSelected"];
    
    if ([self isNetworkReachable]) {
        
        [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"fromInProgressSubmit"];
        [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"isFormHistory"];
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isSurvey"] isEqualToString:@"YES"]) {

            FormsInProgressView *formView = [[[NSBundle mainBundle] loadNibNamed:@"FormsInProgressView" owner:self options:nil] objectAtIndex:0];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            NSManagedObject *obj = [[data valueForKey:@"categoryFormList"]objectAtIndex:indexPath.section];
            NSString *surveyId = [[obj valueForKey:@"surveyId"]objectAtIndex:indexPath.row];
            [[NSUserDefaults standardUserDefaults]setObject:surveyId forKey:@"surveyIdForDelete"];
            [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"fromSuveyViewC"];
            [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"fromInProgress"];
            [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"fromSugestionViewC"];


            [[WebSerivceCall webServiceObject]callServiceForSurvey:YES withSurveyId:surveyId complition:^{
                
                [self.view addSubview:formView];
            }];
            
            
            
            
        }else{
            [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"isSurvey"];
            [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"fromInProgress"];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];

            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",indexPath.row] forKey:@"indexForFormSelected"];
            
            NSManagedObject *obj = [[data valueForKey:@"categoryFormList"]objectAtIndex:indexPath.section];
            NSString *formId = [[obj valueForKey:@"formId"]objectAtIndex:indexPath.row];
            
            if ([[[obj valueForKey:@"typeId"]objectAtIndex:indexPath.row] isEqualToString:@"4"]){
                  [self callServiceForForms:YES buttonIndex:[formId integerValue] sharedForm:YES complition:nil];
            }
            else{
                  [self callServiceForForms:YES buttonIndex:[formId integerValue] sharedForm:NO complition:nil];
            }
          
            
        }
        
    }
    else {
                UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:MSG_NO_INTERNET delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
        
    }

   

}


- (void)callServiceForForms:(BOOL)waitUntilDone buttonIndex:(NSInteger)button sharedForm:(BOOL)isSharedForm complition:(void(^)(void))complition {
    

    FormsInProgressView *formView = [[[NSBundle mainBundle] loadNibNamed:@"FormsInProgressView" owner:self options:nil] objectAtIndex:0];
    
   [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld",(long)button] forKey:@"formId"];
    __block BOOL isWSComplete = NO;
    NSString *aStrClientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
    NSString *strUserId = @"";
    if ([User checkUserExist]) {
        strUserId = [[User currentUser] userId];
    }
   [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?ClientId=%@&UserId=%@&formId=%@", FORM_SETUP, aStrClientId, strUserId,[NSString stringWithFormat:@"%ld",(long)button]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:FORM_SETUP] complition:^(NSDictionary *response) {
      // NSString * strName = [response valueForKey:@"LastAccessedBy"];
    //   [[NSUserDefaults standardUserDefaults]setValue:strName forKey:@"lastAccessedByUser"];
       
       BOOL SharedEdit = [[response valueForKey:@"IsAllowSharedEdit"] boolValue];
       [[NSUserDefaults standardUserDefaults]setBool:SharedEdit forKey:@"isAllowSharedEdit"];
//       if ([[response valueForKey:@"FormHistory"] count] == 0) {
//
//           [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"formId"];
//           [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"fromInProgress"];
//           [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"isFormHistory"];
//           [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"fromInProgressSubmit"];
//
//           [self performSegueWithIdentifier:@"ShowDynamicForm" sender:nil];
//               isWSComplete = YES;
//           return;
//       }
//       else{
           [self deleteAllForms];
           [self insertForms:response];
 //      }

//       if (isSharedForm) {
//               [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"fromInProgress"];
//               [self performSegueWithIdentifier:@"ShowDynamicForm" sender:nil];
//       }
//       else{
           [self.view addSubview:formView];

//       }
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
            form.isAllowEditSharedForm=[[aDict valueForKey:@"IsAllowSharedEdit"] stringValue];
            form.formLastAccessedBy=[aDict valueForKey:@"LastAccessedBy"];

    //        form.isAllowEditSharedForm=[NSString stringWithFormat:@"%@",[aDict valueForKey:@"IsAllowSharedEdit"]];
            
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


@end
