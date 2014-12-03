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
@property (nonatomic, retain) SubmitFormAndSurvey *formOrSurvey;

@end
