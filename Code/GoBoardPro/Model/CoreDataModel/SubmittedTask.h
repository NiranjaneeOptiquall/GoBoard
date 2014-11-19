//
//  SubmittedTask.h
//  GoBoardPro
//
//  Created by ind558 on 19/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SubmitCountUser;

@interface SubmittedTask : NSManagedObject

@property (nonatomic, retain) NSString * taskId;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * response;
@property (nonatomic, retain) NSString * responseType;
@property (nonatomic, retain) NSString * isCommentAreaSupervisor;
@property (nonatomic, retain) NSString * isCommentBuildingSupervisor;
@property (nonatomic, retain) NSString * isCommentGoBoardGroup;
@property (nonatomic, retain) NSString * isCommentTask;
@property (nonatomic, retain) NSString * isCommentWorkOrder;
@property (nonatomic, retain) SubmitCountUser *user;

@end
