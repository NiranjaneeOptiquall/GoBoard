//
//  UserLocation.h
//  GoBoardPro
//
//  Created by ind558 on 13/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserFacility;

@interface UserLocation : NSManagedObject

@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) UserFacility *facility;

@end
