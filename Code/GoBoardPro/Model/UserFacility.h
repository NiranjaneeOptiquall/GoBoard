//
//  UserFacility.h
//  GoBoardPro
//
//  Created by ind558 on 13/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserLocation, UserPosition,UserLocation1;

@interface UserFacility : NSManagedObject

@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *locations1;
@property (nonatomic, retain) NSSet *positions;
@end

@interface UserFacility (CoreDataGeneratedAccessors)

- (void)addLocationsObject:(UserLocation1 *)value;
- (void)removeLocationsObject:(UserLocation1 *)value;
- (void)addLocations:(NSSet *)values;
- (void)removeLocations:(NSSet *)values;

- (void)addPositionsObject:(UserPosition *)value;
- (void)removePositionsObject:(UserPosition *)value;
- (void)addPositions:(NSSet *)values;
- (void)removePositions:(NSSet *)values;

@end
