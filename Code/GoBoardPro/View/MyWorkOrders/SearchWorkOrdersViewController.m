
//
//  MyWorkOrdersViewController.m
//  GoBoardPro
//
//  Created by Optiquall Solutions on 13/12/17.
//  Copyright © 2017 IndiaNIC. All rights reserved.
// expand_icon_small@2x.png

#import "SearchWorkOrdersViewController.h"
#import "MyWorkOrdersTypeViewController.h"
#import "UserHomeViewController.h"
#import "MyWorkOrdersTableViewCell.h"
#import "AddNoteWorkOrderViewController.h"
#import "CreateWorkOrderViewController.h"
#import "EditWithoutFollowUpViewController.h"
#import "EditWithFollowUpViewController.h"
#import "UserFacility.h"

@interface SearchWorkOrdersViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UserFacility *selectedFacility;
    NSArray * arrayFacility,  * arrCategory, * arrType,*arrWorkorderList;
    NSDictionary * responceDic,* responceDicFilter;
    NSMutableArray * selectedFacilityArr,* selectedLocationArr,* selectedCategoryArr,* selectedTypeArr, * arrOrderList,* arrayLocation;
    NSInteger selectedIndex;
    NSString * selectedNumber,*firstTime;
}
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
//@property (weak, nonatomic) IBOutlet UISegmentedControl *workOrdersTabSegment;
@property (weak, nonatomic) IBOutlet UIButton *btnExpandFilterView;
@property (weak, nonatomic) IBOutlet UILabel *lblFrom;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgtxtDateFrom;
@property (weak, nonatomic) IBOutlet UIImageView *imgTxtDateFrom;
@property (weak, nonatomic) IBOutlet UILabel *lblTo;
@property (weak, nonatomic) IBOutlet UIImageView *imgBgtxtDateTo;
@property (weak, nonatomic) IBOutlet UIImageView *imgTxtDateTo;
@property (weak, nonatomic) IBOutlet UILabel *lblFacility;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;

@property (weak, nonatomic) IBOutlet UITextField *txtFromDate;
@property (weak, nonatomic) IBOutlet UITextField *txtToDate;
@property (weak, nonatomic) IBOutlet UITextField *txtFacility;
@property (weak, nonatomic) IBOutlet UIView *viewFacility;
@property (weak, nonatomic) IBOutlet UITableView *tblFacility;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UIView *viewLocation;
@property (weak, nonatomic) IBOutlet UITableView *tblLocation;
@property (weak, nonatomic) IBOutlet UITextField *txtCategory;
@property (weak, nonatomic) IBOutlet UIView *viewCategory;
@property (weak, nonatomic) IBOutlet UITableView *tblCategory;
@property (weak, nonatomic) IBOutlet UITextField *txtType;
@property (weak, nonatomic) IBOutlet UIView *viewType;
@property (weak, nonatomic) IBOutlet UITableView *tblType;
@property (weak, nonatomic) IBOutlet UITableView *tblOrdersDetailList;
@property (weak, nonatomic) IBOutlet UILabel *lblCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UIView *viewListParametersBG;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGFacilityTbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGLocationTbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGCategoryTbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGTypeTbl;
@property (weak, nonatomic) IBOutlet UILabel *lblNote;

@property (weak, nonatomic) IBOutlet UIView *viewTblHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRecordOrder;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRecordFacility;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRecordLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRecordCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRecordType;
@property (weak, nonatomic) IBOutlet UIButton *btnCreate;



@end

@implementation SearchWorkOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    firstTime =@"YES";
    responceDic = [[NSDictionary alloc]init];
    _lblNoRecordOrder.hidden = NO;
    NSString *strFacilityId =[[NSUserDefaults standardUserDefaults] objectForKey:@"facilityId"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"myWorkOrderRecponce"];
    
    // [gblAppDelegate showActivityIndicator];
    //  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    
    
    if (gblAppDelegate.isNetworkReachable) {
        
        [self callServiceForMyWorkOrders:YES complition:^{
            arrayFacility = [[NSArray alloc]init];
            arrayLocation = [[NSMutableArray alloc]init];
            arrCategory = [[NSArray alloc]init];
            arrType = [[NSArray alloc]init];
            selectedFacilityArr = [[NSMutableArray alloc]init];
            selectedLocationArr= [[NSMutableArray alloc]init];
            selectedCategoryArr = [[NSMutableArray alloc]init];
            selectedTypeArr = [[NSMutableArray alloc]init];
            arrOrderList = [[NSMutableArray alloc]init];
            arrWorkorderList =[[NSArray alloc]init];
            [selectedFacilityArr addObject:strFacilityId];
            
            NSData *dictionaryData = [[NSUserDefaults standardUserDefaults] objectForKey:@"myWorkOrderRecponce"];
            responceDic = [NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
            NSLog(@"%@",responceDic);
            
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UserFacility"];
            [request setPropertiesToFetch:@[@"name", @"value"]];
            NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            [request setSortDescriptors:@[sortByName]];
            arrayFacility = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
            
            
            NSFetchRequest *requestLoc = [[NSFetchRequest alloc] initWithEntityName:@"UserInventoryLocation"];
            NSPredicate *predicateLoc = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"facility.value", strFacilityId];
            [requestLoc setPredicate:predicateLoc];
            NSSortDescriptor *sortByName2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            [requestLoc setSortDescriptors:@[sortByName2]];
            [requestLoc setPropertiesToFetch:@[@"name", @"value"]];
            NSArray * tempArr = [[NSArray alloc]init];
            tempArr = [gblAppDelegate.managedObjectContext executeFetchRequest:requestLoc error:nil];
            [arrayLocation addObjectsFromArray:tempArr];
            NSString * tempFaciStr = @"";
            for (int j=0; j<arrayFacility.count; j++) {
                if ([strFacilityId isEqualToString:[[arrayFacility valueForKey:@"value"] objectAtIndex:j]]) {
                    tempFaciStr = [[arrayFacility valueForKey:@"name"] objectAtIndex:j];
                }
            }
            for (int i = 0; i<arrayLocation.count; i++) {
                
                NSMutableDictionary * tepDic = [[NSMutableDictionary alloc]init];
                tepDic = [arrayLocation objectAtIndex:i];
                [tepDic setValue:[NSString stringWithFormat:@"%@(%@)",[[arrayLocation valueForKey:@"name"] objectAtIndex:i],tempFaciStr] forKey:@"name"];
                
                [arrayLocation replaceObjectAtIndex:i withObject:tepDic];
                
            }
            
            arrCategory = [responceDic valueForKey:@"InventoryCategories"];
            arrType = [responceDic valueForKey:@"InventoryTypes"];
        }];
    }
    else{
        
        [gblAppDelegate hideActivityIndicator];
         alert(@"", @"To see updated data please check your internet connection.");
      //  alert(@"", @"We're sorry. C2IT is not currently available offline");
    }
    // });
}
-(void)callServiceForMyWorkOrders:(BOOL)waitUntilDone complition:(void (^)(void))complition
{
    __block BOOL isWSComplete = NO;
    
    NSString *strFacilityId =[[NSUserDefaults standardUserDefaults] objectForKey:@"facilityId"];
    NSString *aStrAccountId = [[NSUserDefaults standardUserDefaults] objectForKey:@"accountId"];
    NSString *strUserId = @"";
    if ([User checkUserExist]) {
        strUserId = [[User currentUser] userId];
    }
    
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?accountId=%@&userId=%@&facilityId=%@", MY_WORK_ORDERS, aStrAccountId, strUserId,strFacilityId] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:MY_WORK_ORDERS] complition:^(NSDictionary *response){
        NSLog(@"%@",response);
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:response];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"myWorkOrderRecponce"];
        
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
-(void)setupView{
    
    if (_btnExpandFilterView.selected) {
        
        _tblFacility.hidden = NO;
        _tblLocation.hidden = NO;
        _lblCategory.hidden = NO;
        _lblType.hidden = NO;
        _tblCategory.hidden = NO;
        _tblType.hidden = NO;
        _btnSubmit.hidden = NO;
        _lblNoRecordFacility.hidden = NO;
        _lblNoRecordLocation.hidden = NO;
        _lblNoRecordCategory.hidden = NO;
        _lblNoRecordType.hidden = NO;
        _imgBGFacilityTbl.hidden = NO;
        _imgBGLocationTbl.hidden = NO;
        _imgBGCategoryTbl.hidden = NO;
        _imgBGTypeTbl.hidden = NO;
        _lblFrom.hidden = NO;
        _lblTo.hidden = NO;
        _imgBgtxtDateFrom.hidden = NO;
        _imgTxtDateFrom.hidden = NO;
        _imgBgtxtDateTo.hidden = NO;
        _imgTxtDateTo.hidden = NO;
        _lblFacility.hidden = NO;
        _lblLocation.hidden = NO;
        
        CGRect frame =  _tblFacility.frame;
        if (arrayFacility.count > 3) {
            frame.size.height = 3 * 44;
        }
        else
            frame.size.height = arrayFacility.count * 44;
        _tblFacility.frame = frame;
        
        frame =  _tblLocation.frame;
        if (arrayLocation.count > 3) {
            frame.size.height = 3 * 44;
        }
        else
            frame.size.height = arrayLocation.count * 44;
        _tblLocation.frame = frame;
        
        frame =  _lblCategory.frame;
        if (_tblFacility.frame.size.height < _tblLocation.frame.size.height) {
            frame.origin.y = _tblLocation.frame.size.height + _tblLocation.frame.origin.y + 20;
        }
        else
            frame.origin.y = _tblFacility.frame.size.height + _tblFacility.frame.origin.y + 20;
        _lblCategory.frame = frame;
        
        frame.origin.x = _lblType.frame.origin.x;
        _lblType.frame = frame;
        
        frame =  _tblCategory.frame;
        frame.origin.y = _lblCategory.frame.size.height  +  _lblCategory.frame.origin.y + 20;
        if (arrCategory.count > 3) {
            frame.size.height = 3 * 44;
        }
        else
            frame.size.height = arrCategory.count * 44;
        
        _tblCategory.frame = frame;
        
        frame =  _tblType.frame;
        frame.origin.y = _lblType.frame.size.height  +  _lblType.frame.origin.y + 20;
        if (arrType.count > 3) {
            frame.size.height = 3 * 44;
        }
        else
            frame.size.height = arrType.count * 44;
        
        _tblType.frame = frame;
        
        frame =  _btnSubmit.frame;
        if (_tblCategory.frame.size.height < _tblType.frame.size.height) {
            frame.origin.y = _tblType.frame.size.height + _tblType.frame.origin.y + 20;
        }
        else
            frame.origin.y = _tblCategory.frame.size.height + _tblCategory.frame.origin.y + 20;
        _btnSubmit.frame = frame;
        
        frame = _lblNote.frame;
        frame.origin.y = _btnSubmit.frame.size.height + _btnSubmit.frame.origin.y + 20;
        _lblNote.frame = frame;
        
        frame =  _viewListParametersBG.frame;
        frame.origin.y = _lblNote.frame.size.height + _lblNote.frame.origin.y + 20;
        _viewListParametersBG.frame = frame;
        _imgBGFacilityTbl.frame = _tblFacility.frame;
        _imgBGLocationTbl.frame = _tblLocation.frame;
        _imgBGCategoryTbl.frame = _tblCategory.frame;
        _imgBGTypeTbl.frame = _tblType.frame;
        
        frame =  _viewTblHeader.frame;
        frame.size.height = _viewListParametersBG.frame.size.height + _viewListParametersBG.frame.origin.y + 5;
        _viewTblHeader.frame = frame;
        
        frame = _lblNoRecordFacility.frame;
        frame.origin.y = _tblFacility.frame.origin.y;
        _lblNoRecordFacility.frame = frame;
        
        frame = _lblNoRecordLocation.frame;
        frame.origin.y = _tblLocation.frame.origin.y;
        _lblNoRecordLocation.frame = frame;
        
        frame = _lblNoRecordCategory.frame;
        frame.origin.y = _tblCategory.frame.origin.y;
        _lblNoRecordCategory.frame = frame;
        
        frame = _lblNoRecordType.frame;
        frame.origin.y = _tblType.frame.origin.y;
        _lblNoRecordType.frame = frame;
        
    }else{
        
        _tblFacility.hidden = YES;
        _tblLocation.hidden = YES;
        _lblCategory.hidden = YES;
        _lblType.hidden = YES;
        _tblCategory.hidden = YES;
        _tblType.hidden = YES;
        _btnSubmit.hidden = YES;
        _lblNoRecordFacility.hidden = YES;
        _lblNoRecordLocation.hidden = YES;
        _lblNoRecordCategory.hidden = YES;
        _lblNoRecordType.hidden = YES;
        _imgBGFacilityTbl.hidden = YES;
        _imgBGLocationTbl.hidden = YES;
        _imgBGCategoryTbl.hidden = YES;
        _imgBGTypeTbl.hidden = YES;
        _lblFrom.hidden = YES;
        _lblTo.hidden = YES;
        _imgBgtxtDateFrom.hidden = YES;
        _imgTxtDateFrom.hidden = YES;
        _imgBgtxtDateTo.hidden = YES;
        _imgTxtDateTo.hidden = YES;
        _lblFacility.hidden = YES;
        _lblLocation.hidden = YES;
        
        
        CGRect frame = _lblNote.frame;
        frame.origin.y = _btnExpandFilterView.frame.size.height + _btnExpandFilterView.frame.origin.y + 20;
        _lblNote.frame = frame;
        
        frame =  _viewListParametersBG.frame;
        
        frame =  _viewListParametersBG.frame;
        frame.origin.y = _lblNote.frame.size.height + _lblNote.frame.origin.y + 20;
        _viewListParametersBG.frame = frame;
        
        frame =  _viewTblHeader.frame;
        frame.size.height = _viewListParametersBG.frame.size.height + _viewListParametersBG.frame.origin.y + 5;
        _viewTblHeader.frame = frame;
    }
    CGRect frame =  _tblOrdersDetailList.frame;
    frame.size.height = self.view.frame.size.height - 210;
    _tblOrdersDetailList.frame =frame;
    
    frame =  _btnCreate.frame;
    frame.origin.y = _tblOrdersDetailList.frame.origin.y +_tblOrdersDetailList.frame.size.height + 11;
    _btnCreate.frame =frame;
    
    [_tblOrdersDetailList reloadData];
    
}
-(void)viewWillAppear:(BOOL)animated{
    firstTime =@"YES";
    
    UIButton * btn = [[UIButton alloc]init];
    [self btnSubmitTapped:btn];
    [self setupView];
}
- (IBAction)btnBack:(UIButton *)sender {
    for (UIViewController *aVCObj in self.navigationController.viewControllers) {
        if ([aVCObj isKindOfClass:[MyWorkOrdersTypeViewController class]]) {
            [self.navigationController popToViewController:aVCObj animated:YES];
        }
    }
    
}
#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tblFacility) {
        if (_btnExpandFilterView.selected) {
            if (arrayFacility.count == 0) {
                _imgBGFacilityTbl.hidden = YES;
            }else{
                _imgBGFacilityTbl.hidden = NO;
            }
        }
        
        return arrayFacility.count;
    }
    else if (tableView == self.tblLocation) {
        if (_btnExpandFilterView.selected) {
            if (arrayLocation.count == 0) {
                _imgBGLocationTbl.hidden = YES;
            }else{
                _imgBGLocationTbl.hidden = NO;
            }
        }
        return arrayLocation.count;
    }
    else if (tableView == self.tblCategory) {
        if (_btnExpandFilterView.selected) {
            if (arrCategory.count == 0) {
                _imgBGCategoryTbl.hidden = YES;
            }else{
                _imgBGCategoryTbl.hidden = NO;
            }
            
        }
        return arrCategory.count;
    }
    else if (tableView == self.tblType) {
        if (_btnExpandFilterView.selected) {
            if (arrType.count == 0) {
                _imgBGTypeTbl.hidden = YES;
            }else{
                _imgBGTypeTbl.hidden = NO;
            }
        }
        return arrType.count;
    }
    
    return arrOrderList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyWorkOrdersTableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (tableView == _tblFacility) {
        //   NSString *strFacilityId =[[NSUserDefaults standardUserDefaults] objectForKey:@"facilityId"];
        
        aCell.lblItemTitle.text = [[arrayFacility valueForKey:@"name"] objectAtIndex:indexPath.row];
        
        if ([selectedFacilityArr containsObject:[[arrayFacility valueForKey:@"value"] objectAtIndex:indexPath.row]]) {
            
            aCell.imgCheckBox.image = [UIImage imageNamed:@"selected_check_box@2x.png"];
            
        }
        else{
            aCell.imgCheckBox.image = [UIImage imageNamed:@"check_box@2x.png"];
            
        }
        
        
    }
    else  if (tableView == _tblLocation) {
        
        
        aCell.lblItemTitle.text = [[arrayLocation valueForKey:@"name"] objectAtIndex:indexPath.row];
        
        if ([selectedLocationArr containsObject:[[arrayLocation valueForKey:@"value"] objectAtIndex:indexPath.row]]) {
            
            aCell.imgCheckBox.image = [UIImage imageNamed:@"selected_check_box@2x.png"];
            
        }
        else{
            aCell.imgCheckBox.image = [UIImage imageNamed:@"check_box@2x.png"];
            
        }
        
        
    }
    else  if (tableView == _tblCategory) {
        aCell.lblItemTitle.text = [[arrCategory valueForKey:@"Name"] objectAtIndex:indexPath.row];
        if ([selectedCategoryArr containsObject:[[arrCategory valueForKey:@"Id"] objectAtIndex:indexPath.row]]) {
            
            aCell.imgCheckBox.image = [UIImage imageNamed:@"selected_check_box@2x.png"];
            
        }
        else{
            aCell.imgCheckBox.image = [UIImage imageNamed:@"check_box@2x.png"];
            
        }
        
    }
    else  if (tableView == _tblType) {
        aCell.lblItemTitle.text = [[arrType valueForKey:@"Name"] objectAtIndex:indexPath.row];
        if ([selectedTypeArr containsObject:[[arrType valueForKey:@"Id"] objectAtIndex:indexPath.row]]) {
            
            aCell.imgCheckBox.image = [UIImage imageNamed:@"selected_check_box@2x.png"];
            
        }
        else{
            aCell.imgCheckBox.image = [UIImage imageNamed:@"check_box@2x.png"];
            
        }
        
    }else{
        
        NSManagedObject * obj = [arrOrderList objectAtIndex:indexPath.row];

        if ([[obj valueForKey:@"workOrderId"] isKindOfClass:[NSNull class]]) {
            aCell.lblWorkOrderNumber.text = @"-";
        }
        else{
            aCell.lblWorkOrderNumber.text = [NSString stringWithFormat:@"%@",[obj valueForKey:@"workOrderId"]];
        }
        if ([[obj valueForKey:@"workOrderType"] isKindOfClass:[NSNull class]]) {
            
            aCell.lblGeneralEquipment.text = @"-";
        }
        else{
            aCell.lblGeneralEquipment.text = [NSString stringWithFormat:@"%@",[obj valueForKey:@"workOrderType"]];
        }
        if ([[obj valueForKey:@"description1"] isKindOfClass:[NSNull class]]) {
            
            aCell.lblTitleDescription.text = @"-";
        }
        else{
            aCell.lblTitleDescription.text = [NSString stringWithFormat:@"%@",[obj valueForKey:@"description1"]];
        }
        if ([[obj valueForKey:@"currentStatus"] isKindOfClass:[NSNull class]]) {
            aCell.lblCurrentStatus.text = @"-";
        }
        else{
            aCell.lblCurrentStatus.text = [NSString stringWithFormat:@"%@",[obj valueForKey:@"currentStatus"] ];
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
                aCell.lblGeneralEquipmentId.text = [NSString stringWithFormat:@"Item ID : %@",[obj valueForKey:@"description1"]];
            }
            
        }
        if ([[obj valueForKey:@"description1"] isKindOfClass:[NSNull class]]) {
            
            aCell.lblDescription.text = @"Description : -";
        }
        else{
            aCell.lblDescription.text = [NSString stringWithFormat:@"Description : %@",[obj valueForKey:@"description1"]];
        }
        
        
        if ([[obj valueForKey:@"isImageAvailable"] isKindOfClass:[NSNull class]]) {
            aCell.lblImage.text = @"Image available : -";
        }
        else{
            //             BOOL imgAvailable = [[[arrOrderList valueForKey:@"IsImageAvailable"]  objectAtIndex:indexPath.row] boolValue];
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
            NSDate *date = [dateformatter dateFromString:[obj valueForKey:@"dateSubmitted"] ];
            [dateformatter setDateFormat:@"MM/dd/yyyy"];
            
            aCell.lblDateSubmitted.text = [NSString stringWithFormat:@"Date submitted : %@",[dateformatter stringFromDate:date]];
        }
        if ([[obj valueForKey:@"assignedTo"] isKindOfClass:[NSNull class]]) {
            aCell.lblAssignTo.text = @"Assign to : -";
        }
        else{
            aCell.lblAssignTo.text = [NSString stringWithFormat:@"Assign to : %@",[obj valueForKey:@"assignedTo"] ];
        }
        
        
        if ([[obj valueForKey:@"updatedOn"] isKindOfClass:[NSNull class]]) {
            aCell.lblLastUpdated.text = @"Last updated : -";
        }
        else{
            
            NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
            [dateformatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]]; // Prevent adjustment to user's local time zone.
            [dateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
            NSDate *date = [dateformatter dateFromString:[obj valueForKey:@"updatedOn"] ];
            [dateformatter setDateFormat:@"MM/dd/yyyy"];
            aCell.lblLastUpdated.text = [NSString stringWithFormat:@"Last updated : %@",[dateformatter stringFromDate:date]];
            
        }
        if ([[obj valueForKey:@"updatedBy"] isKindOfClass:[NSNull class]]) {
            
            aCell.lblUpdatedBy.text = @"Updated by : -";
        }
        else{
            aCell.lblUpdatedBy.text = [NSString stringWithFormat:@"Updated by : %@",[obj valueForKey:@"updatedBy"] ];
        }
        if ([[obj valueForKey:@"notes"] isKindOfClass:[NSNull class]]) {
            aCell.lblNotes.text = @"Notes : -";
        }
        else{
            aCell.lblNotes.text = [NSString stringWithFormat:@"Notes : %@",[obj valueForKey:@"notes"] ];
        }
        [aCell.btnView addTarget:self action:@selector(btnViewWorkWorderTapped:) forControlEvents:UIControlEventTouchUpInside];
        aCell.btnView.tag = indexPath.row;
        
        [aCell.btnEdit addTarget:self action:@selector(btnEditWorkWorderTapped:) forControlEvents:UIControlEventTouchUpInside];
        aCell.btnEdit.tag = indexPath.row;
        
        
    }
    return aCell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tblOrdersDetailList) {
        
        if ([selectedNumber isEqualToString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
            NSManagedObject * obj = [arrOrderList objectAtIndex:indexPath.row];
            
            NSString *aString = [obj valueForKey:@"description1"] ;
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
        else return 55;
    }
    else
        return 55;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tblFacility) {
        if ([selectedFacilityArr containsObject:[[arrayFacility valueForKey:@"value"] objectAtIndex:indexPath.row]]) {
            [selectedFacilityArr removeObject:[[arrayFacility valueForKey:@"value"] objectAtIndex:indexPath.row]];
        }else{
            [selectedFacilityArr addObject:[[arrayFacility valueForKey:@"value"] objectAtIndex:indexPath.row]];
        }
        NSLog(@"%@",arrayLocation);
        arrayLocation = [NSMutableArray new];
        selectedLocationArr = [NSMutableArray new];
        for (int i=0; i<selectedFacilityArr.count; i++) {
            NSFetchRequest *requestLoc = [[NSFetchRequest alloc] initWithEntityName:@"UserInventoryLocation"];
            NSPredicate *predicateLoc = [NSPredicate predicateWithFormat:@"%K MATCHES[cd] %@", @"facility.value", [selectedFacilityArr objectAtIndex:i]];
            [requestLoc setPredicate:predicateLoc];
            NSSortDescriptor *sortByName2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            [requestLoc setSortDescriptors:@[sortByName2]];
            [requestLoc setPropertiesToFetch:@[@"name", @"value"]];
            NSArray * tempArrLocation =[[NSArray alloc] init];
            tempArrLocation = [gblAppDelegate.managedObjectContext executeFetchRequest:requestLoc error:nil];
            [arrayLocation addObjectsFromArray:tempArrLocation];
            
            NSString * tempFaciStr = @"";
            
            for (int j = 0; j<arrayFacility.count; j++) {
                if ([[selectedFacilityArr objectAtIndex:i] isEqualToString:[[arrayFacility valueForKey:@"value"] objectAtIndex:j]]) {
                    tempFaciStr = [[arrayFacility valueForKey:@"name"] objectAtIndex:j];
                }
            }
            for (int k = 0; k< tempArrLocation.count; k++) {
                NSMutableDictionary * tepDic = [[NSMutableDictionary alloc]init];
                tepDic = [tempArrLocation objectAtIndex:k];
                if ([[[tempArrLocation valueForKey:@"name"] objectAtIndex:k] rangeOfString:tempFaciStr].location == NSNotFound)
                {
                    [tepDic setValue:[NSString stringWithFormat:@"%@(%@)",[[tempArrLocation valueForKey:@"name"] objectAtIndex:k],tempFaciStr] forKey:@"name"];
                }
                [arrayLocation addObject:tepDic];
            }
            
        }
        
        NSLog(@"%@",arrayLocation);
        
        [_tblFacility reloadData];
        [_tblLocation reloadData];
    }
    else if (tableView == self.tblLocation) {
        if ([selectedLocationArr containsObject:[[arrayLocation valueForKey:@"value"] objectAtIndex:indexPath.row]]) {
            [selectedLocationArr removeObject:[[arrayLocation valueForKey:@"value"] objectAtIndex:indexPath.row]];
        }else{
            [selectedLocationArr addObject:[[arrayLocation valueForKey:@"value"] objectAtIndex:indexPath.row]];
        }
        
        [_tblLocation reloadData];
    }
    else if (tableView == self.tblCategory) {
        if ([selectedCategoryArr containsObject:[[arrCategory valueForKey:@"Id"] objectAtIndex:indexPath.row]]) {
            [selectedCategoryArr removeObject:[[arrCategory valueForKey:@"Id"] objectAtIndex:indexPath.row]];
        }else{
            [selectedCategoryArr addObject:[[arrCategory valueForKey:@"Id"] objectAtIndex:indexPath.row]];
        }
        
        [_tblCategory reloadData];
    }
    else if (tableView == self.tblType) {
        if ([selectedTypeArr containsObject:[[arrType valueForKey:@"Id"] objectAtIndex:indexPath.row]]) {
            [selectedTypeArr removeObject:[[arrType valueForKey:@"Id"] objectAtIndex:indexPath.row]];
        }else{
            [selectedTypeArr addObject:[[arrType valueForKey:@"Id"] objectAtIndex:indexPath.row]];
        }
        
        [_tblType reloadData];
    }
    else{
        
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
    
}
-(void)btnViewWorkWorderTapped:(UIButton*)sender{
    if (gblAppDelegate.isNetworkReachable) {
   
    EditWithFollowUpViewController * aVCObj =[self.storyboard instantiateViewControllerWithIdentifier:@"EditWithFollowUpViewController"];
    aVCObj.orderId = [[arrOrderList valueForKey:@"iD"]objectAtIndex:sender.tag];
    aVCObj.workOrderHistoryId = [[arrOrderList valueForKey:@"workOrderHistoryId"]objectAtIndex:sender.tag];
    aVCObj.isOnlyView = @"YES";
    //  aVCObj.isAssignToMeView = @"";
    [self.navigationController pushViewController:aVCObj animated:YES];
}
else{
    alert(@"", @"We're sorry. View mode is not currently available offline");
}
}
-(void)btnEditWorkWorderTapped:(UIButton*)sender
{
    if (gblAppDelegate.isNetworkReachable) {
    
    if (![[[arrOrderList valueForKey:@"isEditAllowed"]objectAtIndex:sender.tag] boolValue]){
        
        //do not have edit permission
        
        //            if ([[[arrOrderList valueForKey:@"IsCreatedByMe"]objectAtIndex:sender.tag] boolValue]) {
        //
        //                //  createdby me yes .. allow user to edit all data
        //
        //                [self callForDetailView:sender editPermission:YES assignToMePermission:YES];
        //            }
        //            else if ([[NSString stringWithFormat:@"%@",[[arrOrderList valueForKey:@"WorkOrderHistoryId"]objectAtIndex:sender.tag]] isEqualToString:@"0"] && [[NSString stringWithFormat:@"%@",[[arrOrderList valueForKey:@"InsertedById"]objectAtIndex:sender.tag]] isEqualToString:[[User currentUser] userId]]){
        //
        //                //  createdby me yes .. allow user to edit all data
        //
        //                [self callForDetailView:sender editPermission:YES assignToMePermission:YES];
        //
        //
        //
        //            }
        //            else
        if  ([[[arrOrderList valueForKey:@"isAssignedToMe"]objectAtIndex:sender.tag] boolValue]){
            
            // user have assing to me Permission
            
            //allow user to edit only bellow assign to me section
            
            [self callForDetailView:sender editPermission:NO assignToMePermission:YES];
            
        }
        else{
            
            //user do not created W.O. nither assigned to it.
            
            // do not allow user to edit any data
            alert(@"", @"Please note, you do not have permission to edit this work order");
        }
        
    }
    else{
        
        // having edit permission
        // allow to edit all
        
        [self callForDetailView:sender editPermission:YES assignToMePermission:YES];
        
    }
    
}
else{
    alert(@"", @"We're sorry. Edit mode is not currently available offline");
}
    
}
-(void)callForDetailView:(UIButton*)sender editPermission:(BOOL)editPermission assignToMePermission:(BOOL)assignToMePermission{
    EditWithFollowUpViewController * aVCObj =[self.storyboard instantiateViewControllerWithIdentifier:@"EditWithFollowUpViewController"];
    aVCObj.orderId = [[arrOrderList valueForKey:@"iD"]objectAtIndex:sender.tag];
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
        alert(@"", @"Please note, you do not have permission to edit this work order");
        
    }
    
    [self.navigationController pushViewController:aVCObj animated:YES];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL allowEditing = YES;
    if ([textField isEqual:_txtFromDate]) {
        
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_ALL_DATE option:DATE_SELECTION_DATE_AND_TIME updateField:textField];
        allowEditing = NO;
    }
    else if ([textField isEqual:_txtToDate]) {
        
        DatePopOverView *datePopOver = (DatePopOverView *)[[[NSBundle mainBundle] loadNibNamed:@"DatePopOverView" owner:self options:nil] firstObject];
        [datePopOver showInPopOverFor:textField limit:DATE_LIMIT_ALL_DATE option:DATE_SELECTION_DATE_AND_TIME updateField:textField];
        allowEditing = NO;
    }
    return allowEditing;
}
-(BOOL)validation{
    if ([_txtFacility.text isEqualToString:@""]) {
        return NO;
    }
    else if ([_txtLocation.text isEqualToString:@""]) {
        return NO;
    }
    else if ([_txtCategory.text isEqualToString:@""]) {
        return NO;
    }
    else if ([_txtType.text isEqualToString:@""]) {
        return NO;
    }
    return YES;
}
- (IBAction)btnSubmitTapped:(UIButton *)sender {
    // if ([self validation]) {
    
    NSString * strFacility= @"";
    NSString * strLocation = @"";
    NSString * strCategory = @"";
    NSString * strType = @"";
    NSString * strDateFrom = @"";
    NSString * strTimeFrom = @"";
    NSString * strDateTo = @"";
    NSString * strTimeTo = @"";
    NSString * strShowAll = @"";
    NSString * strAssigntoMe = @"";
    NSString * loadDefault = @"";
    if (sender == _btnSubmit) {
        loadDefault = @"false";
    }
    else  {
        loadDefault = @"true";
    }
    
    for (int i = 0; i<selectedFacilityArr.count; i++) {
        if ([strFacility isEqualToString:@""]) {
            strFacility = [NSString stringWithFormat:@"%@",[selectedFacilityArr objectAtIndex:i]];
        }else{
            strFacility = [NSString stringWithFormat:@"%@,%@",strFacility,[selectedFacilityArr objectAtIndex:i]];
        }
    }
    for (int i = 0; i<selectedLocationArr.count; i++) {
        if ([strLocation isEqualToString:@""]) {
            strLocation = [NSString stringWithFormat:@"%@",[selectedLocationArr objectAtIndex:i]];
        }else{
            strLocation = [NSString stringWithFormat:@"%@,%@",strLocation,[selectedLocationArr objectAtIndex:i]];
        }
    }
    for (int i = 0; i<selectedCategoryArr.count; i++) {
        if ([strCategory isEqualToString:@""]) {
            strCategory = [NSString stringWithFormat:@"%@",[selectedCategoryArr objectAtIndex:i]];
        }else{
            strCategory = [NSString stringWithFormat:@"%@,%@",strCategory,[selectedCategoryArr objectAtIndex:i]];
        }
    }
    for (int i = 0; i<selectedTypeArr.count; i++) {
        if ([strType isEqualToString:@""]) {
            strType = [NSString stringWithFormat:@"%@",[selectedTypeArr objectAtIndex:i]];
        }else{
            strType = [NSString stringWithFormat:@"%@,%@",strType,[selectedTypeArr objectAtIndex:i]];
        }
    }
    
    if (![_txtFromDate.text isEqualToString:@""]) {
        
        
        NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
        NSDate *from = [dateformatter dateFromString:_txtFromDate.text];
        
        [dateformatter setDateFormat:@"yyyy/MM/dd"];
        strDateFrom = [dateformatter stringFromDate:from];
        [dateformatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
        NSDate *to = [dateformatter dateFromString:_txtFromDate.text];
        
        [dateformatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        strTimeFrom = [dateformatter stringFromDate:to];
        
    }
    if (![_txtToDate.text isEqualToString:@""]) {
        NSDateFormatter * dateformatter = [[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
        NSDate *from = [dateformatter dateFromString:_txtToDate.text];
        [dateformatter setDateFormat:@"yyyy/MM/dd"];
        strDateTo = [dateformatter stringFromDate:from];
        [dateformatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
        NSDate *to = [dateformatter dateFromString:_txtToDate.text];
        [dateformatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        strTimeTo = [dateformatter stringFromDate:to];
    }
    //    if (_workOrdersTabSegment.selectedSegmentIndex == 0) {
    //        strAssigntoMe = @"true";
    //         strShowAll = @"false";
    //    }
    //    else if (_workOrdersTabSegment.selectedSegmentIndex == 1) {
    //        strAssigntoMe = @"false";
    //        strShowAll = @"false";
    //    }
    //    else if (_workOrdersTabSegment.selectedSegmentIndex == 2) {
    strAssigntoMe = @"false";
    strShowAll = @"true";
    //    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"myWorkOrderFilterRecponce"];
    //loadDefault
    
    if (gblAppDelegate.isNetworkReachable) {
        
        
        [self callServiceForFilterMyWorkOrders:YES strFacility:strFacility dateFrom:strDateFrom dateTo:strDateTo timeFrom:strTimeFrom timeTo:strTimeTo locationIds:strLocation categoryIds:strCategory typeIds:strType assignedToMe:strAssigntoMe showAll:strShowAll showInProgressWorkOrder:@"false" loadDefault:loadDefault complition:^{
            
           // NSData *dictionaryData = [[NSUserDefaults standardUserDefaults] objectForKey:@"myWorkOrderFilterRecponce"];
         //   responceDicFilter = [NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
//            if (![[responceDicFilter valueForKey:@"WorkOrders"] isKindOfClass:[NSNull class]]) {
//                arrOrderList = [responceDicFilter valueForKey:@"WorkOrders"];
//            }
            [self loadDataInList];
            
        }];
    }
    else{
                [self fetchWorkOrderListData];
                [self loadDataInList];
        [gblAppDelegate hideActivityIndicator];
        alert(@"", @"To see updated data please check your internet connection.");
    }
    //         }
}
-(void)loadDataInList{
    //    arrOrderList = [arrWorkorderList mutableCopy];
    //    NSLog(@"%@",arrOrderList);
    
    if (arrOrderList.count != 0) {
        _lblNoRecordOrder.hidden = YES;
    }
    else{
        _lblNoRecordOrder.hidden = NO;
    }
    
    
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Date" ascending:TRUE];
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"DateSubmitted" ascending:YES];
    
    [arrOrderList sortUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    NSLog(@"%@",arrOrderList);
    
    arrOrderList=[[[arrOrderList reverseObjectEnumerator] allObjects] mutableCopy];
    NSLog(@"%@",arrOrderList);
    if ([firstTime isEqualToString:@"YES"]) {
        firstTime = @"NO";
        if (arrOrderList.count > 10) {
            arrOrderList = [[arrOrderList subarrayWithRange:NSMakeRange(0, 10)] mutableCopy];
        }
    }
    [_tblOrdersDetailList reloadData];
}
- (void)insertWorkOrderList:(NSDictionary*)Dict {
    NSMutableArray *tempArrWorkorderList = [NSMutableArray new];
    [tempArrWorkorderList addObjectsFromArray:[Dict valueForKey:@"WorkOrders"]];
    for (NSDictionary *aDict in tempArrWorkorderList) {
        
        WorkOrderSearch * workOrder = [NSEntityDescription insertNewObjectForEntityForName:@"WorkOrderSearch" inManagedObjectContext:gblAppDelegate.managedObjectContext];
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
- (void)fetchWorkOrderListData{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"WorkOrderSearch"];
    [request setPropertiesToFetch:@[@"updatedBy"]];
    //  NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"updatedBy" ascending:YES];
    // [request setSortDescriptors:@[sortByName]];
    arrWorkorderList = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    arrOrderList = [arrWorkorderList mutableCopy];
    NSLog(@"%lu",(unsigned long)arrWorkorderList.count);
    
}


- (void)deleteAllWorkOrderListData {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"WorkOrderSearch"];
    [request setIncludesPropertyValues:NO];
    NSArray *aryRecords = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    for (NSManagedObject *rec in aryRecords) {
        [gblAppDelegate.managedObjectContext deleteObject:rec];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}
-(void)callServiceForFilterMyWorkOrders:(BOOL)waitUntilDone strFacility:(NSString*)strFacility dateFrom:(NSString*)dateFrom dateTo:(NSString*)dateTo timeFrom:(NSString*)timeFrom timeTo:(NSString*)timeTo locationIds:(NSString*)locationIds categoryIds:(NSString*)categoryIds typeIds:(NSString*)typeIds assignedToMe:(NSString*)assignedToMe showAll:(NSString*)showAll showInProgressWorkOrder:(NSString*)showInProgressWorkOrder loadDefault:(NSString*)loadDefault complition:(void (^)(void))complition
{
    __block BOOL isWSComplete = NO;
    
    NSString *strFacilityId =[[NSUserDefaults standardUserDefaults] objectForKey:@"facilityId"];
    NSString *aStrAccountId = [[NSUserDefaults standardUserDefaults] objectForKey:@"accountId"];
    NSString *strUserId = @"";
    if ([User checkUserExist]) {
        strUserId = [[User currentUser] userId];
    }
    
    
    
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?accountId=%@&userId=%@&datefrom=%@&dateto=%@&timeFrom=%@&timeTo=%@&facilityIds=%@&invLocationIds=%@&categoryIds=%@&typeIds=%@&showWorkOrdersAssignedToMe=%@&showAllWorkOrders=%@&showInProgressWorkOrder=%@&loadDefault=%@", MY_WORK_ORDERS, aStrAccountId,strUserId, dateFrom,dateTo,timeFrom,timeTo,strFacility,locationIds,categoryIds,typeIds,assignedToMe,showAll,showInProgressWorkOrder,loadDefault] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:MY_WORK_ORDERS] complition:^(NSDictionary *response){
        NSLog(@"%@",response);
        
        
                [self deleteAllWorkOrderListData];
                [self insertWorkOrderList:response];
                [self fetchWorkOrderListData];
        
        
    //    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:response];
      //  [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"myWorkOrderFilterRecponce"];
        
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
- (IBAction)btnCreateTapped:(UIButton *)sender {
}
- (void)btnFinalSubmitTapped:(id)sender {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIButton * btn = sender;
    NSLog(@"%@",btn);
    NSLog(@"%ld",(long)btn.tag);
    if ([[segue identifier] isEqualToString:@"editWork"]) {
        AddNoteWorkOrderViewController *aDetail = (AddNoteWorkOrderViewController*)segue.destinationViewController;
        aDetail.orderId = [[arrOrderList valueForKey:@"Id"]objectAtIndex:btn.tag];
    }
    else if ([[segue identifier] isEqualToString:@"createWorkOrder"]) {
        CreateWorkOrderViewController *aDetail = (CreateWorkOrderViewController*)segue.destinationViewController;
        
    }
    else if ([[segue identifier] isEqualToString:@"viewSearchWorkOrder"]) {
        EditWithoutFollowUpViewController *aDetail = (EditWithoutFollowUpViewController*)segue.destinationViewController;
        aDetail.segueFromView =@"searchViewList";
        aDetail.isOnlyView =@"YES";
        aDetail.orderId = [[arrOrderList valueForKey:@"Id"]objectAtIndex:btn.tag];
        aDetail.workOrderHistoryId = [[arrOrderList valueForKey:@"WorkOrderHistoryId"]objectAtIndex:btn.tag];
    }
    
}
- (IBAction)btnExpandFilterViewTapped:(UIButton *)sender {
    if (gblAppDelegate.isNetworkReachable) {
        if (_btnExpandFilterView.selected) {
            _btnExpandFilterView.selected = NO;
        }
        else _btnExpandFilterView.selected = YES;
        
        [self setupView];
    }
    else{
          alert(@"", @"We're sorry. Search is not currently available offline");
    }
    
}

@end

