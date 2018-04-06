//
//  EditWithFollowUpViewController.h
//  GoBoardPro
//
//  Created by Optiquall Solutions on 08/01/18.
//  Copyright © 2018 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditWithFollowUpViewController : UIViewController
@property (strong,nonatomic) NSString * orderId;
@property (strong,nonatomic) NSString * workOrderHistoryId;
@property (strong,nonatomic) NSString * isOnlyView;
@property (strong,nonatomic) NSString * isAssignToMeView;
@property (assign, nonatomic) BOOL isUpdate;
@property (assign, nonatomic) BOOL isServiceProvider;
@property (assign, nonatomic) BOOL isServiceProEditAllow;
@end
