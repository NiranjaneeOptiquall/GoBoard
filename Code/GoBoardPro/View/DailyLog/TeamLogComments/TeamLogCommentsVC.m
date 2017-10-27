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


@interface TeamLogCommentsVC ()

@end

@implementation TeamLogCommentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self doInitialSettings];
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

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

#pragma mark - Action Methods


- (IBAction)btnBackTapped:(id)sender {
    
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
    
    CGSize newSize = [self.txtViewLog sizeThatFits:constrainedSize];
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
