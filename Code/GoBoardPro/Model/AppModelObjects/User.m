//
//  User.m
//  GoBoardPro
//
//  Created by ind558 on 12/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "User.h"

@implementation User
static User *user = nil;

+ (User *)currentUser {
    
    @synchronized(self) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            if (!user) {
                user = [[User alloc] init];
                user.mutArrSelectedLocations = [[NSMutableArray alloc] init];
                user.mutArrSelectedPositions = [[NSMutableArray alloc] init];
            }
            
        });
        
        
        
    }
    return user;
}


+ (void)destroyCurrentUser {
    
    
    user.firstName = nil;
    user.lastName = nil;
    user.middleInitials = nil;
    user.email = nil;
    user.phone = nil;
    user.mobile = nil;
    user.userId = nil;
    user.clientId = nil;
    user.clientName = nil;
    user.accountId = nil;
    user.accountName = nil;
    user.termsAndConditions = nil;
    user.selectedFacility = nil;
    user.username = nil;
    user.userStatusCheck = nil;
    user.ssoKey = nil;
    user.AutomaticLogoutTime = nil;
    
    user.username=@"";
    user.userStatusCheck=@"";
    user.firstName = @"";
    user.lastName = @"";
    user.middleInitials = @"";
    user.email = @"";
    user.phone = @"";
    user.mobile = @"";
    user.userId = @"";
    user.clientId = @"";
    user.clientName = @"";
    user.accountName = @"";
    user.termsAndConditions = @"";
    user.AutomaticLogoutTime = @"";
    user.ssoKey = @"";
}

+ (BOOL)checkUserExist {
    if([user.userId integerValue]>0) {
        return YES;
    }
    return NO;
}
@end
