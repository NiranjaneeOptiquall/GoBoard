//
//  HeadInjuryList.h
//  GoBoardPro
//
//  Created by ind558 on 24/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HeadInjuryList : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSManagedObject *accidentInfo;

@end
