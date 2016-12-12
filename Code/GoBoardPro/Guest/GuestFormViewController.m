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
#import "SurveyQuestions.h"
#import "SurveyResponseTypeValues.h"
#import "WebSerivceCall.h"

@interface GuestFormViewController ()
{
    NSMutableArray *arrForCat;
    NSMutableDictionary *catDictData;
    NSMutableArray *arrForAllData;
    NSString *buttonIndex;
    WebSerivceCall *webcall;
    NSMutableArray *formArray,*tempCatArray,*tempCatName,*tempCatSequence,*data,*tempData;
    NSInteger atSection;
    NSString *txtPath;
    UIActivityIndicatorView *indicatorView;
    UIView *viewActivity;
    NSString *strFlag;

}
@property (nonatomic, assign) BOOL shouldHideActivityIndicator;

//@property (strong, nonatomic)NSMutableDictionary *tempData;
@end

@implementation GuestFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"isSurvey"];
    [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"fromInProgressSubmit"];

    _shouldHideActivityIndicator = YES;

    strFlag = @"addButton";
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"fromInProgressSubmit"];

      strFlag = @"addButton";
    NSString *aStrClientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
    [self setUpInitials:aStrClientId];
    data=[[NSMutableArray alloc]init];
    tempData=[[NSMutableArray alloc]init];
    arrayForBool=[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    arrForCat = [NSMutableArray new];
    arrForAllData = [NSMutableArray new];
    formArray =[NSMutableArray new];
    [self showActivityIndicator];
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"isBack"]isEqualToString:@"yes"])
    {
        [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"isBack"];

        [webcall callServiceForForms:YES complition:nil];
    //    [_tblFormList reloadData];
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
    

  //  NSLog(@"%ld",sender.tag);
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
        [_imvIcon setImage:[UIImage imageNamed:@"complete_a_form.png"]];
        [_lblFormTitle setText:@"Guest Forms"];
        [[WebSerivceCall webServiceObject] callServiceForForms:NO complition:^{
            [self fetchFormList];
            [_tblFormList reloadData];
        }];
    }
    else if (_guestFormType == 3) {
        // Configure for Make a Suggestion screen
        [_imvIcon setImage:[UIImage imageNamed:@"make_a_suggestion.png"]];
        [_lblFormTitle setText:@"Guest Suggestion"];
        [[WebSerivceCall webServiceObject] callServiceForForms:NO complition:^{
            [self fetchFormList];
            [_tblFormList reloadData];
        }];
    }
    else if (_guestFormType == 4) {
        // Configure for User Forms
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
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isSurvey"] isEqualToString:@"YES"]) {
            [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"isSurvey"];
        }
        [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"isSurvey"];
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
    
    [self hideActivityIndicator];

}

- (void)fetchFormList {
    //surveyUserTypeId are 1 = Guest 2 = User
    NSString *strFormUserType = @"1";
    if ([User checkUserExist]) {
        strFormUserType = @"2";
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"FormsList"];
    NSPredicate *predicate;
    
    //predicate = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"userTypeId", strFormUserType];
    
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
    [self hideActivityIndicator];

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
     Purpose :reload table with piced up string from dropdown
     Parameter :
     Return : nsuserdefault
     */
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"removeInProgress"] isEqualToString:@"YES"]) {
        data=[NSMutableArray new];
        [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"removeInProgress"];
       // [data addObjectsFromArray:tempData];
        [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"isBack"];


        [self viewWillAppear:YES];
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
        
     
        
        [aCell.btnFormInProgress addTarget:self action:@selector(formsInProgressList:) forControlEvents:UIControlEventTouchUpInside];
       
        
        aCell.lblFormsCount.layer.cornerRadius = aCell.lblFormsCount.frame.size.height/2;
        aCell.lblFormsCount.layer.masksToBounds = YES;
        
        if ([[[obj valueForKey:@"inProgressCount"]objectAtIndex:indexPath.row]integerValue]>0) {
            
            aCell.lblFormsCount.hidden = NO;
            aCell.btnFormInProgress.hidden = NO;
            
            [aCell.lblFormsCount setText:[NSString stringWithFormat:@"%@",[[obj valueForKey:@"inProgressCount"]objectAtIndex:indexPath.row]]];
            
        }
                
   
    }

   //NSManagedObject *obj = [mutArrFormList objectAtIndex:indexPath.row];
//   UILabel *aLblInstruction = (UILabel *) [aCell.contentView viewWithTag:6];
//    [aLblInstruction setText:[obj valueForKey:@"instructions"]];
//    [aLblInstruction sizeToFit];
    UIView *aView = [aCell.contentView viewWithTag:4];
    CGRect frame = aView.frame;
    frame.origin.y = aCell.frame.size.height - 3;
    frame.size.height = 3;
    [aView setFrame:frame];
   aCell.btnFormInProgress.tag = indexPath.row;
    NSLog(@"%ld",(long)aCell.btnFormInProgress.tag);
    
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
    if (section == 0 || section % 2 == 0) {
        [aHeaderView setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    }
    else {
        [aHeaderView setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
    }
    //NSManagedObject *obj = [mutArrFormList objectAtIndex:section];
    aHeaderView.lblCategory.text = [[data valueForKey:@"categoryName"] objectAtIndex:section];
    UITableViewHeaderFooterView *myHeader = [[UITableViewHeaderFooterView alloc] init];
    myHeader.frame=aHeaderView.frame;
    [myHeader addSubview:aHeaderView];
    [aHeaderView.buttonAction setTag:section];
    [aHeaderView.buttonAction setSelected:YES];
[aHeaderView.imgView setImage:[UIImage imageNamed:@"add_icon.png"]];
//    for (int i=0; i<[arrayForBool count]; i++) {
//        if ([[arrayForBool objectAtIndex:i] boolValue]) {
//          //     [aHeaderView.imgView setImage:[UIImage imageNamed:@"decrease_icon@2x.png"]];
//            aHeaderView.minusImageView.hidden=NO;
//            aHeaderView.imgView.hidden=YES;
//        }
//        else{
//            
//         //   [aHeaderView.imgView setImage:[UIImage imageNamed:@"add_icon.png"]];
//            aHeaderView.minusImageView.hidden=YES;
//            aHeaderView.imgView.hidden=NO;
//        }
//        
//    }
    
    if ([strFlag  isEqualToString:@"addButton"]) {
         [aHeaderView.imgView setImage:[UIImage imageNamed:@"add_icon.png"]];
    }
    else{
        [aHeaderView.imgView setImage:[UIImage imageNamed:@"decrease_icon@2x.png"]];
    }
    

   [aHeaderView.buttonAction addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return myHeader;
    

    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
        return 40;
    }
    return 0;
    
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    typeId 1 = Link: sends user to the provided URL and open it in native browser
//    typeId 2 = Form: displays form within the app
//    typeId 2 = Make A Suggestion: displays form within the app
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isFormHistory"];
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
        selectedSection = indexPath.section;
        [self performSegueWithIdentifier:@"ShowDynamicForm" sender:nil];
    }
  
}

- (void)btnClick:(UIButton *)gestureRecognizer{
    
    sectionForheader=gestureRecognizer.tag;
    if([strFlag  isEqualToString:@"addButton"])
    {
        strFlag = @"decreaseButton";

    }
    else
    {
          strFlag =@"addButton";

        
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
        
//        if(gestureRecognizer.tag == indexPath.section)
//        {
//            [gestureRecognizer setImage:[UIImage imageNamed:@"add_icon.png"] forState:UIControlStateNormal];
//        }
//        else
//        {
//     
//            
//            [gestureRecognizer setImage:[UIImage imageNamed:@"decrease_icon@2x.png"] forState:UIControlStateNormal];
//
//        }

//        CGRect sectionRect = [_tblFormList rectForSection:selectedSection];
//        //sectionRect.size.height = _expandableTableView.frame.size.height;
//        [_tblFormList scrollRectToVisible:sectionRect animated:YES];

        
    }
    
}

-(void)formsInProgressList:(UIButton*)button{
    
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isSurvey"] isEqualToString:@"YES"]) {
      
        FormsInProgressView *formView = [[[NSBundle mainBundle] loadNibNamed:@"FormsInProgressView" owner:self options:nil] objectAtIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:atSection];
        NSManagedObject *obj = [[data valueForKey:@"categoryFormList"]objectAtIndex:indexPath.section];
        NSString *surveyId = [[obj valueForKey:@"surveyId"]objectAtIndex:button.tag];
        
        [[WebSerivceCall webServiceObject]callServiceForSurvey:YES withSurveyId:surveyId complition:^{
            
            [self.view addSubview:formView];
        }];
    }else{
        [self callServiceForForms:YES buttonIndex:button.tag complition:nil];
    }
    [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"fromInProgress"];
    [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"fromInProgressSubmit"];

}

- (void)callServiceForForms:(BOOL)waitUntilDone buttonIndex:(NSInteger)button complition:(void(^)(void))complition {
    

    FormsInProgressView *formView = [[[NSBundle mainBundle] loadNibNamed:@"FormsInProgressView" owner:self options:nil] objectAtIndex:0];
    
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:atSection];
    NSManagedObject *obj = [[data valueForKey:@"categoryFormList"]objectAtIndex:indexPath.section];
    if([[NSUserDefaults standardUserDefaults]valueForKey:@"formId"]!=nil)
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"formId"];
    }
   [[NSUserDefaults standardUserDefaults]setValue:[[obj valueForKey:@"formId"]objectAtIndex:button]forKey:@"formId"];
    
    //[[NSUserDefaults standardUserDefaults]setValue:@"557" forKey:@"formId"];
//    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"formId"]);
    __block BOOL isWSComplete = NO;
    NSString *aStrClientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
    NSString *strUserId = @"";
    if ([User checkUserExist]) {
        strUserId = [[User currentUser] userId];
    }
   [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?ClientId=%@&UserId=%@&formId=%@", FORM_SETUP, aStrClientId, strUserId,[[obj valueForKey:@"formId"]objectAtIndex:button]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:FORM_SETUP] complition:^(NSDictionary *response) {
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
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"FormsList"];
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
    [arrFormHistory addObjectsFromArray:[Dict valueForKey:@"FormHistries"]];
   //for (int i=0; i<arrFormHistory.count; i++) {
        for (NSDictionary *aDict in arrFormHistory) {
            
            FormsList *form = [NSEntityDescription insertNewObjectForEntityForName:@"FormsList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            
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
    
   //}
    
    
}


@end
