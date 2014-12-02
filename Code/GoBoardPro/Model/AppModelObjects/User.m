//
//  User.m
//  GoBoardPro
//
//  Created by ind558 on 12/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "User.h"

@implementation User
static User *user;

+ (User *)currentUser {
    
    @synchronized(self) {
        if (!user) {
            user = [[User alloc] init];
        }
    }
    return user;
}


+ (void)destroyCurrentUser {
    user = nil;
}

+ (BOOL)checkUserExist {
    if(user) {
        return YES;
    }
    return NO;
}
@end
