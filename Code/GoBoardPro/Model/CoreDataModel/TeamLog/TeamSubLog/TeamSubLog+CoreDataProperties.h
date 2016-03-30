//
//  TeamSubLog+CoreDataProperties.h
//  GoBoardPro
//
//  Created by E2M183 on 2/20/16.
//  Copyright © 2016 IndiaNIC. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TeamSubLog.h"
#import "TeamLog.h"
NS_ASSUME_NONNULL_BEGIN

@interface TeamSubLog (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSNumber *shouldSync;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) TeamLog *teamLog;

@end

NS_ASSUME_NONNULL_END
