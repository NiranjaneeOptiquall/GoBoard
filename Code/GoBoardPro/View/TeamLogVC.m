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

@interface TeamLogVC ()
{
    WebSerivceCall * webCall;
}
@end

@implementation TeamLogVC

- (void)viewDidLoad {
    [super viewDidLoad];
   // webCall=[[WebSerivceCall alloc]init];
   // [webCall callServiceForTeamLog:YES complition:nil];
//    [self doInitialSettings];
  _mutArrTeamLog=[NSMutableArray new];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // [self.tblViewteamLog reloadData];
    [gblAppDelegate showActivityIndicator];
    [[WebSerivceCall webServiceObject] callServiceForTeamLog:YES complition:^{
        [self doInitialSettings];
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
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

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
    
    [aCell.txtViewDate setText:[aFormatter stringFromDate:log.date]];
    [aCell.lblDescription setText:log.desc];
    
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
    
    aCell.lblUserName.text = log.username;
    
    
    if (log.teamSubLog.allObjects.count>0) {
        [aCell.btnViewComments setTitle:@"View Comments" forState:UIControlStateNormal];
    }
    else
        [aCell.btnViewComments setTitle:@"Add Comment" forState:UIControlStateNormal];
    
    objc_setAssociatedObject(aCell.btnViewComments,kIndex, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    //---------------------------------
    return aCell;
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
