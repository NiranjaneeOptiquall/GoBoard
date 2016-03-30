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
#define kTextLimit 1000

@interface DailyLogViewController ()

@end

@implementation DailyLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self doInitialSettings];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChangeNotification:) name:UITextViewTextDidChangeNotification object:self.txvDailyLog];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
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
        [self addDailyLog];
    }
   
}

-(void)addDailyLog
{
    DailyLog *aLog = [NSEntityDescription insertNewObjectForEntityForName:@"DailyLog" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    aLog.desc = _txvDailyLog.text;
    aLog.userId = [[User currentUser] userId];
  
    //[aFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    aLog.date =[NSDate date];
    aLog.includeInEndOfDayReport = @"false";
    aLog.shouldSync = [NSNumber numberWithBool:NO];
    [gblAppDelegate.managedObjectContext insertObject:aLog];
    [gblAppDelegate.managedObjectContext save:nil];
    [mutArrDailyList addObject:aLog];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSMutableArray *aMutArrTemp = [[NSMutableArray alloc]initWithArray:[mutArrDailyList sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]]];
    [mutArrDailyList removeAllObjects];
    [mutArrDailyList addObjectsFromArray:aMutArrTemp];
    aMutArrTemp = nil;
    
    [_lblNoRecords setHidden:YES];
    
    [_tblDailyLog reloadData];
    
    
    _txvDailyLog.text = @"";
}

-(void)addTeamLog
{
    TeamLog *aLog = [NSEntityDescription insertNewObjectForEntityForName:@"TeamLog" inManagedObjectContext:gblAppDelegate.managedObjectContext];
    aLog.desc = _txvDailyLog.text;
    aLog.userId = [[User currentUser] userId];
   
    //[aFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    aLog.date = [NSDate date];
    aLog.includeInEndOfDayReport = @(0);
    aLog.shouldSync = [NSNumber numberWithBool:NO];
    aLog.username = [[User currentUser]username];
    
    
    
 //   NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"name MATCHES[cd] %@", self.txtPosition.text];
 //   aLog.positionId = [[[[User currentUser]mutArrSelectedPositions] filteredArrayUsingPredicate:aPredicate][0]valueForKey:@"value"];
    
    aLog.positionId = [[self getPoistion:self.txtPosition.text]stringValue];
    aLog.facilityId = [[[User currentUser]selectedFacility] value];

    
    [gblAppDelegate.managedObjectContext insertObject:aLog];
    [gblAppDelegate.managedObjectContext save:nil];
    [mutArrDailyList addObject:aLog];
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSMutableArray *aMutArrTemp = [[NSMutableArray alloc]initWithArray:[mutArrDailyList sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]]];
    [mutArrDailyList removeAllObjects];
    [mutArrDailyList addObjectsFromArray:aMutArrTemp];
    aMutArrTemp = nil;
    
    [_lblNoRecords setHidden:YES];
    
    [_tblDailyLog reloadData];
    
    [self callWebserviceToAddTeamLogWithTeamLogObject:aLog];
    
    self.txtPosition.text = @"";

    _txvDailyLog.text = @"";
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
    
    self.btnToggleTeam.selected = !self.btnToggleTeam.selected;
    
    if (self.btnToggleTeam.selected) {
        [self.viewSelectPos setHidden:NO];
        [UIView animateWithDuration:0.5 animations:^{
            [self.viewSelectPos setAlpha:1.0];
            
            CGRect aBtnRect = self.btnSubmit.frame;
            aBtnRect.origin.y = self.viewSelectPos.frame.origin.y+self.viewSelectPos.frame.size.height+13;
            self.btnSubmit.frame = aBtnRect;
            
        } completion:nil];
    }
    else
    {
        [self.viewSelectPos setHidden:NO];
        [UIView animateWithDuration:0.5 animations:^{
            [self.viewSelectPos setAlpha:0.0];
        
        } completion:^(BOOL finished) {
            if (finished) {
                self.viewSelectPos.hidden = YES;
                [UIView animateWithDuration:0.5 animations:^{
                    CGRect aBtnRect = self.btnSubmit.frame;
                    aBtnRect.origin.y = self.viewSelectPos.frame.origin.y;
                    self.btnSubmit.frame = aBtnRect;
                }];
            }
        }];
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
    CGRect aBtnRect = self.btnSubmit.frame;
    aBtnRect.origin.y = self.viewSelectPos.frame.origin.y;
    self.btnSubmit.frame = aBtnRect;
    
    if (gblAppDelegate.teamLogCountAfterLogin>0 || self.boolISWSCallNeeded) {
        [gblAppDelegate showActivityIndicator];
        [[WebSerivceCall webServiceObject] callServiceForTeamLog:YES complition:^{
            
            [self fetchDailyLog];
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
        [self fetchDailyLog];
        [self fetchTeamLog];
    }
    

}

-(void)textViewTextDidChangeNotification:(NSNotification *)aNotif
{
    self.lblCharacterCount.text = [NSString stringWithFormat:@"%u",kTextLimit - [[self.txvDailyLog text] length]];
}

- (void)fetchDailyLog {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"DailyLog"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId MATCHES[cd] %@", [[User currentUser] userId]];
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
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"TeamLog"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId MATCHES[cd] %@", [[User currentUser] userId]];
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
}



#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mutArrDailyList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [aCell setBackgroundColor:[UIColor clearColor]];
    UILabel *aLblTime = (UILabel*)[aCell.contentView viewWithTag:3];
    UILabel *aLblLog = (UILabel*)[aCell.contentView viewWithTag:4];
    UIImageView *aImgView = (UIImageView*)[aCell.contentView viewWithTag:5];
    [aImgView setHidden:YES];
    
    
    if ([mutArrDailyList[indexPath.row]isKindOfClass:[DailyLog class]]) {
        DailyLog *log = [mutArrDailyList objectAtIndex:indexPath.row];
        NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
      
        [aFormatter setDateFormat:@"hh:mm a"];
        
        
        [aLblTime setText:[aFormatter stringFromDate:log.date]];
        [aLblLog setText:log.desc];
        //----Changes By Chetan Kasundra-------------
        //-----Before prb in cell height,Content Overlap each other
        
        NSDictionary *aDicAttribute=@{NSFontAttributeName :[UIFont boldSystemFontOfSize:17]};
        CGFloat aHeight = [log.desc boundingRectWithSize:CGSizeMake(664, 9999) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:aDicAttribute context:kNilOptions].size.height;
        
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
        [aLblLog setText:log.desc];
        
        //----Changes By Chetan Kasundra-------------
        //-----Before prb in cell height,Content Overlap each other
        
        NSDictionary *aDicAttribute=@{NSFontAttributeName :[UIFont boldSystemFontOfSize:17]};
        CGFloat aHeight = [log.desc boundingRectWithSize:CGSizeMake(664, 9999) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:aDicAttribute context:kNilOptions].size.height;
        
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
        
        aImgView.hidden = NO;
    }
    

    //---------------------------------
    return aCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DailyLog *log = [mutArrDailyList objectAtIndex:indexPath.row];
    NSDictionary *aDicAttribute=@{NSFontAttributeName :[UIFont boldSystemFontOfSize:17]};
    CGFloat aHeight = [log.desc boundingRectWithSize:CGSizeMake(664, 9999) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:aDicAttribute context:kNilOptions].size.height;
    
    if (aHeight < 21)
    {
        aHeight = 21;
    }
    return aHeight + 49;
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

#pragma mark - Webservice Call

-(void)callWebserviceToAddTeamLogWithTeamLogObject:(TeamLog *)aObj
{
    
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
            
            [gblAppDelegate.managedObjectContext save:nil];
        }
        
    } failure:^(NSError *error, NSDictionary *response) {
        
        alert(@"", MSG_ADDED_TO_SYNC);
        aObj.shouldSync = [NSNumber numberWithBool:YES];
        [gblAppDelegate.managedObjectContext save:nil];
    }];
}



@end
