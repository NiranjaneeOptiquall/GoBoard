//
//  ERPTask.h
//  GoBoardPro
//
//  Created by ind558 on 15/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ERPSubcategory;

@interface ERPTask : NSManagedObject

@property (nonatomic, retain) NSString * task;
@property (nonatomic, retain) NSString * taskID;
@property (nonatomic, retain) NSString * attachmentLink;
@property (nonatomic, retain) ERPSubcategory *erpTitle;
@property (nonatomic, assign) BOOL isCompleted;
@end
