//
//  UserPosition.h
//  GoBoardPro
//
//  Created by ind558 on 13/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserFacility,UserLocation;

@interface UserPosition : NSManagedObject

@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) UserFacility *facility;
@property (nonatomic, retain) NSSet *locations;

@end
@interface UserPosition (CoreDataGeneratedAccessors)


- (void)addLocationsObject:(UserLocation *)value;
- (void)removeLocationsObject:(UserLocation *)value;
- (void)addLocations:(NSSet *)values;
- (void)removeLocations:(NSSet *)values;

@end
