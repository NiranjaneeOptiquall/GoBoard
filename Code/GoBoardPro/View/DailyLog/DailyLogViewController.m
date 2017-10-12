 //
//  DailyLogViewController.m
//  GoBoardPro
//
//  Created by ind558 on 10/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "DailyLogViewController.h"
#import "DailyLog.h"
#import "TeamLog+CoreDataProperties.h"
#import "TeamLogVC.h"
#import "UserHomeViewController.h"
#import "TeamLogTrace.h"
#import "ClientPositions.h"
#import "WebSerivceCall.h"
#import "Reachability.h"
#import "facilityListingTableViewCell.h"
#define kTextLimit 1000

@interface DailyLogViewController ()
{
    WebSerivceCall * webCall;
    
}

@end

@implementation DailyLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedFacilityArr = [[NSMutableArray alloc]init];
    self.btnToggleTeam.selected = NO;
    [self.viewSelectPos setAlpha:0.0];
 [self.tblFacilityListing setAlpha:0.0];
    [self getFacilityList];
    CGRect btnframe = self.btnSubmit.frame;
    self.btnSubmit.frame = CGRectMake(btnframe.origin.x, self.btnToggleTeam.frame.origin.y + self.btnToggleTeam.frame.size.height + 15, btnframe.size.width, btnframe.size.height);

    CGRect lblMyLogframe = self.lblMyLog.frame;
    self.lblMyLog.frame = CGRectMake(lblMyLogframe.origin.x, self.btnSubmit.frame.origin.y + self.btnSubmit.frame.size.height + 10, lblMyLogframe.size.width, lblMyLogframe.size.height);
    
    CGRect tblDailyLogframe = self.tblDailyLog.frame;
    CGFloat height = self.view.frame.size.height - (self.lblMyLog.frame.origin.y + self.lblMyLog.frame.size.height + 10) - 77;
    self.tblDailyLog.frame = CGRectMake(tblDailyLogframe.origin.x, self.lblMyLog.frame.origin.y + self.lblMyLog.frame.size.height + 10, tblDailyLogframe.size.width, height);

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [tap setCancelsTouchesInView:NO];

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{    [super viewWillAppear:animated];
    [gblAppDelegate showActivityIndicator];
    [[WebSerivceCall webServiceObject] callServiceForTeamLog:YES complition:^{
        [self doInitialSettings];
        [self.tblDailyLog reloadData];
      
        
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChangeNotification:) name:UITextViewTextDidChangeNotification object:self.txvDailyLog];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}
-(void)dismissKeyboard
{
    [_txvDailyLog resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBActions

- (IBAction)btnBackTapped:(UIButton *)sender {
    for (UIViewController *aVCObj in self.navigationController.viewControllers) {
        if ([aVCObj isKindOfClass:[UserHomeViewController class]]) {
            [self.navigationController popToViewController:aVCObj animated:YES];
        }
    }
}

- (IBAction)btnSubmitTapped:(id)sender {
   
    if ([[_txvDailyLog.text trimString] isEqualToString:@""]) {
        alert(@"", @"Please enter log detail.");
        return;
    }
    [self.txvDailyLog resignFirstResponder];
 
    if (self.btnToggleTeam.selected) {
        if (selectedFacilityArr.count == 0) {
            alert(@"", @"Please select at least one facility/team for the team log");
            return;
        }
        if ([self.txvDailyLog.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0) {
            if (self.txtPosition.text.length>0) {
                [self addTeamLog];
            }
            else
            {
                alert(@"", @"Please select position for the team log");
            }
        }

        
    }
    else
    {
        if ([self.txvDailyLog.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0) {
                [self addDailyLog];
        }
    }
   
}
- (void)insertDailyLog {
    
    TeamLog *aTeamLogObj = [NSEntityDescription insertNewObjectForEntityForName:@"TeamLog" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        aTeamLogObj.facilityId = [[[User currentUser]selectedFacility] value];
        aTeamLogObj.positionId = @"0";
        aTeamLogObj.teamLogId =@0;
        aTeamLogObj.userId = [[User currentUser] userId];
        aTeamLogObj.isTeamLog = @"0";
        aTeamLogObj.desc =  _txvDailyLog.text;
        aTeamLogObj.username =[[User currentUser]username];
        aTeamLogObj.headerId = @"";
        aTeamLogObj.includeInEndOfDayReport = @"false";
        aTeamLogObj.date =[NSDate date];
    if ([self isNetworkReachable]) {
        aTeamLogObj.shouldSync = [NSNumber numberWithBool:NO];

    }
    else{
        aTeamLogObj.shouldSync = [NSNumber numberWithBool:YES];
    }
    [gblAppDelegate.managedObjectContext save:nil];
    

}

-(void)insertTeamLog{
    TeamLog *aTeamLogObj = [NSEntityDescription insertNewObjectForEntityForName:@"TeamLog" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    aTeamLogObj.facilityId = [[[User currentUser]selectedFacility] value];
    aTeamLogObj.positionId = [[self getPoistion:self.txtPosition.text]stringValue];
    aTeamLogObj.teamLogId =@0;
    aTeamLogObj.userId = [[User currentUser] userId];
    aTeamLogObj.isTeamLog = @"1";
    aTeamLogObj.desc =  _txvDailyLog.text;
    aTeamLogObj.username =[[User currentUser]username];

    aTeamLogObj.headerId = @"";
    aTeamLogObj.includeInEndOfDayReport = @"false";
    aTeamLogObj.date =[NSDate date];
   // aTeamLogObj.shouldSync = [NSNumber numberWithInt:0];
    if ([self isNetworkReachable]) {
        aTeamLogObj.shouldSync = [NSNumber numberWithBool:0];
        
    }
    else{
        aTeamLogObj.shouldSync = [NSNumber numberWithBool:YES];
    }
   
    if ([selectedFacilityArr containsObject:[[[User currentUser]selectedFacility] value]]) {
    [gblAppDelegate.managedObjectContext save:nil];
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

-(void)addDailyLog
{
    [self insertDailyLog];
    DailyLog *aLog = [NSEntityDescription insertNewObjectForEntityForName:@"DailyLog" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    aLog.desc = _txvDailyLog.text;
    aLog.userId = [[User currentUser] userId];
    aLog.date =[NSDate date];
    aLog.includeInEndOfDayReport = @"false";
    aLog.shouldSync = [NSNumber numberWithBool:NO];
   // [gblAppDelegate.managedObjectContext insertObject:aLog];
    //[gblAppDelegate.managedObjectContext save:nil];

    if ([self isNetworkReachable]) {
        
    }
    else{
        aLog.shouldSync=[NSNumber numberWithBool:YES];
    }
    [mutArrDailyList addObject:aLog];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSMutableArray *aMutArrTemp = [[NSMutableArray alloc]initWithArray:[mutArrDailyList sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]]];
    [mutArrDailyList removeAllObjects];
    [mutArrDailyList addObjectsFromArray:aMutArrTemp];
    aMutArrTemp = nil;
    
    [_lblNoRecords setHidden:YES];
    
   
    [self callWebserviceToAddDailyLogWithDailyLogObject:aLog];
    _txvDailyLog.text = @"";
    [_lblLogPlaceholder setHidden:NO];
    self.lblCharacterCount.text = [NSString stringWithFormat:@"%i",kTextLimit];
   [_tblDailyLog reloadData];
   

}


-(void)addTeamLog
{
  [self insertTeamLog];
    
    TeamLog *aLog = [NSEntityDescription insertNewObjectForEntityForName:@"TeamLog" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    aLog.desc = _txvDailyLog.text;
    aLog.userId = [[User currentUser] userId];
    aLog.date = [NSDate date];
    aLog.includeInEndOfDayReport = @"0";
    aLog.shouldSync = [NSNumber numberWithBool:NO];
    aLog.username = [[User currentUser]username];
   aLog.positionId = [[self getPoistion:self.txtPosition.text]stringValue];
    aLog.facilityId = [[[User currentUser]selectedFacility] value];
    aLog.isTeamLog=@"1";
    NSString * strFacilitys = [[selectedFacilityArr valueForKey:@"description"] componentsJoinedByString:@","];
    aLog.selectedFacilities=strFacilitys;
//    [gblAppDelegate.managedObjectContext insertObject:aLog];
//    [gblAppDelegate.managedObjectContext save:nil];
    if ([selectedFacilityArr containsObject:[[[User currentUser]selectedFacility] value]]) {
          [mutArrDailyList addObject:aLog];
    }
  
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSMutableArray *aMutArrTemp = [[NSMutableArray alloc]initWithArray:[mutArrDailyList sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]]];
    [mutArrDailyList removeAllObjects];
    [mutArrDailyList addObjectsFromArray:aMutArrTemp];
    aMutArrTemp = nil;
    [_lblNoRecords setHidden:YES];
    
    [self callWebserviceToAddTeamLogWithTeamLogObject:aLog];
    self.txtPosition.text = @"";
    _txvDailyLog.text = @"";
    [_lblLogPlaceholder setHidden:NO];
    self.lblCharacterCount.text = [NSString stringWithFormat:@"%i",kTextLimit];
    if ([selectedFacilityArr containsObject:[[[User currentUser]selectedFacility] value]]) {

    [_tblDailyLog reloadData];

    }
}

-(NSNumber *)getPoistion:(NSString *)aStrPosition
{
    NSEntityDescription *aEntity = [NSEntityDescription entityForName:@"ClientPositions" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    NSFetchRequest *aRequest = [[NSFetchRequest alloc]init];
    [aRequest setEntity:aEntity];
    [aRequest setPredicate:[NSPredicate predicateWithFormat:@"name ==[cd] %@", aStrPosition]];
    NSArray *aArrPositions = [gblAppDelegate.managedObjectContext executeFetchRequest:aRequest error:nil];
    if (aArrPositions.count>0) {
        ClientPositions *aPosition = aArrPositions[0];
        return aPosition.positionId;
    }
    else
        return [NSNumber numberWithInt:0];
    
}


- (IBAction)btnToggleTeamTapped:(id)sender {
    selectedFacilityArr = [[NSMutableArray alloc]init];
     [selectedFacilityArr addObject:[[[User currentUser] selectedFacility] value]];
    self.btnToggleTeam.selected = !self.btnToggleTeam.selected;
    
    if (self.btnToggleTeam.selected) {
        [self.viewSelectPos setHidden:NO];
         [self.tblFacilityListing setHidden:NO];
        [UIView animateWithDuration:0.5 animations:^{
            [self.viewSelectPos setAlpha:1.0];
            [self.tblFacilityListing setAlpha:1.0];

            CGRect aBtnRect = self.btnSubmit.frame;
            aBtnRect.origin.y = self.viewSelectPos.frame.origin.y+self.viewSelectPos.frame.size.height+13;
            self.btnSubmit.frame = aBtnRect;
            CGRect lblMyLogframe = self.lblMyLog.frame;
            self.lblMyLog.frame = CGRectMake(lblMyLogframe.origin.x, self.btnSubmit.frame.origin.y + self.btnSubmit.frame.size.height + 10, lblMyLogframe.size.width, lblMyLogframe.size.height);
            
            CGRect tblDailyLogframe = self.tblDailyLog.frame;
            CGFloat height = self.view.frame.size.height - (self.lblMyLog.frame.origin.y + self.lblMyLog.frame.size.height + 10) - 77;
            self.tblDailyLog.frame = CGRectMake(tblDailyLogframe.origin.x, self.lblMyLog.frame.origin.y + self.lblMyLog.frame.size.height + 10, tblDailyLogframe.size.width, height);
            

        } completion:nil];
        [self.tblFacilityListing reloadData];
    }
    else
    {
        [self.viewSelectPos setHidden:NO];
           [self.tblFacilityListing setHidden:NO];
        [UIView animateWithDuration:0.5 animations:^{
            [self.viewSelectPos setAlpha:0.0];
         [self.tblFacilityListing setAlpha:1.0];
            CGRect lblMyLogframe = self.lblMyLog.frame;
            self.lblMyLog.frame = CGRectMake(lblMyLogframe.origin.x, self.btnSubmit.frame.origin.y + self.btnSubmit.frame.size.height + 10, lblMyLogframe.size.width, lblMyLogframe.size.height);
            
            CGRect tblDailyLogframe = self.tblDailyLog.frame;
            CGFloat height = self.view.frame.size.height - (self.lblMyLog.frame.origin.y + self.lblMyLog.frame.size.height + 10) - 77;
            self.tblDailyLog.frame = CGRectMake(tblDailyLogframe.origin.x, self.lblMyLog.frame.origin.y + self.lblMyLog.frame.size.height + 10, tblDailyLogframe.size.width, height);
            

        } completion:^(BOOL finished) {
            if (finished) {
                self.viewSelectPos.hidden = YES;
                  self.tblFacilityListing.hidden = YES;
                [UIView animateWithDuration:0.5 animations:^{
                 //   CGRect aBtnRect = self.btnSubmit.frame;
                  //  aBtnRect.origin.y = self.viewSelectPos.frame.origin.y;
                  //  self.btnSubmit.frame = aBtnRect;
                    CGRect btnframe = self.btnSubmit.frame;
                    self.btnSubmit.frame = CGRectMake(btnframe.origin.x, self.btnToggleTeam.frame.origin.y + self.btnToggleTeam.frame.size.height + 15, btnframe.size.width, btnframe.size.height);
                    CGRect lblMyLogframe = self.lblMyLog.frame;
                    self.lblMyLog.frame = CGRectMake(lblMyLogframe.origin.x, self.btnSubmit.frame.origin.y + self.btnSubmit.frame.size.height + 10, lblMyLogframe.size.width, lblMyLogframe.size.height);
                    
                    CGRect tblDailyLogframe = self.tblDailyLog.frame;
                    CGFloat height = self.view.frame.size.height - (self.lblMyLog.frame.origin.y + self.lblMyLog.frame.size.height + 10) - 77;
                    self.tblDailyLog.frame = CGRectMake(tblDailyLogframe.origin.x, self.lblMyLog.frame.origin.y + self.lblMyLog.frame.size.height + 10, tblDailyLogframe.size.width, height);
                    

                }];
            }
        }];
       //  [self.tblFacilityListing reloadData];
    }
}

- (IBAction)btnEditTapped:(id)sender {
}

#pragma mark - Methods


-(void)doInitialSettings
{
    [_lblNoRecords setHidden:YES];
    
    [_tblDailyLog setBackgroundColor:[UIColor clearColor]];
    
    self.lblCharacterCount.text = [NSString stringWithFormat:@"%i",kTextLimit];
    
    self.btnToggleTeam.selected = NO;
 
    [self.viewSelectPos setAlpha:0.0];
    [self.tblFacilityListing setAlpha:0.0];
    
    CGRect tblFacilityframe = self.tblFacilityListing.frame;
    if (aryFacilities.count * 44 > 176) {
        
          self.tblFacilityListing.frame = CGRectMake(tblFacilityframe.origin.x, tblFacilityframe.origin.y, tblFacilityframe.size.width, 176);
    }
    else{
          self.tblFacilityListing.frame = CGRectMake(tblFacilityframe.origin.x, tblFacilityframe.origin.y, tblFacilityframe.size.width, aryFacilities.count * 44);
    }
  
     CGRect viewSelectPosframe = self.viewSelectPos.frame;
    self.viewSelectPos.frame = CGRectMake(viewSelectPosframe.origin.x, self.tblFacilityListing.frame.origin.y + self.tblFacilityListing.frame.size.height + 15, viewSelectPosframe.size.width, viewSelectPosframe.size.height);
    
    CGRect btnframe = self.btnSubmit.frame;
    self.btnSubmit.frame = CGRectMake(btnframe.origin.x, self.btnToggleTeam.frame.origin.y + self.btnToggleTeam.frame.size.height + 15, btnframe.size.width, btnframe.size.height);
    
    CGRect lblMyLogframe = self.lblMyLog.frame;
    self.lblMyLog.frame = CGRectMake(lblMyLogframe.origin.x, self.btnSubmit.frame.origin.y + self.btnSubmit.frame.size.height + 10, lblMyLogframe.size.width, lblMyLogframe.size.height);
    
    CGRect tblDailyLogframe = self.tblDailyLog.frame;
    CGFloat height = self.view.frame.size.height - (self.lblMyLog.frame.origin.y + self.lblMyLog.frame.size.height + 10) - 77;
    self.tblDailyLog.frame = CGRectMake(tblDailyLogframe.origin.x, self.lblMyLog.frame.origin.y + self.lblMyLog.frame.size.height + 10, tblDailyLogframe.size.width, height);
    
   // CGRect aBtnRect = self.btnSubmit.frame;
  //  aBtnRect.origin.y = self.viewSelectPos.frame.origin.y;
   // self.btnSubmit.frame = aBtnRect;
    
    if (gblAppDelegate.teamLogCountAfterLogin>0 || self.boolISWSCallNeeded) {
        [gblAppDelegate showActivityIndicator];
        [[WebSerivceCall webServiceObject] callServiceForTeamLog:YES complition:^{
    
           // [self fetchDailyLog];
            [self fetchTeamLog];
            [self.tblDailyLog reloadData];
            gblAppDelegate.teamLogCountAfterLogin = 0;

            [gblAppDelegate hideActivityIndicator];
            
            UserHomeViewController *aUserHomeVC;
            for (UIViewController *aVCObj in self.navigationController.viewControllers) {
                if ([aVCObj isKindOfClass:[UserHomeViewController class]]) {
                    aUserHomeVC = (UserHomeViewController *)aVCObj;
                    aUserHomeVC.intUnreadLogCount = 0;
                    [aUserHomeVC.cvMenuGrid reloadData];
                }
            }
            
        }];
    }
    else
    {
        //[self fetchDailyLog];
        [self fetchTeamLog];
    }
    

}

-(void)textViewTextDidChangeNotification:(NSNotification *)aNotif
{
    self.lblCharacterCount.text = [NSString stringWithFormat:@"%lu",kTextLimit - [[self.txvDailyLog text] length]];
}

- (void)fetchDailyLog {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"DailyLog"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId MATCHES[cd] %@ AND includeInEndOfDayReport==%@", [[User currentUser] userId],@"false"];
    [request setPredicate:predicate];
    mutArrDailyList = [NSMutableArray arrayWithArray:[gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil]];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSMutableArray *aMutArrTemp = [[NSMutableArray alloc]initWithArray:[mutArrDailyList sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]]];
    [mutArrDailyList removeAllObjects];
    [mutArrDailyList addObjectsFromArray:aMutArrTemp];
    aMutArrTemp = nil;

    [mutArrDailyList sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]];
   
}

- (void)fetchTeamLog {
    mutArrDailyList = [NSMutableArray new];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"TeamLog"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId MATCHES[cd] %@ AND includeInEndOfDayReport==%@", [[User currentUser] userId],@"false"];
    // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"includeInEndOfDayReport==%@",@"false"];
    [request setPredicate:predicate];
    NSArray *aArray  =[gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    
   
    [mutArrDailyList addObjectsFromArray:aArray];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSMutableArray *aMutArrTemp = [[NSMutableArray alloc]initWithArray:[mutArrDailyList sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]]];
    [mutArrDailyList removeAllObjects];
    [mutArrDailyList addObjectsFromArray:aMutArrTemp];
    aMutArrTemp = nil;
    
    [mutArrDailyList sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]];
    if ([mutArrDailyList count] == 0) {
        [_lblNoRecords setHidden:NO];
    }
        [gblAppDelegate hideActivityIndicator];
}

-(void)getFacilityList
{
    aryFacilities = [[NSArray alloc]init];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UserFacility"];
    [request setPropertiesToFetch:@[@"name", @"value"]];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [request setSortDescriptors:@[sortByName]];
    aryFacilities = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    NSLog(@"%@",aryFacilities);
    
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tblFacilityListing) {
         return aryFacilities.count;
    }
    return [mutArrDailyList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (tableView == self.tblFacilityListing) {
        facilityListingTableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
       
        if ([selectedFacilityArr containsObject:[[aryFacilities objectAtIndex:indexPath.row] valueForKey:@"value"]]) {
       
            aCell.imgCheck.image = [UIImage imageNamed:@"selected_check_box@2x.png"];
            
        }
        else{
            aCell.imgCheck.image = [UIImage imageNamed:@"check_box@2x.png"];
            
        }
        aCell.lblFacility.text = [[aryFacilities objectAtIndex:indexPath.row] valueForKey:@"name"];
        
        return aCell;
    }
    else{
            [self fetchTeamLog];
        UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        [aCell setBackgroundColor:[UIColor clearColor]];
        UILabel *aLblTime = (UILabel*)[aCell.contentView viewWithTag:3];
        UILabel *aLblLog = (UILabel*)[aCell.contentView viewWithTag:4];
        UIImageView *aImgView = (UIImageView*)[aCell.contentView viewWithTag:5];
        [aImgView setHidden:YES];
        NSLog(@"%@",[mutArrDailyList objectAtIndex:indexPath.row]);
        if ([mutArrDailyList[indexPath.row]isKindOfClass:[DailyLog class]]) {
            DailyLog *log = [mutArrDailyList objectAtIndex:indexPath.row];
            NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
            
            [aFormatter setDateFormat:@"hh:mm a"];
            
            [aLblTime setText:[aFormatter stringFromDate:log.date]];
        
             NSString * htmlString = log.desc;
            NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                    initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                                    options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                    documentAttributes: nil
                                                    error: nil
                                                    ];
            // [aLblLog setText:log.desc];
            [aLblLog setAttributedText:attributedString];
         
            //----Changes By Chetan Kasundra-------------
            //-----Before prb in cell height,Content Overlap each other
            
            NSDictionary *aDicAttribute=@{NSFontAttributeName :[UIFont boldSystemFontOfSize:17]};
            CGFloat aHeight = [aLblLog.text boundingRectWithSize:CGSizeMake(664, 9999) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:aDicAttribute context:kNilOptions].size.height;
            
            CGRect frame = aLblLog.frame;
            if (aHeight < 21) {
                frame.size.height = 21;
                aLblLog.frame = frame;
            }
            else
            {
                frame.size.height=aHeight;
                aLblLog.frame=frame;
            }
            
            UIView *bgView = [aCell.contentView viewWithTag:2];
            frame = bgView.frame;
            frame.size.height = aHeight + 40;
            bgView.frame = frame;
            aImgView.hidden = YES;
            
        }
        else
        {
            
            TeamLog *log = [mutArrDailyList objectAtIndex:indexPath.row];
            
            NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
            [aFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
            [aFormatter setDateFormat:@"hh:mm a"];
            
            [aLblTime setText:[aFormatter stringFromDate:log.date]];
            
            NSString * htmlString = log.desc;
            
            NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                    initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                                    options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                    documentAttributes: nil
                                                    error: nil
                                                    ];

            //[aLblLog setText:log.desc];
               [aLblLog setAttributedText:attributedString];
            
        //      UIWebView * discriptionView = [aCell.contentView viewWithTag:6];
            //    [discriptionView loadHTMLString:htmlString baseURL:nil];
            
            //----Changes By Chetan Kasundra-------------
            //-----Before prb in cell height,Content Overlap each other
            
            NSDictionary *aDicAttribute=@{NSFontAttributeName :[UIFont boldSystemFontOfSize:17]};
            CGFloat aHeight = [aLblLog.text boundingRectWithSize:CGSizeMake(664, 9999) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:aDicAttribute context:kNilOptions].size.height;
            
            CGRect frame = aLblLog.frame;
            if (aHeight < 21) {
                frame.size.height = 21;
                aLblLog.frame = frame;
            }
            else
            {
                frame.size.height=aHeight;
                aLblLog.frame=frame;
            }
            
          // discriptionView.frame = aLblLog.frame;
          //  discriptionView.backgroundColor = [UIColor clearColor];
            UIView *bgView = [aCell.contentView viewWithTag:2];
            frame = bgView.frame;
            frame.size.height = aHeight + 40;
            bgView.frame = frame;
            
            if ([log.positionId isEqualToString:@"0"]) {
                aImgView.hidden = YES;
            }else{
                aImgView.hidden = NO;
            }
            
        }

       // aLblLog.hidden = YES;
        //---------------------------------
        return aCell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tblFacilityListing) {
        if ([selectedFacilityArr containsObject:[[aryFacilities objectAtIndex:indexPath.row] valueForKey:@"value"]]) {
            [selectedFacilityArr removeObject:[[aryFacilities objectAtIndex:indexPath.row] valueForKey:@"value"]];
        }else{
        [selectedFacilityArr addObject:[[aryFacilities objectAtIndex:indexPath.row] valueForKey:@"value"]];
        }
    }
    [_tblFacilityListing reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tblFacilityListing) {
          return 44;
    }
    else{
    TeamLog *log = [mutArrDailyList objectAtIndex:indexPath.row];
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
    
    if (aHeight < 21)
    {
        aHeight = 21;
    }
    return aHeight + 49;
    }
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    DropDownPopOver *dropDown = (DropDownPopOver*)[[[NSBundle mainBundle] loadNibNamed:@"DropDownPopOver" owner:self options:nil] firstObject];
    dropDown.delegate = self;
    [dropDown showDropDownWith:[[User currentUser]mutArrSelectedPositions] view:textField key:@"name"];
    return NO;
}


#pragma mark - UITextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [_lblLogPlaceholder setHidden:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([_txvDailyLog.text isEqualToString:@""]) {
        [_lblLogPlaceholder setHidden:NO];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
  //  self.lblCharacterCount.text = [NSString stringWithFormat:@"%i",100-textView.text.length];
    return textView.text.length + (text.length - range.length) <= kTextLimit;
}

#pragma mark - Dropdown  Delegate


- (void)dropDownControllerDidSelectValue:(id)value atIndex:(NSInteger)index sender:(id)sender
{
    UserPosition *aPosition = [[User currentUser]mutArrSelectedPositions][index];
    self.txtPosition.text = aPosition.name;
    
}



 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

     if ([segue.destinationViewController isKindOfClass:[TeamLogVC class]]) {
         NSMutableArray *aMutArrVC = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
         
         for (UIViewController *aVCObj in self.navigationController.viewControllers) {
             if ([aVCObj isKindOfClass:[TeamLogVC class]]) {
                 [aMutArrVC removeObject:aVCObj];
             }
         }
         self.navigationController.viewControllers = aMutArrVC;
     }
 }

-(void)callWebserviceToAddDailyLogWithDailyLogObject:(DailyLog *)aObj
{
    TeamLog *aLog = [NSEntityDescription insertNewObjectForEntityForName:@"TeamLog" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    aLog.facilityId = [[[User currentUser]selectedFacility] value];

    NSString *aParamDate = [gblAppDelegate getUTCDate:[NSDate date]];
    NSString *aStrName = [[User currentUser]username];
    NSDictionary *aDictParams = @{@"Id":@"0",
                                  @"FacilityId":aLog.facilityId,
                                  @"PositionId":@"",
                                  @"selectedFacilities":@"",
                                  @"IsTeamLog":[NSNumber numberWithBool:NO],
                                  @"IsAlwaysVisible":[NSNumber numberWithBool:NO],
                                  @"Date":aParamDate,
                                  @"UserId":[[User currentUser] userId],
                                  @"DailyLogDetails":@[
                                          @{@"Id":@"0",
                                        @"Date":aParamDate,
                                            @"Description":_txvDailyLog.text,
                                            @"IncludeInEndOfDayReport":[NSNumber numberWithBool:NO],
                                            @"UserId":[[User currentUser]userId],
                                            @"UserName":aStrName
                                            }
                                          ]
                                  };
    [gblAppDelegate callWebService:TEAM_LOG parameters:aDictParams httpMethod:@"POST" complition:^(NSDictionary *response) {
        alert(@"", @"Daily Log is submitted successfully")
        if ([response[@"Success"]boolValue]) {
            
        }
        
    } failure:^(NSError *error, NSDictionary *response) {
        
        alert(@"", MSG_ADDED_TO_SYNC);
        aObj.shouldSync = [NSNumber numberWithBool:YES];
        [gblAppDelegate.managedObjectContext save:nil];        
    }];

    
}
#pragma mark - Webservice Call

-(void)callWebserviceToAddTeamLogWithTeamLogObject:(TeamLog *)aObj
{
        TeamLog *aTeamLogObj = [NSEntityDescription insertNewObjectForEntityForName:@"TeamLog" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    //"2016-02-11 06:45:45 PM";
    NSString *aParamDate = [gblAppDelegate getUTCDate:aObj.date];
   
    NSString *aStrName = [[User currentUser]username];

    
    NSDictionary *aDictParams = @{@"Id":@"0",
                                  @"FacilityId":aObj.facilityId,
                                  @"PositionId":aObj.positionId,
                                  @"IsTeamLog":[NSNumber numberWithBool:YES],
                                  @"IsAlwaysVisible":[NSNumber numberWithBool:NO],
                                  @"Date":aParamDate,
                                  @"UserId":aObj.userId,
                                  @"SelectedFacilities":aObj.selectedFacilities,
                                  @"DailyLogDetails":@[
                                          @{@"Id":@"0",
                                            @"Date":aParamDate,
                                            @"Description":aObj.desc,
                                            @"IncludeInEndOfDayReport":[NSNumber numberWithBool:NO],
                                            @"UserId":[[User currentUser]userId],
                                            @"UserName":aStrName
                                            }
                                          ]
                                  };
    [gblAppDelegate callWebService:TEAM_LOG parameters:aDictParams httpMethod:@"POST" complition:^(NSDictionary *response) {
        alert(@"", @"Team Log is submitted successfully")
        if ([response[@"Success"]boolValue]) {
            
            aObj.teamLogId = response[@"Id"];
            
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"TeamLogTrace"];
            [request setPredicate:[NSPredicate predicateWithFormat:@"userId==[cd]%@",[[User currentUser]userId]]];
            NSArray *aArrLogs = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
            TeamLogTrace *aTeamLogTraceObj;
            if (aArrLogs.count>0) {
              
                aTeamLogTraceObj = aArrLogs[0];

            }
            else
            {
                aTeamLogTraceObj = (TeamLogTrace *)[NSEntityDescription
                                                    insertNewObjectForEntityForName:@"TeamLogTrace" inManagedObjectContext:gblAppDelegate.managedObjectContext];
            }
            
            aTeamLogTraceObj.userId= aObj.userId;
            aTeamLogTraceObj.byuserId = aObj.userId;
            aTeamLogTraceObj.date = aObj.date;
            aTeamLogTraceObj.teamLogId  = aObj.teamLogId;
            if ([selectedFacilityArr containsObject:[[[User currentUser]selectedFacility] value]]) {
                [gblAppDelegate.managedObjectContext save:nil];

            }
            [selectedFacilityArr removeAllObjects];
            [selectedFacilityArr addObject:[[[User currentUser]selectedFacility] value]];
            [_tblFacilityListing reloadData];
            
                 }
        
    } failure:^(NSError *error, NSDictionary *response) {
        
        alert(@"", MSG_ADDED_TO_SYNC);
//        aObj.shouldSync = [NSNumber numberWithBool:YES];
//        [gblAppDelegate.managedObjectContext save:nil];
        
    }];
}



@end
