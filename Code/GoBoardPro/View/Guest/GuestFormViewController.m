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

@interface GuestFormViewController ()

@end

@implementation GuestFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *aStrClientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
    [self setUpInitials:aStrClientId];
    // Do any additional setup after loading the view.
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
    if ([mutArrFormList count] == 0) {
        [_lblNoRecord setHidden:NO];
         [_lblNoRecord setText:@"No form available."];
    }
    
    
    
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mutArrFormList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 0 || indexPath.row % 2 == 0) {
        [aCell setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    }
    else {
        [aCell setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
    }


    NSManagedObject *obj = [mutArrFormList objectAtIndex:indexPath.row];
    UILabel *aLbl = (UILabel *)[aCell.contentView viewWithTag:2];
    [aLbl setText:[obj valueForKey:@"Name"]];
    
    //NSString *temp = [NSString stringWithFormat:@"%@(%@)",[obj valueForKey:@"Name"],[obj valueForKey:@"sequence"]];
    //aLbl.text = temp;
    
    //UILabel *aLblInstruction = (UILabel *) [aCell.contentView viewWithTag:6];
    //[aLblInstruction setText:[obj valueForKey:@"instructions"]];
    //[aLblInstruction sizeToFit];
    UIView *aView = [aCell.contentView viewWithTag:4];
    CGRect frame = aView.frame;
    frame.origin.y = aCell.frame.size.height - 3;
    frame.size.height = 3;
    [aView setFrame:frame];
    return aCell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    typeId 1 = Link: sends user to the provided URL and open it in native browser
//    typeId 2 = Form: displays form within the app
//    typeId 2 = Make A Suggestion: displays form within the app
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
