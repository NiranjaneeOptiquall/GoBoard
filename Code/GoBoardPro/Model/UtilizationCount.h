//
//  UtilizationCount.h
//  GoBoardPro
//
//  Created by ind726 on 13/03/15.
//  Copyright (c) 2015 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UtilizationCount;

@interface UtilizationCount : NSManagedObject

@property (nonatomic, retain) NSString * capacity;
@property (nonatomic, retain) NSString * lastCount;
@property (nonatomic, retain) NSString * lastCountDateTime;
@property (nonatomic, retain) NSString * locationId;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * sequence;
@property (nonatomic, retain) UtilizationCount *location;
@property (nonatomic, retain) NSOrderedSet *sublocations;



@property (nonatomic, retain) NSString *originalMessage;
@property (nonatomic, assign) NSInteger originalCount;
@property (nonatomic, assign) BOOL isCountRemainSame;
//@property (nonatomic, assign) BOOL isCountClosed;
@property (nonatomic, assign) BOOL isClosed;
@property (nonatomic, assign) BOOL isReadyToSubmit;
@property (nonatomic, assign) BOOL isLocationStatusChanged;
@property (nonatomic, assign) BOOL isUpdateAvailable;
@property (nonatomic, assign) BOOL isExceedMaximumCapacity;


- (void)setInitialValues;
@end

@interface UtilizationCount (CoreDataGeneratedAccessors)

- (void)insertObject:(UtilizationCount *)value inSublocationsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSublocationsAtIndex:(NSUInteger)idx;
- (void)insertSublocations:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSublocationsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSublocationsAtIndex:(NSUInteger)idx withObject:(UtilizationCount *)value;
- (void)replaceSublocationsAtIndexes:(NSIndexSet *)indexes withSublocations:(NSArray *)values;
- (void)addSublocationsObject:(UtilizationCount *)value;
- (void)removeSublocationsObject:(UtilizationCount *)value;
- (void)addSublocations:(NSOrderedSet *)values;
- (void)removeSublocations:(NSOrderedSet *)values;
@end
