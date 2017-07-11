//
//  DailyLog+CoreDataProperties.h
//  GoBoardPro
//
//  Created by E2M183 on 2/20/16.
//  Copyright © 2016 IndiaNIC. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DailyLog.h"

NS_ASSUME_NONNULL_BEGIN

@interface DailyLog (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSString *includeInEndOfDayReport;
@property (nullable, nonatomic, retain) NSNumber *shouldSync;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSString *isTeamLog;

@end

NS_ASSUME_NONNULL_END
