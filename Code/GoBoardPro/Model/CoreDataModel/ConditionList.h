//
//  ConditionList.h
//  GoBoardPro
//
//  Created by ind558 on 20/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ConditionList : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * conditionId;
@property (nonatomic, retain) NSManagedObject *incidentType;

@end
