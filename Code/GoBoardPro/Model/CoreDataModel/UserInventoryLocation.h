//
//  UserInventoryLocation.h
//  GoBoardPro
//
//  Created by Optiquall Solutions on 28/12/17.
//  Copyright © 2017 IndiaNIC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@class UserFacility;

@interface UserInventoryLocation : NSManagedObject

@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) UserFacility *facility;

@end
