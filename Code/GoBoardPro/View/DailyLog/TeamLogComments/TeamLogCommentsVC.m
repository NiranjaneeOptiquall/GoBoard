//
//  TeamLogCommentsVC.m
//  GoBoardPro
//
//  Created by E2M183 on 2/11/16.
//  Copyright © 2016 IndiaNIC. All rights reserved.
//

#import "TeamLogCommentsVC.h"
#import "TeamLogCell.h"
#import "TeamSubLog.h"
#import "User.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "ClientPositions.h"
#import "Reachability.h"

#define kTextLimit 1000

#import "SOPViewController.h"
#import "AccidentReportViewController.h"
#import "IncidentDetailViewController.h"
#import "DynamicFormsViewController.h"
#import "ERPDetailViewController.h"
#import "EmergencyResponseViewController.h"

@interface TeamLogCommentsVC ()<UIWebViewDelegate>
{
    NSMutableArray * allDataForLinkedSopErp;
    
}

@end

@implementation TeamLogCommentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self doInitialSettings];
    _webView.scrollView.scrollEnabled = NO;

    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

}
-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    

}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

-(void)viewWillDisappear:(BOOL)animated
{
   // [[NSNotificationCenter defaultCenter]removeObserver:self forKeyPath:UIKeyboardWillShowNotification];
  //  [[NSNotificationCenter defaultCenter]removeObserver:self forKeyPath:UIKeyboardWillHideNotification];
    
    [super viewWillDisappear:animated];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



// Implement loadView to create a view hierarchy programmatically, without using a nib.


#pragma mark - UITableView DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  return UITableViewAutomaticDimension;
 TeamSubLog *log = [self.mutArrComments  objectAtIndex:indexPath.row];
    NSDictionary *aDicAttribute=@{NSFontAttributeName :[UIFont boldSystemFontOfSize:17]};
    NSString * htmlString = log.desc;
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    UILabel * lblTemp = [[UILabel alloc]init];
    lblTemp.attributedText = attributedString;
    CGFloat aHeight = [lblTemp.text boundingRectWithSize:CGSizeMake(664, 9999) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:aDicAttribute context:kNilOptions].size.height;
    
    if (aHeight < 30)
    {
        aHeight = 30;
    }
    return aHeight + 50;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewAutomaticDimension;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mutArrComments  count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamLogCell *aCell = (TeamLogCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    [aCell setBackgroundColor:[UIColor clearColor]];
     aCell.webViewDesc.scrollView.scrollEnabled = NO;
    TeamSubLog *log = [self.mutArrComments  objectAtIndex:indexPath.row];
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"MM/dd/yyyy  hh:mm a"];
    
    [aCell.lblDate setText:[aFormatter stringFromDate:log.date]];
    
    NSString * htmlString = log.desc;
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
  //  [aCell.lblDescription setText:log.desc];
      [aCell.lblDescription setAttributedText:attributedString];
     [aCell.webViewDesc loadHTMLString:htmlString baseURL:nil];
    NSString *aStrName = [NSString stringWithFormat:@"%@",log.username];
    [aCell.lblUserName setText:aStrName];

   return aCell;
}

-(void)getLinkedSopData:(NSArray*)dataDic{
    
    for (NSMutableDictionary * tempDic in dataDic) {
        if ([[tempDic valueForKey:@"Children"] count] ==0) {
            
            [allDataForLinkedSopErp addObject:tempDic];
            
        }
        else{
            [self getLinkedSopData:[tempDic valueForKey:@"Children"]];
        }
    }
    
}

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType
//{
//
//    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
//        [[UIApplication sharedApplication] openURL:[inRequest URL]];
//        return NO;
//    }
//
//    return YES;
//}
{
    
    NSURL *url = [inRequest URL];
    NSString * strUrl = [NSString stringWithFormat:@"%@",url];
    NSLog(@"%@",strUrl);
    if ( [strUrl containsString:@"IsLinked=true"]) {
        //  NSLog(@"linked type");
        if ([strUrl containsString:@"SOPs"]) {
            NSLog(@"linked type SOPs");
            
            NSRange r1 = [strUrl rangeOfString:@"id="];
            NSRange r2 = [strUrl rangeOfString:@"&"];
            NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
            NSString *sopId = [strUrl substringWithRange:rSub];
            
            [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@",SOP_CATEGORY, [[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:SOP_CATEGORY] complition:^(NSDictionary *response) {
                
                
                SOPViewController *sopView = [self.storyboard instantiateViewControllerWithIdentifier:@"SOPViewController"];
                allDataForLinkedSopErp= [[NSMutableArray alloc]init];
                for (NSMutableDictionary * tempDic in [response valueForKey:@"SopCategories"]) {
                    [allDataForLinkedSopErp addObject:tempDic];
                }
                for (NSMutableDictionary * tempDic in [response valueForKey:@"SopCategories"]) {
                    [allDataForLinkedSopErp addObject:tempDic];
                }
                
                [self getLinkedSopData:[response valueForKey:@"SopCategories"]];
                
                for (int i = 0; i<allDataForLinkedSopErp.count; i++) {
                    if ([[NSString stringWithFormat:@"%@",[[allDataForLinkedSopErp valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:sopId]) {
                        sopView.dictSOPCategory = [allDataForLinkedSopErp objectAtIndex:i];
                    }
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (sopView.dictSOPCategory == nil) {
                        alert(@"", @"This link is broken or no longer exists.");
                        return;
                    }else{
                        sopView.mutArrCategoryHierarchy = [NSMutableArray array];
                        [sopView.mutArrCategoryHierarchy addObject:sopView.dictSOPCategory];
                        sopView.isBtnSOPListHidden = YES;
                        [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"NOTE"];

                        [self.navigationController pushViewController:sopView animated:YES];
                    }
                    
                });
                
                
            } failure:^(NSError *error, NSDictionary *response) {
                
            }];
            
        }
        else if ([strUrl containsString:@"ERP"]) {
            NSLog(@"linked type erp");
            
            NSRange r1 = [strUrl rangeOfString:@"id="];
            NSRange r2 = [strUrl rangeOfString:@"&"];
            NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
            NSString *sopId = [strUrl substringWithRange:rSub];
            
            [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@/%@", ERP_CATEGORY, [[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:ERP_CATEGORY] complition:^(NSDictionary *response) {
                
                EmergencyResponseViewController *erpView = [self.storyboard instantiateViewControllerWithIdentifier:@"ERPViewController"];
                allDataForLinkedSopErp= [[NSMutableArray alloc]init];
                for (NSMutableDictionary * tempDic in [response valueForKey:@"ErpCategories"]) {
                    [allDataForLinkedSopErp addObject:tempDic];
                }
                [self getLinkedSopData:[response valueForKey:@"ErpCategories"]];
                
                for (int i = 0; i<allDataForLinkedSopErp.count; i++) {
                    if ([[NSString stringWithFormat:@"%@",[[allDataForLinkedSopErp valueForKey:@"Id"] objectAtIndex:i]] isEqualToString:sopId]) {
                        erpView.dictERPCategory = [allDataForLinkedSopErp objectAtIndex:i];
                    }
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (erpView.dictERPCategory == nil) {
                        alert(@"", @"This link is broken or no longer exists.");
                        return;
                    }else{
                        erpView.mutArrCategoryHierarchy = [NSMutableArray array];
                        [erpView.mutArrCategoryHierarchy addObject:erpView.dictERPCategory];
                        erpView.isBtnERPListHidden = YES;
                        [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"NOTE"];

                        [self.navigationController pushViewController:erpView animated:YES];
                    }
                    
                });
                
                
            } failure:^(NSError *error, NSDictionary *response) {
                
            }];
            
        }
        else if ([strUrl containsString:@"Accident"]) {
            NSLog(@"linked type Accident");
            AccidentReportViewController * acciView = [self.storyboard instantiateViewControllerWithIdentifier:@"AccidentReportViewController"];
            [self.navigationController pushViewController:acciView animated:YES];
        }
        else if ([strUrl containsString:@"Incident"]) {
            
            if ([strUrl containsString:@"Misconduct"]) {
                NSLog(@"linked type Misconduct");
                IncidentDetailViewController * inciView = [self.storyboard instantiateViewControllerWithIdentifier:@"IncidentDetailViewController"];
                inciView.incidentType = 1;
                [self.navigationController pushViewController:inciView animated:YES];
            }
            else if ([strUrl containsString:@"CustomerService"]) {
                NSLog(@"linked type CustomerService");
                IncidentDetailViewController * inciView = [self.storyboard instantiateViewControllerWithIdentifier:@"IncidentDetailViewController"];
                inciView.incidentType = 2;
                [self.navigationController pushViewController:inciView animated:YES];
                
            }
            else if ([strUrl containsString:@"Other"]) {
                NSLog(@"linked type Other");
                IncidentDetailViewController * inciView = [self.storyboard instantiateViewControllerWithIdentifier:@"IncidentDetailViewController"];
                inciView.incidentType = 3;
                [self.navigationController pushViewController:inciView animated:YES];
                
            }
        }
        else if ([strUrl containsString:@"Survey"]) {
            NSLog(@"linked type Survey");
            NSRange r1 = [strUrl rangeOfString:@"surveyId="];
            NSRange r2 = [strUrl rangeOfString:@"&"];
            NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
            NSString *surveyId = [strUrl substringWithRange:rSub];
            
            [[WebSerivceCall webServiceObject] callServiceForSurvey:NO linkedSurveyId:surveyId complition:^{
                DynamicFormsViewController * formView = [self.storyboard instantiateViewControllerWithIdentifier:@"DYFormsView"];
                
                NSString *strSurveyUserType = @"1";
                if ([User checkUserExist]) {
                    strSurveyUserType = @"2";
                }
                NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SurveyList"];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userTypeId ==[CD] %@",strSurveyUserType];
                
                
                [request setPredicate:predicate];
                
                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
                NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"surveyId" ascending:YES];
                
                [request setSortDescriptors:@[sort,sort1]];
                NSMutableArray * mutArrFormList = [NSMutableArray arrayWithArray:[gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil]];
                NSLog(@"%@",mutArrFormList);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (mutArrFormList.count == 0) {
                        alert(@"", @"This link is broken or no longer exists.");
                        return;
                    }
                    else{
                        formView.objFormOrSurvey = [mutArrFormList objectAtIndex:0];
                        
                        formView.isSurvey = YES;
                        
                        [self.navigationController pushViewController:formView animated:YES];
                    }
                });
                
                
            }];
        }
        else if ([strUrl containsString:@"Form"]) {
            
            NSLog(@"linked type Form");
            NSRange r1 = [strUrl rangeOfString:@"formId="];
            NSRange r2 = [strUrl rangeOfString:@"&"];
            NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
            NSString *formId = [strUrl substringWithRange:rSub];
            
            [[WebSerivceCall webServiceObject] callServiceForForms:NO linkedFormId:formId complition:^{
                DynamicFormsViewController * formView = [self.storyboard instantiateViewControllerWithIdentifier:@"DYFormsView"];
                
                NSString *strSurveyUserType = @"1";
                if ([User checkUserExist]) {
                    strSurveyUserType = @"2";
                }
                NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"FormsList"];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userTypeId ==[CD] %@ AND NOT (typeId ==[cd] %@)",strSurveyUserType,[NSString stringWithFormat:@"%d", 3]];
                [request setPredicate:predicate];
                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
                NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"formId" ascending:YES];
                [request setSortDescriptors:@[sort,sort1]];
                NSMutableArray *mutArrFormList = [NSMutableArray arrayWithArray:[gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil]];
                NSLog(@"%@",mutArrFormList);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (mutArrFormList.count == 0) {
                        alert(@"", @"This link is broken or no longer exists.");
                        return;
                    }
                    else{
                        formView.objFormOrSurvey = [mutArrFormList objectAtIndex:0];
                        
                        formView.isSurvey = NO;
                        
                        [self.navigationController pushViewController:formView animated:YES];
                    }
                });
                
                
            }];
            
            
        }
        return NO;
    }
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        //        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        //        return NO;
    
        [gblAppDelegate showActivityIndicator];
        
        NSIndexPath* indexPathLoad = [NSIndexPath indexPathForRow:webView.tag inSection:0];
        
        if (popOver) {
            [popOver dismissPopoverAnimated:NO];
            popOver.contentViewController.view = nil;
            popOver = nil;
        }
        
        
        [_webViewPopOver loadRequest:inRequest];
        
        UIViewController *viewController = [[UIViewController alloc] init];
        viewController.view = _vwPopOver;
        popOver = [[UIPopoverController alloc] initWithContentViewController:viewController];
        viewController = nil;
        [popOver setDelegate:self];
        [popOver setPopoverContentSize:_vwPopOver.frame.size];
        CGRect frame = _webView.frame;
        [popOver presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        return NO;
        
    }

    return YES;
}
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [_webViewPopOver loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    popOver.contentViewController.view = nil;
    popOver = nil;
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{

   [gblAppDelegate hideActivityIndicator];
    
    CGRect frame = _webView.frame;
    CGSize fittingSize = [_webView sizeThatFits:_webView.scrollView.contentSize];
    frame.size = fittingSize;
    _webView.frame = frame;
    _cnstwebViewLogHeight.constant = frame.size.height;
    
    
//    rowHeight = frame.size.height + 109;
//    
//    if ([arrLoadedIndex containsObject:indexPathLoad]) {
//        
//    }
//    else{
//        [arrLoadedIndex addObject:indexPathLoad];
//        [arrRowHeight replaceObjectAtIndex:indexPathLoad.row withObject:[NSString stringWithFormat:@"%f",rowHeight]];
//        
//        NSLog(@"%@",arrRowHeight);
//        
//        [_tblViewteamLog reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathLoad, nil] withRowAnimation:NO];
//    }
//    
    
}

#pragma mark - Action Methods


- (IBAction)btnBackTapped:(id)sender {
    [NSUserDefaults.standardUserDefaults setValue:@"YES" forKey:@"fromCommentView"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSubmitTapped:(id)sender {
    
    if ([textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0) {
        
        if (self.teamLogObj.teamLogId.integerValue>0) {
            [self addTeamLog];
        }
        else
            alert(@"", @"Before adding comment please sync the Team Log from Home Screen once you have an internet connection.");
        
    }
    else
        alert(@"", @"Please add text for comments");

    
}

#pragma mark - Methods


-(void)doInitialSettings
{
    [self createCommentContainer];

    NSString * htmlString = self.teamLogObj.desc;
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
 //   self.txtViewLog.text = self.teamLogObj.desc;
     self.txtViewLog.attributedText = attributedString;
    [_webView loadHTMLString:htmlString baseURL:nil];
    self.mutArrComments = [NSMutableArray array];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSMutableArray *aMutArrTemp = [[NSMutableArray alloc]initWithArray:[self.teamLogObj.teamSubLog.allObjects sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]]];
    [self.mutArrComments addObjectsFromArray:aMutArrTemp];

    self.lblPosition.text = [self getPoistionForLog:self.teamLogObj];
    
    if ([self.teamLogObj.teamSubLog allObjects].count==0) {
        self.lblNoRecords.hidden = NO;
    }
    else
        self.lblNoRecords.hidden = YES;
    
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    [aFormatter setDateFormat:@"MM/dd/yyyy  hh:mm a"];
    self.lblDate.text = [aFormatter stringFromDate:self.teamLogObj.date];
    
    float aFloatWidth = kScreenWidth-16;
    
    CGSize constrainedSize = CGSizeMake(aFloatWidth, 9999);
    
  //  CGSize newSize = [self.txtViewLog sizeThatFits:constrainedSize];
      CGSize newSize = [self.webView sizeThatFits:constrainedSize];
    self.cnstTxtViewLogHeight.constant = newSize.height;
    [self.view layoutIfNeeded];
}


-(NSString *)getPoistionForLog:(TeamLog *)aLog
{
    NSEntityDescription *aEntity = [NSEntityDescription entityForName:@"ClientPositions" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    NSFetchRequest *aRequest = [[NSFetchRequest alloc]init];
    [aRequest setEntity:aEntity];
    [aRequest setPredicate:[NSPredicate predicateWithFormat:@"positionId ==[cd] %@", aLog.positionId]];
    NSArray *aArrPositions = [gblAppDelegate.managedObjectContext executeFetchRequest:aRequest error:nil];
    if (aArrPositions.count>0) {
        ClientPositions *aPosition = aArrPositions[0];
        return aPosition.name;
    }
    else
        return @"";
    
}

- (void)createCommentContainer {
  
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height -116, self.view.frame.size.width, 70)];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
 //   containerView.frame = CGRectMake(0, self.view.frame.size.height - 70, self.view.frame.size.width, 70);
    
    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, self.view.frame.size.width-12, 70)];
    textView.translatesAutoresizingMaskIntoConstraints = NO;
//    [textView setFrame:CGRectMake(6, 3, self.view.frame.size.width-150, 70)];
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 6;
    // you can also set the maximum height in points with maxHeight
     textView.maxHeight = 200.0f;
    textView.returnKeyType = UIReturnKeyDefault; //just as an example
    textView.font = [UIFont systemFontOfSize:15.0f];
    textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeholder = @"Add Comments here";
    textView.layer.cornerRadius = 5.0;
    // textView.text = @"test\n\ntest";
    // textView.animateHeightChange = NO; //turns off animation
    
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [containerView addSubview:textView];
    
    
    lblCount = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50,38, 50, 30)];
    lblCount.backgroundColor = [UIColor clearColor];
    lblCount.textColor = [UIColor whiteColor];
    lblCount.translatesAutoresizingMaskIntoConstraints = YES;
    lblCount.frame =CGRectMake(self.view.frame.size.width-50,containerView.frame.size.height-35, 50, 30);
    lblCount.text = @"1000";
    
    lblCount.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;

    
    [containerView addSubview:lblCount];
    
   // [containerView addSubview:doneBtn];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [containerView setBackgroundColor:[UIColor blackColor]];
    
    
    [self.view addSubview:containerView];

}
- (BOOL)isNetworkReachable {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];//[Reachability reachabilityWithHostName:@"http://www.google.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if (remoteHostStatus == NotReachable) {
        return NO;
    }
    return YES;
}

-(void)addTeamLog
{
    if ([self isNetworkReachable]) {
   
    
    TeamSubLog *aLog = [NSEntityDescription insertNewObjectForEntityForName:@"TeamSubLog" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    aLog.desc = textView.text;
    aLog.userId = [[User currentUser] userId];
    //[aFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    aLog.date =[NSDate date];
    aLog.shouldSync = [NSNumber numberWithBool:NO];
    aLog.username = [[User currentUser]username];
    [self.teamLogObj addTeamSubLogObject:aLog];
    
    [gblAppDelegate.managedObjectContext insertObject:aLog];
    [gblAppDelegate.managedObjectContext save:nil];
    [self.mutArrComments addObject:aLog];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSMutableArray *aMutArrTemp = [[NSMutableArray alloc]initWithArray:[self.mutArrComments sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]]];
    [self.mutArrComments removeAllObjects];
    [self.mutArrComments addObjectsFromArray:aMutArrTemp];
    aMutArrTemp = nil;
    
    [self.tblViewComments reloadData];
    
    textView.text = @"";
    
    self.lblNoRecords.hidden = YES;
    
    [self callWebserviceToAddTeamLogWithTeamLogObject:aLog];
    }
    else{
        alert(@"",MSG_NO_INTERNET);
    }
}


-(void)resignTextView
{
    [textView resignFirstResponder];
}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    
    
    // commit animations
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerView.frame.size.height - 60;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
}
//- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
//{
//   
//    return YES;
//}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    containerView.frame = r;
    
    lblCount.frame =CGRectMake(self.view.frame.size.width-50,containerView.frame.size.height-35, 50, 30);

}
- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    lblCount.text = [NSString stringWithFormat:@"%u",kTextLimit - [[textView text] length]];

}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return growingTextView.text.length + (text.length - range.length) <= kTextLimit;
}


#pragma mark - Webservice Call

-(void)callWebserviceToAddTeamLogWithTeamLogObject:(TeamSubLog *)aObj
{
    
    
    //"2016-02-11 06:45:45 PM";
    NSString *aParamDate = [gblAppDelegate getUTCDate:aObj.date];
    
    NSString *aStrUserName =[[User currentUser]username];
    
    NSDictionary *aDictParams = @{@"Id":@"0",
                                  @"FacilityId":self.teamLogObj.facilityId,
                                  @"PositionId":self.teamLogObj.positionId,
                                  @"IsTeamLog":[NSNumber numberWithBool:YES],
                                  @"IsAlwaysVisible":[NSNumber numberWithBool:NO],
                                  @"Date":aParamDate,
                                  @"UserId":self.teamLogObj.userId,
                                  @"DailyLogHeaderId":self.teamLogObj.teamLogId,
                                  @"Description":aObj.desc,
                                  @"UserName":aStrUserName
                                  };
    [gblAppDelegate callWebService:POSTCOMMENTS parameters:aDictParams httpMethod:@"POST" complition:^(NSDictionary *response) {
        
        alert(@"", @"Your comment on the team log is submitted successfully")

        
    } failure:^(NSError *error, NSDictionary *response) {
        
        alert(@"", MSG_ADDED_TO_SYNC);
        aObj.shouldSync = [NSNumber numberWithBool:YES];
        [gblAppDelegate.managedObjectContext save:nil];
    }];
}


@end
