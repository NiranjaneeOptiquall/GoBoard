//
//  DailyLog.h
//  GoBoardPro
//
//  Created by ind558 on 12/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DailyLog : NSManagedObject

@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * includeInEndOfDayReport;
@property (nonatomic, retain) NSNumber * shouldSync;

@end
