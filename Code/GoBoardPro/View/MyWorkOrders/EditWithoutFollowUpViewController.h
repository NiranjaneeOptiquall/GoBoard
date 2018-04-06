//
//  EditWithoutFollowUpViewController.h
//  GoBoardPro
//
//  Created by Optiquall Solutions on 08/01/18.
//  Copyright © 2018 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditWithoutFollowUpViewController : UIViewController
@property (strong,nonatomic) NSString * orderId;
@property (strong,nonatomic) NSString * workOrderHistoryId;
@property (strong,nonatomic) NSString * segueFromView;
@property (strong,nonatomic) NSString * isOnlyView;
@property (assign, nonatomic) BOOL isUpdate;

@end
