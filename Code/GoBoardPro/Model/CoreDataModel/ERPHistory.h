//
//  ERPHistory.h
//  GoBoardPro
//
//  Created by ind558 on 15/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ERPHistoryTask;

@interface ERPHistory : NSManagedObject

@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * facilityId;
@property (nonatomic, retain) NSString * locationId;
@property (nonatomic, retain) NSString * erpSubcategoryId;
@property (nonatomic, retain) NSString * startDateTime;
@property (nonatomic, retain) NSString * endDateTime;
@property (nonatomic, retain) NSSet *taskList;
@end

@interface ERPHistory (CoreDataGeneratedAccessors)

- (void)addTaskListObject:(ERPHistoryTask *)value;
- (void)removeTaskListObject:(ERPHistoryTask *)value;
- (void)addTaskList:(NSSet *)values;
- (void)removeTaskList:(NSSet *)values;

@end
