//
//  WebSerivceCall.h
//  GoBoardPro
//
//  Created by ind558 on 10/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface WebSerivceCall : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate> {

}

#pragma mark - Instantiate Object

+ (WebSerivceCall *)webServiceObject;

- (void)getAllData;

- (void)callServiceForEmergencyResponsePlan:(BOOL)waitUntilDone complition:(void (^)(void))completion;

- (BOOL)callServiceForUtilizationCount:(BOOL)waitUntilDone complition:(void (^)(void))completion;

- (void)callServiceForTaskList:(BOOL)waitUntilDone complition:(void (^)(void))completion;

- (void)callServiceForIncidentReport:(BOOL)waitUntilDone complition:(void(^)(void))complition;
@end
