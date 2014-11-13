//
//  User.m
//  GoBoardPro
//
//  Created by ind558 on 12/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "User.h"

@implementation User

+ (User *)currentUser {
    static User *user;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[User alloc] init];
    });
    return user;
}

@end
