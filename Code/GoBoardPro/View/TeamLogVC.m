//
//  TeamLogVC.m
//  GoBoardPro
//
//  Created by E2M183 on 2/10/16.
//  Copyright © 2016 IndiaNIC. All rights reserved.
//

#import "TeamLogVC.h"
#import <CoreData/CoreData.h>
#import "User.h"
#import "Constants.h"
#import "TeamLog+CoreDataProperties.h"
#import "UserHomeViewController.h"
#import "DailyLogViewController.h"
#import "TeamLogCell.h"
#import "TeamLogCommentsVC.h"
#import "ClientPositions.h"
#import "objc/runtime.h"

#define kIndex @"Index"

#import "SOPViewController.h"
#import "AccidentReportViewController.h"
#import "IncidentDetailViewController.h"
#import "DynamicFormsViewController.h"
#import "ERPDetailViewController.h"
#import "EmergencyResponseViewController.h"


@interface TeamLogVC ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    WebSerivceCall * webCall;
    CGFloat rowHeight;
    NSMutableArray * arrLoadedIndex,*arrRowHeight;
    NSMutableArray * allDataForLinkedSopErp;

//    NSIndexPath *indexPathLoad;
}
@end

@implementation TeamLogVC

- (void)viewDidLoad {
    [super viewDidLoad];
    arrLoadedIndex = [[NSMutableArray alloc] init];
      arrRowHeight = [[NSMutableArray alloc] init];
    rowHeight = 150;
   // webCall=[[WebSerivceCall alloc]init];
   // [webCall callServiceForTeamLog:YES complition:nil];
//    [self doInitialSettings];
  _mutArrTeamLog=[NSMutableArray new];
    self.tblViewteamLog.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    arrLoadedIndex = [[NSMutableArray alloc] init];
    arrRowHeight = [[NSMutableArray alloc] init];
    rowHeight = 150;
      self.tblViewteamLog.hidden = YES;
   // [self.tblViewteamLog reloadData];
    [gblAppDelegate showActivityIndicator];
    [[WebSerivceCall webServiceObject] callServiceForTeamLog:YES complition:^{
        [self doInitialSettings];
        self.tblViewteamLog.hidden = NO;
        [self.tblViewteamLog reloadData];
        [gblAppDelegate hideActivityIndicator];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSIndexPath *aIndexPath = objc_getAssociatedObject(sender, kIndex);
    
    TeamLogCommentsVC *aVCObj = segue.destinationViewController;
    aVCObj.teamLogObj = self.mutArrTeamLog[aIndexPath.row];
}



#pragma mark - UITableView DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//   // return UITableViewAutomaticDimension;
//   TeamLog *log = [self.mutArrTeamLog objectAtIndex:indexPath.row];
//    
//    NSDictionary *aDicAttribute=@{NSFontAttributeName :[UIFont boldSystemFontOfSize:17]};
//    NSString * htmlString = log.desc;
//    NSAttributedString *attributedString = [[NSAttributedString alloc]
//                                            initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
//                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
//                                            documentAttributes: nil
//                                            error: nil
//                                            ];
//    UILabel * lblTemp = [[UILabel alloc]init];
//    lblTemp.attributedText = attributedString;
//    CGFloat aHeight = [lblTemp.text boundingRectWithSize:CGSizeMake(664, 9999) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:aDicAttribute context:kNilOptions].size.height;
//    
//    if (aHeight < 40)
//    {
//        aHeight = 40;
//    }
//    return aHeight + 90;


    return [[arrRowHeight objectAtIndex:indexPath.row] integerValue];

    
    }

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewAutomaticDimension;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mutArrTeamLog count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamLogCell *aCell = (TeamLogCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    [aCell setBackgroundColor:[UIColor clearColor]];
    
    TeamLog *log = [self.mutArrTeamLog objectAtIndex:indexPath.row];
    NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
    //[aFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
    [aFormatter setDateFormat:@"MM/dd/yyyy  hh:mm a"];
     aCell.webViewDesc.scrollView.scrollEnabled = NO;
    [aCell.txtViewDate setText:[aFormatter stringFromDate:log.date]];
  
    NSString * htmlString = log.desc;
//    NSAttributedString *attributedString = [[NSAttributedString alloc]
//                                            initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
//                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
//                                            documentAttributes: nil
//                                            error: nil
//                                            ];
//   // [aCell.lblDescription setText:log.desc];
//     [aCell.lblDescription setAttributedText:attributedString];
    NSLog(@"%@",htmlString);
    [aCell.webViewDesc loadHTMLString:htmlString baseURL:nil];
    aCell.webViewDesc.tag = indexPath.row;
   // NSString *aStrName = [NSString stringWithFormat:@"%@ %@",[[User currentUser]firstName],[[User currentUser]lastName]];
    [aCell.txtViewUsername setText:log.username];
    
    aCell.txtViewPosition.text = [self getPoistionForLog:log];

    aCell.txtViewPosition.textContainerInset = UIEdgeInsetsZero;
    aCell.txtViewDate.textContainerInset = UIEdgeInsetsMake(0, 0, 0, -5);
    aCell.txtViewUsername.textContainerInset = UIEdgeInsetsMake(0, -5, 0, 0);

    aCell.cnstTextViewDateHeight.constant = [self getHeightFromText:aCell.txtViewDate.text txtView:aCell.txtViewDate].height;
    aCell.cnstTextViewPositionHeight.constant = [self getHeightFromText: aCell.txtViewPosition.text txtView:aCell.txtViewPosition].height;
    aCell.cnstTxtViewUserNameHeight.constant = [self getHeightFromText: aCell.txtViewUsername.text txtView:aCell.txtViewUsername].height;
    
    float aMaxFloat  = MAX(MAX(aCell.cnstTextViewDateHeight.constant, aCell.cnstTextViewPositionHeight.constant), aCell.cnstTxtViewUserNameHeight.constant);
    aCell.cnstLblDescriptionTop.constant = aCell.txtViewPosition.frame.origin.y+aMaxFloat+12;
     aCell.cnstWebDescriptionTop.constant = aCell.txtViewPosition.frame.origin.y+aMaxFloat+12;
     // aCell.cnstWebDescriptionHeight.constant = [self getHeightFromText:aCell.lblDescription.text txtView:aCell.txtViewDate].height;
   // if (aCell.cnstWebDescriptionHeight.constant < 40) {
  //      aCell.cnstWebDescriptionHeight.constant = 40;
  //  }
   // else{
  //      aCell.cnstWebDescriptionHeight.constant = aCell.cnstWebDescriptionHeight.constant + 20;
  //  }
    

    aCell.lblUserName.text = log.username;
    
    
    if (log.teamSubLog.allObjects.count>0) {
        [aCell.btnViewComments setTitle:@"View Comments" forState:UIControlStateNormal];
    }
    else
        [aCell.btnViewComments setTitle:@"Add Comment" forState:UIControlStateNormal];
    
    objc_setAssociatedObject(aCell.btnViewComments,kIndex, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    aCell.lblDescription.hidden = YES;

//    CGRect frame = aCell.frame;
//    frame.size.height  = aCell.webViewDesc.frame.origin.y + aCell.webViewDesc.frame.size.height + 70;
//    aCell.frame = frame;
    //---------------------------------
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
        UITableViewCell *aCell = [_tblViewteamLog cellForRowAtIndexPath:indexPathLoad];
        CGRect frame = [_tblViewteamLog convertRect:aCell.frame toView:self.view];
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
//    CGPoint viewCenterRelativeToTableview = [_tblViewteamLog convertPoint:CGPointMake(CGRectGetMidX(webView.bounds), CGRectGetMidY(webView.bounds)) fromView:webView];
 // NSIndexPath * indexPathLoad = [_tblViewteamLog indexPathForRowAtPoint:viewCenterRelativeToTableview];
   
    [gblAppDelegate hideActivityIndicator];
    
    NSIndexPath* indexPathLoad = [NSIndexPath indexPathForRow:webView.tag inSection:0];

    TeamLogCell *aCell = [_tblViewteamLog cellForRowAtIndexPath:indexPathLoad];


CGFloat height= [[aCell.webViewDesc stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
       NSLog(@"%f",height);
    
    
    CGRect frame = aCell.webViewDesc.frame;
    CGSize fittingSize = [aCell.webViewDesc sizeThatFits:aCell.webViewDesc.scrollView.contentSize];
    frame.size = fittingSize;
    frame.size.height = height;
    aCell.webViewDesc.frame = frame;
    aCell.cnstWebDescriptionHeight.constant = frame.size.height;
    rowHeight = frame.size.height + 150;
    
    
    if ([arrLoadedIndex containsObject:indexPathLoad]) {
        
    }
    else{
        [arrRowHeight replaceObjectAtIndex:indexPathLoad.row withObject:[NSString stringWithFormat:@"%f",rowHeight]];
        
        NSLog(@"%@",arrRowHeight);


        if ([_tblViewteamLog.indexPathsForVisibleRows containsObject:indexPathLoad]) {
            [arrLoadedIndex addObject:indexPathLoad];
            
            [_tblViewteamLog reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathLoad, nil] withRowAnimation:NO];

        }
   
         }

    
}
#pragma mark - Other Methods

- (CGSize)getHeightFromText:(NSString *)str txtView:(UITextView *)aTxtView{
    
    float aFloatWidth = (kScreenWidth - (37*2)-(4*10))/3;
    
    CGSize constrainedSize = CGSizeMake(aFloatWidth, 9999);
    
    CGSize newSize = [aTxtView sizeThatFits:constrainedSize];
   // CGRect newFrame = aTxtView.frame;
   // newFrame.size = CGSizeMake(fmaxf(newSize.width,aFloatWidth), newSize.height);
    return newSize;
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

#pragma mark - Methods

-(void)doInitialSettings
{
    self.mutArrTeamLog = [NSMutableArray array];

    [self fetchTeamLog];
}

- (void)fetchTeamLog {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"TeamLog"];
    
 //   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(isTeamLog==%@) AND (shouldSync==%@)",@1,@0];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(isTeamLog==%@)",@1];

//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"positionId CONTAINS %@ AND positionId != nil",@1];    aObj.shouldSync = [NSNumber numberWithBool:YES];

    [request setPredicate:predicate];
    
    self.mutArrTeamLog = [NSMutableArray arrayWithArray:[gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil]];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSMutableArray *aMutArrTemp = [[NSMutableArray alloc]initWithArray:[self.mutArrTeamLog sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]]];
    [self.mutArrTeamLog removeAllObjects];
    [self.mutArrTeamLog addObjectsFromArray:aMutArrTemp];
    
    NSMutableArray *aMutArrRemove = [NSMutableArray array];
    NSLog(@"%@",self.mutArrTeamLog);
    for (TeamLog *aTeamLog in self.mutArrTeamLog) {
        NSString *aCurrentUser = [[User currentUser]userId];
        if (![aTeamLog.userId isEqualToString:aCurrentUser] && aTeamLog.shouldSync.integerValue==1) {
            [aMutArrRemove addObject:aTeamLog];
        }
    }
    
    [self.mutArrTeamLog removeObjectsInArray:aMutArrRemove];
    
    aMutArrTemp = nil;
    
    [self.mutArrTeamLog sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]];
    if ([self.mutArrTeamLog count] == 0) {
        [_lblNoRecords setHidden:NO];
    }
    arrRowHeight = [[NSMutableArray alloc]init];
    for (int i = 0; i<_mutArrTeamLog.count; i++) {
        [arrRowHeight insertObject:@"150" atIndex:i];
    }
    NSLog(@"%@",arrRowHeight);
}


#pragma mark - Action Methods

- (IBAction)toggleDailyLogBtnAction:(id)sender {
    

    NSMutableArray *aMutArrVC = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    for (UIViewController *aVCObj in self.navigationController.viewControllers) {
        if ([aVCObj isKindOfClass:[DailyLogViewController class]]) {
            [aMutArrVC removeObject:aVCObj];
        }
    }
    
    self.navigationController.viewControllers = aMutArrVC;
    
    UIStoryboard *aStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DailyLogViewController *aDailyLogVC = [aStoryboard instantiateViewControllerWithIdentifier:@"DailyLogViewController"];
    [self.navigationController pushViewController:aDailyLogVC animated:YES];
}

- (IBAction)btnBackTapped:(id)sender {
    
    
    for (UIViewController *aVCObj in self.navigationController.viewControllers) {
        if ([aVCObj isKindOfClass:[UserHomeViewController class]]) {
            
            [self.navigationController popToViewController:aVCObj animated:YES];
        }
    }
}

- (IBAction)btnViewCommentsTapped:(id)sender {

    [self performSegueWithIdentifier:@"TeamLogComments" sender:sender];
}



@end
