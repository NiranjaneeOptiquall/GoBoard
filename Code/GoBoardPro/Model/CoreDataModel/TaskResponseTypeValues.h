//
//  TaskResponseTypeValues.h
//  GoBoardPro
//
//  Created by ind558 on 18/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaskList;

@interface TaskResponseTypeValues : NSManagedObject

@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * typeId;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) TaskList *task;

@end
