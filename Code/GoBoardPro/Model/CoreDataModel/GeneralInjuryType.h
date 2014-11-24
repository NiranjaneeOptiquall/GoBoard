//
//  GeneralInjuryType.h
//  GoBoardPro
//
//  Created by ind558 on 24/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GeneralInjuryType : NSManagedObject

@property (nonatomic, retain) NSString * typeId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSManagedObject *accidentInfo;

@end
