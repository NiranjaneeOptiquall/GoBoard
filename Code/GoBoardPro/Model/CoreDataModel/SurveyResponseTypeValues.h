//
//  SurveyResponseTypeValues.h
//  GoBoardPro
//
//  Created by ind726 on 13/03/15.
//  Copyright (c) 2015 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SurveyQuestions;

@interface SurveyResponseTypeValues : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * sequence;
@property (nonatomic, retain) SurveyQuestions *question;

@end
