//
//  EditWorkOrderViewController.h
//  GoBoardPro
//
//  Created by Optiquall Solutions on 18/12/17.
//  Copyright © 2017 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkOrderAddNotesSubmit.h"
@interface AddNoteWorkOrderViewController : UIViewController
@property (strong,nonatomic) NSString * orderId;
@property (strong, nonatomic) WorkOrderAddNotesSubmit  * addNotesSubmit;

@end
