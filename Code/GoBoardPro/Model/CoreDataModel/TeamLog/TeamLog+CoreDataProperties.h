//
//  TeamLog+CoreDataProperties.h
//  GoBoardPro
//
//  Created by E2M183 on 2/20/16.
//  Copyright © 2016 IndiaNIC. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TeamLog.h"

NS_ASSUME_NONNULL_BEGIN

@interface TeamLog (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSString *facilityId;
@property (nullable, nonatomic, retain) NSString *selectedFacilities;
@property (nullable, nonatomic, retain) NSString *includeInEndOfDayReport;
@property (nullable, nonatomic, retain) NSString *positionId;
@property (nullable, nonatomic, retain) NSNumber *shouldSync;
@property (nullable, nonatomic, retain) NSNumber *teamLogId;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *isTeamLog;
@property (nullable, nonatomic, retain) NSString *headerId;
@property (nullable, nonatomic, retain) NSSet<TeamSubLog *> *teamSubLog;

@end

@interface TeamLog (CoreDataGeneratedAccessors)

- (void)addTeamSubLogObject:(TeamSubLog *)value;
- (void)removeTeamSubLogObject:(TeamSubLog *)value;
- (void)addTeamSubLog:(NSSet<TeamSubLog *> *)values;
- (void)removeTeamSubLog:(NSSet<TeamSubLog *> *)values;

@end

NS_ASSUME_NONNULL_END
