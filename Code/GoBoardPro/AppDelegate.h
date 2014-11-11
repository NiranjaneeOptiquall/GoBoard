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

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UINavigationController *navigationController;

@property (assign, nonatomic) BOOL isAdmin;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (BOOL)validateEmail:(NSString*)strEmail;
@end

@interface NSString (Additions)

- (NSString *)trimString;
- (BOOL)isNumbersOnly;
- (BOOL)isValidPhoneNumber;
- (BOOL)isValidPassword;
@end

@interface UITextField (Additions)
- (BOOL)isTextFieldBlank;
- (NSString *)trimText;
@end