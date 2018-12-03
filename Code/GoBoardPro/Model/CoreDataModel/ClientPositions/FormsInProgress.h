//
//  FormsInProgress.h
//  GoBoardPro
//
//  Created by Optiquall Solutions on 19/12/16.
//  Copyright © 2016 IndiaNIC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SurveyQuestions;

@interface FormsInProgress : NSManagedObject

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
@property (nonatomic,retain) NSString * date;
@property (nonatomic,retain) NSString * inProgressFormId;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic,retain) NSString * isAllowEditSharedForm;
@property (nonatomic,retain) NSString * formLastAccessedBy;

@property (nonatomic,retain) NSNumber * userFormIsAllowEdit;
@property (nonatomic,retain) NSNumber * userFormIsAllowView;
@property (nonatomic,retain) NSString * reportNumber;
@property (nonatomic,retain) NSString * user;
@property (nonatomic,retain) NSString * updatedBy;
@property (nonatomic,retain) NSString * updatedOn;
@property (nonatomic,retain) NSString * deactivate;
@property (nonatomic,retain) NSString * changeQuestionResponseTypeVersion;
@property (nonatomic,retain) NSNumber * userFormIsAllowDelete;
@property (nonatomic,retain) NSNumber * userFormIsAllowDeactivate;

//"Name"
//""
//"Url"
//""
//"Date"
//""
//""
//""
@end


@interface FormsInProgress (CoreDataGeneratedAccessors)

- (void)addQuestionListObject:(SurveyQuestions *)value;
- (void)removeQuestionListObject:(SurveyQuestions *)value;
- (void)addQuestionList:(NSSet *)values;
- (void)removeQuestionList:(NSSet *)values;

@end
