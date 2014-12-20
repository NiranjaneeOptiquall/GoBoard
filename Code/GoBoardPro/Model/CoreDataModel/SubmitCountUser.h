//
//  SubmitCountUser.h
//  GoBoardPro
//
//  Created by ind558 on 20/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SubmitUtilizationCount, SubmittedTask;

@interface SubmitCountUser : NSManagedObject

@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSSet *countLocation;
@property (nonatomic, retain) NSSet *submittedTask;
@end

@interface SubmitCountUser (CoreDataGeneratedAccessors)

- (void)addCountLocationObject:(SubmitUtilizationCount *)value;
- (void)removeCountLocationObject:(SubmitUtilizationCount *)value;
- (void)addCountLocation:(NSSet *)values;
- (void)removeCountLocation:(NSSet *)values;

- (void)addSubmittedTaskObject:(SubmittedTask *)value;
- (void)removeSubmittedTaskObject:(SubmittedTask *)value;
- (void)addSubmittedTask:(NSSet *)values;
- (void)removeSubmittedTask:(NSSet *)values;

@end
