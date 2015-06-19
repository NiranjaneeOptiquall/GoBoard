//
//  FormsList.h
//  GoBoardPro
//
//  Created by ind558 on 02/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SurveyQuestions;

@interface FormsList : NSManagedObject

@property (nonatomic, retain) NSString * typeId;
@property (nonatomic, retain) NSString * userTypeId;
@property (nonatomic, retain) NSString * formId;
@property (nonatomic, retain) NSString * instructions;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * sequence;
@property (nonatomic, retain) NSSet *questionList;
@end

@interface FormsList (CoreDataGeneratedAccessors)

- (void)addQuestionListObject:(SurveyQuestions *)value;
- (void)removeQuestionListObject:(SurveyQuestions *)value;
- (void)addQuestionList:(NSSet *)values;
- (void)removeQuestionList:(NSSet *)values;

@end
