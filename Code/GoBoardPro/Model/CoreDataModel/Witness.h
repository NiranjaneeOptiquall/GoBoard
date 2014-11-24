//
//  Witness.h
//  GoBoardPro
//
//  Created by ind558 on 21/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Report;

@interface Witness : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * middleInitial;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * homePhone;
@property (nonatomic, retain) NSString * alternatePhone;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * witnessWrittenAccount;
@property (nonatomic, retain) Report *report;

@end
