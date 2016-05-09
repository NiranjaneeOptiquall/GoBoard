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
#import <Raygun4iOS/Raygun.h>



@interface AppDelegate () 

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    gblAppDelegate = self;
    NSLog(@"%@", [self applicationDocumentsDirectory]);
   // NSURL *path=[self applicationDocumentsDirectory];
    
    
    // add the code for Raygun and comment the code for Crittercism
    
    [Raygun sharedReporterWithApiKey:@"lmj784kqfMpBWsj6ylF4dA=="];
    [[Raygun sharedReporter] identify:@"Guest"];
    
    /*
    [Crittercism enableWithAppID:@"54658465466eda0236000003"];
    //    //sync Breadcrumb Mode
    [Crittercism setAsyncBreadcrumbMode:YES]; */
    
    
    CGRect aRect = [[UIScreen mainScreen]bounds];
    NSString *aStrRect = NSStringFromCGRect(aRect);
    NSLog(@"Frame:%@", aStrRect);
    
    _shouldHideActivityIndicator = YES;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"SettingsIsProduction"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SettingsIsProduction"];
    }
    _isProduction = [[NSUserDefaults standardUserDefaults] boolForKey:@"SettingsIsProduction"];
    
    return YES;
}

-(void)showSimpleAlertWithMessage:(NSString *)aStrMessage
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Alert"
                                          message:aStrMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
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
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error]) {
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

        
        NSString *aUrl = [NSString stringWithFormat:@"%@%@", SERVICE_URL, url];
        aUrl = [aUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:aUrl]];
        
        [request setHTTPMethod:httpMethod];
        if (params) {
            NSData *aData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
            NSString *aStrJson = [[NSString alloc]initWithData:aData encoding:NSUTF8StringEncoding];
         //  NSLog(@"requestParam:%@",aStrJson);
            [request setHTTPBody:aData];
        }
        [request setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"vKDx#'D4i}qxj,0Q9@$tWPb!Y69RhS" forHTTPHeaderField:@"ApiKey"];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        manager.responseSerializer =
        [AFJSONResponseSerializer serializerWithReadingOptions: NSJSONReadingMutableContainers];
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            
            if (error) {
               
                failure (error, @{@"ErrorMessage":MSG_SERVICE_FAIL});
                
            } else {
                
                
                NSMutableDictionary *aDict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
          //      NSData *d = [request HTTPBody];
            //    NSString *aStr = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
              //  NSLog(@"%@", aStr);
                if ([[aDict objectForKey:@"Success"] boolValue]) {
                    completion(aDict);
                }
                else {
                    alert(@"", [aDict objectForKey:@"ErrorMessage"]);
                    failure (nil, aDict);
                }
                
            }
             [self hideActivityIndicator];
        }];
        [dataTask resume];
        
    }
    else {
        failure(nil, @{@"ErrorMessage":MSG_NO_INTERNET});
        
    }
}


- (void)callSynchronousWebService:(NSString*)url parameters:(NSDictionary*)params httpMethod:(NSString*)httpMethod complition:(void (^)(NSDictionary *response))completion failure:(void (^)(NSError *error, NSDictionary *response))failure {
    if ([self isNetworkReachable]) {
        [self showActivityIndicator];
        
        
        
        //        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html",@"text/json",nil]];
        NSString *aUrl = [NSString stringWithFormat:@"%@%@", SERVICE_URL, url];
        aUrl = [aUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:aUrl]];
        
        [request setHTTPMethod:httpMethod];
        if (params) {
            NSData *aData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
            NSString *aStr = [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding];
          //  NSLog(@"%@", aStr);
            [request setHTTPBody:aData];
        }
        [request setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
        
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        manager.responseSerializer =
        [AFJSONResponseSerializer serializerWithReadingOptions: NSJSONReadingMutableContainers];
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            
            if (error) {
                [self hideActivityIndicator];
                failure (error, @{@"ErrorMessage":MSG_SERVICE_FAIL});
                
            } else {
                
                [self hideActivityIndicator];
                NSMutableDictionary *aDict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                if ([[aDict objectForKey:@"Success"] boolValue]) {
                    completion(aDict);
                }
                else {
                    failure (nil, aDict);
                }
                
            }
        }];
        [dataTask resume];
        
        
    }
    else {
        failure(nil, nil);
        
    }
}

- (void)callAsynchronousWebService:(NSString*)url parameters:(NSDictionary*)params httpMethod:(NSString*)httpMethod complition:(void (^)(NSDictionary *response))completion failure:(void (^)(NSError *error, NSDictionary *response))failure {
    if ([self isNetworkReachable]) {

        NSString *aUrl = [NSString stringWithFormat:@"%@%@", SERVICE_URL, url];
        aUrl = [aUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:aUrl]];
        
        [request setHTTPMethod:httpMethod];
        if (params) {
            NSData *aData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
            
            [request setHTTPBody:aData];
        }
        [request setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"vKDx#'D4i}qxj,0Q9@$tWPb!Y69RhS" forHTTPHeaderField:@"ApiKey"];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        manager.responseSerializer =
        [AFJSONResponseSerializer serializerWithReadingOptions: NSJSONReadingMutableContainers];
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            
            if (error) {
                [self hideActivityIndicator];
                failure (error, @{@"ErrorMessage":MSG_SERVICE_FAIL});
                
            } else {
                
                [self hideActivityIndicator];
                NSMutableDictionary *aDict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                if ([[aDict objectForKey:@"Success"] boolValue]) {
                    completion(aDict);
                }
                else {
                    failure (nil, aDict);
                }
                
            }
        }];
        [dataTask resume];

    }
    else {
        failure(nil, @{@"ErrorMessage":MSG_NO_INTERNET});
        
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
    return @"Connect2";
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
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
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
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if (viewActivity) {
            [indicatorView stopAnimating];
            [viewActivity removeFromSuperview];
            indicatorView = nil;
            viewActivity = nil;
        }
    }
    
}

-(NSString *)getUTCDate:(NSDate *)aDate
{
    NSDate* datetime =aDate;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]]; // Prevent adjustment to user's local time zone.
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSString* dateTimeInIsoFormatForUTCTimeZone = [dateFormatter stringFromDate:datetime];
    return  dateTimeInIsoFormatForUTCTimeZone;
}
-(NSDate *)getLocalDate:(NSString *)aStrDate
{
    NSDateFormatter* aDateFormatter = [[NSDateFormatter alloc] init];
    [aDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]]; // Prevent adjustment to user's local time zone.
    [aDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *aDateUTC = [aDateFormatter dateFromString:aStrDate];
    if (aDateUTC==nil) {
        [aDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        aDateUTC =[aDateFormatter dateFromString:aStrDate];
    }
    return aDateUTC;
}


@end





//==================================== Categories ======================================\\


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

@implementation UITextView (Additions)

- (BOOL)isTextViewBlank {
    BOOL isEmpty = [[self trimText] isEqualToString:@""];
    if (isEmpty) {
        [self becomeFirstResponder];
    }
    return isEmpty;
}

- (NSString *)trimText {
    return [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


@end


@implementation UIButton (exclusive)

- (void)awakeFromNib {
    [self setExclusiveTouch:YES];
}

@end

