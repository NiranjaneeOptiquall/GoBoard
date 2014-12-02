//
//  User.h
//  GoBoardPro
//
//  Created by ind558 on 12/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserFacility.h"
#import "UserLocation.h"
#import "UserPosition.h"

@interface User : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *middleInitials;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *password;
@property (assign, nonatomic) BOOL isAdmin;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *clientId;
@property (strong, nonatomic) UserFacility *selectedFacility;
@property (strong, nonatomic) UserLocation *selectedLocation;
@property (strong, nonatomic) UserPosition *selectedPosition;
+ (User *)currentUser;
+ (void)destroyCurrentUser;
+ (BOOL)checkUserExist;
@end
