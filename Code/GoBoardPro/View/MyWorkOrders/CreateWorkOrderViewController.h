//
//  CreateWorkOrderViewController.h
//  GoBoardPro
//
//  Created by Optiquall Solutions on 21/12/17.
//  Copyright © 2017 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MediaAccessibility/MediaAccessibility.h>
#import "WorkOrderCreateNewSubmit.h"
#import "WorkOrderNewEquipmentInventory.h"

@interface CreateWorkOrderViewController : UIViewController

@property (assign, nonatomic) BOOL isUpdate;
@property (assign, nonatomic) BOOL isEqInventoryAddToDb;
@property (assign, nonatomic) BOOL isEqInventoryPresentInDb;
@property (strong, nonatomic) WorkOrderCreateNewSubmit  * createdNewSubmit;

@end
