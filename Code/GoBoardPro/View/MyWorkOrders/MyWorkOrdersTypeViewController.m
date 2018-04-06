//
//  MyWorkOrdersTypeViewController.m
//  GoBoardPro
//
//  Created by Optiquall Solutions on 04/01/18.
//  Copyright © 2018 IndiaNIC. All rights reserved.
//MyworkorderList

#import "MyWorkOrdersTypeViewController.h"
#import "UserHomeViewController.h"
#import "SearchWorkOrdersViewController.h"
#import "MyWorkOrdersViewController.h"
@interface MyWorkOrdersTypeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblNoteMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnMyWorkOrders;
@property (weak, nonatomic) IBOutlet UIButton *btnSearchWorkOrder;

@property (weak, nonatomic) IBOutlet UILabel *lblAssignToMeCount;
@property (nonatomic,assign)NSInteger intWorkOrderCount;

@end

@implementation MyWorkOrdersTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    _lblAssignToMeCount.layer.cornerRadius = 5;
    _lblAssignToMeCount.layer.borderColor = [UIColor whiteColor].CGColor;
    _lblAssignToMeCount.layer.borderWidth = 1;
    
   self.intWorkOrderCount = [[[NSUserDefaults standardUserDefaults] valueForKey:@"WorkOrderToalCount"]integerValue];
    if (_intWorkOrderCount > 0) {
        [_lblAssignToMeCount.layer setCornerRadius:5.0];
        [_lblAssignToMeCount.layer setBorderWidth:1.0];
        [_lblAssignToMeCount setClipsToBounds:YES];
        [_lblAssignToMeCount.layer setBorderColor:[UIColor whiteColor].CGColor];
        _lblAssignToMeCount.hidden = NO;
       _lblAssignToMeCount.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"WorkOrderToalCount"]];
    }
    
    if (_IsServoceProvider) {
        
        _btnSearchWorkOrder.hidden = YES;
    //    _lblAssignToMeCount.hidden = YES;
        
    if (_IsAccessAllowed) {
        _lblNoteMessage.text = @"Click below on the appropriate icon to manage your work order.";
        CGRect frame = _btnMyWorkOrders.frame;
        frame.origin.x = (self.view.frame.size.width/2) - (_btnMyWorkOrders.frame.size.width/2);
        _btnMyWorkOrders.frame = frame;
        
        frame = _lblAssignToMeCount.frame;
        frame.origin.x = _btnMyWorkOrders.frame.origin.x + _btnMyWorkOrders.frame.size.width - 50 ;
        _lblAssignToMeCount.frame = frame;
    }
    else{
        _lblNoteMessage.text = @"We’re sorry. You do not have permission to access this area. Please see your system administrator.";
        _btnMyWorkOrders.hidden = YES;

    }
   }
}
-(void)viewWillAppear:(BOOL)animated{
    
    

    
}
- (IBAction)btnBackTapped:(id)sender {
//    for (UIViewController *aVCObj in self.navigationController.viewControllers) {
//        if ([aVCObj isKindOfClass:[UserHomeViewController class]]) {
//            [self.navigationController popToViewController:aVCObj animated:YES];
//        }
//    }
    
     [self.navigationController popViewControllerAnimated:NO];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
//    UIButton * btn = sender;
//    NSLog(@"%@",btn);
//    NSLog(@"%ld",(long)btn.tag);
//    if ([[segue identifier] isEqualToString:@"MyworkorderList"]) {
//    }
//    else if ([[segue identifier] isEqualToString:@"SearchWorkorderList"]) {
//
//    }
    }
- (IBAction)btnMyWorkOrderTapped:(UIButton *)sender {
//dispatch_async(dispatch_get_main_queue(), ^{
    MyWorkOrdersViewController * aVCObj =[self.storyboard instantiateViewControllerWithIdentifier:@"MyWorkOrdersViewController"];
    aVCObj.IsServoceProvider = _IsServoceProvider;
    [self.navigationController pushViewController:aVCObj animated:YES];
//});

    
        
}
- (IBAction)btnSearchOrCreateWorkOrderTapped:(UIButton *)sender {
    //dispatch_async(dispatch_get_main_queue(), ^{
 
    SearchWorkOrdersViewController * aVCObj =[self.storyboard instantiateViewControllerWithIdentifier:@"SearchWorkOrdersViewController"];
    
    [self.navigationController pushViewController:aVCObj animated:YES];
     //   });
}

@end
