//
//  OfflineResponseTypeValues.h
//  GoBoardPro
//
//  Created by Optiquall Solutions on 26/12/16.
//  Copyright © 2016 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class QuestionDetails;

@interface OfflineResponseTypeValues : NSManagedObject
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * sequence;
@property (nonatomic, retain) QuestionDetails *question;

@end
