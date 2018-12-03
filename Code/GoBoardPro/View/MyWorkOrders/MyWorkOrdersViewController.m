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
#import "WorkOrderListing.h"
@interface MyWorkOrdersViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * arrOrderList;
     NSString * selectedNumber;
    NSDictionary * responceDic;
    NSArray * arrWorkorderList;
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
    arrWorkorderList = [[NSArray alloc]init];
    arrOrderList = [[NSMutableArray alloc]init];
    UIFont *Boldfont = [UIFont boldSystemFontOfSize:19.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:Boldfont forKey:UITextAttributeFont];
    [_workOrdersTabSegment setTitleTextAttributes:attributes forState:UIControlStateNormal];
    //[self getWorkOrderData:@"false"];
    
    if (_IsServoceProvider) {
        [_workOrdersTabSegment setTitle:@"" forSegmentAtIndex:1];
        [_workOrdersTabSegment setWidth:0.1 forSegmentAtIndex:1];
    }
    if ([gblAppDelegate isNetworkReachable]) {
        
       [self getWorkOrderData:@"AssignedToMe"];
       [self getWorkOrderData:@"CreatedByMe"];
       [self getWorkOrderData:@"InProgress"];
    }
    else{
        [self loadDataInList:@"AssignedToMe"];
        alert(@"", @"To see updated data please check your internet connection.");
    }
    
}
-(void)viewDidAppear:(BOOL)animated{
 
}
-(void)viewWillAppear:(BOOL)animated{
  //  if (_btnShowIncompleteWorkOrder.isSelected) {
//     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//    if ([gblAppDelegate isNetworkReachable]) {
//        
//        [self getWorkOrderData:@"AssignedToMe"];
//    }
//    else{
//        alert(@"", @"To see updated data please check your internet connection.");
//    }
//     });
//    
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        if ([gblAppDelegate isNetworkReachable]) {
//            
//            [self getWorkOrderData:@"CreatedByMe"];
//        }
//        else{
//            alert(@"", @"To see updated data please check your internet connection.");
//        }
//    });
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        if ([gblAppDelegate isNetworkReachable]) {
//            
//            
//            [self getWorkOrderData:@"InProgress"];
//        }
//        else{
//            alert(@"", @"To see updated data please check your internet connection.");
//        }
//    });
   
 
}
-(void)getWorkOrderData:(NSString*)workOrderListType{
    
    NSString * strShowAll = @"";
    NSString * strAssigntoMe = @"";
    NSString * showInProgressWorkOrder = @"";
    
//
//    if (_workOrdersTabSegment.selectedSegmentIndex == 0) {
//        strAssigntoMe = @"true";
//        strShowAll = @"false";
//    }
//    else  {
//        strAssigntoMe = @"false";
//        strShowAll = @"false";
//    }
//    if (_btnShowIncompleteWorkOrder.selected) {
//        showInProgressWorkOrder = @"true";
//    }
//
//
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"myWorkOrderFilterRecponce"];
    
    
    if ([workOrderListType isEqualToString:@"AssignedToMe"]) {
        strAssigntoMe = @"true";
        strShowAll = @"false";
        showInProgressWorkOrder = @"false";
        
    }
    else if ([workOrderListType isEqualToString:@"CreatedByMe"]) {
        strAssigntoMe = @"false";
        strShowAll = @"false";
        showInProgressWorkOrder = @"false";
        
    }
    else if ([workOrderListType isEqualToString:@"InProgress"]) {
        strAssigntoMe = @"false";
        strShowAll = @"false";
        showInProgressWorkOrder = @"true";
        
    }
    else {
        return;
    }
    
     NSString *strFacilityId =[[NSUserDefaults standardUserDefaults] objectForKey:@"facilityId"];
    
        [gblAppDelegate showActivityIndicator];
      if (gblAppDelegate.isNetworkReachable) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
   
    [self callServiceForFilterMyWorkOrders:YES strFacility:strFacilityId dateFrom:@"" dateTo:@"" timeFrom:@"" timeTo:@"" locationIds:@"" categoryIds:@"" typeIds:@"" assignedToMe:strAssigntoMe showAll:strShowAll showInProgressWorkOrder:showInProgressWorkOrder complition:^{
        
        NSData *dictionaryData = [[NSUserDefaults standardUserDefaults] objectForKey:@"myWorkOrderFilterRecponce"];
        NSDictionary * responceDic2 = [NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
        
        [self deleteAllForms:workOrderListType];
        [self insertWorkOrder:[responceDic2 valueForKey:@"WorkOrders"] type:workOrderListType];
        [self loadDataInList:@"AssignedToMe"];

    }];
        
 });
      }
      else{

          [gblAppDelegate hideActivityIndicator];
          alert(@"", @"To see updated data please check your internet connection.");
      }
}
- (void)deleteAllForms:(NSString*)type {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"WorkOrderListing"];
    [request setIncludesPropertyValues:NO];
     NSPredicate * predicate = [NSPredicate predicateWithFormat:@"workOrderListType ==[CD] %@",type];
    [request setPredicate:predicate];
    NSArray *aryRecords = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    for (NSManagedObject *rec in aryRecords) {
        [gblAppDelegate.managedObjectContext deleteObject:rec];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}

-(void)insertWorkOrder:(NSArray*)responceArr type:(NSString*)type{
    
    for (NSDictionary *aDict in responceArr) {
        
        WorkOrderListing *workOrder = [NSEntityDescription insertNewObjectForEntityForName:@"WorkOrderListing" inManagedObjectContext:gblAppDelegate.managedObjectContext];
           if ([[aDict objectForKey:@"AssignedTo"] isKindOfClass:[NSNull class]]) {
               workOrder.assignedTo = @"";
           }
           else{
        workOrder.assignedTo = [aDict objectForKey:@"AssignedTo"];
           }
        workOrder.currentStatus = [aDict objectForKey:@"CurrentStatus"];
        workOrder.dateSubmitted = [aDict objectForKey:@"DateSubmitted"];
        workOrder.workOrderDescription = [aDict objectForKey:@"Description"];
        workOrder.equipmentId = [aDict objectForKey:@"EquipmentId"];
        workOrder.iid = [[aDict objectForKey:@"Id"] stringValue];
        workOrder.insertedById = [[aDict objectForKey:@"InsertedById"] stringValue];
        workOrder.isAssignedToMe = [[aDict objectForKey:@"IsAssignedToMe"] stringValue];
        workOrder.isCreatedByMe = [[aDict objectForKey:@"IsCreatedByMe"] stringValue];
        workOrder.isEditAllowed = [[aDict objectForKey:@"IsEditAllowed"] stringValue] ;
        workOrder.isImageAvailable = [[aDict objectForKey:@"IsImageAvailable"] stringValue] ;
        workOrder.isViewAllowed = [[aDict objectForKey:@"IsViewAllowed"] stringValue];
        if ([[aDict objectForKey:@"Notes"] isKindOfClass:[NSNull class]]) {
            workOrder.notes = @"";

        }
        else{
            workOrder.notes = [aDict objectForKey:@"Notes"];

        }
        workOrder.updatedBy = [aDict objectForKey:@"UpdatedBy"] ;
        workOrder.updatedOn = [aDict objectForKey:@"UpdatedOn"];
        workOrder.workOrderHistoryId = [[aDict objectForKey:@"WorkOrderHistoryId"] stringValue] ;
        workOrder.workOrderId = [aDict objectForKey:@"WorkOrderId"];
        workOrder.workOrderType = [aDict objectForKey:@"WorkOrderType"] ;
        workOrder.workOrderListType = type;
    
        [gblAppDelegate.managedObjectContext insertObject:workOrder];
        [gblAppDelegate.managedObjectContext save:nil];
        
    }
}
-(void)loadDataInList:(NSString*)type {
    
    NSFetchRequest *request =[[NSFetchRequest alloc] initWithEntityName:@"WorkOrderListing"];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"workOrderListType ==[CD] %@",type];
    [request setPredicate:predicate];
    
   arrOrderList = [NSMutableArray arrayWithArray:[gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil]];
    
    
    NSLog(@"%@",arrOrderList);


    if (arrOrderList.count != 0) {
        _lblNoRecordOrder.hidden = YES;
    }
    else{
        _lblNoRecordOrder.hidden = NO;
    }
    [_tblOrdersDetailList reloadData];
    
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
    
//        [self deleteAllWorkOrderListData:assignedToMe showAll:showAll showInProgressWorkOrder:showInProgressWorkOrder];
//
//        if ([assignedToMe isEqualToString:@"true"] && [showAll isEqualToString:@"false"] && [showInProgressWorkOrder isEqualToString:@"false"]) {
//            [self insertWorkOrderAssignToMeList:response];
//        }
//        else  if ([assignedToMe isEqualToString:@"false"] && [showAll isEqualToString:@"false"] && [showInProgressWorkOrder isEqualToString:@"false"]) {
//            [self insertWorkOrderCreatedByMeList:response];
//        }
//        else  {
//            [self insertWorkOrderCreatedByMeInProgressList:response];
//  }
//
//        [self fetchWorkOrderListData:assignedToMe showAll:showAll showInProgressWorkOrder:showInProgressWorkOrder];
        
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
    _btnShowIncompleteWorkOrder.selected = NO;
   // [self getWorkOrderData:@"false"];
    if (sender.selectedSegmentIndex == 1) {
           _btnShowIncompleteWorkOrder.hidden = NO;
        [self loadDataInList:@"CreatedByMe"];
    }else{
         _btnShowIncompleteWorkOrder.hidden = YES;
    [self loadDataInList:@"AssignedToMe"];
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
    
    NSManagedObject * obj = [arrOrderList objectAtIndex:indexPath.row];
    
 
    if ([[obj valueForKey:@"workOrderId"] isKindOfClass:[NSNull class]]) {
        aCell.lblWorkOrderNumber.text = @"-";
    }
    else{
        aCell.lblWorkOrderNumber.text = [NSString stringWithFormat:@"%@",[obj valueForKey:@"workOrderId"] ];
    }
    if ([[obj valueForKey:@"workOrderType"] isKindOfClass:[NSNull class]]) {
        
        aCell.lblGeneralEquipment.text = @"-";
    }
    else{
        aCell.lblGeneralEquipment.text = [NSString stringWithFormat:@"%@",[obj valueForKey:@"workOrderType"]];
    }
    if ([[obj valueForKey:@"currentStatus"] isKindOfClass:[NSNull class]]) {
        aCell.lblCurrentStatus.text = @"-";
    }
    else{
        aCell.lblCurrentStatus.text = [NSString stringWithFormat:@"%@",[obj valueForKey:@"currentStatus"]];
    }
    
    if ([[obj valueForKey:@"workOrderDescription"] isKindOfClass:[NSNull class]]) {
        aCell.lblTitleDes.text = @"-";
    }
    else{
        aCell.lblTitleDes.text = [NSString stringWithFormat:@"%@",[obj valueForKey:@"workOrderDescription"]];
    }
    
    if ([[obj valueForKey:@"equipmentId"] isKindOfClass:[NSNull class]]) {
        
        aCell.lblGeneralEquipmentId.hidden = YES;
    }
    else{
        if ([aCell.lblGeneralEquipment.text isEqualToString:@"General"]) {
            aCell.lblGeneralEquipmentId.hidden = YES;
            
        }
        else{
            aCell.lblGeneralEquipmentId.hidden = NO;
            aCell.lblGeneralEquipmentId.text = [NSString stringWithFormat:@"Item ID : %@",[obj valueForKey:@"equipmentId"]];
        }
        
    }
    if ([[obj valueForKey:@"workOrderDescription"] isKindOfClass:[NSNull class]]) {
        
        aCell.lblDescription.text = @"Description : -";
    }
    else{
        aCell.lblDescription.text = [NSString stringWithFormat:@"Description : %@",[obj valueForKey:@"workOrderDescription"]];
    }
    
    
    if ([[obj valueForKey:@"isImageAvailable"] isKindOfClass:[NSNull class]]) {
        aCell.lblImage.text = @"Image available : -";
    }
    else{
        //            BOOL imgAvailable = [[[arrOrderList valueForKey:@"IsImageAvailable"]  objectAtIndex:indexPath.row] boolValue];
        if ([[obj valueForKey:@"isImageAvailable"] boolValue]) {
            
            aCell.lblImage.text = [NSString stringWithFormat:@"Image available : Yes"];
        }
        else{
            aCell.lblImage.text = [NSString stringWithFormat:@"Image available : No"];
        }
        
    }
    if ([[obj valueForKey:@"dateSubmitted"] isKindOfClass:[NSNull class]]) {
        
        aCell.lblDateSubmitted.text = @"Date submitted : -";
    }
    else{
        NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
        [dateformatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]]; // Prevent adjustment to user's local time zone.
        [dateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *date = [dateformatter dateFromString:[obj valueForKey:@"dateSubmitted"]];
        [dateformatter setDateFormat:@"MM/dd/yyyy"];
        
        aCell.lblDateSubmitted.text = [NSString stringWithFormat:@"Date submitted : %@",[dateformatter stringFromDate:date]];
    }
    if ([[obj valueForKey:@"assignedTo"] isKindOfClass:[NSNull class]]) {
        aCell.lblAssignTo.text = @"Assign to : -";
    }
    else{
        aCell.lblAssignTo.text = [NSString stringWithFormat:@"Assign to : %@",[obj valueForKey:@"assignedTo"]];
    }
    
    
    if ([[obj valueForKey:@"updatedOn"] isKindOfClass:[NSNull class]]) {
        aCell.lblLastUpdated.text = @"Last updated : -";
    }
    else{
        
        NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
        [dateformatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]]; // Prevent adjustment to user's local time zone.
        [dateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        NSDate *date = [dateformatter dateFromString:[obj valueForKey:@"updatedOn"]];
        [dateformatter setDateFormat:@"MM/dd/yyyy"];
        aCell.lblLastUpdated.text = [NSString stringWithFormat:@"Last updated : %@",[dateformatter stringFromDate:date]];
        
    }
    if ([[obj valueForKey:@"updatedBy"] isKindOfClass:[NSNull class]]) {
        
        aCell.lblUpdatedBy.text = @"Updated by : -";
    }
    else{
        aCell.lblUpdatedBy.text = [NSString stringWithFormat:@"Updated by : %@",[obj valueForKey:@"updatedBy"]];
    }
    if ([[obj valueForKey:@"notes"] isKindOfClass:[NSNull class]]) {
        aCell.lblNotes.text = @"Notes : -";
    }
    else{
        aCell.lblNotes.text = [NSString stringWithFormat:@"Notes : %@",[obj valueForKey:@"notes"]];
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

//        if ([selectedNumber isEqualToString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
//            return  261;
//        }
    if ([selectedNumber isEqualToString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
        NSManagedObject * obj = [arrOrderList objectAtIndex:indexPath.row];
        
        NSString *aString = [obj valueForKey:@"workOrderDescription"] ;
        //            UIFont * font = [UIFont systemFontOfSize:30];
        //
        //            CGSize stringSize = [aString sizeWithFont:font];
        //
        //            CGFloat height = stringSize.height;
        
        // NSString *someString = @"Hello World";
        
        
        UIFont *yourFont = [UIFont fontWithName:@"Helvetica" size:24];
        CGSize stringBoundingBox = [aString sizeWithFont:yourFont];
        CGFloat height = stringBoundingBox.height;
        CGFloat width = stringBoundingBox.width;
        
        int strWidth = [[NSNumber numberWithFloat:width] intValue];
        //  if (strWidth%1000 <=1000 ) {
        int i = strWidth/1000;
        height = height*i;
        // }
        return  261+height;
    }

        else return 49;

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
    if (gblAppDelegate.isNetworkReachable) {
        
   
     if (_IsServoceProvider) {
    if (![[[arrOrderList valueForKey:@"IsViewAllowed"]objectAtIndex:sender.tag] boolValue]) {
        alert(@"", @"Please note, you do not have permission to Add Note to this work order");
        return;
    }
     }
    AddNoteWorkOrderViewController * aDetail =[self.storyboard instantiateViewControllerWithIdentifier:@"AddNoteWorkOrderViewController"];
    
    aDetail.orderId = [[arrOrderList valueForKey:@"iid"]objectAtIndex:sender.tag];
     [self.navigationController pushViewController:aDetail animated:YES];
   
     }
    else{
       alert(@"", @"We're sorry. View mode is not currently available offline");
    }
}
-(void)editWorkOrderTapped:(UIButton*)sender{
    if (gblAppDelegate.isNetworkReachable) {
        
    
    if (_IsServoceProvider) {
        if (![[[arrOrderList valueForKey:@"isEditAllowed"]objectAtIndex:sender.tag] boolValue]){
            
            //do not have edit permission
            //allow user to edit only bellow assign to me section
            
            [self callForDetailView:sender editPermission:NO assignToMePermission:YES];
        }
        
        else {
            
            // have edit permission
              // do not allow user to edit all data
            
            [self callForDetailView:sender editPermission:YES assignToMePermission:YES];

        }
            }
    else
    {
        // general user
        if (_btnShowIncompleteWorkOrder.selected) {
         
            [self callForDetailView:sender editPermission:YES assignToMePermission:YES];

        }
        else if (![[[arrOrderList valueForKey:@"isEditAllowed"]objectAtIndex:sender.tag] boolValue]){
            
            //do not have edit permission
           
//            if ([[[arrOrderList valueForKey:@"IsCreatedByMe"]objectAtIndex:sender.tag] boolValue]) {
//              
//                //  createdby me yes .. allow user to edit all data
//                
//                [self callForDetailView:sender editPermission:YES assignToMePermission:YES];
//            }
//            else if ([[NSString stringWithFormat:@"%@",[[arrOrderList valueForKey:@"WorkOrderHistoryId"]objectAtIndex:sender.tag]] isEqualToString:@"0"] && [[NSString stringWithFormat:@"%@",[[arrOrderList valueForKey:@"InsertedById"]objectAtIndex:sender.tag]] isEqualToString:[[User currentUser] userId]]){
//                
//                    //  createdby me yes .. allow user to edit all data
//                    
//                    [self callForDetailView:sender editPermission:YES assignToMePermission:YES];
//              
//             
//
//            }
          //  else
                if  ([[[arrOrderList valueForKey:@"isAssignedToMe"]objectAtIndex:sender.tag] boolValue]){
                
                // user have assing to me Permission
                   
                    //allow user to edit only bellow assign to me section
                    
                    [self callForDetailView:sender editPermission:NO assignToMePermission:YES];
                    
                }
                else{
                    
                    //user do not created W.O. nither assigned to it.
                   
                    // do not allow user to edit any data
                    alert(@"", @"You do not have permission to access this area");
                }
            
        }
        else{
            
            // having edit permission
         // allow to edit all
            
               [self callForDetailView:sender editPermission:YES assignToMePermission:YES];
            
        }
    }
    }
    else{
        alert(@"", @"We're sorry. Edit is not currently available offline");
    }

}
-(void)callForDetailView:(UIButton*)sender editPermission:(BOOL)editPermission assignToMePermission:(BOOL)assignToMePermission{
    if (_btnShowIncompleteWorkOrder.selected) {
        
        EditWithoutFollowUpViewController * aVCObj =[self.storyboard instantiateViewControllerWithIdentifier:@"EditWithoutFollowUpViewController"];
        aVCObj.orderId = [[arrOrderList valueForKey:@"iid"]objectAtIndex:sender.tag];
        aVCObj.workOrderHistoryId = [[arrOrderList valueForKey:@"workOrderHistoryId"]objectAtIndex:sender.tag];
    
//        if (editPermission) {
//            //allow all to edit
            aVCObj.isOnlyView = @"NO";
        
//        }
//        else {
//            // do not allow to edit
//            alert(@"", @"You do not have permission to access this area");
//
//        }
        [self.navigationController pushViewController:aVCObj animated:YES];
    }
    else{
        EditWithFollowUpViewController * aVCObj =[self.storyboard instantiateViewControllerWithIdentifier:@"EditWithFollowUpViewController"];
        aVCObj.orderId = [[arrOrderList valueForKey:@"iid"]objectAtIndex:sender.tag];
        aVCObj.workOrderHistoryId = [[arrOrderList valueForKey:@"workOrderHistoryId"]objectAtIndex:sender.tag];
        //    aVCObj.isOnlyView = @"NO";
        //   aVCObj.isAssignToMeView = @"NO";
        if (editPermission) {
            //allow all to edit
            aVCObj.isOnlyView = @"NO";
            aVCObj.isEditAllow = @"YES";
            aVCObj.isF_EditAllow = @"YES";
            
        }
        else if (assignToMePermission){
            //allow only below assigne to me section
            aVCObj.isOnlyView = @"NO";
            aVCObj.isEditAllow = @"NO";
            aVCObj.isF_EditAllow = @"YES";
        }
        else {
            // do not allow to edit
            alert(@"", @"You do not have permission to access this area");

        }
        
        [self.navigationController pushViewController:aVCObj animated:YES];
        
    }
}
-(void)viewWorkOrderTapped:(UIButton*)sender{
    if (gblAppDelegate.isNetworkReachable) {
  
    if (_btnShowIncompleteWorkOrder.selected) {
        
        EditWithoutFollowUpViewController * aVCObj =[self.storyboard instantiateViewControllerWithIdentifier:@"EditWithoutFollowUpViewController"];
        aVCObj.orderId = [[arrOrderList valueForKey:@"iid"]objectAtIndex:sender.tag];
        aVCObj.workOrderHistoryId = [[arrOrderList valueForKey:@"workOrderHistoryId"]objectAtIndex:sender.tag];
        aVCObj.isOnlyView = @"YES";
        [self.navigationController pushViewController:aVCObj animated:YES];
        
        
    }
    else{
        EditWithFollowUpViewController * aVCObj =[self.storyboard instantiateViewControllerWithIdentifier:@"EditWithFollowUpViewController"];
        aVCObj.orderId = [[arrOrderList valueForKey:@"iid"]objectAtIndex:sender.tag];
        aVCObj.workOrderHistoryId = [[arrOrderList valueForKey:@"workOrderHistoryId"]objectAtIndex:sender.tag];
        aVCObj.isOnlyView = @"YES";
                [self.navigationController pushViewController:aVCObj animated:YES];
        
    }
 
}
else{
    alert(@"", @"We're sorry. Add note is not currently available offline");
}
}
- (IBAction)btnShowIncompleteWorkOrderTapped:(UIButton *)sender {
       if (sender.isSelected) {
           [sender setSelected:NO];
         //  [self getWorkOrderData:@"false"];
            [self loadDataInList:@"CreatedByMe"];
    }
       else{
            [sender setSelected:YES];
//           [self getWorkOrderData:@"true"];
            [self loadDataInList:@"InProgress"];
       }


}
- (void)insertWorkOrderAssignToMeList:(NSDictionary*)Dict{
    NSMutableArray *arrWorkorderList = [NSMutableArray new];
    [arrWorkorderList addObjectsFromArray:[Dict valueForKey:@"WorkOrders"]];
    for (NSDictionary *aDict in arrWorkorderList) {
        
        WorkOrderAssignToMe * workOrder = [NSEntityDescription insertNewObjectForEntityForName:@"WorkOrderAssignToMe" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        
        if (![[aDict objectForKey:@"AssignedTo"] isKindOfClass:[NSNull class]]) {
            workOrder.assignedTo = [aDict objectForKey:@"AssignedTo"];
        }
        else {
            workOrder.assignedTo = @"";
        }
        
        workOrder.currentStatus = [aDict objectForKey:@"CurrentStatus"];
        workOrder.dateSubmitted = [aDict objectForKey:@"DateSubmitted"];
        workOrder.description1 = [aDict objectForKey:@"Description"];
        workOrder.equipmentId = [aDict objectForKey:@"EquipmentId"];
        
        workOrder.iD = [[aDict objectForKey:@"Id"] stringValue];
        workOrder.insertedById = [[aDict objectForKey:@"InsertedById"] stringValue];
        
        if ([[aDict objectForKey:@"IsAssignedToMe"] boolValue]) {
            workOrder.isAssignedToMe = @"true";
        }
        else{
            workOrder.isAssignedToMe = @"false";
        }
        if ([[aDict objectForKey:@"IsEditAllowed"] boolValue]) {
            workOrder.isEditAllowed = @"true";
        }
        else{
            workOrder.isEditAllowed = @"false";
        }
        if ([[aDict objectForKey:@"IsImageAvailable"] boolValue]) {
            workOrder.isImageAvailable = @"true";
        }
        else{
            workOrder.isImageAvailable = @"false";
        }
        if ([[aDict objectForKey:@"IsViewAllowed"] boolValue]) {
            workOrder.isViewAllowed = @"true";
        }
        else{
            workOrder.isViewAllowed = @"false";
        }
        if ([[aDict objectForKey:@"IsCreatedByMe"] boolValue]) {
            workOrder.isCreatedByMe = @"true";
        }
        else{
            workOrder.isCreatedByMe = @"false";
        }
        
        if (![[aDict objectForKey:@"Notes"] isKindOfClass:[NSNull class]]) {
            workOrder.notes = [Dict objectForKey:@"Notes"] ;
        }
        else {
            workOrder.notes = @"";
        }
        workOrder.updatedBy = [aDict objectForKey:@"UpdatedBy"];
        workOrder.updatedOn = [aDict objectForKey:@"UpdatedOn"];
        workOrder.workOrderHistoryId = [[aDict objectForKey:@"WorkOrderHistoryId"] stringValue];
        workOrder.workOrderId =[aDict objectForKey:@"WorkOrderId"];
        workOrder.workOrderType = [aDict objectForKey:@"WorkOrderType"];
        
        //        @property (assign, nonatomic) BOOL  isAssignedToMe;
        //        @property (assign, nonatomic) BOOL isEditAllowed;
        //        @property (assign, nonatomic) BOOL  isImageAvailable;
        //        @property (assign, nonatomic) BOOL  isViewAllowed;
        //        @property (assign, nonatomic) BOOL  isCreatedByMe;
        
        [gblAppDelegate.managedObjectContext insertObject:workOrder];
        [gblAppDelegate.managedObjectContext save:nil];
    }
}

- (void)insertWorkOrderCreatedByMeList:(NSDictionary*)Dict{
    NSMutableArray *arrWorkorderList = [NSMutableArray new];
    [arrWorkorderList addObjectsFromArray:[Dict valueForKey:@"WorkOrders"]];
    for (NSDictionary *aDict in arrWorkorderList) {
        
        WorkOrderCreated * workOrder = [NSEntityDescription insertNewObjectForEntityForName:@"WorkOrderCreated" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        
        if (![[aDict objectForKey:@"AssignedTo"] isKindOfClass:[NSNull class]]) {
            workOrder.assignedTo = [aDict objectForKey:@"AssignedTo"];
        }
        else {
            workOrder.assignedTo = @"";
        }
        
        workOrder.currentStatus = [aDict objectForKey:@"CurrentStatus"];
        workOrder.dateSubmitted = [aDict objectForKey:@"DateSubmitted"];
        workOrder.description1 = [aDict objectForKey:@"Description"];
        workOrder.equipmentId = [aDict objectForKey:@"EquipmentId"];
        
        workOrder.iD = [[aDict objectForKey:@"Id"] stringValue];
        workOrder.insertedById = [[aDict objectForKey:@"InsertedById"] stringValue];
        
        if ([[aDict objectForKey:@"IsAssignedToMe"] boolValue]) {
            workOrder.isAssignedToMe = @"true";
        }
        else{
            workOrder.isAssignedToMe = @"false";
        }
        if ([[aDict objectForKey:@"IsEditAllowed"] boolValue]) {
            workOrder.isEditAllowed = @"true";
        }
        else{
            workOrder.isEditAllowed = @"false";
        }
        if ([[aDict objectForKey:@"IsImageAvailable"] boolValue]) {
            workOrder.isImageAvailable = @"true";
        }
        else{
            workOrder.isImageAvailable = @"false";
        }
        if ([[aDict objectForKey:@"IsViewAllowed"] boolValue]) {
            workOrder.isViewAllowed = @"true";
        }
        else{
            workOrder.isViewAllowed = @"false";
        }
        if ([[aDict objectForKey:@"IsCreatedByMe"] boolValue]) {
            workOrder.isCreatedByMe = @"true";
        }
        else{
            workOrder.isCreatedByMe = @"false";
        }
        
        if (![[aDict objectForKey:@"Notes"] isKindOfClass:[NSNull class]]) {
            workOrder.notes = [Dict objectForKey:@"Notes"] ;
        }
        else {
            workOrder.notes = @"";
        }
        workOrder.updatedBy = [aDict objectForKey:@"UpdatedBy"];
        workOrder.updatedOn = [aDict objectForKey:@"UpdatedOn"];
        workOrder.workOrderHistoryId = [[aDict objectForKey:@"WorkOrderHistoryId"] stringValue];
        workOrder.workOrderId =[aDict objectForKey:@"WorkOrderId"];
        workOrder.workOrderType = [aDict objectForKey:@"WorkOrderType"];
        
        //        @property (assign, nonatomic) BOOL  isAssignedToMe;
        //        @property (assign, nonatomic) BOOL isEditAllowed;
        //        @property (assign, nonatomic) BOOL  isImageAvailable;
        //        @property (assign, nonatomic) BOOL  isViewAllowed;
        //        @property (assign, nonatomic) BOOL  isCreatedByMe;
        
        [gblAppDelegate.managedObjectContext insertObject:workOrder];
        [gblAppDelegate.managedObjectContext save:nil];
    }
    
    
    
    
}

- (void)insertWorkOrderCreatedByMeInProgressList:(NSDictionary*)Dict{
    NSMutableArray *arrWorkorderList = [NSMutableArray new];
    [arrWorkorderList addObjectsFromArray:[Dict valueForKey:@"WorkOrders"]];
    for (NSDictionary *aDict in arrWorkorderList) {
        
        WorkOrderCreatedInProgres * workOrder = [NSEntityDescription insertNewObjectForEntityForName:@"WorkOrderCreatedInProgres" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        
        if (![[aDict objectForKey:@"AssignedTo"] isKindOfClass:[NSNull class]]) {
            workOrder.assignedTo = [aDict objectForKey:@"AssignedTo"];
        }
        else {
            workOrder.assignedTo = @"";
        }
        
        workOrder.currentStatus = [aDict objectForKey:@"CurrentStatus"];
        workOrder.dateSubmitted = [aDict objectForKey:@"DateSubmitted"];
        workOrder.description1 = [aDict objectForKey:@"Description"];
        workOrder.equipmentId = [aDict objectForKey:@"EquipmentId"];
        
        workOrder.iD = [[aDict objectForKey:@"Id"] stringValue];
        workOrder.insertedById = [[aDict objectForKey:@"InsertedById"] stringValue];
        
        if ([[aDict objectForKey:@"IsAssignedToMe"] boolValue]) {
            workOrder.isAssignedToMe = @"true";
        }
        else{
            workOrder.isAssignedToMe = @"false";
        }
        if ([[aDict objectForKey:@"IsEditAllowed"] boolValue]) {
            workOrder.isEditAllowed = @"true";
        }
        else{
            workOrder.isEditAllowed = @"false";
        }
        if ([[aDict objectForKey:@"IsImageAvailable"] boolValue]) {
            workOrder.isImageAvailable = @"true";
        }
        else{
            workOrder.isImageAvailable = @"false";
        }
        if ([[aDict objectForKey:@"IsViewAllowed"] boolValue]) {
            workOrder.isViewAllowed = @"true";
        }
        else{
            workOrder.isViewAllowed = @"false";
        }
        if ([[aDict objectForKey:@"IsCreatedByMe"] boolValue]) {
            workOrder.isCreatedByMe = @"true";
        }
        else{
            workOrder.isCreatedByMe = @"false";
        }
        
        if (![[aDict objectForKey:@"Notes"] isKindOfClass:[NSNull class]]) {
            workOrder.notes = [Dict objectForKey:@"Notes"] ;
        }
        else {
            workOrder.notes = @"";
        }
        workOrder.updatedBy = [aDict objectForKey:@"UpdatedBy"];
        workOrder.updatedOn = [aDict objectForKey:@"UpdatedOn"];
        workOrder.workOrderHistoryId = [[aDict objectForKey:@"WorkOrderHistoryId"] stringValue];
        workOrder.workOrderId =[aDict objectForKey:@"WorkOrderId"];
        workOrder.workOrderType = [aDict objectForKey:@"WorkOrderType"];
        
        //        @property (assign, nonatomic) BOOL  isAssignedToMe;
        //        @property (assign, nonatomic) BOOL isEditAllowed;
        //        @property (assign, nonatomic) BOOL  isImageAvailable;
        //        @property (assign, nonatomic) BOOL  isViewAllowed;
        //        @property (assign, nonatomic) BOOL  isCreatedByMe;
        
        [gblAppDelegate.managedObjectContext insertObject:workOrder];
        [gblAppDelegate.managedObjectContext save:nil];
    }
    
    
    
    
}
- (void)fetchWorkOrderListData:(NSString *)assignedToMe showAll:(NSString*)showAll showInProgressWorkOrder:(NSString*)showInProgressWorkOrder{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"WorkOrderAssignToMe"];
    [request setPropertiesToFetch:@[@"updatedBy"]];
    
    if ([assignedToMe isEqualToString:@"true"] && [showAll isEqualToString:@"false"] && [showInProgressWorkOrder isEqualToString:@"false"]) {
        request = [[NSFetchRequest alloc] initWithEntityName:@"WorkOrderAssignToMe"];
        [request setPropertiesToFetch:@[@"updatedBy"]];
    }
    else  if ([assignedToMe isEqualToString:@"false"] && [showAll isEqualToString:@"false"] && [showInProgressWorkOrder isEqualToString:@"false"]) {
        request = [[NSFetchRequest alloc] initWithEntityName:@"WorkOrderCreated"];
        [request setPropertiesToFetch:@[@"updatedBy"]];
    }
    else  {
        request = [[NSFetchRequest alloc] initWithEntityName:@"WorkOrderCreatedInProgres"];
        [request setPropertiesToFetch:@[@"updatedBy"]];
    }

    arrWorkorderList = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    NSLog(@"%lu",(unsigned long)arrWorkorderList.count);
    
}


- (void)deleteAllWorkOrderListData:(NSString *)assignedToMe showAll:(NSString*)showAll showInProgressWorkOrder:(NSString*)showInProgressWorkOrder {
  NSFetchRequest *request  = [[NSFetchRequest alloc] initWithEntityName:@"WorkOrderAssignToMe"];
    if ([assignedToMe isEqualToString:@"true"] && [showAll isEqualToString:@"false"] && [showInProgressWorkOrder isEqualToString:@"false"]) {
     request = [[NSFetchRequest alloc] initWithEntityName:@"WorkOrderAssignToMe"];
        [request setIncludesPropertyValues:NO];
    }
    else  if ([assignedToMe isEqualToString:@"false"] && [showAll isEqualToString:@"false"] && [showInProgressWorkOrder isEqualToString:@"false"]) {
        request = [[NSFetchRequest alloc] initWithEntityName:@"WorkOrderCreated"];
        [request setIncludesPropertyValues:NO];
    }
    else  {
       request = [[NSFetchRequest alloc] initWithEntityName:@"WorkOrderCreatedInProgres"];
        [request setIncludesPropertyValues:NO];
    }

    NSArray *aryRecords = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    for (NSManagedObject *rec in aryRecords) {
        [gblAppDelegate.managedObjectContext deleteObject:rec];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}
@end
