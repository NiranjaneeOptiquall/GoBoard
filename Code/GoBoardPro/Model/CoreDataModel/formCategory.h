//
//  formCategory.h
//  GoBoardPro
//
//  Created by Inversedime on 28/11/16.
//  Copyright © 2016 IndiaNIC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface formCategory : NSManagedObject
@property(nonatomic,retain) NSString *catId;
@property(nonatomic,retain) NSString *catName;
@property(nonatomic,retain) NSString *isCatHaveItem;

@end
