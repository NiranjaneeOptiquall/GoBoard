//
//  AppDelegate.h
//  GoBoardPro
//
//  Created by ind558 on 22/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
typedef void (^QSCompletionBlock) ();
typedef NS_ENUM (NSInteger, ActivityIndicatorPosition) {
    ActivityIndicatorPositionTop = 0,
    ActivityIndicatorPositionCenter = 1,
    ActivityIndicatorPositionBottom = 2,
};


@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UIView *viewActivity;
    UIActivityIndicatorView *indicatorView;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (nonatomic, assign) BOOL shouldHideActivityIndicator;

@property (strong, nonatomic) NSMutableArray *mutArrMemoList;
@property (strong, nonatomic) NSMutableArray *mutArrHomeMenus;

@property (assign, nonatomic) BOOL isAdmin;
@property (assign, nonatomic) BOOL isProduction;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (BOOL)validateEmail:(NSString*)strEmail;
- (NSString *)appName;
- (BOOL)isNetworkReachable;
- (void)callWebService:(NSString*)url parameters:(NSDictionary*)params httpMethod:(NSString*)httpMethod complition:(void (^)(NSDictionary *response))completion failure:(void (^)(NSError *error, NSDictionary *response))failure;
- (void)showActivityIndicator;
- (void)hideActivityIndicator;
@end



//==================================== Categories ======================================\\

@interface UITextField (Additions)
- (BOOL)isTextFieldBlank;
- (NSString *)trimText;
@end