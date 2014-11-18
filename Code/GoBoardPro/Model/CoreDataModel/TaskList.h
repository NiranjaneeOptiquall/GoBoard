//
//  TaskList.h
//  GoBoardPro
//
//  Created by ind558 on 18/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TaskList : NSManagedObject

@property (nonatomic, retain) NSNumber * isCompleted;
@property (nonatomic, retain) NSString * response;
@property (nonatomic, retain) NSString * responseType;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * taskId;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * isCommentTask;
@property (nonatomic, retain) NSNumber * isCommentGoBoardGroup;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * isCommentBuildingSupervisor;
@property (nonatomic, retain) NSNumber * isCommentAreaSupervisor;
@property (nonatomic, retain) NSNumber * isCommentWorkOrder;
@property (nonatomic, retain) NSSet *responseTypeValues;
@end

@interface TaskList (CoreDataGeneratedAccessors)

- (void)addResponseTypeValuesObject:(NSManagedObject *)value;
- (void)removeResponseTypeValuesObject:(NSManagedObject *)value;
- (void)addResponseTypeValues:(NSSet *)values;
- (void)removeResponseTypeValues:(NSSet *)values;

@end
