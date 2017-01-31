//
//  SopCategory.h
//  GoBoardPro
//
//  Created by IndiaNIC on 03/08/15.
//  Copyright (c) 2015 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SopCategory;

@interface SopCategory : NSManagedObject

@property (nonatomic, retain) NSString * sopId;
@property (nonatomic, retain) NSString * published;
@property (nonatomic, retain) NSNumber * sequence;
@property (nonatomic, retain) NSString * displaySequence;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * linkType;
@property (nonatomic, retain) SopCategory *children;
@property (nonatomic, retain) NSSet *subChildren;
@end

@interface SopCategory (CoreDataGeneratedAccessors)

- (void)addSubChildrenObject:(SopCategory *)value;
- (void)removeSubChildrenObject:(SopCategory *)value;
- (void)addSubChildren:(NSSet *)values;
- (void)removeSubChildren:(NSSet *)values;

@end
