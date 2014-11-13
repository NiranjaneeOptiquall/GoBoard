//
//  User.h
//  GoBoardPro
//
//  Created by ind558 on 12/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>

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
@property (strong, nonatomic) NSMutableArray *mutArrCertificates;

+ (User *)currentUser;

@end
