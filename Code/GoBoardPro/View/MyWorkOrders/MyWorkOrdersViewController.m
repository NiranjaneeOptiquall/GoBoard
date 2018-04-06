//
//  MyWorkOrdersViewController.m
//  GoBoardPro
//
//  Created by Optiquall Solutions on 05/01/18.
//  Copyright © 2018 IndiaNIC. All rights reserved.
//

#import "MyWorkOrdersViewController.h"
#import "MyWorkOrdersTypeViewController.h"
#import "AddNoteWorkOrderViewController.h"
#import "CreateWorkOrderViewController.h"
#import "MyWorkOrdersTableViewCell.h"
#import "UserHomeViewController.h"
#import "EditWithFollowUpViewController.h"
#import "EditWithoutFollowUpViewController.h"
#import "AppDelegate.h"
@interface MyWorkOrdersViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * arrOrderList;
     NSString * selectedNumber;
    NSDictionary * responceDic;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *workOrdersTabSegment;
@property (weak, nonatomic) IBOutlet UIView *viewListParametersBG;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIView *viewTblHeader;
@property (weak, nonatomic) IBOutlet UIButton *btnCreate;
@property (weak, nonatomic) IBOutlet UITableView *tblOrdersDetailList;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRecordOrder;
@property (weak, nonatomic) IBOutlet UIButton *btnShowIncompleteWorkOrder;

@end

@implementation MyWorkOrdersViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lblNoRecordOrder.hidden = NO;
    _btnShowIncompleteWorkOrder.hidden = YES;
    arrOrderList = [[NSMutableArray alloc]init];
    UIFont *Boldfont = [UIFont boldSystemFontOfSize:19.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:Boldfont forKey:UITextAttributeFont];
    [_workOrdersTabSegment setTitleTextAttributes:attributes forState:UIControlStateNormal];
    //[self getWorkOrderData:@"false"];
    
    if (_IsServoceProvider) {
        [_workOrdersTabSegment setTitle:@"" forSegmentAtIndex:1];
        [_workOrdersTabSegment setWidth:0.1 forSegmentAtIndex:1];
    }
}
-(void)viewDidAppear:(BOOL)animated{
 
}
-(void)viewWillAppear:(BOOL)animated{
    if (_btnShowIncompleteWorkOrder.isSelected) {
        
        [self getWorkOrderData:@"true"];
    }
    else{
        
        [self getWorkOrderData:@"false"];
    }
}
-(void)getWorkOrderData:(NSString*)showInProgressWorkOrder{
    
    NSString * strShowAll = @"";
    NSString * strAssigntoMe = @"";
    
    if (_workOrdersTabSegment.selectedSegmentIndex == 0) {
        strAssigntoMe = @"true";
        strShowAll = @"false";
    }
    else  {
        strAssigntoMe = @"false";
        strShowAll = @"false";
    }
    if (_btnShowIncompleteWorkOrder.selected) {
        showInProgressWorkOrder = @"true";
    }
    NSString *strFacilityId =[[NSUserDefaults standardUserDefaults] objectForKey:@"facilityId"];

        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"myWorkOrderFilterRecponce"];
    
        [gblAppDelegate showActivityIndicator];
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
   
    [self callServiceForFilterMyWorkOrders:YES strFacility:strFacilityId dateFrom:@"" dateTo:@"" timeFrom:@"" timeTo:@"" locationIds:@"" categoryIds:@"" typeIds:@"" assignedToMe:strAssigntoMe showAll:strShowAll showInProgressWorkOrder:showInProgressWorkOrder complition:^{
        
        
        NSData *dictionaryData = [[NSUserDefaults standardUserDefaults] objectForKey:@"myWorkOrderFilterRecponce"];
        responceDic = [NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
        if (![[responceDic valueForKey:@"WorkOrders"] isKindOfClass:[NSNull class]]) {
            arrOrderList = [responceDic valueForKey:@"WorkOrders"];
        }
        
        if (arrOrderList.count != 0) {
            _lblNoRecordOrder.hidden = YES;
        }
        else{
            _lblNoRecordOrder.hidden = NO;
        }
        [_tblOrdersDetailList reloadData];
    }];
 });
}
-(void)callServiceForFilterMyWorkOrders:(BOOL)waitUntilDone strFacility:(NSString*)strFacility dateFrom:(NSString*)dateFrom dateTo:(NSString*)dateTo timeFrom:(NSString*)timeFrom timeTo:(NSString*)timeTo locationIds:(NSString*)locationIds categoryIds:(NSString*)categoryIds typeIds:(NSString*)typeIds assignedToMe:(NSString*)assignedToMe showAll:(NSString*)showAll showInProgressWorkOrder:(NSString*)showInProgressWorkOrder complition:(void (^)(void))complition
{
    __block BOOL isWSComplete = NO;
    
    NSString *strFacilityId =[[NSUserDefaults standardUserDefaults] objectForKey:@"facilityId"];
    NSString *aStrAccountId = [[NSUserDefaults standardUserDefaults] objectForKey:@"accountId"];
    NSString *strUserId = @"";
    if ([User checkUserExist]) {
        strUserId = [[User currentUser] userId];
    }
    
    
    
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?accountId=%@&userId=%@&datefrom=%@&dateto=%@&timeFrom=%@&timeTo=%@&facilityIds=%@&invLocationIds=%@&categoryIds=%@&typeIds=%@&showWorkOrdersAssignedToMe=%@&showAllWorkOrders=%@&showInProgressWorkOrder=%@&loadDefault=false", MY_WORK_ORDERS, aStrAccountId,strUserId, dateFrom,dateTo,timeFrom,timeTo,strFacility,locationIds,categoryIds,typeIds,assignedToMe,showAll,showInProgressWorkOrder] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:MY_WORK_ORDERS] complition:^(NSDictionary *response){
        NSLog(@"%@",response);
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:response];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"myWorkOrderFilterRecponce"];
        
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
- (IBAction)myWorkOrderTabChange:(UISegmentedControl *)sender {

    [self getWorkOrderData:@"false"];
    if (sender.selectedSegmentIndex == 1) {
           _btnShowIncompleteWorkOrder.hidden = NO;
         [_btnShowIncompleteWorkOrder setSelected:NO];
    }else{
         _btnShowIncompleteWorkOrder.hidden = YES;
        [_btnShowIncompleteWorkOrder setSelected:NO];
    }
    
}

- (IBAction)btnBack:(UIButton *)sender {
    for (UIViewController *aVCObj in self.navigationController.viewControllers) {
        if ([aVCObj isKindOfClass:[MyWorkOrdersTypeViewController class]]) {
            [self.navigationController popToViewController:aVCObj animated:YES];
        }
    }
    
}

- (IBAction)btnCreateTapped:(UIButton *)sender {
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIButton * btn = sender;
    NSLog(@"%@",btn);
    NSLog(@"%ld",(long)btn.tag);
//    if ([[segue identifier] isEqualToString:@"addNote"]) {
////        AddNoteWorkOrderViewController *aDetail = (AddNoteWorkOrderViewController*)segue.destinationViewController;
////        
////        aDetail.orderId = [[arrOrderList valueForKey:@"Id"]objectAtIndex:btn.tag];
//    }

        if ([[segue identifier] isEqualToString:@"createWorkOrder"]) {
    //    CreateWorkOrderViewController *aDetail = (CreateWorkOrderViewController*)segue.destinationViewController;
        
    }
    else if ([[segue identifier] isEqualToString:@"editWorkOrder"]) {
        //    CreateWorkOrderViewController *aDetail = (CreateWorkOrderViewController*)segue.destinationViewController;
        
    }


}
#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return arrOrderList.count;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyWorkOrdersTableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
   
        if ([[[arrOrderList valueForKey:@"WorkOrderId"] objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
            aCell.lblWorkOrderNumber.text = @"-";
        }
        else{
            aCell.lblWorkOrderNumber.text = [NSString stringWithFormat:@"%@",[[arrOrderList valueForKey:@"WorkOrderId"] objectAtIndex:indexPath.row]];
        }
        if ([[[arrOrderList valueForKey:@"WorkOrderType"] objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
            
            aCell.lblGeneralEquipment.text = @"-";
        }
        else{
            aCell.lblGeneralEquipment.text = [NSString stringWithFormat:@"%@",[[arrOrderList valueForKey:@"WorkOrderType"] objectAtIndex:indexPath.row]];
        }
        if ([[[arrOrderList valueForKey:@"CurrentStatus"] objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
            aCell.lblCurrentStatus.text = @"-";
        }
        else{
            aCell.lblCurrentStatus.text = [NSString stringWithFormat:@"%@",[[arrOrderList valueForKey:@"CurrentStatus"] objectAtIndex:indexPath.row]];
        }
        if ([[[arrOrderList valueForKey:@"EquipmentId"] objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
            
            aCell.lblGeneralEquipmentId.hidden = YES;
        }
        else{
            if ([aCell.lblGeneralEquipment.text isEqualToString:@"General"]) {
                aCell.lblGeneralEquipmentId.hidden = YES;

            }
            else{
                aCell.lblGeneralEquipmentId.hidden = NO;
                aCell.lblGeneralEquipmentId.text = [NSString stringWithFormat:@"Equipment id : %@",[[arrOrderList valueForKey:@"EquipmentId"] objectAtIndex:indexPath.row]];
            }
            
        }
        if ([[[arrOrderList valueForKey:@"Description"] objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
            
            aCell.lblDescription.text = @"Description : -";
        }
        else{
            aCell.lblDescription.text = [NSString stringWithFormat:@"Description : %@",[[arrOrderList valueForKey:@"Description"] objectAtIndex:indexPath.row]];
        }
        
        
        if ([[[arrOrderList valueForKey:@"IsImageAvailable"]  objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
            aCell.lblImage.text = @"Image available : -";
        }
        else{
            BOOL imgAvailable = [[[arrOrderList valueForKey:@"IsImageAvailable"]  objectAtIndex:indexPath.row] boolValue];
            if (imgAvailable) {
                
                aCell.lblImage.text = [NSString stringWithFormat:@"Image available : Yes"];
            }
            else{
                aCell.lblImage.text = [NSString stringWithFormat:@"Image available : No"];
            }
            
        }
        if ([[[arrOrderList valueForKey:@"DateSubmitted"] objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
            
            aCell.lblDateSubmitted.text = @"Date submitted : -";
        }
        else{
            NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
            [dateformatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]]; // Prevent adjustment to user's local time zone.
            [dateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSDate *date = [dateformatter dateFromString:[[arrOrderList valueForKey:@"DateSubmitted"] objectAtIndex:indexPath.row]];
            [dateformatter setDateFormat:@"MM/dd/yyyy"];
            
            aCell.lblDateSubmitted.text = [NSString stringWithFormat:@"Date submitted : %@",[dateformatter stringFromDate:date]];
        }
        if ([[[arrOrderList valueForKey:@"AssignedTo"] objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
            aCell.lblAssignTo.text = @"Assign to : -";
        }
        else{
            aCell.lblAssignTo.text = [NSString stringWithFormat:@"Assign to : %@",[[arrOrderList valueForKey:@"AssignedTo"] objectAtIndex:indexPath.row]];
        }
        
        
        if ([[[arrOrderList valueForKey:@"UpdatedOn"] objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
            aCell.lblLastUpdated.text = @"Last updated : -";
        }
        else{
            
            NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
            [dateformatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]]; // Prevent adjustment to user's local time zone.
            [dateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
            NSDate *date = [dateformatter dateFromString:[[arrOrderList valueForKey:@"UpdatedOn"] objectAtIndex:indexPath.row]];
            [dateformatter setDateFormat:@"MM/dd/yyyy"];
            aCell.lblLastUpdated.text = [NSString stringWithFormat:@"Last updated : %@",[dateformatter stringFromDate:date]];
            
        }
        if ([[[arrOrderList valueForKey:@"UpdatedBy"] objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
            
            aCell.lblUpdatedBy.text = @"Updated by : -";
        }
        else{
            aCell.lblUpdatedBy.text = [NSString stringWithFormat:@"Updated by : %@",[[arrOrderList valueForKey:@"UpdatedBy"] objectAtIndex:indexPath.row]];
        }
        if ([[[arrOrderList valueForKey:@"Notes"] objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]]) {
            aCell.lblNotes.text = @"Notes : -";
        }
        else{
            aCell.lblNotes.text = [NSString stringWithFormat:@"Notes : %@",[[arrOrderList valueForKey:@"Notes"] objectAtIndex:indexPath.row]];
        }
    [aCell.btnEdit addTarget:self action:@selector(editWorkOrderTapped:) forControlEvents:UIControlEventTouchUpInside];
        aCell.btnEdit.tag = indexPath.row;
 
    [aCell.btnAddnotes addTarget:self action:@selector(addNoteWorkOrderTapped:) forControlEvents:UIControlEventTouchUpInside];
    aCell.btnAddnotes.tag = indexPath.row;
    
    [aCell.btnView addTarget:self action:@selector(viewWorkOrderTapped:) forControlEvents:UIControlEventTouchUpInside];
    aCell.btnView.tag = indexPath.row;

    if (_workOrdersTabSegment.selectedSegmentIndex == 1) {
        if (_btnShowIncompleteWorkOrder.selected) {
            aCell.btnAddnotes.hidden = YES;
        }
        else{
            aCell.btnAddnotes.hidden = NO;
        }
    }

    return aCell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

        if ([selectedNumber isEqualToString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
            return  261;
        }
        else return 42;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

        if ([selectedNumber isEqualToString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
            selectedNumber = @"";
        }else{
            selectedNumber = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        }
        [UIView setAnimationsEnabled:NO];
        [tableView beginUpdates];
        [tableView endUpdates];
        [UIView setAnimationsEnabled:YES];
  
}
-(void)addNoteWorkOrderTapped:(UIButton*)sender{
     if (_IsServoceProvider) {
    if (![[[arrOrderList valueForKey:@"IsViewAllowed"]objectAtIndex:sender.tag] boolValue]) {
        alert(@"", @"Please note, you do not have permission to Add Note to this work order");
        return;
    }
     }
    AddNoteWorkOrderViewController * aDetail =[self.storyboard instantiateViewControllerWithIdentifier:@"AddNoteWorkOrderViewController"];
    
    aDetail.orderId = [[arrOrderList valueForKey:@"Id"]objectAtIndex:sender.tag];
     [self.navigationController pushViewController:aDetail animated:YES];
   
        
}
-(void)editWorkOrderTapped:(UIButton*)sender{
    if (_IsServoceProvider) {
        
        if (![[[arrOrderList valueForKey:@"IsViewAllowed"]objectAtIndex:sender.tag] boolValue]) {
              alert(@"", @"Please note, you do not have permission to edit this work order");
            return;
        }else{
         
                EditWithFollowUpViewController * aVCObj =[self.storyboard instantiateViewControllerWithIdentifier:@"EditWithFollowUpViewController"];
                aVCObj.orderId = [[arrOrderList valueForKey:@"Id"]objectAtIndex:sender.tag];
                aVCObj.workOrderHistoryId = [[arrOrderList valueForKey:@"WorkOrderHistoryId"]objectAtIndex:sender.tag];
            aVCObj.isOnlyView = @"NO";
                aVCObj.isAssignToMeView = @"YES";
            aVCObj.isServiceProvider = YES;
         
            if (![[[arrOrderList valueForKey:@"IsEditAllowed"]objectAtIndex:sender.tag] boolValue]){
                aVCObj.isServiceProEditAllow = NO;
                
            }else{
                aVCObj.isServiceProEditAllow = YES;
                      }
                [self.navigationController pushViewController:aVCObj animated:YES];
            
        }
        
    }
    else{
    if (_workOrdersTabSegment.selectedSegmentIndex == 0) {
        
        if (![[[arrOrderList valueForKey:@"IsEditAllowed"]objectAtIndex:sender.tag] boolValue] && ![[[arrOrderList valueForKey:@"IsAssignedToMe"]objectAtIndex:sender.tag] boolValue]) {
            alert(@"", @"Please note, you do not have permission to edit this work order");
        }
        else{
        
        EditWithFollowUpViewController * aVCObj =[self.storyboard instantiateViewControllerWithIdentifier:@"EditWithFollowUpViewController"];
        aVCObj.orderId = [[arrOrderList valueForKey:@"Id"]objectAtIndex:sender.tag];
        aVCObj.workOrderHistoryId = [[arrOrderList valueForKey:@"WorkOrderHistoryId"]objectAtIndex:sender.tag];
        aVCObj.isOnlyView = @"NO";
        aVCObj.isAssignToMeView = @"YES";
        [self.navigationController pushViewController:aVCObj animated:YES];
        }
    }
    else{
        if (_btnShowIncompleteWorkOrder.selected) {
            EditWithoutFollowUpViewController * aVCObj =[self.storyboard instantiateViewControllerWithIdentifier:@"EditWithoutFollowUpViewController"];
            aVCObj.orderId = [[arrOrderList valueForKey:@"Id"]objectAtIndex:sender.tag];
            aVCObj.workOrderHistoryId = [[arrOrderList valueForKey:@"WorkOrderHistoryId"]objectAtIndex:sender.tag];
            aVCObj.isOnlyView = @"NO";
            [self.navigationController pushViewController:aVCObj animated:YES];
            
        }else{
            if (![[[arrOrderList valueForKey:@"IsEditAllowed"]objectAtIndex:sender.tag] boolValue] && ![[[arrOrderList valueForKey:@"IsAssignedToMe"]objectAtIndex:sender.tag] boolValue]) {
                alert(@"", @"Please note, you do not have permission to edit this work order");
            }
            else{
                        EditWithFollowUpViewController * aVCObj =[self.storyboard instantiateViewControllerWithIdentifier:@"EditWithFollowUpViewController"];
            aVCObj.orderId = [[arrOrderList valueForKey:@"Id"]objectAtIndex:sender.tag];
            aVCObj.workOrderHistoryId = [[arrOrderList valueForKey:@"WorkOrderHistoryId"]objectAtIndex:sender.tag];
            aVCObj.isOnlyView = @"NO";
            aVCObj.isAssignToMeView = @"NO";
            [self.navigationController pushViewController:aVCObj animated:YES];
            }

        }
        
    }
    }
}
-(void)viewWorkOrderTapped:(UIButton*)sender{
    if (_IsServoceProvider) {

            if (![[[arrOrderList valueForKey:@"IsViewAllowed"]objectAtIndex:sender.tag] boolValue]) {
                alert(@"", @"Please note, you do not have permission to Add Note to this work order");
                return;
            }
   

            
            EditWithFollowUpViewController * aVCObj =[self.storyboard instantiateViewControllerWithIdentifier:@"EditWithFollowUpViewController"];
            aVCObj.orderId = [[arrOrderList valueForKey:@"Id"]objectAtIndex:sender.tag];
            aVCObj.workOrderHistoryId = [[arrOrderList valueForKey:@"WorkOrderHistoryId"]objectAtIndex:sender.tag];
            aVCObj.isOnlyView = @"YES";
            aVCObj.isAssignToMeView = @"YES";
            aVCObj.isServiceProvider = YES;
     
            [self.navigationController pushViewController:aVCObj animated:YES];
            
        
        
    }
    else{

    if (_workOrdersTabSegment.selectedSegmentIndex == 0) {
        EditWithFollowUpViewController * aVCObj =[self.storyboard instantiateViewControllerWithIdentifier:@"EditWithFollowUpViewController"];
        aVCObj.orderId = [[arrOrderList valueForKey:@"Id"]objectAtIndex:sender.tag];
        aVCObj.workOrderHistoryId = [[arrOrderList valueForKey:@"WorkOrderHistoryId"]objectAtIndex:sender.tag];
        aVCObj.isOnlyView = @"YES";
        aVCObj.isAssignToMeView = @"";
                    [self.navigationController pushViewController:aVCObj animated:YES];

    }
    else{
        if (_btnShowIncompleteWorkOrder.selected) {
            EditWithoutFollowUpViewController * aVCObj =[self.storyboard instantiateViewControllerWithIdentifier:@"EditWithoutFollowUpViewController"];
            aVCObj.orderId = [[arrOrderList valueForKey:@"Id"]objectAtIndex:sender.tag];
            aVCObj.workOrderHistoryId = [[arrOrderList valueForKey:@"WorkOrderHistoryId"]objectAtIndex:sender.tag];
            aVCObj.isOnlyView = @"YES";
            [self.navigationController pushViewController:aVCObj animated:YES];

        }else{
            EditWithFollowUpViewController * aVCObj =[self.storyboard instantiateViewControllerWithIdentifier:@"EditWithFollowUpViewController"];
            aVCObj.orderId = [[arrOrderList valueForKey:@"Id"]objectAtIndex:sender.tag];
            aVCObj.workOrderHistoryId = [[arrOrderList valueForKey:@"WorkOrderHistoryId"]objectAtIndex:sender.tag];
            aVCObj.isOnlyView = @"YES";
            aVCObj.isAssignToMeView = @"";
            [self.navigationController pushViewController:aVCObj animated:YES];
        }
        
    }
    }
}
- (IBAction)btnShowIncompleteWorkOrderTapped:(UIButton *)sender {
       if (sender.isSelected) {
           [sender setSelected:NO];
           [self getWorkOrderData:@"false"];
    }
       else{
            [sender setSelected:YES];
           [self getWorkOrderData:@"true"];
       }


}

@end
