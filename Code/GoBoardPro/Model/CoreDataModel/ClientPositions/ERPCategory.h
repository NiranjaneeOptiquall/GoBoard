//
//  ERPCategory.h
//  GoBoardPro
//
//  Created by ind558 on 15/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ERPSubcategory;

@interface ERPCategory : NSManagedObject

@property (nonatomic, retain) NSString * categoryId;
@property (nonatomic, retain) NSString * categorySequence;

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *erpTitles;
@property (nonatomic, assign) BOOL isExpanded;
@end

@interface ERPCategory (CoreDataGeneratedAccessors)

- (void)addErpTitlesObject:(ERPSubcategory *)value;
- (void)removeErpTitlesObject:(ERPSubcategory *)value;
- (void)addErpTitles:(NSSet *)values;
- (void)removeErpTitles:(NSSet *)values;

@end
