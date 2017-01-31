//
//  ClientPositions+CoreDataProperties.h
//  GoBoardPro
//
//  Created by E2M183 on 2/24/16.
//  Copyright © 2016 IndiaNIC. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ClientPositions.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClientPositions (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *positionId;
@property (nullable, nonatomic, retain) NSString *name;

@end

NS_ASSUME_NONNULL_END
