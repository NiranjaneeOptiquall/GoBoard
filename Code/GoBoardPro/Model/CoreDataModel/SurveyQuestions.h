//
//  SurveyQuestions.h
//  GoBoardPro
//
//  Created by ind558 on 01/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SurveyList, SurveyResponseTypeValues;

@interface SurveyQuestions : NSManagedObject

@property (nonatomic, retain) NSString * questionId;
@property (nonatomic, retain) NSString * responseType;
@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) NSNumber * sequence;
@property (nonatomic, retain) SurveyList *survey;
@property (nonatomic, retain) NSSet *responseList;
@end

@interface SurveyQuestions (CoreDataGeneratedAccessors)

- (void)addResponseListObject:(SurveyResponseTypeValues *)value;
- (void)removeResponseListObject:(SurveyResponseTypeValues *)value;
- (void)addResponseList:(NSSet *)values;
- (void)removeResponseList:(NSSet *)values;

@end
