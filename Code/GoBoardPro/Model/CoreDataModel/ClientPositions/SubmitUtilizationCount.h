//
//  SubmitUtilizationCount.h
//  GoBoardPro
//
//  Created by ind558 on 18/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SubmitCountUser, SubmitUtilizationCount;

@interface SubmitUtilizationCount : NSManagedObject

@property (nonatomic, retain) NSString * capacity;
@property (nonatomic, retain) NSString * lastCount;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * locationId;
@property (nonatomic, retain) NSString * lastCountDateTime;
@property (nonatomic, retain) SubmitUtilizationCount *location;
@property (nonatomic, retain) NSSet *sublocations;
@property (nonatomic, retain) SubmitCountUser *user;
@property (nonatomic, assign) BOOL isClosed;
@property (nonatomic, assign) BOOL isReadyToSubmit;
@property (nonatomic, assign) BOOL isLocationStatusChanged;
@end

@interface SubmitUtilizationCount (CoreDataGeneratedAccessors)

- (void)addSublocationsObject:(SubmitUtilizationCount *)value;
- (void)removeSublocationsObject:(SubmitUtilizationCount *)value;
- (void)addSublocations:(NSSet *)values;
- (void)removeSublocations:(NSSet *)values;

@end
