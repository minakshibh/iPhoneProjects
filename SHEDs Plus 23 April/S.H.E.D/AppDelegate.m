//
//  AppDelegate.m
//  S.H.E.D
//
//  Created by Krishna_Mac on 11/20/13.
//  Copyright (c) 2013 Krishna_Mac. All rights reserved.
//

#import "AppDelegate.h"
#import "FMDatabase.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import "SHED_listViewController.h"
#import "enterPasscodeViewController.h"

@implementation AppDelegate


{
    SHED_listViewController *shedVc;
}
@synthesize splash,navigator,session,todaysDate,flag,facebookConnect,gratArchievArray,database;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                    fallbackHandler:^(FBAppCall *call) {
                        NSLog(@"In fallback handler");
                    }];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //NSLog (@"Font families: %@", [UIFont familyNames]);
  //  [[NSUserDefaults standardUserDefaults ] setValue:@"" forKey:@"Review" ];

    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"Review"]==nil )
    {
        [[NSUserDefaults standardUserDefaults ] setValue:@"" forKey:@"Review" ];
    }
   
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }

    
    
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
  
    if (locationNotification) {
        application.applicationIconBadgeNumber = 0;
         [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    }
    
    NSArray* scheduledNotifications = [NSArray arrayWithArray:application.scheduledLocalNotifications];
    application.scheduledLocalNotifications = scheduledNotifications;
    
  
    NSUserDefaults * value = [NSUserDefaults standardUserDefaults];
    NSString *isFirstRun = [value objectForKey:@"isFirstRun"];
    
    if(isFirstRun == nil)
    {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
       [value setObject:@"NO" forKey:@"isFirstRun"];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setValue:[NSString stringWithFormat:@"1"] forKey:@"PopUp"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    session=[[FBSession alloc] init];

    [self createCopyOfDatabaseIfNeeded];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSDate *date1 = [NSDate date];
    NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init] ;
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    todaysDate = [formatter1 stringFromDate:date1];
    
  
    NSDate* fiveDaysAgo = [date1 dateByAddingTimeInterval:+7*24*60*60];
    NSString *fiveDaysStr=[formatter1 stringFromDate:fiveDaysAgo];
    NSLog(@"%@",fiveDaysStr);
    
    [self scheduleNotificationForDate:fiveDaysStr :@"Is everything OK?" ];
    
    autoArchieve=[value valueForKey:@"autoArchieve"];
    keepHistry=[value valueForKey:@"keepArchieveHisty"];

    if (autoArchieve==nil)
    {
        [value setObject:@"Off" forKey:@"autoArchieve"];
    }
    if (keepHistry==nil) {
        [value setObject:@"No History" forKey:@"keepArchieveHisty"];
    }
    
    NSLog(@"%@",[value valueForKey:@"toggleSwitch"]);
    NSString *str=[value valueForKey:@"toggleSwitch"];
    NSLog(@"%@",str);
    if ([[value valueForKey:@"toggleSwitch"] isEqualToString:@"test"] && !([value valueForKey:@"passcode"] == NULL))
    {
        enterPasscodeViewController *passcode;
        if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
            passcode = [[enterPasscodeViewController alloc] initWithNibName:@"enterPasscodeViewController" bundle:Nil];
            //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480) {
            passcode = [[enterPasscodeViewController alloc] initWithNibName:@"enterPasscodeViewController_iphone4" bundle:Nil];
            // this is iphone 4 xib
        }
        else
        {
            passcode = [[enterPasscodeViewController alloc] initWithNibName:@"enterPasscodeViewController_ipad" bundle:Nil];
        }
        navigator = [[UINavigationController alloc] initWithRootViewController:passcode];
    }
    else{
        if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
            splash = [[splashscreenViewController alloc] initWithNibName:@"splashscreenViewController" bundle:Nil];
            //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480) {
            splash = [[splashscreenViewController alloc] initWithNibName:@"splashscreenViewController_iphone4" bundle:Nil];
            // this is iphone 4 xib
        }
        else
        {
            splash = [[splashscreenViewController alloc] initWithNibName:@"splashscreenViewController_ipad" bundle:Nil];
        }
        navigator = [[UINavigationController alloc] initWithRootViewController:splash];
    }
    
    
     shedVc=[[SHED_listViewController alloc]initWithNibName:@"SHED_listViewController" bundle:nil];
    
        self.window.rootViewController = navigator;
    
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    if (facebookConnect) {
        NSLog(@"Facebook");
    }
    else {
        exit(0);

    }
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActive];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];

    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - Defined Functions

- (void)createCopyOfDatabaseIfNeeded {
    
    NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"shed_db" ofType:@"sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [paths objectAtIndex:0];
    dbPath = [documentsDir stringByAppendingPathComponent:@"shed_db.sqlite"];
    NSLog(@"db path %@", dbPath);
    NSLog(@"File exist is %hhd", [fileManager fileExistsAtPath:dbPath]);
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    if (!success)
    {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"shed_db.sqlite"];
        NSLog(@"default DB path %@", defaultDBPath);
        
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        if (!success)
        {
            NSLog(@"Failed to create writable DB. Error '%@'.", [error localizedDescription]);
        }
        else
        {
            NSLog(@"DB copied.");
        }
    }
    else
    {
        NSLog(@"DB exists, no need to copy.");
    }
}

-(void)facebookIntegration:(NSString*)messageStr

{
    activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        view=[[UIView alloc]initWithFrame:CGRectMake(0,0, 320, 568)];
         activityIndicatorObject.center = CGPointMake(160, 130);
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        view=[[UIView alloc]initWithFrame:CGRectMake(0,0, 320, 480)];
        activityIndicatorObject.center = CGPointMake(160, 150);

        // this is iphone 4 xib
    }
    else
    {
        view=[[UIView alloc]initWithFrame:CGRectMake(0,0, 768, 1024)];
        activityIndicatorObject.center = CGPointMake(384, 312);

    }

    view.backgroundColor=[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.6];
    [self.window addSubview:view];
    [view addSubview:activityIndicatorObject];
    [activityIndicatorObject startAnimating];

    NSString *urlLink=[NSString stringWithFormat:@"http://itunes.apple.com/app/id838069848"];
    NSString *name=[NSString stringWithFormat:@"SHEDs Plus"];
    NSString *discription = [NSString stringWithFormat:@"I have been using this great App, SHEDs - Simple Habits Every Day, to get my life on track and firing. You must try it. It's awesome"];
  
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            name,@"name",
                            discription, @"message",urlLink, @"link", @"", @"caption",discription, @"description"
                            ,nil ];
    
    NSDictionary *params1 = [NSDictionary dictionaryWithObjectsAndKeys:
                            name,@"name",
                            messageStr, @"message"
                            ,nil ];

    
//       NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                    name, @"name",urlLink, @"link", @"", @"caption", discription, @"description",nil];
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
             
             // [self showAlert:@"Photo Post" result:result error:error0];
             
         }];
        [connection start];

      
        /* make the API call */
        
        [FBRequestConnection startWithGraphPath:@"/1469787619936379/feed"
                                     parameters:params1
                                     HTTPMethod:@"POST"
                              completionHandler:^(
                                                  FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error
                                                  ) {
                                  
                                  [view removeFromSuperview];
                                  [activityIndicatorObject stopAnimating];
                               
                                  //[shedVc enabled];
                                  
                                  NSLog(@"%@ result is",[result objectForKey:@"id"]);
                                  [self showAlert:@"Photo Post" result:result error:error];
                                  
                                  NSString *idstr=[result objectForKey:@"id"];
                                  
                                  
                                  NSArray*tempidArray = [idstr componentsSeparatedByString:@"_"];
                                  idstr=[tempidArray objectAtIndex:1];
                                  NSString *graphPath=[NSString stringWithFormat:@"/%@/likes",idstr];
                                  [FBRequestConnection startWithGraphPath:graphPath
                                                               parameters:nil
                                                               HTTPMethod:@"POST"
                                                        completionHandler:^(
                                                                            FBRequestConnection *connection,
                                                                            id result,
                                                                            NSError *error
                                                                            ) {
                                                        }];
                                 
                              }];
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
                     // if we don't already have the permission, then we request it now
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
    //[shedVc enabled];
//    [shedVc.activityIndicatorObject stopAnimating];
//    shedVc.view.userInteractionEnabled=YES;
    
    
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

-(void) scheduleNotificationForDate: (NSString*)dateStr: (NSString*)desc
{
    for(UILocalNotification *notify in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        if ([notify.alertBody isEqualToString:desc])
        {
            NSLog(@"the notification this is canceld is %@", notify.alertBody);
            [[UIApplication sharedApplication] cancelLocalNotification:notify] ;
        }
    }
    NSUserDefaults *popUpdefaults =[NSUserDefaults standardUserDefaults];
    int popUpValue= [[popUpdefaults valueForKey:@"PopUp"]intValue];
    if (popUpValue==1)
    {
        NSArray *tempStr = [dateStr componentsSeparatedByString:@"-"];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:[[tempStr objectAtIndex:0] intValue]];
        [comps setMonth:[[tempStr objectAtIndex:1] intValue]];
        [comps setDay:[[tempStr objectAtIndex:2] intValue]];
        [comps setHour:0];
        [comps setMinute:0];
        [comps setTimeZone:[NSTimeZone systemTimeZone]];
        NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *setTime = [cal dateFromComponents:comps];
        
        NSLog(@"notify tym..%@",setTime);
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        if (localNotif == nil)
            return;
        
        localNotif.fireDate = setTime;
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        localNotif.alertBody = desc;
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        localNotif.applicationIconBadgeNumber = 0;
        
        //    [[NSNotificationCenter defaultCenter] addObserver:self
        //                                                  selector:@selector(reloadTable)
        //                                                      name:@"reloadData"
        //                                                    object:nil];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        NSLog(@"notification started");
    }
}

//-(void)reloadTable{
//    
//}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
//    UIApplicationState state = [application applicationState];
//    if (state == UIApplicationStateActive) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
//                                                        message:notification.alertBody
//                                                       delegate:self cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    application.applicationIconBadgeNumber = 0;
  
}


@end
