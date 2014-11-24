//
//  Constants.h
//  GoBoardPro
//
//  Created by ind558 on 23/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#ifndef GoBoardPro_Constants_h
#define GoBoardPro_Constants_h

#import "WebSerivceCall.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "DatePopOverView.h"
#import "DropDownPopOver.h"
#import "User.h"


AppDelegate *gblAppDelegate;

#define alert(title, msg)              [[[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show]


#define LOCATION_VALUES                 @[@{@"title":@"Main Gymnasium", @"id": @"1"}, @{@"title":@"Fitness Center", @"id": @"2"}, @{@"title":@"Swimming Pool", @"id": @"3"}, @{@"title":@"Tennis Court", @"id": @"4"}]

#define POSITION_VALUES                 @[@{@"title":@"Manager", @"id": @"1"}, @{@"title":@"Assistant", @"id": @"2"}, @{@"title":@"Trainer", @"id": @"3"}, @{@"title":@"Medical Personnel", @"id": @"4"}]

#define FACILITY_VALUES                 @[@{@"title":@"Gymnasium", @"id": @"1"}, @{@"title":@"Fitness Center", @"id": @"2"}, @{@"title":@"Games", @"id": @"3"}, @{@"title":@"Cafeteria", @"id": @"4"}]

#define INJURY_TYPE_GENERAL                     @[@{@"title":@"Allergic Reaction", @"id": @"1"}, @{@"title":@"Diabetic Emergency", @"id": @"2"}, @{@"title":@"Fever", @"id": @"3"}, @{@"title":@"Gestrointestinal", @"id": @"4"}, @{@"title":@"Heart", @"id": @"5"}, @{@"title":@"Heat", @"id": @"6"}, @{@"title":@"Other", @"id": @"10"}]

#define INJURY_TYPE_BODY_PART                   @[@{@"title":@"Abrasion", @"id": @"1"}, @{@"title":@"Bruise", @"id": @"2"}, @{@"title":@"Bleeding", @"id": @"3"}, @{@"title":@"Cut", @"id": @"4"}, @{@"title":@"Dental", @"id": @"5"}, @{@"title":@"Fracture", @"id": @"6"}, @{@"title":@"Spinal Injury", @"id": @"7"}, @{@"title":@"Strain", @"id": @"8"}, @{@"title":@"Other", @"id": @"10"}]


#define ACTION_TAKEN                            @[@{@"title":@"Ice Applied", @"id": @"1"}, @{@"title":@"Provided Bandages", @"id": @"2"}, @{@"title":@"Called Security", @"id": @"3"}, @{@"title":@"Called 911"}]

#define CARE_PROVIDED_BY                        @[@{@"title":@"Staff", @"id": @"1"}, @{@"title":@"Medical Personnel", @"id": @"2"}, @{@"title":@"Security", @"id": @"3"}, @{@"title":@"911", @"id":@"4"}, @{@"title":@"Refused Care", @"id":@"5"}]

#define WEEKDAYS                                @[@{@"title":@"Sunday", @"id": @"1"}, @{@"title":@"Monday", @"id": @"2"}, @{@"title":@"Tuesday", @"id": @"3"}, @{@"title":@"Wednesday", @"id": @"4"}, @{@"title":@"Thursday", @"id": @"5"}, @{@"title":@"Friday", @"id": @"6"}, @{@"title":@"Saturday", @"id": @"7"}]

#define MONTHS                                  @[@{@"title":@"Jan", @"id": @"1"}, @{@"title":@"Feb", @"id": @"2"}, @{@"title":@"Mar", @"id": @"3"}, @{@"title":@"Apr", @"id": @"4"}, @{@"title":@"May", @"id": @"5"}, @{@"title":@"Jun", @"id": @"6"}, @{@"title":@"Jul", @"id": @"7"}, @{@"title":@"Aug", @"id": @"8"}, @{@"title":@"Sep", @"id": @"9"}, @{@"title":@"Oct", @"id": @"10"}, @{@"title":@"Nov", @"id": @"11"}, @{@"title":@"Dec", @"id": @"12"}]

#define HEAD_INJURY                             @[@"Eye", @"Ear", @"Head", @"Jaw", @"Mouth", @"Neck", @"Nose", @"Tooth"]
#define ARM_INJURY                              @[@"Arm", @"Elbow", @"Finger/Thumb", @"Forearm", @"Hand", @"Shoulder", @"Wrist"]
#define CHEST_INJURY                            @[@"Abdomen", @"Back", @"Chest", @"Spine"]
#define LEG_INJURY                              @[@"Ankle", @"Foot", @"Groin", @"Hip", @"Knee", @"Leg", @"Thigh", @"Toe"]


typedef enum : NSUInteger {
    PERSON_MEMBER = 1,
    PERSON_GUEST,
    PERSON_EMPLOYEE,
} PersonInvolved;


#define REQUIRED_TYPE_PERSON    @"PersonInvolved"
#define REQUIRED_TYPE_EMERGENCY    @"EmergencyResponse"
#define REQUIRED_TYPE_WITNESS    @"Witness"
#define REQUIRED_TYPE_EMPLOYEE    @"Employee"

#define SERVICE_URL                 @"http://goboardapi.azurewebsites.net/api/"


#define USER_SERVICE                @"User"
#define USER_LOGIN                  @"UserAuthentication"
#define USER_FORGOT_PASSWORD        @"UserForgotPassword"
#define USER_FACILITY               @"UserFacility"
#define SOP_CATEGORY                @"SopCategory"
#define SOP_DETAIL                  @"SopDetail"
#define ERP_CATEGORY                @"Erp"
#define ERP_HISTORY                 @"ErpHistory"
#define UTILIZATION_COUNT           @"Count"
#define TASK                        @"Task"
#define INCIDENT_REPORT_SETUP       @"IncidentReportSetup"
#define ACCIDENT_REPORT_SETUP       @"AccidentReportSetup"


#define SERVICE_HTTP_METHOD         @{USER_LOGIN:@"GET", USER_FORGOT_PASSWORD : @"POST", USER_FACILITY:@"GET", SOP_CATEGORY:@"GET", SOP_DETAIL:@"GET", ERP_CATEGORY:@"GET", ERP_HISTORY: @"POST", INCIDENT_REPORT_SETUP : @"GET", ACCIDENT_REPORT_SETUP : @"GET"}







#define MSG_REQUIRED_FIELDS         @"Please complete all required fields."
#define MSG_PROFILE_UPDATE_SUCCESS  @"Profile has been updated Successfully"
#define MSG_PROFILE_UPDATE_FAILURE  @"Unable to update profile at this time, Please try again later"
#define MSG_LOGIN_FAILURE           @"Email id or password does not match, Please check your email id or password"
#define MSG_NO_INTERNET             @"Please make sure you have an Internet connection and try again."
#define MSG_SERVICE_FAIL            @"An unexpected error occurred.  Please try again.  If the issue persists, please contact support."
#endif
