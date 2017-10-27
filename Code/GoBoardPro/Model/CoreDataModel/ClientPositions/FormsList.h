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
@property (nonatomic, retain) NSString * categoryId;
@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSString * categorySequence;
@property (nonatomic, retain) NSString * inProgressCount;
@property (nonatomic, retain) NSString * isAllowInProgress;
@property (assign, nonatomic) BOOL isSharedForm;
@property (assign, nonatomic) BOOL isAllowEditSharedForm;
//@property (nonatomic, retain) NSString * isAllowEditSharedForm;
@property (nonatomic,retain) NSString * date;
@property (nonatomic,retain) NSString * inProgressFormId;
@property (nonatomic,retain) NSString * publishedToFacilityPositions;


@end

@interface FormsList (CoreDataGeneratedAccessors)

- (void)addQuestionListObject:(SurveyQuestions *)value;
- (void)removeQuestionListObject:(SurveyQuestions *)value;
- (void)addQuestionList:(NSSet *)values;
- (void)removeQuestionList:(NSSet *)values;

@end
