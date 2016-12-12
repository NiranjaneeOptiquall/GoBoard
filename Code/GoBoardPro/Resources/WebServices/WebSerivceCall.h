//
//  WebSerivceCall.h
//  GoBoardPro
//
//  Created by ind558 on 10/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface WebSerivceCall : NSObject {

}

#pragma mark - Instantiate Object

+ (WebSerivceCall *)webServiceObject;

- (void)getAllData;

- (void)callServiceForEmergencyResponsePlan:(BOOL)waitUntilDone complition:(void (^)(void))completion;

- (BOOL)callServiceForUtilizationCount:(BOOL)waitUntilDone complition:(void (^)(void))completion;

- (void)callServiceForTaskList:(BOOL)waitUntilDone complition:(void (^)(void))completion;

- (void)callServiceForIncidentReport:(BOOL)waitUntilDone complition:(void(^)(void))complition;

- (void)callServiceForAccidentReport:(BOOL)waitUntilDone complition:(void(^)(void))complition;

- (void)callServiceForSurvey:(BOOL)waitUntilDone complition:(void(^)(void))complition;
- (void)callServiceForForms:(BOOL)waitUntilDone complition:(void(^)(void))complition;
- (void)callServiceForSurvey:(BOOL)waitUntilDone withSurveyId:(NSString*)surveyId complition:(void(^)(void))complition;

- (void)callServiceForMemos:(BOOL)waitUntilDone complition:(void (^)(void))completion ;
- (void)callServiceForTeamLog:(BOOL)waitUntilDone complition:(void(^)(void))complition;
- (void)callServiceForTeamLogInBackground:(BOOL)waitUntilDone complition:(void(^)(NSDictionary *))complition;
@end
