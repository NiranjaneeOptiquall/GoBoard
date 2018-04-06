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

- (void)callServiceForSurvey:(BOOL)waitUntilDone linkedSurveyId:(NSString*)linkedSurveyId complition:(void(^)(void))complition ;

- (void)callServiceForForms:(BOOL)waitUntilDone linkedFormId:(NSString*)linkedFormId complition:(void(^)(void))complition;

- (void)callServiceForSurvey:(BOOL)waitUntilDone withSurveyId:(NSString*)surveyId complition:(void(^)(void))complition;

- (void)callServiceForSurveyInOffline:(BOOL)waitUntilDone withSurveyId:(NSString*)surveyId withSurveyInstructions:(NSString*)SurveyInstructions withSurveyIsAllowInProgress:(NSString*)SurveyIsAllowInProgress withSurveyName:(NSString*)SurveyName complition:(void(^)(void))complition;

- (void)callServiceForFormInOffline:(BOOL)waitUntilDone withFormId:(NSString*)FormId withFormInstructions:(NSString*)FormInstructions withFormIsAllowInProgress:(NSString*)FormIsAllowInProgress withFormName:(NSString*)FormName complition:(void(^)(void))complition;

- (void)callServiceForMemos:(BOOL)waitUntilDone complition:(void (^)(void))completion ;
- (void)callServiceForDashboardCount:(BOOL)waitUntilDone complition:(void(^)(NSDictionary *))completion;
- (void)callServiceForTeamLog:(BOOL)waitUntilDone complition:(void(^)(void))complition;
- (void)callServiceForTeamLogInBackground:(BOOL)waitUntilDone complition:(void(^)(NSDictionary *))complition;
//-(void)callServiceForMyWorkOrders:(BOOL)waitUntilDone complition:(void (^)(void))complition;
//-(void)callServiceForFilterMyWorkOrders:(BOOL)waitUntilDone strFacility:(NSString*)strFacility dateFrom:(NSString*)dateFrom dateTo:(NSString*)dateTo timeFrom:(NSString*)timeFrom timeTo:(NSString*)timeTo locationIds:(NSString*)locationIds categoryIds:(NSString*)categoryIds typeIds:(NSString*)typeIds assignedToMe:(NSString*)assignedToMe showAll:(NSString*)showAll showInProgressWorkOrder:(NSString*)showInProgressWorkOrder complition:(void (^)(void))complition;
-(void)callServiceForGetAddNoteWorkOrder:(BOOL)waitUntilDone orderId:(NSString*)orderId complition:(void (^)(void))complition;
-(void)callServiceForUpdateAddNoteWorkOrder:(BOOL)waitUntilDone orderId:(NSString*)orderId statusId:(NSString*)statusId notesId:(NSString*)notesId dateSubmited:(NSString*)dateSubmited sequence:(NSString*)sequence complition:(void (^)(void))complition;
-(void)callServiceForGetCreateWorkOrder:(BOOL)waitUntilDone complition:(void (^)(void))complition;
-(void)callServiceForAddNewCreateWorkOrder:(BOOL)waitUntilDone paraDic:(NSDictionary*)paraDic isReadyForFollowupcomplition:(NSString*)isReadyForFollowupcomplition complition:(void (^)(void))complition
;
-(void)callServiceForGetEquipmentDetailsWorkOrder:(BOOL)waitUntilDone strBarcode:(NSString*)strBarcode strIsBarCode:(NSString*)strIsBArcode complition:(void (^)(void))complition;
-(void)callServiceForGetInventoryPartsUsedWorkOrder:(BOOL)waitUntilDone equipmentId:(NSString*)equipmentId checkFilter:(NSString*)checkFilter complition:(void (^)(void))complition;
-(void)callServiceForEditWorkOrder:(BOOL)waitUntilDone paraDic:(NSDictionary*)paraDic isFollowPresent:(NSString*)isFollowPresent isSubmit:(NSString*)isSubmit historyReportId:(NSString*)historyReportId revisionId:(NSString*)revisionId sequence:(NSString*)sequence complition:(void (^)(void))complition;
-(void)callServiceForGetEditWorkOrder:(BOOL)waitUntilDone orderId:(NSString*)orderId workOrderHistoryId:(NSString*)workOrderHistoryId complition:(void (^)(void))complition;
-(void)callServiceForGetEditWithFollowUpWorkOrder:(BOOL)waitUntilDone workOrderId:(NSString*)workOrderId isInResponses:(NSString*)isInResponses workOrderHistoryId:(NSString*)workOrderHistoryId complition:(void (^)(void))complition;
-(void)callServiceForGetPhotoVideoWorkOrder:(BOOL)waitUntilDone workOrderHistoryId:(NSString*)workOrderHistoryId complition:(void (^)(void))complition;

-(void)callServiceForSubmitWithFollowupEditWorkOrder:(BOOL)waitUntilDone paraDic:(NSDictionary*)paraDic isFollowPresent:(NSString*)isFollowPresent isSubmit:(NSString*)isSubmit historyReportId:(NSString*)historyReportId revisionId:(NSString*)revisionId isImage:(NSString*)isImage isVideo:(NSString*)isVideo  sequence:(NSString*)sequence complition:(void (^)(void))complition
;
-(void)callServiceForDeleteWorkOrder:(BOOL)waitUntilDone workOrderId:(NSString*)workOrderId sequence:(NSString*)sequence complition:(void (^)(void))complition;
-(void)callServiceForDeleteFollowupWorkOrder:(BOOL)waitUntilDone workOrderId:(NSString*)workOrderId sequence:(NSString*)sequence isFollowupLog:(BOOL)isFollowupLog complition:(void (^)(void))complition;
-(void)callServiceForSaveFollowupLogWorkOrder:(BOOL)waitUntilDone strCell:(NSString*)strCell strName:(NSString*)strName strMail:(NSString*)strMail strPhn:(NSString*)strPhn strInfo:(NSString*)strInfo strCall:(NSString*)strCall strId:(NSString*)strId complition:(void (^)(void))complition;
-(void)callServiceForSaveFollowupQWorkOrder:(BOOL)waitUntilDone questionResponse1:(NSString*)questionResponse1 questionResponse2:(NSString*)questionResponse2 questionResponse3:(NSString*)questionResponse3 questionResponse4:(NSString*)questionResponse4 followupId:(NSString*)followupId complition:(void (^)(void))complition;
- (void)callServiceForHomeSetup:(BOOL)waitUntilDone complition:(void (^)(void))completion;
-(void)callServiceForGetPhotoVideoDataWorkOrder:(BOOL)waitUntilDone workOrderHistoryId:(NSString*)workOrderHistoryId fileName:(NSString*)fileName complition:(void (^)(void))complition;

@end
