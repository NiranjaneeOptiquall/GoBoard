//
//  UtilizationCount.h
//  GoBoardPro
//
//  Created by ind558 on 18/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UtilizationCount;

@interface UtilizationCount : NSManagedObject

@property (nonatomic, retain) NSString * locationId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * capacity;
@property (nonatomic, retain) NSString * lastCount;
@property (nonatomic, retain) NSString * lastCountDateTime;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSSet *sublocations;
@property (nonatomic, retain) UtilizationCount *location;

@property (nonatomic, retain) NSString *originalMessage;
@property (nonatomic, assign) NSInteger originalCount;
@property (nonatomic, assign) BOOL isCountRemainSame;
@property (nonatomic, assign) BOOL isUpdateAvailable;



- (void)setInitialValues;
@end

@interface UtilizationCount (CoreDataGeneratedAccessors)

- (void)addSublocationsObject:(UtilizationCount *)value;
- (void)removeSublocationsObject:(UtilizationCount *)value;
- (void)addSublocations:(NSSet *)values;
- (void)removeSublocations:(NSSet *)values;

@end
