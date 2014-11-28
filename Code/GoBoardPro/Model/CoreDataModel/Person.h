//
//  Person.h
//  GoBoardPro
//
//  Created by ind558 on 28/11/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Report;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * affiliationTypeID;
@property (nonatomic, retain) NSString * alternatePhone;
@property (nonatomic, retain) NSString * apartmentNumber;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * dateOfBirth;
@property (nonatomic, retain) NSString * duringWorkHours;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * employeeTitle;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * genderTypeID;
@property (nonatomic, retain) NSString * guestOfFirstName;
@property (nonatomic, retain) NSString * guestOfLastName;
@property (nonatomic, retain) NSString * guestOfMiddleInitial;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * memberId;
@property (nonatomic, retain) NSString * middleInitial;
@property (nonatomic, retain) NSString * minor;
@property (nonatomic, retain) NSString * personTypeID;
@property (nonatomic, retain) NSString * primaryPhone;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * streetAddress;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSData * personPhoto;
@property (nonatomic, retain) Report *report;

@end
