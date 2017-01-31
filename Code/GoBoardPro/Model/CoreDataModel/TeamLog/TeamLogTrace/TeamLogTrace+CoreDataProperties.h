//
//  TeamLogTrace+CoreDataProperties.h
//  GoBoardPro
//
//  Created by E2M183 on 2/23/16.
//  Copyright © 2016 IndiaNIC. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TeamLogTrace.h"

NS_ASSUME_NONNULL_BEGIN

@interface TeamLogTrace (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *teamLogId;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *byuserId;

@end

NS_ASSUME_NONNULL_END
