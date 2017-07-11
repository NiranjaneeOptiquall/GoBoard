//
//  MyApplication.h
//  GoBoardPro
//
//  Created by Optiquall Solutions on 21/04/17.
//  Copyright © 2017 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyApplication : UIApplication
@property (retain,nonatomic) NSTimer* idleTimer;
@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic) UIApplication *application;
@property(strong,nonatomic)NSString *isActive;
- (void)sendEvent:(UIEvent *)event;
- (void)resetIdleTimer;
@end
