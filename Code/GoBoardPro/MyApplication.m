//
//  MyApplication.m
//  GoBoardPro
//
//  Created by Optiquall Solutions on 21/04/17.
//  Copyright © 2017 IndiaNIC. All rights reserved.
//

#import "MyApplication.h"
#import "LoginViewController.h"

@implementation MyApplication
- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
    // Only want to reset the timer on a Began touch or an Ended touch, to reduce the number of timer resets.
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] > 0) {
        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
        if (phase == UITouchPhaseBegan || phase == UITouchPhaseEnded)
              [self resetIdleTimer];
            NSLog(@"resetIdleTimer");
        [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"istouch"];
    }
}
- (void)resetIdleTimer {
   
    if (self.idleTimer) {
        [self.idleTimer invalidate];
    }
   NSTimeInterval timeInterva = [[[User currentUser]AutomaticLogoutTime] doubleValue]*60;
    //NSTimeInterval timeInterva = 30;

    NSLog(@"Total Time ====%f",timeInterva);
    if (timeInterva > 0) {
        [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"istouch"];
        NSLog(@"TimerStarted............");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAtFacility"
                                                            object:self];
        self.idleTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterva target:self selector:@selector(idleTimerExceeded) userInfo:nil repeats:NO] ;
        
    }
}
- (void)idleTimerExceeded {
    [self webserviceCallForUserLogOff];
    dispatch_async(dispatch_get_main_queue(), ^{
        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        LoginViewController *controller = (LoginViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"LoginViewController"];
        [navigationController pushViewController:controller animated:YES];
        
    });
  
//[[NSNotificationCenter defaultCenter] postNotificationName:@"DataUpdated"
                                                    //object:self];
}

-(void)webserviceCallForUserLogOff{
    
//    NSDictionary *aDict = @{@"userId":[[User currentUser] userId], @"logoutType": @2};
//    
//    [gblAppDelegate callWebService:USER_SERVICE parameters:aDict httpMethod:@"POST" complition:^(NSDictionary *response) {
//        //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:@"Incident Report has been submitted successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        //  [alert show];
//    } failure:^(NSError *error, NSDictionary *response) {
//        //[self saveIncidentToOffline:aDict completed:YES];
//    }];
    
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?userId=%@",USER_LOGIN,[[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:USER_LOGIN] complition:^(NSDictionary *response) {
        
    }failure:^(NSError *error, NSDictionary *response) {
        
    }];
    
}
@end
