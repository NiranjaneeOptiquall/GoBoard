//
//  WebSerivceCall.m
//  GoBoardPro
//
//  Created by ind558 on 10/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "WebSerivceCall.h"
#import "Constants.h"
#import "UtilizationCount.h"
#import "TaskList.h"
#import "TaskResponseTypeValues.h"



@implementation WebSerivceCall

+ (WebSerivceCall *)webServiceObject {
    static WebSerivceCall *object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[WebSerivceCall alloc] init];
    });
    return object;
}


#pragma mark - UtilizationCount

- (BOOL)callServiceForUtilizationCount {
    __block BOOL isWSComplete = NO;
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?facilityId=%@&locationId=%@&positionId=%@&userId=%@", UTILIZATION_COUNT, [[[User currentUser] selectedFacility] value], [[[User currentUser] selectedLocation] value], [[[User currentUser] selectedPosition] value], [[User currentUser] userId]] parameters:nil httpMethod:@"GET" complition:^(NSDictionary *response) {
        [self deleteAllCountLocation];
        [self insertAllCountLocation:[response objectForKey:@"Locations"]];
        isWSComplete = YES;
    } failure:^(NSError *error, NSDictionary *response) {
        alert(@"", [response objectForKey:@"ErrorMessage"]);
        isWSComplete = YES;
    }];
    while (!isWSComplete) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
    }
    return isWSComplete;
}

- (void)deleteAllCountLocation {
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"UtilizationCount" inManagedObjectContext:gblAppDelegate.managedObjectContext]];
    [request setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSError * error = nil;
    NSArray * allRecords = [gblAppDelegate.managedObjectContext executeFetchRequest:request error:&error];
    //error handling goes here
    for (NSManagedObject * rec in allRecords) {
        [gblAppDelegate.managedObjectContext deleteObject:rec];
    }
    NSError *saveError = nil;
    [gblAppDelegate.managedObjectContext save:&saveError];
}

- (void)insertAllCountLocation:(NSArray *)arrLocations {
    for (NSDictionary *aDict in arrLocations) {
        UtilizationCount *location = [NSEntityDescription insertNewObjectForEntityForName:@"UtilizationCount" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        location.locationId = [[aDict objectForKey:@"Id"] stringValue];
        location.name = [aDict objectForKey:@"Name"];
        if ([[aDict objectForKey:@"Message"] isKindOfClass:[NSNull class]])
            location.message = @"";
        else
            location.message = [aDict objectForKey:@"Message"];
        if ([[aDict objectForKey:@"LastCount"] isKindOfClass:[NSNull class]])
            location.lastCount = @"0";
        else
            location.lastCount = [[aDict objectForKey:@"LastCount"] stringValue];
        if ([[aDict objectForKey:@"LastCountDateTime"] isKindOfClass:[NSNull class]])
            location.lastCountDateTime = @"";
        else {
            NSString *aStrDate = [[[aDict objectForKey:@"LastCountDateTime"] componentsSeparatedByString:@"."] firstObject];
            location.lastCountDateTime = aStrDate;
        }
        
        location.capacity = [[aDict objectForKey:@"Capacity"] stringValue];
        NSMutableSet *set = [NSMutableSet set];
        if (![[aDict objectForKey:@"Sublocations"] isKindOfClass:[NSNull class]]) {
            for (NSDictionary *aDictSubLoc in [aDict objectForKey:@"Sublocations"]) {
                UtilizationCount *subLoc = [NSEntityDescription insertNewObjectForEntityForName:@"UtilizationCount" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                subLoc.name = [aDictSubLoc objectForKey:@"Name"];
                if ([[aDict objectForKey:@"LastCount"] isKindOfClass:[NSNull class]])
                    subLoc.lastCount = @"0";
                else
                    subLoc.lastCount = [[aDictSubLoc objectForKey:@"LastCount"] stringValue];
                if ([[aDict objectForKey:@"LastCountDateTime"] isKindOfClass:[NSNull class]])
                    subLoc.lastCountDateTime = @"";
                else {
                    NSString *aStrDate = [[[aDict objectForKey:@"LastCountDateTime"] componentsSeparatedByString:@"."] firstObject];
                    subLoc.lastCountDateTime = aStrDate;
                }
                subLoc.locationId = [[aDictSubLoc objectForKey:@"Id"] stringValue];
                subLoc.location = location;
                [set addObject:subLoc];
            }
        }
        location.sublocations = set;
        [gblAppDelegate.managedObjectContext insertObject:location];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}

#pragma mark - Task

- (void)callServiceForTaskList {
    __block BOOL isWSComplete = NO;
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?facilityId=%@&locationId=%@&positionId=%@&userId=%@", TASK, [[[User currentUser] selectedFacility] value], [[[User currentUser] selectedLocation] value], [[[User currentUser] selectedPosition] value], [[User currentUser] userId]] parameters:nil httpMethod:@"GET" complition:^(NSDictionary *response) {
        NSLog(@"%@", response);
        [self deleteAllTask];
        [self insertAllTask:[response objectForKey:@"Tasks"]];
        isWSComplete = YES;
    } failure:^(NSError *error, NSDictionary *response) {
        isWSComplete = YES;
    }];
    while (!isWSComplete) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
    }
}

- (void)deleteAllTask {
    NSFetchRequest * allTask = [[NSFetchRequest alloc] init];
    [allTask setEntity:[NSEntityDescription entityForName:@"TaskList" inManagedObjectContext:gblAppDelegate.managedObjectContext]];
    [allTask setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSError * error = nil;
    NSArray * tasks = [gblAppDelegate.managedObjectContext executeFetchRequest:allTask error:&error];
    //error handling goes here
    for (NSManagedObject * task in tasks) {
        [gblAppDelegate.managedObjectContext deleteObject:task];
    }
    NSError *saveError = nil;
    [gblAppDelegate.managedObjectContext save:&saveError];
}

- (void)insertAllTask:(NSArray*)aryTask {
    for (NSDictionary *aDict in aryTask) {
        TaskList *aList = [NSEntityDescription insertNewObjectForEntityForName:@"TaskList" inManagedObjectContext:gblAppDelegate.managedObjectContext];
        aList.isCompleted = [aDict objectForKey:@"Completed"];
        aList.desc = [aDict objectForKey:@"Description"];
        aList.name = [aDict objectForKey:@"Name"];
        aList.taskId = [[aDict objectForKey:@"Id"] stringValue];
        
        if ([[aDict objectForKey:@"Response"] isKindOfClass:[NSNull class]]) {
            aList.response = @"";
        }
        else {
            aList.response = [aDict objectForKey:@"Response"];
        }
        
        aList.responseType = [aDict objectForKey:@"ResponseType"];
        NSMutableSet *aSet = [NSMutableSet set];
        if (![[aDict objectForKey:@"ResponseTypeValues"] isKindOfClass:[NSNull class]] && [[aDict objectForKey:@"ResponseTypeValues"] count] > 0) {
            for (NSDictionary *dictType in [aDict objectForKey:@"ResponseTypeValues"]) {
                TaskResponseTypeValues *typeValues = [NSEntityDescription insertNewObjectForEntityForName:@"TaskResponseTypeValues" inManagedObjectContext:gblAppDelegate.managedObjectContext];
                typeValues.value = [dictType objectForKey:@"Value"];
                typeValues.code = [dictType objectForKey:@"Code"];
                typeValues.typeId = [[dictType objectForKey:@"Id"] stringValue];
                typeValues.task = aList;
                [aSet addObject:typeValues];
            }
            aList.responseTypeValues = aSet;
        }
        aList.isCommentAreaSupervisor = [aDict objectForKey:@"IsCommentAreaSupervisor"];
        aList.isCommentBuildingSupervisor = [aDict objectForKey:@"IsCommentBuildingSupervisor"];
        aList.isCommentGoBoardGroup = [aDict objectForKey:@"IsCommentGoBoardGroup"];
        aList.isCommentTask = [aDict objectForKey:@"IsCommentTask"];
        aList.isCommentWorkOrder = [aDict objectForKey:@"IsCommentWorkOrder"];
        [gblAppDelegate.managedObjectContext insertObject:aList];
    }
    [gblAppDelegate.managedObjectContext save:nil];
}

@end
