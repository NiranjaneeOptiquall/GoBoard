//
//  UserLocation1.h
//  GoBoardPro
//
//  Created by Optiquall Solutions on 09/06/17.
//  Copyright © 2017 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserFacility;


@interface UserLocation1 : NSManagedObject

@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) UserFacility *facility;

@end
