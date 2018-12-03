//
//  EditWithFollowUpViewController.h
//  GoBoardPro
//
//  Created by Optiquall Solutions on 08/01/18.
//  Copyright © 2018 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkOrderWithFollowupSubmit.h"
#import "WorkOrderInventoryPartsUsed.h"
#import "WorkOrderFollowup.h"
#import "WorkOrderFollowupLogsNew.h"
#import "WorkOrderNewEquipmentInventory.h"

@interface EditWithFollowUpViewController : UIViewController
@property (strong,nonatomic) NSString * orderId;
@property (strong,nonatomic) NSString * workOrderHistoryId;
@property (strong,nonatomic) NSString * isOnlyView;
//@property (strong,nonatomic) NSString * isAssignToMeView;
@property (assign, nonatomic) BOOL isUpdate;
//@property (assign, nonatomic) BOOL isServiceProvider;
//@property (assign, nonatomic) BOOL isServiceProEditAllow;
@property (strong,nonatomic) NSString * isEditAllow;
@property (strong,nonatomic) NSString * isF_EditAllow;
@property (assign, nonatomic) BOOL isEqInventoryAddToDb;
@property (strong, nonatomic) WorkOrderWithFollowupSubmit  * editSubmit;
@property (strong, nonatomic) WorkOrderInventoryPartsUsed  * editInventoryPartsUsed;
@property (strong, nonatomic) WorkOrderFollowup  * editFollowup;
@property (strong, nonatomic) WorkOrderFollowupLogsNew  * editFollowupLogsNew;
@end
