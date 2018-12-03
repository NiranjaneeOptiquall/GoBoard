//
//  ViewController.m
//  GoBoardPro
//
//  Created by ind558 on 22/09/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "LoginViewController.h"
#import <WebKit/WebKit.h>
#import "GuestFormViewController.h"
#import "DailyLog.h"
#import "Reachability.h"
#import <Raygun4iOS/Raygun.h>
#import "MyApplication.h"
#import "MyWorkOrdersTypeViewController.h"
@interface LoginViewController ()<WKNavigationDelegate,WKUIDelegate>
{
    NSString * loginWithSSO, *strSSOUserName, *strSSOUserKey;
    NSArray *cookies;
}
@property (weak, nonatomic) IBOutlet UIButton *btnSSOSignIn;

//@property (weak, nonatomic) IBOutlet WKWebView *ssoWebView;

@end

@implementation LoginViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    cookies = [[NSArray alloc]init];
    loginWithSSO = @"NO";
    _btnSSOSignIn.hidden = YES;
 
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"istouch"];
 
    _lblGuestFormCount.hidden=YES;
    _lblGuestSurveyCount.hidden=YES;
    _lblGuestSugessionCount.hidden=YES;

    _lblGuestFormCount.layer.cornerRadius=5.0;
    _lblGuestFormCount.layer.borderWidth=1.0;
    _lblGuestFormCount.layer.borderColor=[UIColor whiteColor].CGColor;
    _lblGuestFormCount.layer.masksToBounds=YES;

    _lblGuestSurveyCount.layer.cornerRadius=5.0;
    _lblGuestSurveyCount.layer.borderWidth=1.0;
    _lblGuestSurveyCount.layer.borderColor=[UIColor whiteColor].CGColor;
    _lblGuestSurveyCount.layer.masksToBounds=YES;

    _lblGuestSugessionCount.layer.cornerRadius=5.0;
    _lblGuestSugessionCount.layer.borderWidth=1.0;
    _lblGuestSugessionCount.layer.borderColor=[UIColor whiteColor].CGColor;
    _lblGuestSugessionCount.layer.masksToBounds=YES;
    
     [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"backFromGuestUserListView"];
    
   // _txtGuestName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientName"];
   _txtGuestName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"accountName"];

    [_lblVersionNumber setText:[NSString stringWithFormat:@"v%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(defaultsSettingsChanged) name:NSUserDefaultsDidChangeNotification object:nil];
    [self initialUIConfig];
    gblAppDelegate.shouldHideActivityIndicator = NO;
    [self checkAppVersions];
    gblAppDelegate.shouldHideActivityIndicator = YES;
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    loginWithSSO = @"NO";
    [_btnUserSignIn sendActionsForControlEvents: UIControlEventTouchUpInside];
    
    //    if ([_isTimeExpire isEqualToString:@"yes"]) {
    //        UIApplication *myapp=[UIApplication sharedApplication];
    //        AppDelegate *mydelegatefile=(AppDelegate *)myapp.delegate;
    //[mydelegatefile resetWindowToInitialView];
    //    }
    
    //[self.txtUserId becomeFirstResponder];
    
    _txtUserId.text = @"";
    _txtPassword.text = @"";
    gblAppDelegate.mutArrMemoList = nil;
    gblAppDelegate.mutArrHomeMenus = nil;
    [User destroyCurrentUser];
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"backFromGuestUserListView"] isEqualToString:@"YES"]) {
        [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"backFromGuestUserListView"];
        //   [_btnGuestSignIn setSelected:NO];
        [self btnGuestSignInTapped:_btnGuestSignIn];
        
    }
    else{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"ssoKey"] != nil) {
        
        if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"ssoKey"] isEqualToString:@""]) {
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            NSString * url = [NSString stringWithFormat:@"Account?AKey=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"ssoKey"]];
                 [gblAppDelegate showActivityIndicator];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

            [gblAppDelegate callWebService:url parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:USER_LOGIN] complition:^(NSDictionary *response) {
     

                NSLog(@"%@",response);
                BOOL isSuperAdmin = NO;
                
                   if ([[NSUserDefaults standardUserDefaults] valueForKey:@"isSuperAdmin"] != nil) {
                        isSuperAdmin = [[[NSUserDefaults standardUserDefaults] valueForKey:@"isSuperAdmin"] boolValue];
                   }
                if (isSuperAdmin) {
                    if ([[NSString stringWithFormat:@"%@",[response valueForKey:@"SSOActivationStatus"]] isEqualToString:@"0"]) {
                        _btnSSOSignIn.hidden = YES;
                    }
                    else  if ([[NSString stringWithFormat:@"%@",[response valueForKey:@"SSOActivationStatus"]] isEqualToString:@"1"] || [[NSString stringWithFormat:@"%@",[response valueForKey:@"SSOActivationStatus"]] isEqualToString:@"2"]) {
                        
                        _btnSSOSignIn.hidden = NO;
                    }
                  
                    else  {
                        _btnSSOSignIn.hidden = YES;
                    }
                }else{
                if ([[NSString stringWithFormat:@"%@",[response valueForKey:@"SSOActivationStatus"]] isEqualToString:@"0"]) {
                     _btnSSOSignIn.hidden = YES;
                }
                else  if ([[NSString stringWithFormat:@"%@",[response valueForKey:@"SSOActivationStatus"]] isEqualToString:@"1"]) {
                     _btnSSOSignIn.hidden = NO;
                }
                else  if ([[NSString stringWithFormat:@"%@",[response valueForKey:@"SSOActivationStatus"]] isEqualToString:@"2"]) {
                    _vwCUserSignIn.hidden = YES;
                    _btnSSOSignIn.hidden = NO;
                    CGRect frame = _btnSSOSignIn.frame;
                    frame.origin.y = _vwCUserSignIn.frame.origin.y + 30;
                    _btnSSOSignIn.frame = frame;
                }
                else  {
                    _btnSSOSignIn.hidden = YES;
                }
                }
                [gblAppDelegate hideActivityIndicator];
            }failure:^(NSError *error, NSDictionary *response) {
                NSLog(@"%@",response);
                NSLog(@"%@",error);
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                _btnSSOSignIn.hidden = YES;
                           [gblAppDelegate hideActivityIndicator];
            }];
                  });
        }
    }
    }
}
- (IBAction)btnSSOSignInTapped:(UIButton *)sender {
    loginWithSSO = @"YES";
    //    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    //
//        NSData *cookieData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ssoCookies"];
//        cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookieData];
//
//    NSString *cookiesString = @"";//[cookies componentsJoinedByString:@";"];
//
//    for (int i = 0; i < cookies.count; i++) {
//        NSArray * dic = [cookies objectAtIndex:i];
//        cookiesString = [NSString stringWithFormat:@"%@",[dic objectAtIndex:0] ];
//        for (int j = 1; j <dic.count; j++) {
//            cookiesString = [NSString stringWithFormat:@"%@,%@",cookiesString,[dic objectAtIndex:j] ];
//        }
//    }
    

 //   WKUserContentController* userContentController = WKUserContentController.new;
//    WKUserScript * cookieScript = [[WKUserScript alloc]
//                                   initWithSource: cookiesString
//                                   injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    // again, use stringWithFormat: in the above line to inject your values programmatically
//    [userContentController addUserScript:cookieScript];
    
    
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
   //  theConfiguration.userContentController = userContentController;
    WKWebView *ssoWebView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
    ssoWebView.hidden = NO;


    ssoWebView.navigationDelegate = self;
    ssoWebView.allowsBackForwardNavigationGestures = YES;
    NSString * strSSOKey = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"ssoKey"]];
    // NSString * strSSOKey = @"39D4DF38-9F0C-49AA-92D7-92E93E8C07FB";
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@AKey=%@&RS=iOS",SERVICE_URL_SSO,strSSOKey]];
    
    [ssoWebView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:ssoWebView];
}
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    NSLog(@"Allow all");
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
    CFDataRef exceptions = SecTrustCopyExceptions (serverTrust);
    SecTrustSetExceptions (serverTrust, exceptions);
    CFRelease (exceptions);
    completionHandler (NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:serverTrust]);
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"ERRRRRR: %@",error.localizedDescription);
}
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [gblAppDelegate showActivityIndicator];
    NSLog(@"Strat to load");
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"finish to load");
    [gblAppDelegate hideActivityIndicator];

}
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler{
   NSLog(@"%@",navigationAction.request.URL.absoluteString);
    NSString * urlString = navigationAction.request.URL.absoluteString;
    NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
    if ([urlString containsString:@"/IOSLogin?"]) {
        NSArray *urlComponents = [urlString componentsSeparatedByString:@"&"];
        NSLog(@"%@",urlComponents);
        for (NSString *keyValuePair in urlComponents)
        {
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
            NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
            NSLog(@"%@ : %@",key,value);
           [queryStringDictionary setObject:value forKey:key];
     
        }
        for (NSString *key in queryStringDictionary) {
            id value = queryStringDictionary[key];
            NSLog(@"Value: %@ for key: %@", value, key);
            if ([key containsString:@"IOSLogin?UN"]) {
                strSSOUserName = [NSString stringWithFormat:@"%@",value ];
            }
        }
        strSSOUserKey = [NSString stringWithFormat:@"%@",[queryStringDictionary valueForKey:@"UKey"] ];
        [self btnSignInTapped:_btnSSOSignIn];
        webView.hidden = YES;
        [webView stopLoading];
    }
 
    decisionHandler(WKNavigationResponsePolicyAllow);
}
-(void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//    NSLog(@"%@",navigationResponse);
    NSHTTPURLResponse * response = (NSHTTPURLResponse *)navigationResponse.response;
//    NSLog(@"%@",response);
//    NSDictionary *dictionary1 = [(NSHTTPURLResponse*)response allHeaderFields];
//    NSLog(@"%@",dictionary1);
//    NSDictionary *dictionary2 = [NSDictionary dictionaryWithObjects:[dictionary1 allValues] forKeys:[dictionary1 allKeys]];
//    NSLog(@"%@",dictionary2);
//
    
    
//    cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[NSURL URLWithString:@""]];
//     NSLog(@"%@",cookies);
//    if (cookies.count != 0) {
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
//        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"ssoCookies"];
//    }
    
    
//    for (NSHTTPCookie *cookie in cookies) {
//        // Do something with the cookie
//        NSLog(@"%@",cookie);
//
//    }
    
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [_txtUserId resignFirstResponder];
    [_txtPassword resignFirstResponder];
    GuestFormViewController *guestForm = (GuestFormViewController*)[segue destinationViewController];
    if ([[segue identifier] isEqualToString:@"takeASurvey"]) {
        guestForm.guestFormType = 1;
    }
    else if ([[segue identifier] isEqualToString:@"makeSuggestion"]) {
        guestForm.guestFormType = 3;
    }
    else if ([[segue identifier] isEqualToString:@"completeForm"]) {
        guestForm.guestFormType = 2;
    }
}

#pragma mark - IBActions & Selectors

- (IBAction)btnGuestSignInTapped:(UIButton *)sender {
    
    [self callServiceForGuestUserDashboardCount:YES complition:^(NSDictionary * aDict){
        if ([[aDict objectForKey:@"Success"] boolValue]) {
            NSString * strFormCount=[NSString stringWithFormat:@"%@",[[aDict valueForKey:@"DashboardCount"] valueForKey:@"FormInprogressCount"]];
                NSString * strSurveyCount=[NSString stringWithFormat:@"%@",[[aDict valueForKey:@"DashboardCount"] valueForKey:@"SurveyInprogressCount"]];
                NSString * strSugessionCount=[NSString stringWithFormat:@"%@",[[aDict valueForKey:@"DashboardCount"] valueForKey:@"SuggestionInprogressCount"]];
            if (![strSurveyCount isEqualToString:@"0"]) {
                _lblGuestSurveyCount.hidden=NO;
                _lblGuestSurveyCount.text=strSurveyCount;
            }
            else
            {
                _lblGuestSurveyCount.hidden=YES;
                
            }
            if (![strFormCount isEqualToString:@"0"]) {
                _lblGuestFormCount.hidden=NO;
                _lblGuestFormCount.text=strFormCount;
                
                
            }
            else
            {
                _lblGuestFormCount.hidden=YES;
                
            }
            if (![strSugessionCount isEqualToString:@"0"]) {
                _lblGuestSugessionCount.hidden=NO;
                _lblGuestSugessionCount.text=strSugessionCount;
                
                
            }
            else
            {
                _lblGuestSugessionCount.hidden=YES;
                
            }

        }
        
    }];

    
    
    if (![sender isSelected]) {
        [sender setSelected:YES];
        [_btnUserSignIn setSelected:NO];
        [_imvGuestIndicator setHidden:NO];
        [_imvUserIndicator setHidden:YES];
        [_vwUserSignIn setHidden:YES];
        [_vwGuestSignIn setHidden:NO];
        
        [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"isGuest"];
    }
}

- (IBAction)btnUserSignInTapped:(UIButton*)sender {

    
    if (![sender isSelected]) {
        [sender setSelected:YES];
        [_btnGuestSignIn setSelected:NO];
        [_imvUserIndicator setHidden:NO];
        [_imvGuestIndicator setHidden:YES];
        [_vwGuestSignIn setHidden:YES];
        [_vwUserSignIn setHidden:NO];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isGuest"];
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

#pragma mark - GuestUserDashboard Count

-(void)callServiceForGuestUserDashboardCount:(BOOL)waitUntilDone complition:(void(^)(NSDictionary * aDict))complition
{
    __block BOOL isWSComplete = NO;
    
    NSMutableArray *arrOfPosition = [NSMutableArray new];
    
    // NSString *aStrFacilityID = [[User currentUser]selectedFacility].value;
    
    // NSString *aStrUserID = [[User currentUser]userId];
    
    NSMutableArray *arr=  [[User currentUser]mutArrSelectedPositions];
    
    //  NSString *aStrClientId = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientId"];
    
    NSString * isAdmin;
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"IsAdmin"] integerValue] == 0) {
        isAdmin= @"False";
    }
    else{
        isAdmin= @"True";
    }
    
    for (UserPosition *p in arr) {
        
        [arrOfPosition addObject:p.value];
    }

     NSString *strUrl =[NSString stringWithFormat:@"HomeScreenModules?accountId=%@&userId=%@&facilityId=0&positionIds=0&locationIds=0&isAdmin=%@&formAccess=False&surveyAccess=False&logAccess=False&taskAccess=False&memoAccess=False",[[NSUserDefaults standardUserDefaults] objectForKey:@"accountId"],[[User currentUser]userId],isAdmin];

    [gblAppDelegate callWebService:strUrl parameters:nil httpMethod:@"GET" complition:^(NSDictionary *response) {
        
        NSLog(@"%@",response);
   
        isWSComplete = YES;
        if (complition)
            complition(response);
    } failure:^(NSError *error, NSDictionary *response) {
        isWSComplete = YES;
        if (complition)
            complition(response);
        
    }];
    if (waitUntilDone) {
        while (!isWSComplete) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        }
    }
    
    
}
- (IBAction)btnSignInTapped:(id)sender {
    NSString * urlStr = @"";
     NSDate *methodStart = [NSDate date];
    if ([loginWithSSO isEqualToString:@"NO"]) {

    _btnSignInTapped.userInteractionEnabled=NO;
    if ([_txtUserId isTextFieldBlank]) {
        alert(@"Login", @"Please enter a Username");
        return;
    }
    else if ([_txtPassword isTextFieldBlank]) {
        alert(@"Login", @"Please enter a Password");
        return;
    }
    else if (![_txtPassword.text isValidPassword]) {
        alert(@"Login", @"Password must be between 8-16 characters with the use of both upper- and lower-case letters (case sensitivity) and inclusion of one or more numerical digits");
        return;
    }
       

//
//    NSDictionary * aDic = @{@"UserCredentials" :
//                                                        @{
//                                                            @"Username":_txtUserId.trimText,
//                                                            @"Password":_txtPassword.text
//                                                            }
//                                            };
        
        urlStr = [NSString stringWithFormat:@"%@?userName=%@&password=%@",USER_LOGIN,_txtUserId.trimText, _txtPassword.text];
    }
    else{
        NSString * accountID = [[NSUserDefaults standardUserDefaults] valueForKey:@"ssoKey"];
          urlStr = [NSString stringWithFormat:@"%@?userName=%@&UKey=%@&AKey=%@",USER_LOGIN,strSSOUserName,strSSOUserKey,accountID];
    }
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
     [gblAppDelegate callWebService:urlStr parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:USER_LOGIN] complition:^(NSDictionary *response) {
     // [gblAppDelegate callWebService:[NSString stringWithFormat:@"TestUser/AuthenticateUser"] parameters:aDic httpMethod:@"POST" complition:^(NSDictionary *response) {
        NSLog(@"%@",response);
        _btnSignInTapped.userInteractionEnabled=YES;
        
        if ([[response objectForKey:@"UserStatus"] isEqualToString:@"Invited"] || [[response objectForKey:@"UserStatus"] isEqualToString:@"Active"]){
            
            
            User *currentUser = [User currentUser];
            currentUser.firstName = nil;
            currentUser.lastName = nil;
            currentUser.middleInitials = nil;
            currentUser.email = nil;
            currentUser.phone = nil;
            currentUser.mobile = nil;
            currentUser.userId = nil;
            currentUser.clientId = nil;
            currentUser.clientName = nil;
            currentUser.accountId = nil;
            currentUser.accountName = nil;
            currentUser.termsAndConditions = nil;
            currentUser.selectedFacility = nil;
            currentUser.username = nil;
            currentUser.AutomaticLogoutTime = nil;
            currentUser.userStatusCheck = nil;
            currentUser.username = self.txtUserId.text;
          //  currentUser.ssoKey = @"";
            currentUser.AutomaticLogoutTime = [NSString stringWithFormat:@"%@",[response objectForKey:@"AutomaticLogoutTime"]];
           
            [[NSUserDefaults standardUserDefaults] setValue:[response objectForKey:@"IsSuperAdmin"] forKey:@"isSuperAdmin"];
            
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@",[response objectForKey:@"AccountKey"]] forKey:@"ssoKey"];
    //        [[NSUserDefaults standardUserDefaults] setValue:@"39D4DF38-9F0C-49AA-92D7-92E93E8C07FB" forKey:@"ssoKey"];

            
          //  [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%ld",(long)[[response objectForKey:@"AccountId"] integerValue]] forKey:@"accountId"];
            
            [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"isBack"];
            [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"fromSugestionViewC"];
            
            NSLog(@"Automatic Logout Time======%@",[NSString stringWithFormat:@"%@",[response objectForKey:@"AutomaticLogoutTime"]]);
            currentUser.firstName = [response objectForKey:@"FirstName"];
            if ([[response objectForKey:@"MiddleInitial"] isKindOfClass:[NSNull class]]) {
                currentUser.middleInitials = @"";
            }
            else {
                currentUser.middleInitials = [response objectForKey:@"MiddleInitial"];
            }
            currentUser.termsAndConditions = [response objectForKey:@"TermsAndConditions"];
            currentUser.isAcceptedTermsAndConditions = [[response objectForKey:@"AcceptedTermsAndConditions"] boolValue];
            
            currentUser.userStatusCheck = [NSString stringWithFormat:@"%@",[response objectForKey:@"UserStatus"]];

            currentUser.lastName = [response objectForKey:@"LastName"];
            if ([[response objectForKey:@"Mobile"] isKindOfClass:[NSNull class]]) {
                currentUser.mobile = @"";
            }
            else {
                currentUser.mobile = [response objectForKey:@"Mobile"];
            }
            if ([[response objectForKey:@"Phone"] isKindOfClass:[NSNull class]]) {
                currentUser.phone = @"";
            }
            else {
                currentUser.phone = [response objectForKey:@"Phone"];
            }
            currentUser.email = [response objectForKey:@"Email"];
            
            currentUser.clientName = [response objectForKey:@"ClientName"];
            currentUser.accountName = [response objectForKey:@"AccountName"];

            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"oldeAccount"] isEqualToString:[response objectForKey:@"AccountName"]]) {
                if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isFirstTimeDataSurveyDone"] isEqualToString:@"YES"]){
                    
                    [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"isSameClientSurvey"];
                    
                }
                if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isFirstTimeDataFormDone"] isEqualToString:@"YES"]){
                    
                    [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"isSameClientForm"];
                    
                }
                
                
            }
            else{
                [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"isFirstTimeDataSurveyDone"];
                [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"isFirstTimeDataFormDone"];
                
                [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"isSameClientForm"];
                [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"isSameClientSurvey"];
                
            }

            
            
    /*        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"oldeClient"] isEqualToString:[response objectForKey:@"ClientName"]]) {
                if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isFirstTimeDataSurveyDone"] isEqualToString:@"YES"]){
                    
                    [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"isSameClientSurvey"];
                    
                }
                if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"isFirstTimeDataFormDone"] isEqualToString:@"YES"]){
                    
                    [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"isSameClientForm"];
                    
                }
                
                
            }
            else{
                [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"isFirstTimeDataSurveyDone"];
                [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"isFirstTimeDataFormDone"];
                
                [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"isSameClientForm"];
                [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"isSameClientSurvey"];
                
            } */
            
            
            [[NSUserDefaults standardUserDefaults]setValue:[response objectForKey:@"IsAdmin"] forKey:@"IsAdmin"];
            
            [[NSUserDefaults standardUserDefaults]setValue:currentUser.clientName forKey:@"oldeClient"];
            [[NSUserDefaults standardUserDefaults]setValue:currentUser.accountName forKey:@"oldeAccount"];
  
            currentUser.userId = [NSString stringWithFormat:@"%ld",(long)[[response objectForKey:@"Id"] integerValue]];
            currentUser.clientId = [NSString stringWithFormat:@"%ld",(long)[[response objectForKey:@"ClientId"] integerValue]];
         
            currentUser.accountId = [NSString stringWithFormat:@"%ld",(long)[[response objectForKey:@"AccountId"] integerValue]];

            currentUser.isAdmin = [[response objectForKey:@"IsAdmin"] boolValue];
            NSString *prevUserId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
            if (prevUserId) {
                if (![prevUserId isEqualToString:currentUser.userId]) {
                    [self deleteAllDailyLogData];
                }
            }
            
            [[Raygun sharedReporter] identify:[NSString stringWithFormat:@"%@ %@",[User currentUser].firstName , [User currentUser].lastName]];
            
            [[NSUserDefaults standardUserDefaults] setObject:currentUser.userId forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults] setObject:currentUser.clientId forKey:@"clientId"];
            [[NSUserDefaults standardUserDefaults] setObject:currentUser.accountId forKey:@"accountId"];

            [[NSUserDefaults standardUserDefaults] setObject:currentUser.clientName forKey:@"clientName"];
             [[NSUserDefaults standardUserDefaults] setObject:currentUser.accountName forKey:@"accountName"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
          //  _txtGuestName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientName"];
            _txtGuestName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"accountName"];

            
            /*====== Checking method complition execution time taken======= */
            NSDate *methodFinish = [NSDate date];
            NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
            NSLog(@"Sucess executionTime = %f", executionTime);
            /*==================End Time checking ============= */
            
            //            if (currentUser.isAdmin) {
            //                [self performSegueWithIdentifier:@"loginToHome" sender:nil];
            //            }
            //            else {
            MyApplication *myApp;
            [myApp resetIdleTimer];

            
            if ([[response objectForKey:@"IsServiceProvider"] boolValue]) {
                   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                  [[WebSerivceCall webServiceObject]callServiceForHomeSetup:YES complition:nil];
                    
                       dispatch_async(dispatch_get_main_queue(), ^{
                      
                             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        
                                 [[WebSerivceCall webServiceObject]callServiceForDashboardCount:NO  complition:^(NSDictionary *aDict){
                           
                                  dispatch_async(dispatch_get_main_queue(), ^{

                                  NSMutableArray*moduleArr = [NSMutableArray new];
                                  for (NSDictionary * tempDic in gblAppDelegate.mutArrHomeMenus) {
                                      if (([tempDic[@"IsActive"] boolValue] && [tempDic[@"IsAccessAllowed"] boolValue])) {
                                          [moduleArr addObject:tempDic];
                                      }
                                  }
                                  NSLog(@"%@",moduleArr);
                                  
                                  MyWorkOrdersTypeViewController * workOrderView = [self.storyboard instantiateViewControllerWithIdentifier:@"MyWorkOrdersTypeViewController"];
                                  if (moduleArr.count == 0) {
                                      
                                      workOrderView.IsAccessAllowed = NO;
                                      
                                  }
                                  else{
                                      workOrderView.IsAccessAllowed = YES;
                                  }
                                  workOrderView.IsServoceProvider = YES;
                                  
                                  
                                  
                                  [self.navigationController pushViewController:workOrderView animated:YES];
                                  
                                      
                                       });
                                            }];
                                   });
          });
          
                   });
            }
            else{
                [self performSegueWithIdentifier:@"loginToWelcome" sender:nil];
            }
            
            
            
            //            }
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
  
        
             }
        else {
            alert(@"", @"Your account is not yet activated, please contact System Administrator");
             [self webserviceCallForUserLogOff];
        }
     }failure:^(NSError *error, NSDictionary *response) {
         NSLog(@"%@",response);
         NSLog(@"%@",error);

        NSDate *methodFinish = [NSDate date];
        NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
        NSLog(@"failure executionTime = %f", executionTime);
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
         if ([[response objectForKeyedSubscript:@"ErrorMessage"] isEqualToString:@""]) {
             alert(@"", @"Your account is not yet activated, please contact System Administrator");
         }else{
                  alert(@"", [response objectForKeyedSubscript:@"ErrorMessage"]);

         }

        _btnSignInTapped.userInteractionEnabled=YES;
         [self webserviceCallForUserLogOff];

    }];
   
}
-(void)webserviceCallForUserLogOff{
    

    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@?userId=%@",USER_LOGIN,[[User currentUser] userId]] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:USER_LOGIN] complition:^(NSDictionary *response) {
        
        NSLog(@"%@",response);
    }failure:^(NSError *error, NSDictionary *response) {
        
    }];
    
}
- (void)deleteAllDailyLogData {
    NSFetchRequest * allRecords = [[NSFetchRequest alloc] init];
    [allRecords setEntity:[NSEntityDescription entityForName:@"DailyLog" inManagedObjectContext:gblAppDelegate.managedObjectContext]];
    [allRecords setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSError * error = nil;
    NSArray * records = [gblAppDelegate.managedObjectContext executeFetchRequest:allRecords error:&error];
    //error handling goes here
    for (NSManagedObject * rec in records) {
        [gblAppDelegate.managedObjectContext deleteObject:rec];
    }
    NSError *saveError = nil;
    [gblAppDelegate.managedObjectContext save:&saveError];
}

- (IBAction)btnForgotPasswordTapped:(id)sender {
}

- (IBAction)btnSignUpTapped:(id)sender {
}
- (IBAction)btnTakeASurveyTapped:(id)sender {
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"isSurvey"];
    [[NSUserDefaults standardUserDefaults]setObject:@"no" forKey:@"isForm"];
    [[NSUserDefaults standardUserDefaults]setObject:@"no" forKey:@"isSuggestion"];

}

- (IBAction)btnMakeASuggestionTapped:(id)sender {
    [[NSUserDefaults standardUserDefaults]setObject:@"no" forKey:@"isSurvey"];
    [[NSUserDefaults standardUserDefaults]setObject:@"no" forKey:@"isForm"];
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"isSuggestion"];

    [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"fromSuveyViewC"];
    [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"fromInProgress"];
    [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"fromSugestionViewC"];
    
}

- (IBAction)btnCompleteAFormTapped:(id)sender {
    [[NSUserDefaults standardUserDefaults]setObject:@"no" forKey:@"isSurvey"];
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"isForm"];
    [[NSUserDefaults standardUserDefaults]setObject:@"no" forKey:@"isSuggestion"];

}

- (IBAction)unwindBackToLoginScreen:(UIStoryboardSegue*)segue {
    
}

#pragma mark - Methods

// Delete all records from all tables in database.
- (void)resetLocalDatabaseForNewUser {
    NSError * error;
    NSURL * storeURL = [[gblAppDelegate.managedObjectContext persistentStoreCoordinator] URLForPersistentStore:[[[gblAppDelegate.managedObjectContext persistentStoreCoordinator] persistentStores] lastObject]];
    [gblAppDelegate.managedObjectContext lock];
    [gblAppDelegate.managedObjectContext reset];//to drop pending changes
    //delete the store from the current managedObjectContext
    if ([[gblAppDelegate.managedObjectContext persistentStoreCoordinator] removePersistentStore: [[[gblAppDelegate.managedObjectContext persistentStoreCoordinator] persistentStores] lastObject] error:&error])
    {
        // remove the file containing the data
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
        //recreate the store like in the  appDelegate method
        [[[gblAppDelegate managedObjectContext] persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options: @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error];
    }    
    [gblAppDelegate.managedObjectContext unlock];
}

- (void)initialUIConfig {
    [_btnGuestSignIn setSelected:NO];
    [_imvGuestIndicator setHidden:YES];
    [_vwGuestSignIn setHidden:YES];
    [_btnUserSignIn setSelected:YES];
    [_imvUserIndicator setHidden:NO];
    [_vwUserSignIn setHidden:NO];
}

-(void)checkAppVersions
{
    
    [gblAppDelegate callWebService:[NSString stringWithFormat:@"%@",APPVERSION] parameters:nil httpMethod:[SERVICE_HTTP_METHOD objectForKey:APPVERSION] complition:^(NSDictionary *response)
    {
        
        NSArray *arryCurrentVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] componentsSeparatedByString:@"."];
        NSArray *arryNewVersion = [[response objectForKey:@"Version"] componentsSeparatedByString:@"."];
        
        NSMutableString *mutbStr = [[NSMutableString alloc]init];
        
        for (NSString *str in arryCurrentVersion){
            [mutbStr appendString:str];
        }
        
        NSInteger currentVersion = [mutbStr integerValue];
        
        mutbStr = [[NSMutableString alloc]init];
        
        for (NSString *str in arryNewVersion){
            [mutbStr appendString:str];
        }
        
        NSInteger newVersion = [mutbStr integerValue];
        
        
        if ( currentVersion < newVersion){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:MSG_NEWVERSION delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
            alert.delegate = self;
            [alert show];
        }
    
    } failure:^(NSError *error, NSDictionary *response) {
    }];
    
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:_txtGuestName]) {
        [textField resignFirstResponder];
    }
    else if ([textField isEqual:_txtUserId]) {
        [_txtPassword becomeFirstResponder];
    }
    else {
        [self btnSignInTapped:nil];
    }
    
    return YES;
}


- (void)defaultsSettingsChanged {
    BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:@"SettingsIsProduction"];
    if (value != gblAppDelegate.isProduction) {
        gblAppDelegate.isProduction = value;
        [self.navigationController popToViewController:self animated:YES];
    }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NSURL *aAppUrl = [NSURL URLWithString:ITUENS_APPLINK];
        
        if ([[UIApplication sharedApplication] canOpenURL:aAppUrl])
        {
            [[UIApplication sharedApplication] openURL:aAppUrl];
        }
    }
}

@end
