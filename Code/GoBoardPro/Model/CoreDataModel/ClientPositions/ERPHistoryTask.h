//
//  ERPHistoryTask.h
//  GoBoardPro
//
//  Created by ind558 on 15/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ERPHistory;

@interface ERPHistoryTask : NSManagedObject

@property (nonatomic, retain) NSString * erpTaskId;
@property (nonatomic, retain) NSString * completed;
@property (nonatomic, retain) ERPHistory *erpHistory;

@end
