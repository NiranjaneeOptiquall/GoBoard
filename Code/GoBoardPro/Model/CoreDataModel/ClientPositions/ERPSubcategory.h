//
//  ERPSubcategory.h
//  GoBoardPro
//
//  Created by ind558 on 15/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ERPCategory, ERPTask;

@interface ERPSubcategory : NSManagedObject

@property (nonatomic, retain) NSString * subCateId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) ERPCategory *erpHeader;
@property (nonatomic, retain) NSSet *erpTasks;
@end

@interface ERPSubcategory (CoreDataGeneratedAccessors)

- (void)addErpTasksObject:(ERPTask *)value;
- (void)removeErpTasksObject:(ERPTask *)value;
- (void)addErpTasks:(NSSet *)values;
- (void)removeErpTasks:(NSSet *)values;

@end
