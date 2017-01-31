//
//  SurveyInProgress.h
//  GoBoardPro
//
//  Created by Optiquall Solutions on 19/12/16.
//  Copyright © 2016 IndiaNIC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
@class SurveyQuestions;

@interface SurveyInProgress : NSManagedObject

@property (nonatomic, retain) NSString * instructions;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * surveyId;
@property (nonatomic, retain) NSString * typeId;
@property (nonatomic, retain) NSString * userTypeId;
@property (nonatomic, retain) NSNumber * sequence;
@property (nonatomic, retain) NSSet *questionList;
@property (nonatomic, retain) NSString * categoryId;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSString * categorySequence;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * inProgressCount;
@property (nonatomic, retain) NSString * isAllowInProgress;
@property (nonatomic, retain) NSString * inProgressFormId;
@property (nonatomic, retain) NSString * userId;
@end

@interface SurveyInProgress (CoreDataGeneratedAccessors)

- (void)addQuestionListObject:(SurveyQuestions *)value;
- (void)removeQuestionListObject:(SurveyQuestions *)value;
- (void)addQuestionList:(NSSet *)values;
- (void)removeQuestionList:(NSSet *)values;

@end
