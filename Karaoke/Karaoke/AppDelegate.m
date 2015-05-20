//
//  AppDelegate.m
//  Karaoke
//
//  Created by Krishna_Mac_3 on 20/03/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import "AppDelegate.h"
#import "SplashViewController.h"
#import "FMDatabase.h"
#import "Reachability.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import "PayPalMobile.h"

//@implementation UIViewController (rotate)
//
//-(BOOL)shouldAutorotate {
//    return NO;
//}
////
////- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
////    return [self preferredInterfaceOrientationForPresentation];
////}
////
//@end

@implementation AppDelegate
@synthesize splashvc,navigator,session,facebookConnect,user_UDID_Str,registrationIDStr,tempString,message,result,certificate,deviceToken,payload,webView;

//- (id)init {
//    self = [super init];
//    if(self != nil) {
//        self.deviceToken = @"cbc22d0d bb92e756 6486c748 6cdc9e40 3f745807 4815ded8 14f9e5fa 899a2dad";
//        
//        self.payload = @"{\"aps\":{\"alert\":\"You got a new message!\",\"badge\":5,\"sound\":\"beep.wav\"},\"acme1\":\"bar\",\"acme2\":42}";
//        
//        self.certificate = [[NSBundle mainBundle]
//                            pathForResource:@"aps_development (4)-1" ofType:@"cer"];
//    }
//    return self;
//}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                    fallbackHandler:^(FBAppCall *call) {
                        // If there is an active session
                        if (FBSession.activeSession.isOpen) {
                            // Do nothing
                        } else if (call.accessTokenData) {
                            // If token data is passed in and there's
                            // no active session, open it from cache
                            [self handleAppLinkToken:call.accessTokenData];
                        }
                    }];
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"Aeb3lxANRph5fgtn5auHq3VjPVjFknJuMasZGKrwE8qCJvFIRaoaKRtiPAEE",
                                                           PayPalEnvironmentSandbox : @"Afbn1hBIq7how5F79CzIS4qglRt0Gd-2mGm7_lgwznkdXujup_q4OoFhEhaQ"}];
    
//    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"AZGYchD7i6ek930B6AhczFR01EFwXVLjGjdpPE5_rmMZvwqnlEi7so5pgGiW",
//                                                           PayPalEnvironmentSandbox : @"Afbn1hBIq7how5F79CzIS4qglRt0Gd-2mGm7_lgwznkdXujup_q4OoFhEhaQ"}];
    
    if (launchOptions != nil)
    {
        //opened from a push notification when the app is closed
        NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo != nil)
        {
            NSString *channelID = [[userInfo objectForKey:@"aps"] objectForKey:@"channelID"];
            NSLog(@"channelID->%@",channelID);
        }
    }
    else{
        //opened app without a push notification.
    }
//    UIDevice* device = [UIDevice currentDevice];
//    NSUUID *myDevice = [NSUUID UUID];
//    NSString *deviceUDID = myDevice.UUIDString;
//    NSLog(@"Device ID.. %@",deviceUDID);
//    NSString *uid;

    NSUUID *myDevice1 = [[UIDevice currentDevice] identifierForVendor];
    NSLog(@"udid is %@",myDevice1.UUIDString);
    NSString *deviceUDID=myDevice1.UUIDString;
    NSLog(@"Device udid is %@",deviceUDID);
    user_UDID_Str=[NSString stringWithString:deviceUDID];
 //  user_UDID_Str=@"123";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:user_UDID_Str forKey:@"user_UDID_Str"];
   
    [self createCopyOfDatabaseIfNeeded];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        splashvc = [[SplashViewController alloc] initWithNibName:@"SplashViewController" bundle:Nil];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        splashvc = [[SplashViewController alloc] initWithNibName:@"SplashViewController_iphone4" bundle:Nil];
        // this is iphone 4 xib
    }
    else{
        splashvc = [[SplashViewController alloc] initWithNibName:@"SplashViewController_ipad" bundle:Nil];
    }

    navigator = [[CustomNavigationController alloc] initWithRootViewController:splashvc];
    self.window.rootViewController = navigator;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"YES"
                                                            forKey:@"enableRotation"];
    [defaults registerDefaults:appDefaults];
    [defaults synchronize];
    self.appUsageCheckEnabled = NO;
    if ([defaults objectForKey:@"AppUsageCheck"]) {
        self.appUsageCheckEnabled = [defaults boolForKey:@"AppUsageCheck"];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [application registerForRemoteNotifications];
    }
    else
    {
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if (facebookConnect) {
        NSLog(@"Facebook");
    }
    else {
        exit(0);
        
    }
//If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActive];
   
    if (self.appUsageCheckEnabled && [self checkAppUsageTrigger]) {
        [NSTimer scheduledTimerWithTimeInterval:0.2
                                         target:self
                                       selector:@selector(showInvite)
                                       userInfo:nil
                                        repeats:NO];
    }
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];
}
- (BOOL)handleAppLinkToken:(FBAccessTokenData *)appLinkToken {
    FBSession *appLinkSession = [[FBSession alloc] initWithAppID:nil
                                                     permissions:nil
                                                 defaultAudience:FBSessionDefaultAudienceNone
                                                 urlSchemeSuffix:nil
                                              tokenCacheStrategy:[FBSessionTokenCachingStrategy nullCacheInstance] ];
    [FBSession setActiveSession:appLinkSession];
    return [appLinkSession openFromAccessTokenData:appLinkToken
                                 completionHandler:^(FBSession *session,
                                                     FBSessionState status,
                                                     NSError *error) {
                                     // Log any errors
                                     if (error) {
                                         NSLog(@"Error using cached token to open a session: %@",
                                               error.localizedDescription);
                                     }
                                 }];
}

/*
 * Send a user to user request
 */
- (void)sendRequest {
    
}

/*
 * Send request to iOS device users.
 */
- (void)sendRequestToiOSFriends {
    
}


- (BOOL) checkAppUsageTrigger {
    // Initialize the app active count
    NSInteger appActiveCount = 0;
    // Read the stored value of the counter, if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"AppUsedCounter"]) {
        appActiveCount = [defaults integerForKey:@"AppUsedCounter"];
    }
    
    // Increment the counter
    appActiveCount++;
    BOOL trigger = NO;
    if (FBSession.activeSession.isOpen && (appActiveCount >= 3)) {
        trigger = YES;
        appActiveCount = 0;
    }
    // Save the updated counter
    [defaults setInteger:appActiveCount forKey:@"AppUsedCounter"];
    [defaults synchronize];
    return trigger;
}

/*
 * Helper method to show the invite alert
 */
- (void)showInvite
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Invite Friends"
                          message:@"If you enjoy using this app, would you mind take a moment to invite a few friends that you think will also like it?"
                          delegate:self
                          cancelButtonTitle:@"No Thanks"
                          otherButtonTitles:@"Tell Friends!", @"Remind Me Later", nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate methods
/*
 * When the alert is dismissed check which button was clicked so
 * you can take appropriate action, such as displaying the request
 * dialog, or setting a flag not to prompt the user again.
 */

- (void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // User has clicked on the No Thanks button, do not ask again
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:@"AppUsageCheck"];
        [defaults synchronize];
        self.appUsageCheckEnabled = NO;
    } else if (buttonIndex == 1) {
        // User has clicked on the Tell Friends button
        [self performSelector:@selector(sendRequest)
                   withObject:nil afterDelay:0.5];
    }
}

- (void)createCopyOfDatabaseIfNeeded {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:@"ZoomKaraoke_db.sqlite"];
    NSLog(@"db path %@", dbPath);

    NSLog(@"File exist is %hhd", [fileManager fileExistsAtPath:dbPath]);
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    if (!success) {
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ZoomKaraoke_db.sqlite"];
        NSLog(@"default DB path %@", defaultDBPath);
        
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        if (!success) {
            NSLog(@"Failed to create writable DB. Error '%@'.", [error localizedDescription]);
        } else {
            NSLog(@"DB copied.");
        }
    }else {
        NSLog(@"DB exists, no need to copy.");
    }
    
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}



- (void)facebookIntegration:(NSString*)songNameString1: (NSString *) imageString
{
    
    activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        view=[[UIView alloc]initWithFrame:CGRectMake(0,0, 320, 568)];
        activityIndicatorObject.center = CGPointMake(160, 130);
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        view=[[UIView alloc]initWithFrame:CGRectMake(0,0, 320, 480)];
        activityIndicatorObject.center = CGPointMake(160, 130);
    }
    else{
         view=[[UIView alloc]initWithFrame:CGRectMake(0,0, 768, 1024)];
        activityIndicatorObject.center = CGPointMake(384, 312);
    }
 
    view.backgroundColor=[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.6];
    [self.window addSubview:view];
    [view addSubview:activityIndicatorObject];
    [activityIndicatorObject startAnimating];
    NSString *urlLink=[NSString stringWithFormat:@"http://itunes.apple.com/app/id907440050"];
    NSString *name=[NSString stringWithFormat:@"Zoom Karaoke"];
    NSString *discription = [NSString stringWithFormat:@"I am listening %@",songNameString1];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   name, @"name",
                                   urlLink, @"link",
                                   discription, @"caption",
                                   discription, @"description",
                                   imageString, @"picture",
                                   nil];
    [session closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession.activeSession  closeAndClearTokenInformation];
    FBSession.activeSession=nil;
    session = [[FBSession alloc] init];
    
    [self performPublishAction:^{
        FBRequestConnection *connection = [[FBRequestConnection alloc] init];
        connection.errorBehavior = FBRequestConnectionErrorBehaviorReconnectSession
        | FBRequestConnectionErrorBehaviorAlertUser
        | FBRequestConnectionErrorBehaviorRetry;
        
        FBRequest *request=[FBRequest requestWithGraphPath:@"/me/feed" parameters:params HTTPMethod:@"POST"];
        [connection addRequest:request completionHandler:^(FBRequestConnection *connection, id result, NSError *error0)
         {
             [view removeFromSuperview];
             [activityIndicatorObject stopAnimating];
             [self showAlert:@"Photo Post" result:result error:error0];
         }];
        [connection start];
    }];
}

#pragma mark -

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action
{
    if (!session.isOpen)
    {
        FBSession.activeSession = session;
        [session openWithCompletionHandler:^(FBSession *session,
                                             FBSessionState status,
                                             NSError *error)
         {
             if (status==FBSessionStateClosedLoginFailed)
             {
                 [view removeFromSuperview];
                 [activityIndicatorObject stopAnimating];
             }
             
             if(session.isOpen)
             {
                 NSLog(@"%@",session);
                 NSLog(@"%lu",(unsigned long)[FBSession.activeSession.permissions indexOfObject:@"publish_actions"]);
                 if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
                   
                     [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error)
                      {
                          if (!error)
                          {
                              action();
                          }
                          else if (error.fberrorCategory != FBErrorCategoryUserCancelled)
                          {
                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Permission denied" message:@"Unable to get permission to post" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
                              [alertView show];
                          }
                      }];
                 }
                 else
                 {
                     action();
                 }
             }
         }];
    }
    else
    {
        NSLog(@"calling postdata when session is  open******");
        NSLog(@"%@",session);
        
        if(session.isOpen)
        {
            NSLog(@"%@",session);
            NSLog(@"%lu",(unsigned long)[FBSession.activeSession.permissions indexOfObject:@"publish_actions"]);
            if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
                [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error)
                 {
                     if (!error)
                     {
                         action();
                     }
                     else if (error.fberrorCategory != FBErrorCategoryUserCancelled)
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Permission denied" message:@"Unable to get permission to post" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
                         [alertView show];
                     }
                 }];
            }
            else
            {
                action();
            }
        }
    }
}

- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error
{
    NSString *alertMsg;
    NSString *alertTitle;
    facebookConnect=NO;
    if (error)
    {
        alertTitle = @"Error";
        if (error.fberrorUserMessage && FBSession.activeSession.isOpen)
        {
            alertTitle = nil;
        }
        else
        {
            alertMsg = @"Operation failed due to a connection problem, retry later.";
        }
    }
    else
    {
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.", message];
        NSString *postId = [resultDict valueForKey:@"id"];
        if (!postId)
        {
            postId = [resultDict valueForKey:@"postId"];
        }
        if (postId)
        {
            alertMsg = @"Shared on facebook successfully";
        }
        alertTitle = @"Congratulations!!!";
    }
    
    if (alertTitle)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                            message:alertMsg
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;;
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken1
{
	NSLog(@"My token is: %@", deviceToken1);

    NSString *str=[NSString stringWithFormat:@"%@",deviceToken1];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Token without space %@",str);
    str = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSLog(@"Token without <> %@",str);
    registrationIDStr=str;
     [self serviceUdid];
 
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
 
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)serviceUdid{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/RegisterDeviceId",Kwebservices]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    NSString *registrationID;
    NSString *user_UDID;
    
    
    if(user_UDID==nil)
        user_UDID = [NSString stringWithFormat:@"%@",user_UDID_Str];
    [request setPostValue:user_UDID forKey:@"userID"];
    
    registrationID = [NSString stringWithFormat:@"%@",registrationIDStr];
    [request setPostValue:registrationID forKey:@"registrationID"];
    [request setPostValue:@"ios" forKey:@"userType"];
    
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request startAsynchronous];
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    
    NSLog(@"res error :%@",error.description);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSLog(@"response%@", responseString);
    NSData *responseData = [request responseData];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData: responseData];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
}

- (void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI
 qualifiedName:(NSString *) qName attributes:(NSDictionary *) attributeDict

{
    
    if ([elementName isEqualToString:@"Result"]){
        tempString = [[NSMutableString alloc] init];
    }  else if ([elementName isEqualToString:@"Success"]){
        tempString = [[NSMutableString alloc] init];
    }
    
}

//---when the text in an element is found---
- (void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
    [tempString appendString:string];
}

//---when the end of element is found---
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if([elementName isEqualToString:@"Result"]){
        result = [NSString stringWithFormat:@"%@", tempString];
    } else if ([elementName isEqualToString:@"Success"]){
        message = [NSString stringWithFormat:@"%@", tempString];
        
    }
    
}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    if (application.applicationState == UIApplicationStateInactive)
//    {
//        //opened from a push notification when the app was on background
//        
//        NSString *channelID = [[userInfo objectForKey:@"aps"] objectForKey:@"channelID"];
//        NSLog(@"channelID->%@",channelID);
//    }
//    else if(application.applicationState == UIApplicationStateActive)
//    {
//        // a push notification when the app is running. So that you can display an alert and push in any view
//        
//        NSString *channelID = [[userInfo objectForKey:@"aps"] objectForKey:@"channelID"];
//        NSLog(@"channelID->%@",channelID);
//    }
//
//
//}
@end
