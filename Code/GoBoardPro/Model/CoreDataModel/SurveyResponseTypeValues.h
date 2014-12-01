//
//  SurveyResponseTypeValues.h
//  GoBoardPro
//
//  Created by ind558 on 01/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SurveyQuestions;

@interface SurveyResponseTypeValues : NSManagedObject

@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) SurveyQuestions *question;

@end
