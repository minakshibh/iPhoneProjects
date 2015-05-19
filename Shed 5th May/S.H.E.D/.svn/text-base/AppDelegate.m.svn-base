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

@implementation AppDelegate
@synthesize splash,navigator,session,todaysDate,flag,facebookConnect;

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
    NSUserDefaults * value = [NSUserDefaults standardUserDefaults];
    //   [value setObject:valueToSave forKey:@"preferedDate"];
    NSString *isFirstRun = [value objectForKey:@"isFirstRun"];
    if(isFirstRun == nil){
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        // update your flag so that it fails this check on any subsequent launches
       [value setObject:@"NO" forKey:@"isFirstRun"];
    }
   session=[[FBSession alloc] init];

        [self createCopyOfDatabaseIfNeeded];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSDate *date1 = [NSDate date];
    NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init] ;
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    
    todaysDate = [formatter1 stringFromDate:date1];
    
    
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

// Function to Create a writable copy of the bundled default database in the application Documents directory.
- (void)createCopyOfDatabaseIfNeeded {
    // First, test for existence.
   // NSString *path = [[NSBundle mainBundle] pathForResource:@"shed_db" ofType:@"sqlite"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:@"shed_db.sqlite"];
    NSLog(@"db path %@", dbPath);
    NSLog(@"File exist is %hhd", [fileManager fileExistsAtPath:dbPath]);
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    if (!success) {
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"shed_db.sqlite"];
        NSLog(@"default DB path %@", defaultDBPath);
        //NSLog(@"File exist is %hhd", [fileManager fileExistsAtPath:defaultDBPath]);
        
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

-(void)facebookIntegration
{
    NSString *urlLink=[NSString stringWithFormat:@"http://itunes.apple.com/app/id838069848"];
    NSString *name=[NSString stringWithFormat:@"SHEDs"];
    NSString *discription = [NSString stringWithFormat:@"I have been using this great App, SHEDs - Simple Habits Every Day, to get my life on track and firing. You must try it. It's awesome"];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   name, @"name",
                                   urlLink, @"link",
                                   @"", @"caption",
                                   discription, @"description",
                                   
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


@end
