//
//  UserFacility.h
//  GoBoardPro
//
//  Created by ind558 on 13/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserLocation, UserPosition,UserLocation1,UserInventoryLocation;

@interface UserFacility : NSManagedObject

@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *locations1;
@property (nonatomic, retain) NSSet *positions;
@property (nonatomic, retain) NSSet *inventoerLocations;
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

- (void)addInventoryLocationsObject:(UserInventoryLocation *)value;
- (void)removeInventoryLocationsObject:(UserInventoryLocation *)value;
- (void)addInventoryLocations:(NSSet *)values;
- (void)removeInventoryLocations:(NSSet *)values;

@end
