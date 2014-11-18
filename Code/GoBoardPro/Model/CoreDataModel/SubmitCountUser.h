//
//  SubmitCountUser.h
//  GoBoardPro
//
//  Created by ind558 on 18/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SubmitUtilizationCount;

@interface SubmitCountUser : NSManagedObject

@property (nonatomic, retain) NSString * positionId;
@property (nonatomic, retain) NSString * locationId;
@property (nonatomic, retain) NSString * facilityId;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSSet *countLocation;
@end

@interface SubmitCountUser (CoreDataGeneratedAccessors)

- (void)addCountLocationObject:(SubmitUtilizationCount *)value;
- (void)removeCountLocationObject:(SubmitUtilizationCount *)value;
- (void)addCountLocation:(NSSet *)values;
- (void)removeCountLocation:(NSSet *)values;

@end
