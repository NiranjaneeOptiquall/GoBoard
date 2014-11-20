//
//  AppDelegate.m
//  GoBoardPro
//
//  Created by ind558 on 22/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "Reachability.h"
#import "Crittercism.h"
@interface AppDelegate () 

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    gblAppDelegate = self;
    NSLog(@"%@", [self applicationDocumentsDirectory]);
    [Crittercism enableWithAppID:@"54658465466eda0236000003"];
    //    //sync Breadcrumb Mode
    [Crittercism setAsyncBreadcrumbMode:YES];
    _shouldHideActivityIndicator = YES;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.IndiaNIC.GoBoardPro" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GoBoardPro" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"GoBoardPro.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


- (void)callWebService:(NSString*)url parameters:(NSDictionary*)params httpMethod:(NSString*)httpMethod complition:(void (^)(NSDictionary *response))completion failure:(void (^)(NSError *error, NSDictionary *response))failure {
    if ([self isNetworkReachable]) {
        [self showActivityIndicator];
        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil]];
        NSString *aUrl = [NSString stringWithFormat:@"%@%@", SERVICE_URL, url];
        aUrl = [aUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:aUrl]];
        
        [request setHTTPMethod:httpMethod];
        if (params) {
            NSData *aData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
            NSString *aStr = [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", aStr);
            [request setHTTPBody:aData];
        }
        [request setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^
                                             (NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                 [self hideActivityIndicator];
                                                 NSMutableDictionary *aDict = [NSMutableDictionary dictionaryWithDictionary:JSON];
                                                 if ([[aDict objectForKey:@"Success"] boolValue]) {
                                                     completion(aDict);
                                                 }
                                                 else {
                                                     failure (nil, aDict);
                                                 }
                                             }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                 [self hideActivityIndicator];
                                                 failure (error, @{@"ErrorMessage":MSG_SERVICE_FAIL});
                                                 
                                             }];
        
        [operation start];
    }
    else {
        failure(nil, @{@"ErrorMessage":MSG_NO_INTERNET});
        
    }
}

- (void)callSynchronousWebService:(NSString*)url parameters:(NSDictionary*)params httpMethod:(NSString*)httpMethod complition:(void (^)(NSDictionary *response))completion failure:(void (^)(NSError *error, NSDictionary *response))failure {
    if ([self isNetworkReachable]) {
        [self showActivityIndicator];
        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil]];
        NSString *aUrl = [NSString stringWithFormat:@"%@%@", SERVICE_URL, url];
        aUrl = [aUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:aUrl]];
        
        [request setHTTPMethod:httpMethod];
        if (params) {
            NSData *aData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
            NSString *aStr = [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", aStr);
            [request setHTTPBody:aData];
        }
        [request setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
//        AFJSONRequestOperation *operation = [AFJSONRequestOperation ]
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^
                                             (NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                 [self hideActivityIndicator];
                                                 NSMutableDictionary *aDict = [NSMutableDictionary dictionaryWithDictionary:JSON];
                                                 if ([[aDict objectForKey:@"Success"] boolValue]) {
                                                     completion(aDict);
                                                 }
                                                 else {
                                                     failure (nil, aDict);
                                                 }
                                             }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                 [self hideActivityIndicator];
                                                 failure (error, JSON);
                                                 
                                             }];
        
        [operation start];
    }
    else {
        failure(nil, nil);
        
    }
}

#pragma mark Reachability

- (BOOL)isNetworkReachable {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];//[Reachability reachabilityWithHostName:@"http://www.google.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if (remoteHostStatus == NotReachable) {
        return NO;
    }
    return YES;
}


#pragma mark - Methods

- (BOOL)validateEmail:(NSString*)strEmail {
    if ([strEmail isEqualToString:@""]) return YES;
        
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [emailTest evaluateWithObject:[strEmail trimString]];
}

- (NSString *)appName {
    return @"GoBoardPro";
}

- (void)showActivityIndicator {
    if (_shouldHideActivityIndicator) {
        [self showActivityIndicatorWithMessage:nil];
    }
}


- (void)showActivityIndicatorWithMessage:(NSString*)strMessage {
    [self showActivityIndicatorWithMessage:strMessage atPosition:ActivityIndicatorPositionCenter];
}


- (void)showActivityIndicatorWithMessage:(NSString*)strMessage atPosition:(ActivityIndicatorPosition)pos {
    if (!viewActivity) {
        viewActivity = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [viewActivity setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]];
        indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicatorView startAnimating];
        if (strMessage && strMessage.length > 0) {
            NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"HelveticaNeue-Light" size:11] forKey: NSFontAttributeName];
            
            // iOS 7 method to mesure height of string instead if sizeWithFont: as it is deprecated
            float height = [strMessage boundingRectWithSize:CGSizeMake(viewActivity.frame.size.width - 6, 30) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin  attributes:stringAttributes context:nil].size.height;
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, viewActivity.frame.size.width - 6, height)];
            lbl.numberOfLines = 0;
            [lbl setBackgroundColor:[UIColor clearColor]];
            [lbl setTextColor:[UIColor whiteColor]];
            [lbl setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11]];
            [lbl setTextAlignment:NSTextAlignmentCenter];
            [lbl setText:strMessage];
            float a = ((viewActivity.frame.size.height - indicatorView.frame.size.height - height - 5) / 2) + (indicatorView.frame.size.height / 2);
            indicatorView.center = CGPointMake(viewActivity.center.x, a);
            lbl.center = CGPointMake(viewActivity.center.x, viewActivity.frame.size.height - indicatorView.frame.origin.y - (height/2));
            [viewActivity addSubview:lbl];
        }
        else {
            indicatorView.center = viewActivity.center;
        }
        
        [viewActivity addSubview:indicatorView];
        [viewActivity.layer setCornerRadius:6.0];
        if (pos == ActivityIndicatorPositionCenter) {
            viewActivity.center = self.window.center;
        }
        else if (pos == ActivityIndicatorPositionBottom) {
            viewActivity.center = CGPointMake(self.window.center.x, self.window.bounds.size.height - (viewActivity.bounds.size.height / 2) - 55);
        }
        else if (pos == ActivityIndicatorPositionTop) {
            viewActivity.center = CGPointMake(self.window.center.x, (viewActivity.bounds.size.height / 2) + 80);
        }
        
        [self.window addSubview:viewActivity];
    }
}

- (void)hideActivityIndicator {
    if (_shouldHideActivityIndicator) {
        if (viewActivity) {
            [indicatorView stopAnimating];
            [viewActivity removeFromSuperview];
            indicatorView = nil;
            viewActivity = nil;
        }
    }
    
}


@end









//==================================== Categories ======================================\\



@implementation NSString (Additions)

- (NSString *)trimString {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isNumbersOnly {
    NSString *regex = @"^(?:|0|[1-9]\\d*)(?:\\.\\d*)?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isSuccess = [predicate evaluateWithObject:self];
    return isSuccess;
}

//chatacter you need will be in [ ], ? indicates that the expression before it is optional, { } indiactes the limit or range of expression before it and \\s indicates space
- (BOOL)isValidPhoneNumber {
    if ([self isEqualToString:@""]) {
        return YES;
    }
    NSString *regex = @"[+]?[(]?[0-9]{3}[)]?[-\\s]?[0-9]{3}[-\\s]?[0-9]{4,9}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isSuccess = [predicate evaluateWithObject:self];
    return isSuccess;
}


// Password validation conditions are:
// "Atleast 1 digit" specifies with: (?=.*\\d)
// "Atleast 1 alphabate" specifies with: (?=.*[a-z])
// "Atleast 1 Capital letter" specifiec with: (?=.*[A-Z])
// Must be atleast 8 char and not longer than 16 char specifies with : .{8,16}
// Regex starts with ^ and ends with $

- (BOOL)isValidPassword {
    if ([self isEqualToString:@""]) {
        return NO;
    }
    NSString *regex = @"^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,16}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isSuccess = [predicate evaluateWithObject:self];
    return isSuccess;
}
@end

@implementation UITextField (Additions)

- (BOOL)isTextFieldBlank {
    BOOL isEmpty = [[self trimText] isEqualToString:@""];
    if (isEmpty) {
        [self becomeFirstResponder];
    }
    return isEmpty;
}

- (NSString *)trimText {
   return [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)awakeFromNib {
    [self setValue:[UIColor colorWithRed:69.0/255.0 green:69.0/255.0 blue:69.0/255.0 alpha:0.7] forKeyPath:@"_placeholderLabel.textColor"];
    [self setFont:[UIFont systemFontOfSize:16.0]];
    [self setExclusiveTouch:YES];
}

@end

@implementation UIButton (exclusive)

- (void)awakeFromNib {
    [self setExclusiveTouch:YES];
}

@end

