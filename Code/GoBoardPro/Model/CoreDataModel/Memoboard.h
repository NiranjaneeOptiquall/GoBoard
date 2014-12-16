//
//  Memoboard.h
//  GoBoardPro
//
//  Created by ind558 on 12/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Memoboard : NSManagedObject

@property (nonatomic, retain) NSString * to;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * memo;
@property (nonatomic, retain) NSString * date;

@end
