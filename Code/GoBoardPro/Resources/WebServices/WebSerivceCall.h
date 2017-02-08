//
//  WebSerivceCall.h
//  GoBoardPro
//
//  Created by ind558 on 10/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface WebSerivceCall : NSObject<UINavigationControllerDelegate>
{
    BOOL isErrorOccurred;
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

- (void)callServiceForSurveyInOffline:(BOOL)waitUntilDone withSurveyId:(NSString*)surveyId withSurveyInstructions:(NSString*)SurveyInstructions withSurveyIsAllowInProgress:(NSString*)SurveyIsAllowInProgress withSurveyName:(NSString*)SurveyName complition:(void(^)(void))complition;

- (void)callServiceForFormInOffline:(BOOL)waitUntilDone withFormId:(NSString*)FormId withFormInstructions:(NSString*)FormInstructions withFormIsAllowInProgress:(NSString*)FormIsAllowInProgress withFormName:(NSString*)FormName complition:(void(^)(void))complition;

- (void)callServiceForMemos:(BOOL)waitUntilDone complition:(void (^)(void))completion ;
- (void)callServiceForDashboardCount:(BOOL)waitUntilDone complition:(void(^)(NSDictionary *))completion;
- (void)callServiceForTeamLog:(BOOL)waitUntilDone complition:(void(^)(void))complition;
- (void)callServiceForTeamLogInBackground:(BOOL)waitUntilDone complition:(void(^)(NSDictionary *))complition;
@end
