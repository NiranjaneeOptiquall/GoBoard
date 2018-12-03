//
//  QuestionDetails.h
//  GoBoardPro
//
//  Created by ind558 on 03/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SubmitFormAndSurvey;

@interface QuestionDetails : NSManagedObject

@property (nonatomic, retain) NSString * questionId;
@property (nonatomic, retain) NSString * responseText;
@property (nonatomic, retain) NSString * responseId;
@property (nonatomic, retain) NSString * questionText;
@property (nonatomic, retain) NSString * detailImageVideoText;
@property (nonatomic, retain) NSString * existingResponseBool;
@property (nonatomic, retain) NSString * isMandatory;
@property (nonatomic, retain) NSString * responseType;
@property (nonatomic, retain) NSSet * responseList;
@property (nonatomic, retain) NSString * sequence;
@property (nonatomic, retain) SubmitFormAndSurvey *formOrSurvey;

@property (nonatomic, retain) NSNumber * isSkipLogic;
@property (nonatomic, retain) NSNumber * isSkipLogicQuestionShow;
@property (nonatomic, retain) NSNumber * isShowOnForm;

@end
