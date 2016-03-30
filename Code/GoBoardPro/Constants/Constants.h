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
#import "UIColor+HexToRGB.h"
#import "NSString+Validations.h"
#import "UIDevice+Rotation.h"
AppDelegate *gblAppDelegate;

//#define alert(title, msg)              [[[UIAlertView alloc] initWithTitle:[gblAppDelegate appName] message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show]

#define alert(title, msg) [gblAppDelegate showSimpleAlertWithMessage:msg];


#define ITUENS_APPLINK @"https://itunes.apple.com/us/app/goboardpro/id941499495"

#define STATES                          @[@"AL", @"AK", @"AZ", @"AR", @"CA", @"CO", @"CT", @"DE", @"DC", @"FL", @"GA", @"HI", @"ID", @"IL", @"IN", @"IA", @"KS", @"KY", @"LA", @"ME", @"MD", @"MA", @"MI", @"MN", @"MS", @"MO", @"MT", @"NE", @"NV", @"NH", @"NJ", @"NM", @"NY", @"NC", @"ND", @"OH", @"OK", @"OR", @"PA", @"RI", @"SC", @"SD", @"TN", @"TX", @"UT", @"VT", @"VA", @"WA", @"WV", @"WI", @"WY"]

#define MONTHS                                  @[@{@"name":@"Jan", @"id": @"1"}, @{@"name":@"Feb", @"id": @"2"}, @{@"name":@"Mar", @"id": @"3"}, @{@"name":@"Apr", @"id": @"4"}, @{@"name":@"May", @"id": @"5"}, @{@"name":@"Jun", @"id": @"6"}, @{@"name":@"Jul", @"id": @"7"}, @{@"name":@"Aug", @"id": @"8"}, @{@"name":@"Sep", @"id": @"9"}, @{@"name":@"Oct", @"id": @"10"}, @{@"name":@"Nov", @"id": @"11"}, @{@"name":@"Dec", @"id": @"12"}]

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
#define REQUIRED_TYPE_FIRST_AID     @"FirstAid"

// http://goboardapi.azurewebsites.net/api/
#define SERVICE_URL                 (gblAppDelegate.isProduction) ? @"https://api.goboardrec.com/api/" : @"http://goboardapi-qa.azurewebsites.net/api/"


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
#define INCIDENT_REPORT_POST        @"IncidentReport"
#define ACCIDENT_REPORT_SETUP       @"AccidentReportSetup"
#define ACCIDENT_REPORT_POST        @"AccidentReport"
#define SURVEY_SETUP                @"SurveySetup"
#define SURVEY_HISTORY_POST         @"SurveyHistory"
#define FORM_SETUP                  @"FormSetup"
#define FORM_HISTORY_POST           @"FormHistory"
#define INCIDENT_GRAPH              @"IncidentGraph"
#define UTILIZATION_GRAPH           @"UtilizationGraph"
#define TASK_SETUP                  @"TaskSetup"
#define NOTIFY_EMAIL_GROUP          @"NotificationEmailGroup"
#define MEMO                        @"Memo"
#define DAILY_MATRICS               @"DailyMetrics"
#define DAILY_LOG                   @"DailyLog"
#define TEAM_LOG                    @"DailyLog/PostDailyLog"
#define POSTCOMMENTS                @"DailyLogTeam/PostDailyLogTeamDetail"
#define ADMIN_TASK_LIST             @"AdminTaskList"
#define HOME_SCREEN_MODULES         @"HomeScreenModules"
#define APPVERSION                  @"AppVersion"
#define CLIENT_POSITIONS             @"UserFacility/GetFacilitesByUser"


#define SERVICE_HTTP_METHOD         @{USER_LOGIN:@"GET", USER_FORGOT_PASSWORD : @"POST", USER_FACILITY:@"GET", SOP_CATEGORY:@"GET", SOP_DETAIL:@"GET", ERP_CATEGORY:@"GET", ERP_HISTORY: @"POST", INCIDENT_REPORT_SETUP : @"GET", ACCIDENT_REPORT_SETUP : @"GET", INCIDENT_REPORT_POST:@"POST", ACCIDENT_REPORT_POST:@"POST", SURVEY_SETUP:@"GET", FORM_SETUP:@"GET", SURVEY_HISTORY_POST:@"POST", FORM_HISTORY_POST:@"POST", INCIDENT_GRAPH:@"GET", UTILIZATION_GRAPH:@"GET", DAILY_MATRICS:@"GET", DAILY_LOG:@"POST", ADMIN_TASK_LIST:@"GET", HOME_SCREEN_MODULES:@"GET", APPVERSION:@"GET",CLIENT_POSITIONS:@"GET"}





#define kScreenBounds                           ([[UIScreen mainScreen] bounds])
#define kScreenWidth                            (kScreenBounds.size.width)
#define kScreenHeight                           (kScreenBounds.size.height)


#define MSG_REQUIRED_FIELDS         @"Please complete all required fields."
#define MSG_PROFILE_UPDATE_SUCCESS  @"Profile has been updated Successfully"
#define MSG_PROFILE_UPDATE_FAILURE  @"Unable to update profile at this time, Please try again later"
#define MSG_LOGIN_FAILURE           @"Email id or password does not match, Please check your email id or password"
#define MSG_NO_INTERNET             @"Please make sure you have an Internet connection and try again."
#define MSG_SERVICE_FAIL            @"An unexpected error occurred.  Please try again.  If the issue persists, please contact support."
//#define MSG_ADDED_TO_SYNC           @"Your information was saved locally.  Please sync from the Home screen to upload the information to GoBoard once you have an Internet connection."
#define  MSG_ADDED_TO_SYNC          @"You appear to be working offline. Your information was saved locally.Please Sync from the Home Screen to upload the information to your web portal once you have an internet connection."
#define MSG_NEWVERSION              @"There is a newer version of the app, please visit the app store to download the latest version"
#endif


//#define DEBUG_LOG

#ifdef DEBUG_LOG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif