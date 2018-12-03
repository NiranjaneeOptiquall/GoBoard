//
//  MyWorkOrdersViewController.h
//  GoBoardPro
//
//  Created by Optiquall Solutions on 05/01/18.
//  Copyright © 2018 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkOrderAssignToMe.h"
#import "WorkOrderCreated.h"
#import "WorkOrderCreatedInProgres.h"
@interface MyWorkOrdersViewController : UIViewController
@property (assign, nonatomic) BOOL IsServoceProvider;
@property (strong, nonatomic) WorkOrderAssignToMe  * assignToMeList;
@property (strong, nonatomic) WorkOrderCreated  * createdList;
@property (strong, nonatomic) WorkOrderCreatedInProgres  * createdInProgresList;

@end
