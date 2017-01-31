//
//  TaskList.h
//  GoBoardPro
//
//  Created by ind726 on 09/03/15.
//  Copyright (c) 2015 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaskResponseTypeValues;

@interface TaskList : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * isCommentAreaSupervisor;
@property (nonatomic, retain) NSNumber * isCommentBuildingSupervisor;
@property (nonatomic, retain) NSNumber * isCommentGoBoardGroup;
@property (nonatomic, retain) NSNumber * isCommentTask;
@property (nonatomic, retain) NSNumber * isCommentWorkOrder;
@property (nonatomic, retain) NSNumber * isCompleted;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * response;
@property (nonatomic, retain) NSString * responseType;
@property (nonatomic, retain) NSNumber * sequence;
@property (nonatomic, retain) NSDate * taskDateTime;
@property (nonatomic, retain) NSString * taskId;
@property (nonatomic, retain) NSDate * expirationTime;
@property (nonatomic, retain) NSSet *responseTypeValues;
@end

@interface TaskList (CoreDataGeneratedAccessors)

- (void)addResponseTypeValuesObject:(TaskResponseTypeValues *)value;
- (void)removeResponseTypeValuesObject:(TaskResponseTypeValues *)value;
- (void)addResponseTypeValues:(NSSet *)values;
- (void)removeResponseTypeValues:(NSSet *)values;

@end
