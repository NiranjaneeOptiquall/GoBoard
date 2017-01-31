//
//  SubmitFormAndSurvey.h
//  GoBoardPro
//
//  Created by ind558 on 03/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SubmitFormAndSurvey : NSManagedObject

@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * clientId;
@property (nonatomic, retain) NSString * headerId;
@property (nonatomic, retain) NSString * offlineFormId;

@property (nonatomic, retain) NSString * isInProgressId;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * typeId;
@property (nonatomic, retain) NSSet *questionList;

@end

@interface SubmitFormAndSurvey (CoreDataGeneratedAccessors)

- (void)addQuestionListObject:(NSManagedObject *)value;
- (void)removeQuestionListObject:(NSManagedObject *)value;
- (void)addQuestionList:(NSSet *)values;
- (void)removeQuestionList:(NSSet *)values;

@end
