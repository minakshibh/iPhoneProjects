//
//  AppDelegate.m
//  RapidRide
//
//  Created by Br@R on 08/10/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "SplashViewController.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "RideFinishViewController.h"
#import "DriverRequestAndQueueViewController.h"
#import "DriverRideMapViewController.h"
#import "LocateDriverOnMapViewController.h"
#import "MapViewController.h"
#import "DriverFirstViewViewController.h"

@implementation AppDelegate
@synthesize navigator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    driverIdStr=[[NSUserDefaults standardUserDefaults ]valueForKey:@"driverid"];
    RiderIdStr=[[NSUserDefaults standardUserDefaults ]valueForKey:@"riderId"];
    acceptReq=NO;
    if (launchOptions != nil)
    {
        //opened from a push notification when the app is closed
        NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        NSString *channelID;
        if (userInfo != nil)
        {
            channelID = [[userInfo objectForKey:@"aps"] objectForKey:@"channelID"];
            NSLog(@"channelID->%@",channelID);
            
            NSString *messageStr = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
            if ([messageStr rangeOfString:@"accepted"].location == NSNotFound)
            {
                if ([messageStr rangeOfString:@"Please rate"].location == NSNotFound)
                {
                    if ([messageStr rangeOfString:@"Handicap:"].location == NSNotFound)
                    {
                        if ([messageStr rangeOfString:@"has arrived"].location == NSNotFound)
                        {
                            if ([messageStr rangeOfString:@"has started"].location==NSNotFound)
                            {
                                if ([messageStr rangeOfString:@"has cancelled"].location==NSNotFound)
                                {
                                    if ([messageStr rangeOfString:@"Turn on"].location==NSNotFound)
                                    {
                                        // active ride
                                        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue" ] isEqualToString:@"RiderSide"] )
                                        {
                                            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                            alert.tag=8;
                                            
                                            NSArray *arr=[messageStr componentsSeparatedByString:@"TripId:"];
                                            reqId=[arr objectAtIndex:1];
                                            [alert show];
                                        }
                                    }
                                    else{
                                        if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue" ] isEqualToString:@"RiderSide"] )
                                        {
                                            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                            alert.tag=6;
                                            
                                            NSArray *arr=[messageStr componentsSeparatedByString:@":"];
                                            colour=[arr objectAtIndex:1];
                                            [alert show];
                                        }
                                    }
                                }
                                
                                else
                                {
                                    //Cancel Ride
                                    
                                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                    [alert show];
                                }
                            }
                            else
                            {
                                // start ride
                                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue" ] isEqualToString:@"RiderSide"] )
                                {
                                    
                                    NSArray *arr=[messageStr componentsSeparatedByString:@"TripId:"];
                                    reqId=[arr objectAtIndex:1];
                                    
                                    DriverRideMapViewController*driverRideMapVc;
                                    if ([[UIScreen mainScreen] bounds].size.height == 568)
                                    {
                                        driverRideMapVc = [[DriverRideMapViewController alloc] initWithNibName:@"DriverRideMapViewController" bundle:nil];
                                        
                                        //this is iphone 5 xib
                                    }
                                    else if([[UIScreen mainScreen] bounds].size.height == 480)
                                    {
                                        driverRideMapVc = [[DriverRideMapViewController alloc] initWithNibName:@"DriverRideMapViewController_iphone4" bundle:nil];
                                        
                                        // this is iphone 4 xib
                                    }
                           
                                    driverRideMapVc.FromNotification=YES;
                                    driverRideMapVc.GetTripId=reqId;
                                    [navigator pushViewController:driverRideMapVc animated:YES];
                                    
                                    // [alert show];
                                }
                            }
                        }
                        else
                        {
                            // arrived
                            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue" ] isEqualToString:@"RiderSide"] )
                            {
                                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                [alert show];
                            }
                        }
                    }
                    else
                    {
                        if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue" ] isEqualToString:@"RiderSide"] )
                        {
                            NSURL *url=[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"Formula 1 Car Sound"] ofType:@"mp3"]];
                            masterAudioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
                            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
                            [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
                            
                            masterAudioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
                            [masterAudioPlayer play];
                            
                            timer= [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(test:) userInfo:nil repeats:NO];
                            
                            NSRange r1 = [messageStr rangeOfString:@"("];
                            NSRange r2 = [messageStr rangeOfString:@")"];
                            NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
                            NSString *subString = [messageStr substringWithRange:rSub];
                            NSLog(@"subString = %@",subString);
                            reqType=[NSString stringWithFormat:@"%@",subString];
                            messageStr = [messageStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"(%@)",subString]withString:@""];
                            
                            if ([reqType isEqualToString:@"VIP"])
                            {
                                NSArray *arr=[messageStr componentsSeparatedByString:@";"];
                                reqId=[arr objectAtIndex:1];
                                
                                NSArray *arr5=[reqId componentsSeparatedByString:@":"];
                                reqId=[arr5 objectAtIndex:1];
                                
                                
                                destinationLoc=[arr objectAtIndex:0];
                                
                                NSArray *arr2=[destinationLoc componentsSeparatedByString:@"and offering price "];
                                destinationLoc=[arr2 objectAtIndex:0];
                                priceStr=[arr2 objectAtIndex:1];
                                ratingStr=[[[arr objectAtIndex:2]componentsSeparatedByString:@":"]objectAtIndex:1];
                                handicapedStr=[[[arr objectAtIndex:3]componentsSeparatedByString:@":"]objectAtIndex:1];
                                picUrl=[[[arr objectAtIndex:6]componentsSeparatedByString:@"Image:"]objectAtIndex:1];
                                pickupTime=[[[arr objectAtIndex:4]componentsSeparatedByString:@":"]objectAtIndex:1];;
                                vehicleStr=[[[arr objectAtIndex:5]componentsSeparatedByString:@":"]objectAtIndex:1];
                                getRiderNameStr=[[riderNameStr componentsSeparatedByString:@"is requesting"]objectAtIndex:0];
                            }
                            else
                            {
                                NSArray *arr=[messageStr componentsSeparatedByString:@";"];
                                NSLog(@"%@",arr);
                                NSString *str1=[arr objectAtIndex:0];
                                distanceStr=[arr objectAtIndex:1];
                                timeStr=[[[arr objectAtIndex:2]componentsSeparatedByString:@":"]objectAtIndex:1];
                                reqId=[arr objectAtIndex:3];
                                
                                
                                ratingStr=[[[arr objectAtIndex:4]componentsSeparatedByString:@":"]objectAtIndex:1];
                                handicapedStr=[[[arr objectAtIndex:5]componentsSeparatedByString:@":"]objectAtIndex:1];
                                picUrl=[[[arr objectAtIndex:8]componentsSeparatedByString:@"Image:"]objectAtIndex:1];
                                pickupTime=[[[arr objectAtIndex:6]componentsSeparatedByString:@":"]objectAtIndex:1];
                                NSArray *arr1=[str1 componentsSeparatedByString:@"Current Location:"];
                                currentLocStr=[arr1 objectAtIndex:1];
                                NSString *tempStr=[arr1 objectAtIndex:0];
                                NSArray *arr2=[tempStr componentsSeparatedByString:@"and offering price "];
                                priceStr=[arr2 objectAtIndex:1];
                                vehicleStr=[[[arr objectAtIndex:7]componentsSeparatedByString:@":"]objectAtIndex:1];
                                
                                riderNameStr=[NSString stringWithFormat:@"%@ a ride",[[tempStr componentsSeparatedByString:@"ride to "]objectAtIndex:0]];
                                tempStr=[arr2 objectAtIndex:0];
                                destinationLoc=[[tempStr componentsSeparatedByString:@"ride to "]objectAtIndex:1];
                                NSArray *arr5=[reqId componentsSeparatedByString:@":"];
                                reqId=[arr5 objectAtIndex:1];
                                NSLog(@"TRipid %@",reqId );
                                getRiderNameStr=[[riderNameStr componentsSeparatedByString:@"is requesting"]objectAtIndex:0];
                                
                            }
                            [self launchDialog:messageStr];
                        }
                    }
                }
                
                else
                {
                    //rating to driver
                    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue" ] isEqualToString:@"RiderSide"] )
                    {
                        NSURL *url=[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"cars023"] ofType:@"mp3"]];
                        masterAudioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
                        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
                        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
                        
                        masterAudioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
                        [masterAudioPlayer play];
                        
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                        alert.tag=9;
                    }
                }
            }
            else
            {
                // when driver acepts the ride request.
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue"]isEqualToString:@"RiderSide"])
                {
                    animatedView=[[UIView alloc] initWithFrame:CGRectMake(0, 490, 320, 80)];
                    animatedView.backgroundColor=[UIColor whiteColor];
                    [self.window addSubview:animatedView];
                    
                    DriverNameLbl=[[UILabel alloc] initWithFrame:CGRectMake(60, 12, 250, 25)];
                    [animatedView addSubview:DriverNameLbl];
                    
                    MessageLbl=[[UILabel alloc] initWithFrame:CGRectMake(60, 25, 250, 40)];
                    [MessageLbl setFont:[UIFont systemFontOfSize:11]];
                    MessageLbl.numberOfLines=3;
                    [animatedView addSubview:MessageLbl];
                    
                    NSArray *arr=[messageStr componentsSeparatedByString:@"@"];
                    
                    NSLog(@"%@",arr);
                    NSString *username=[arr objectAtIndex:0];
                    NSString *Message=[arr objectAtIndex:1];
                    NSString *ImageUrl=[arr objectAtIndex:2];
                    
                    
                    DriverNameLbl.text=username;
                    MessageLbl.text=Message;
                    
                    DriverImgView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 65)];
                    DriverImgView.backgroundColor=[UIColor grayColor];
                    [animatedView addSubview:DriverImgView];
                    
                    UIImage* myImage = [UIImage imageWithData:
                                        [NSData dataWithContentsOfURL:
                                         [NSURL URLWithString:ImageUrl]]];
                    [DriverImgView setImage:myImage];
                    
                    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(DisableView) userInfo:nil repeats:NO];
                }
            }

        }
    }

    NSUUID *myDevice1 = [[UIDevice currentDevice] identifierForVendor];
    NSLog(@"udid is %@",myDevice1.UUIDString);
    NSString *deviceUDID=myDevice1.UUIDString;
    NSLog(@"Device udid is %@",deviceUDID);
    user_UDID_Str=deviceUDID;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:user_UDID_Str forKey:@"user_UDID_Str"];
    
    CLLocationManager *locationManager = [[CLLocationManager alloc]init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [locationManager requestWhenInUseAuthorization];
        //[locationManager requestAlwaysAuthorization];
    }
     // [GMSServices provideAPIKey:@"AIzaSyARfvZ_reZBbuEILzSR9nSO6b0LdYUB0NE"];
   [GMSServices provideAPIKey:@"AIzaSyAyncD545s2oy_EYfjlB4Re_5_YI69C0Bg"];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
    SplashViewController *splashVc;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        splashVc=[[SplashViewController alloc]initWithNibName:@"SplashViewController" bundle:nil];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480)
    {
        splashVc=[[SplashViewController alloc]initWithNibName:@"SplashViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }
    else
    {
        splashVc=[[SplashViewController alloc]initWithNibName:@"SplashViewController" bundle:nil];
    }
    
    navigator = [[UINavigationController alloc] initWithRootViewController:splashVc];
    self.window.rootViewController = navigator;
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//         (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
       [UIApplication sharedApplication].applicationIconBadgeNumber=0;
   
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
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:registrationIDStr forKey:@"registrationID"];

}
-(void)DisableView
{
    [animatedView removeFromSuperview];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    
    NSLog(@"User info.. %@",userInfo);
    //  UIApplicationState state = [application applicationState];
    NSString *messageStr = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    if ([messageStr rangeOfString:@"accepted"].location == NSNotFound)
    {
        if ([messageStr rangeOfString:@"Please rate"].location == NSNotFound)
        {
            if ([messageStr rangeOfString:@"Handicap:"].location == NSNotFound)
            {
                if ([messageStr rangeOfString:@"has arrived"].location == NSNotFound)
                {
                    if ([messageStr rangeOfString:@"has started"].location==NSNotFound)
                    {
                        if ([messageStr rangeOfString:@"has cancelled"].location==NSNotFound)
                        {
                            if ([messageStr rangeOfString:@"Turn on"].location==NSNotFound)
                            {
                                // active ride
                                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue" ] isEqualToString:@"RiderSide"] )
                                {
                                    NSArray *arr=[messageStr componentsSeparatedByString:@";TripId:"];
                                    reqId=[arr objectAtIndex:1];
                                    messageStr=[arr objectAtIndex:0];
                                    
                                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                    alert.tag=8;
                                    [alert show];
                                }
                            }
                            else{
                                if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue" ] isEqualToString:@"RiderSide"] )
                                {
                                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                    alert.tag=6;
                                    
                                    NSArray *arr=[messageStr componentsSeparatedByString:@":"];
                                    colour=[arr objectAtIndex:1];
                                    [alert show];
                                }
                            }
                        }
                        
                        else
                        {
                            //Cancel Ride
                            
                            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                            
                            
                         
                               
                                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue" ] isEqualToString:@"RiderSide"] )
                                {
                                    alert.tag=2;
                                    [alert show];
                                }
                                else {
                                    alert.tag=1;
                                    [alert show];
                                }
                            
                           
                           
                        }
                    }
                    else
                    {
                        // start ride
                        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue" ] isEqualToString:@"RiderSide"] )
                        {
                            
                            NSArray *arr=[messageStr componentsSeparatedByString:@"TripId:"];
                            reqId=[arr objectAtIndex:1];
                            
                            DriverRideMapViewController*driverRideMapVc;
                            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                                driverRideMapVc = [[DriverRideMapViewController alloc] initWithNibName:@"DriverRideMapViewController" bundle:nil];
                                
                                //this is iphone 5 xib
                            }
                            else if([[UIScreen mainScreen] bounds].size.height == 480) {
                                driverRideMapVc = [[DriverRideMapViewController alloc] initWithNibName:@"DriverRideMapViewController_iphone4" bundle:nil];
                                
                                // this is iphone 4 xib
                            }
                           
                            driverRideMapVc.FromNotification=YES;
                            driverRideMapVc.GetTripId=reqId;
                            [[NSUserDefaults standardUserDefaults]setValue:reqId forKey:@"tripId"];
                            [navigator pushViewController:driverRideMapVc animated:YES];
                            
                            // [alert show];
                        }
                    }
                }
                else
                {
                    // arrived
                    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue" ] isEqualToString:@"RiderSide"] )
                        
                    {
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                        
                    }
                }
                
            }
            else
            {
                /// request ride
                if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue" ] isEqualToString:@"RiderSide"] )
                {
                    NSURL *url=[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"Formula 1 Car Sound"] ofType:@"mp3"]];
                    masterAudioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
                    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
                    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
                    
                    masterAudioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
                    [masterAudioPlayer play];
                    
                    
                                    NSRange r1 = [messageStr rangeOfString:@"("];
                    NSRange r2 = [messageStr rangeOfString:@")"];
                    NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
                    NSString *subString = [messageStr substringWithRange:rSub];
                    NSLog(@"subString = %@",subString);
                    reqType=[NSString stringWithFormat:@"%@",subString];
                    messageStr = [messageStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"(%@)",subString]withString:@""];
                    
                    if ([reqType isEqualToString:@"VIP"])
                    {
                        NSArray *arr=[messageStr componentsSeparatedByString:@";"];
                        reqId=[arr objectAtIndex:2];
                        
                        NSArray *arr5=[reqId componentsSeparatedByString:@":"];
                        reqId=[arr5 objectAtIndex:1];
                        
                        currentLocStr=[[[arr objectAtIndex:1]componentsSeparatedByString:@":"]objectAtIndex:1];
                        
                        destinationLoc=[arr objectAtIndex:0];
                        
                        NSArray *arr2=[destinationLoc componentsSeparatedByString:@"and offering price "];
                        riderNameStr=[arr2 objectAtIndex:0];
                        
                        
                        priceStr=[arr2 objectAtIndex:1];
                        ratingStr=[[[arr objectAtIndex:3]componentsSeparatedByString:@":"]objectAtIndex:1];
                        handicapedStr=[[[arr objectAtIndex:4]componentsSeparatedByString:@":"]objectAtIndex:1];
                        picUrl=[[[arr objectAtIndex:7]componentsSeparatedByString:@"Image:"]objectAtIndex:1];
                        pickupTime=[[[arr objectAtIndex:5]componentsSeparatedByString:@":"]objectAtIndex:1];;
                        vehicleStr=[[[arr objectAtIndex:6]componentsSeparatedByString:@":"]objectAtIndex:1];
                        getRiderNameStr=[[riderNameStr componentsSeparatedByString:@"is requesting"]objectAtIndex:0];
                    }
                    else
                    {
                        NSArray *arr=[messageStr componentsSeparatedByString:@";"];
                        NSLog(@"%@",arr);
                        NSString *str1=[arr objectAtIndex:0];
                        distanceStr=[arr objectAtIndex:1];
                        timeStr=[[[arr objectAtIndex:2]componentsSeparatedByString:@":"]objectAtIndex:1];
                        reqId=[arr objectAtIndex:3];
                        
                        
                        ratingStr=[[[arr objectAtIndex:4]componentsSeparatedByString:@":"]objectAtIndex:1];
                        handicapedStr=[[[arr objectAtIndex:5]componentsSeparatedByString:@":"]objectAtIndex:1];
                        picUrl=[[[arr objectAtIndex:8]componentsSeparatedByString:@"Image:"]objectAtIndex:1];
                        pickupTime=[[[arr objectAtIndex:6]componentsSeparatedByString:@":"]objectAtIndex:1];
                        NSArray *arr1=[str1 componentsSeparatedByString:@"Current Location:"];
                        currentLocStr=[arr1 objectAtIndex:1];
                        NSString *tempStr=[arr1 objectAtIndex:0];
                        NSArray *arr2=[tempStr componentsSeparatedByString:@"and offering price "];
                        priceStr=[arr2 objectAtIndex:1];
                        vehicleStr=[[[arr objectAtIndex:7]componentsSeparatedByString:@":"]objectAtIndex:1];
                        
                        riderNameStr=[NSString stringWithFormat:@"%@ a ride",[[tempStr componentsSeparatedByString:@"ride to "]objectAtIndex:0]];
                        tempStr=[arr2 objectAtIndex:0];
                        destinationLoc=[[tempStr componentsSeparatedByString:@"ride to "]objectAtIndex:1];
                        NSArray *arr5=[reqId componentsSeparatedByString:@":"];
                        reqId=[arr5 objectAtIndex:1];
                        NSLog(@"TRipid %@",reqId );
                        getRiderNameStr=[[riderNameStr componentsSeparatedByString:@"is requesting"]objectAtIndex:0];
                        
                    }
                    [self launchDialog:messageStr];
                }
            }
        }
        
        else
        {
            //rating to driver
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue" ] isEqualToString:@"RiderSide"] )
            {
                NSURL *url=[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"cars023"] ofType:@"mp3"]];
                masterAudioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
                AVAudioSession *audioSession = [AVAudioSession sharedInstance];
                [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
                
                masterAudioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
                [masterAudioPlayer play];
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                alert.tag=9;
            }
        }
    }
    
    else
    {
        // when driver acepts the ride request.
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue" ] isEqualToString:@"RiderSide"] )
        {
            
            NSRange r1 = [messageStr rangeOfString:@"("];
            NSRange r2 = [messageStr rangeOfString:@")"];
            NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
            NSString *subString = [messageStr substringWithRange:rSub];
            NSLog(@"subString = %@",subString);
            reqType=[NSString stringWithFormat:@"%@",subString];
            
            messageStr = [messageStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"(%@)",subString]withString:@""];
            
            animatedView=[[UIView alloc] initWithFrame:CGRectMake(0, 490, 320, 80)];
            animatedView.backgroundColor=[UIColor whiteColor];
            [self.window addSubview:animatedView];
            
            
            DriverNameLbl=[[UILabel alloc] initWithFrame:CGRectMake(60, 5, 250, 25)];
            [animatedView addSubview:DriverNameLbl];
            
            MessageLbl=[[UILabel alloc] initWithFrame:CGRectMake(60, 25, 250, 40)];
            [MessageLbl setFont:[UIFont systemFontOfSize:11]];
            MessageLbl.numberOfLines=3;
            [animatedView addSubview:MessageLbl];
            
            NSArray *arr=[messageStr componentsSeparatedByString:@"@"];
            
            NSLog(@"%@",arr);
            NSString *username=[arr objectAtIndex:0];
            NSString *Message=[arr objectAtIndex:1];
            NSString *ImageUrl=[arr objectAtIndex:2];
            NSString*tripId=[arr objectAtIndex:3];
            reqId=[[tripId componentsSeparatedByString:@":"]objectAtIndex:1];
            
            DriverNameLbl.text=username;
            MessageLbl.text=Message;
            
            DriverImgView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 65)];
            DriverImgView.backgroundColor=[UIColor grayColor];
            [animatedView addSubview:DriverImgView];
            
            UIImage* myImage = [UIImage imageWithData:
                                [NSData dataWithContentsOfURL:
                                 [NSURL URLWithString:ImageUrl]]];
            [DriverImgView setImage:myImage];
            
            [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(DisableView) userInfo:nil repeats:NO];
            
            
            if ([reqType isEqualToString:@"Now"])
            {
                DriverRequestAndQueueViewController *drivereqAndQueueVc;
                
                if ([[UIScreen mainScreen] bounds].size.height == 568) {
                    drivereqAndQueueVc=[[DriverRequestAndQueueViewController alloc]initWithNibName:@"DriverRequestAndQueueViewController" bundle:nil];
                }
                else if([[UIScreen mainScreen] bounds].size.height == 480)
                {
                    drivereqAndQueueVc=[[DriverRequestAndQueueViewController alloc]initWithNibName:@"DriverRequestAndQueueViewController_iphone4" bundle:nil];
                    // this is iphone 4 xib
                }
                drivereqAndQueueVc.GetTripId=reqId;
                drivereqAndQueueVc.FromNotification=YES;
                [navigator pushViewController:drivereqAndQueueVc animated:YES];
            }
        }
    }
}

-(void)test:(CustomIOS7AlertView *)alertView
{

    [alertViewCustom close];
    acceptReq=NO;

}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
	NSLog(@"Failed to get token, error: %@", error);
}


- (void)launchDialog:(NSString*)messagetext
{
    // Here we need to pass a full frame
    alertViewCustom = [[CustomIOS7AlertView alloc] init];
    
    // Add some custom content to the alert view
    [alertViewCustom setContainerView:[self createDemoView:messagetext]];
    
    // Modify the parameters
    [alertViewCustom setButtonTitles:[NSMutableArray arrayWithObjects:@"Accept", @"Reject",nil]];
    [alertViewCustom setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertViewCustom setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertViewCustom close];
    }];
    
    [alertViewCustom setUseMotionEffects:true];
    
    // And launch the dialog
    [alertViewCustom show];
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    [masterAudioPlayer stop];
    [timer invalidate];
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    if (buttonIndex==0)
    {
        acceptReq=YES;
        jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:reqId,@"TripId",@"Accepted",@"Status",nil];
        jsonRequest = [jsonDict JSONRepresentation];
        
        NSLog(@"jsonRequest is %@", jsonRequest);
        
        urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/AcceptOrRejectRequest",Kwebservices]];
        
        [self postWebservices];
    }
    else if (buttonIndex==1)
    {
         acceptReq=NO;

    }
    
    
    [alertView close];
}

- (UIView *)createDemoView:(NSString*)message1
{
    
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 300)];
    UIView *ColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 30)];
    ColorView.layer.cornerRadius=6.0;
    
    if ([reqType isEqualToString:@"Future"])
    {
        [ColorView setBackgroundColor:[UIColor redColor]];
        
    }
    else if ([reqType isEqualToString:@"VIP"])
    {
        [ColorView setBackgroundColor:[UIColor purpleColor]];
        
    }
    else
    {
        [ColorView setBackgroundColor:[UIColor yellowColor]];
        
    }
    [demoView addSubview:ColorView];
    
    
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYYMMddHHmmss"];
    NSDate *date = [dateFormat dateFromString:pickupTime];
    
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:flags fromDate:date];
    
    NSDate* dateOnly = [calendar dateFromComponents:components];
    
    
    //Current Date
    NSDate *CurrentDate=[NSDate date];
    
    NSDate*currntDate=[NSDate date];
    
    float timeDiffer=[date timeIntervalSinceDate: currntDate];
    int pickupTym=timeDiffer/60;
    if (pickupTym<4)
    {
        reqType=@"Now";
    }
    
    unsigned int flags1 = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar1 = [NSCalendar currentCalendar];
    
    NSDateComponents* components1 = [calendar1 components:flags1 fromDate:CurrentDate];
    
    NSDate* CurrentdateOnly = [calendar dateFromComponents:components1];
    //compare dates
    switch ([dateOnly compare:CurrentdateOnly])
    {
        case NSOrderedAscending:
        {
            NSLog(@"NSOrderedAscending");
        }
            
            break;
        case NSOrderedSame:
        {
            NSLog(@"NSOrderedSame");
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            format.dateFormat = @"HH:mm";
            pickupTime=[format stringFromDate:date];
            
        }
            break;
        case NSOrderedDescending:
        {
            NSLog(@"NSOrderedDescending");
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            format.dateFormat = @"dd-MM-yyyy";
            pickupTime=[format stringFromDate:date];
        }
            break;
    }
    UILabel *nameLbl=[[UILabel alloc] initWithFrame:CGRectMake(100, 29, 160, 40)];
    nameLbl.numberOfLines=3;
    nameLbl.text=riderNameStr;
    [demoView addSubview:nameLbl];
 
    
    UITextView*startLocTxt=[[UITextView alloc]initWithFrame:CGRectMake(10, 95, 260, 50)];
    startLocTxt.text=[NSString stringWithFormat:@"Pick up at : %@",currentLocStr];
     startLocTxt.backgroundColor=[UIColor clearColor];
    startLocTxt.editable=NO;
    
    
    UITextView*endLocTxt=[[UITextView alloc]initWithFrame:CGRectMake(10, 150, 260,50)];
    endLocTxt.backgroundColor=[UIColor clearColor];
    endLocTxt.editable=NO;

    endLocTxt.text=[NSString stringWithFormat:@"Destination : %@",destinationLoc];

    
    UIImageView *handicapedImage =[[UIImageView alloc] initWithFrame:CGRectMake(260,35,20,20)];
    handicapedImage.image=[UIImage imageNamed:@"Handicap.png"];
    if ([handicapedStr isEqualToString:@"1 "])
    {
          [demoView addSubview:handicapedImage];
    }

    picUrl = [picUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSURL *url = [NSURL URLWithString: picUrl];
    
    DriverImgView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 35, 50, 60)];

    [demoView addSubview: DriverImgView];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    
    [DriverImgView setImage:img];
    
    if ([vehicleStr isEqualToString:@"2"]) {
        vehicleStr=@"XL";
    }
    else if ([vehicleStr isEqualToString:@"3"]) {
        vehicleStr=@"EXECUTIVE";
    }
    else if ([vehicleStr isEqualToString:@"4"]) {
        vehicleStr=@"SUV";
    } else if ([vehicleStr isEqualToString:@"5"]) {
        vehicleStr=@"LUXURY";
    }else
    {
        vehicleStr=@"REGULAR";
    }
    
  
    
    UILabel *ratingLbl=[[UILabel alloc] initWithFrame:CGRectMake(15, 200, 100, 20)];
    ratingLbl.text=[NSString stringWithFormat:@"Rating : %@",ratingStr];
    [demoView addSubview:ratingLbl];
    
    
    UILabel *OfferedPriceLbl =[[UILabel alloc] initWithFrame:CGRectMake(15, 235, 290, 25)];
   
    OfferedPriceLbl.text=[NSString stringWithFormat:@"Offered Fare : $%@",priceStr];
    
    if (distanceStr.length>16)
    {
        distanceStr=[distanceStr substringToIndex:16];
      
    }
    NSArray *arr=[distanceStr componentsSeparatedByString:@"Distance:"];
    
    NSString*distStr=[arr objectAtIndex:1];

    float dist=[distStr floatValue];
    distanceStr=[NSString stringWithFormat:@"Distance:%.1f",dist];
    
    
    UILabel *distanceLbl=[[UILabel alloc] initWithFrame:CGRectMake(15, 275, 290, 25)];
    distanceLbl.text=[NSString stringWithFormat:@"%@  Miles",distanceStr];
    
    UILabel *pickUpTimelbl =[[UILabel alloc] initWithFrame:CGRectMake(15, 255, 290, 25)];
    
    if ([reqType isEqualToString:@"Now"]) {
         pickUpTimelbl.text=[NSString stringWithFormat:@"Pickup Time : Now"];
    }
    else{
          pickUpTimelbl.text=[NSString stringWithFormat:@"Pickup Time : %@",pickupTime];
    }
  
    [demoView addSubview:pickUpTimelbl];
    
    UILabel *vehicleLbl =[[UILabel alloc] initWithFrame:CGRectMake(15, 217, 290, 25)];
    vehicleLbl.text=[NSString stringWithFormat:@"Vehicle : %@",vehicleStr];
    [demoView addSubview:vehicleLbl];
   
    timeLbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 5,290, 20)];
    timeLbl.textAlignment=NSTextAlignmentCenter;
    timeLbl.text=@"Time Left : 15";
    Time=15;
    [ColorView addSubview:timeLbl];
    
    
    [startLocTxt setFont:[UIFont fontWithName:@"Myriad Pro" size:15]];
    [endLocTxt setFont:[UIFont fontWithName:@"Myriad Pro" size:15]];
    [OfferedPriceLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:18]];
    [distanceLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:15]];
    [ratingLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:15]];
    [nameLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:15]];
    [pickUpTimelbl setFont:[UIFont fontWithName:@"Myriad Pro" size:15]];
    [vehicleLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:18]];

    startLocTxt.textColor=[UIColor colorWithRed:(0 / 255.0) green:(102.0 / 255.0) blue:(0.0 / 255.0) alpha:1];
    endLocTxt.textColor=[UIColor redColor];
    
    [demoView addSubview:endLocTxt];
    [demoView addSubview:OfferedPriceLbl];
    [demoView addSubview:startLocTxt];
    [demoView addSubview:distanceLbl];
    
    if ([riderNameStr rangeOfString:@"VIP"].location==NSNotFound)
    {
        endLocTxt.hidden=NO;
        distanceLbl .hidden=NO;
    }
    else{
         endLocTxt.hidden=YES;
         distanceLbl .hidden=YES;
     }
    timer= [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(test:) userInfo:nil repeats:NO];
    

    stopWatchTimer= [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    
    return demoView;
}


- (void)timerTick:(NSTimer *)timer
{
    Time=Time-1;
    timeLbl.text = [NSString stringWithFormat:@"Time Left : %d",Time];
    if (Time==0)
    {
        [stopWatchTimer invalidate];
    }
}


#pragma mark - Alert View Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex
{
  
    if (alertView.tag==1)
    {
        if ([[[NSUserDefaults standardUserDefaults ]valueForKey:@"View"]isEqualToString:@"RideStart"])
        {
            
            [[NSUserDefaults standardUserDefaults ]removeObjectForKey:@"View"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey: @"tripId"];
            DriverFirstViewViewController*driverFirstVc;
            if ([[UIScreen mainScreen] bounds].size.height == 568)
            {
                driverFirstVc=[[DriverFirstViewViewController alloc]initWithNibName:@"DriverFirstViewViewController" bundle:nil];
            }
            else if([[UIScreen mainScreen] bounds].size.height == 480)
            {
                driverFirstVc=[[DriverFirstViewViewController alloc]initWithNibName:@"DriverFirstViewViewController_iphone4" bundle:nil];
                // this is iphone 4 xib
            }
            [navigator pushViewController:driverFirstVc animated:YES];
        }
    }

    if (alertView.tag==2)
    {
    
        if ([[[NSUserDefaults standardUserDefaults ]valueForKey:@"View"]isEqualToString:@"RideStart"]||[[[NSUserDefaults standardUserDefaults ]valueForKey:@"RideDetailView"]isEqualToString:@"RideDetailView"])
        
        {
            [[NSUserDefaults standardUserDefaults ]removeObjectForKey:@"RideDetailView"];
            [[NSUserDefaults standardUserDefaults ]removeObjectForKey:@"View"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey: @"tripId"];
            MapViewController *mapVc;
        
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
            }
            else if([[UIScreen mainScreen] bounds].size.height == 480)
            {
                mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController_iphone4" bundle:nil];
            // this is iphone 4 xib
            }
        
            [navigator pushViewController:mapVc animated:YES];
        }
    }
    if (alertView.tag==3)
    {
        DriverFirstViewViewController *drivrFirstVC;
        
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            drivrFirstVC=[[DriverFirstViewViewController alloc]initWithNibName:@"DriverFirstViewViewController" bundle:nil];
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480)
        {
            drivrFirstVC=[[DriverFirstViewViewController alloc]initWithNibName:@"DriverFirstViewViewController_iphone4" bundle:nil];
        }
        [navigator pushViewController:drivrFirstVC animated:YES];
    }

    if (alertView.tag==4)
    {
        [[NSUserDefaults standardUserDefaults ]removeObjectForKey:@"View"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey: @"tripId"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"activeTripId"];
        
        
        MapViewController *mapVc;
        
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480)
        {
            mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController_iphone4" bundle:nil];
            // this is iphone 4 xib
        }
       
        [navigator pushViewController:mapVc animated:YES];
        
    }
    if (alertView.tag==5)
    {
        [timer invalidate];
        if (buttonIndex==1)
        {
            acceptReq=YES;
           jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:reqId,@"TripId",@"Accepted",@"Status",nil];
            jsonRequest = [jsonDict JSONRepresentation];
            
            NSLog(@"jsonRequest is %@", jsonRequest);
            
            urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/AcceptOrRejectRequest",Kwebservices]];
            
            [self postWebservices];
        }
        else if (buttonIndex==0)
        {
            acceptReq=NO;

        }
        
    }
 

    if (alertView.tag==6)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
            view=[[UIView alloc]initWithFrame:CGRectMake(0,0, 320, 568)];
            //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480) {
            view=[[UIView alloc]initWithFrame:CGRectMake(0,0, 320, 480)];
            
            // this is iphone 4 xib
        }
        else
        {
            view=[[UIView alloc]initWithFrame:CGRectMake(0,0, 768, 1024)];
        }
        
        if([colour  isEqualToString:@"red"] ) {
            view.backgroundColor=[UIColor colorWithRed:(240.0 / 255.0) green:(60.0 / 255.0) blue:(43.0 / 255.0) alpha:1];
        }
        if([colour isEqualToString:@"pink"] )
        {
            view.backgroundColor=[UIColor colorWithRed:(238.0 / 255.0) green:(44.0 / 255.0) blue:(115.0 / 255.0) alpha:1];
        }
        if([colour isEqualToString:@"green"]  )
        {
            view.backgroundColor=[UIColor colorWithRed:(37.0 / 255.0) green:(168.0 / 255.0) blue:(102.0 / 255.0) alpha:1];
        }
        if([colour isEqualToString:@"blue"]  )
        {
            view.backgroundColor=[UIColor colorWithRed:(34.0 / 255.0) green:(175.0 / 255.0) blue:(195.0 / 255.0) alpha:1];
        }
        if([colour isEqualToString:@"white"] )
        {
            view.backgroundColor=[UIColor colorWithRed:(226.0 / 255.0) green:(220.0 / 255.0) blue:(205.0 / 255.0) alpha:1];
        }
        if([colour isEqualToString:@"orange"]  )
        {
            view.backgroundColor=[UIColor colorWithRed:(244.0 / 255.0) green:(129.0 / 255.0) blue:(75.0 / 255.0) alpha:1];
        }
        if([colour isEqualToString:@"yellow"]  )
        {
            view.backgroundColor=[UIColor colorWithRed:(251.0 / 255.0) green:(236.0 / 255.0) blue:(73.0 / 255.0) alpha:1];
        }
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cancelBtn addTarget:self
                   action:@selector(cancelBtn:)
         forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitle:@"Tap to close" forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(0.0, 0.0,320.0, 480.0);
        cancelBtn .backgroundColor =[UIColor clearColor];
        [view addSubview:cancelBtn];
        [self.window addSubview:view];
    }
    
    if (alertView.tag==7)
    {
        DriverRideMapViewController*driverRideMapVc;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            driverRideMapVc = [[DriverRideMapViewController alloc] initWithNibName:@"DriverRideMapViewController" bundle:nil];
            //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480) {
            driverRideMapVc = [[DriverRideMapViewController alloc] initWithNibName:@"DriverRideMapViewController_iphone4" bundle:nil];
            // this is iphone 4 xib
        }
        
        driverRideMapVc.FromNotification=YES;
        driverRideMapVc.GetTripId=reqId;
        [navigator pushViewController:driverRideMapVc animated:YES];
    }
    if (alertView.tag==8)
    {
        
        DriverRequestAndQueueViewController *drivereqAndQueueVc;
        
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            drivereqAndQueueVc=[[DriverRequestAndQueueViewController alloc]initWithNibName:@"DriverRequestAndQueueViewController" bundle:nil];
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480)
        {
            drivereqAndQueueVc=[[DriverRequestAndQueueViewController alloc]initWithNibName:@"DriverRequestAndQueueViewController_iphone4" bundle:nil];
            // this is iphone 4 xib
        }
        drivereqAndQueueVc.GetTripId=reqId;
        drivereqAndQueueVc.FromNotification=YES;
        [navigator pushViewController:drivereqAndQueueVc animated:YES];
        
  
    }

    if (alertView.tag==9)
    {
        RideFinishViewController *ridefinishVC;
        
        if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
            ridefinishVC=[[RideFinishViewController alloc]initWithNibName:@"RideFinishViewController" bundle:nil];
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480)
        {
            ridefinishVC=[[RideFinishViewController alloc]initWithNibName:@"RideFinishViewController_iphone4" bundle:nil];
        }
        ridefinishVC.FromNotification=YES;
        NSLog(@"reqId : %@",reqId);
        [[NSUserDefaults standardUserDefaults]setValue:reqId forKey:@"tripId"];
        DriverRideMapViewController*driverRideMapVc=[[DriverRideMapViewController alloc]init];
        [driverRideMapVc.Disttimer invalidate];
        [navigator pushViewController:ridefinishVC animated:YES];
    }
}


-(IBAction)cancelBtn:(id)sender
{
    [view removeFromSuperview];
}
#pragma mark - Post JSON Web Service

-(void)postWebservices
{
    [stopWatchTimer invalidate];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        if(webData==nil)
        {
            webData = [NSMutableData data] ;
            NSLog(@"data");
        }
        else
        {
            webData=nil;
            webData = [NSMutableData data] ;
        }
        NSLog(@"server connection made");
    }
    else
    {
        NSLog(@"connection is NULL");
    }
}

#pragma mark - Response Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert;
    alert=[[UIAlertView alloc]initWithTitle:@"Rapid Ride" message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alert.tag=2;
    [alert show];
    NSLog(@"ERROR with the Connection ");
    webData =nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    
    NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
  
    if (webservice==7)
    {
        webservice=0;
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result1=[[userDetailDict valueForKey:@"result" ]intValue];
            if (result1==1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
               // [alert show];
            }
        }
    }
    else
    {
        
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result1=[[userDetailDict valueForKey:@"result" ]intValue];
            if (result1==1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
            }
            else
            {
                if ([reqType isEqualToString:@"Now"] && acceptReq==YES)
                {
                    webservice=7;
                    self.locationManager = [[CLLocationManager alloc] init];
                    self.locationManager.delegate = self;
                    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                    self.locationManager.distanceFilter = kCLDistanceFilterNone;
                    [self.locationManager startUpdatingLocation];
                    
                    float  current_longitude=self.locationManager.location.coordinate.longitude;
                    float  current_latitude=self.locationManager.location.coordinate.latitude;
                    
                    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:RiderIdStr,@"RiderId",driverIdStr,@"DriverId",@"Busy",@"Trigger",[NSString stringWithFormat:@"%f",current_longitude],@"Longitude",[NSString stringWithFormat:@"%f",current_latitude],@"Latitude",nil];
                    
                    jsonRequest = [jsonDict JSONRepresentation];
                    NSLog(@"jsonRequest is %@", jsonRequest);
                    
                    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/SwitchBetweenMode",Kwebservices]];
                    
                    [self postWebservices];
                    
                    DriverRideMapViewController*driverRideMapVc;
                    if ([[UIScreen mainScreen] bounds].size.height == 568) {
                        driverRideMapVc = [[DriverRideMapViewController alloc] initWithNibName:@"DriverRideMapViewController" bundle:nil];
                        //this is iphone 5 xib
                    }
                    else if([[UIScreen mainScreen] bounds].size.height == 480) {
                        driverRideMapVc = [[DriverRideMapViewController alloc] initWithNibName:@"DriverRideMapViewController_iphone4" bundle:nil];
                        // this is iphone 4 xib
                    }
                    driverRideMapVc.GetNameStr=getRiderNameStr;
                    driverRideMapVc.GetTripId=reqId;
                    driverRideMapVc.getDesignationStr=currentLocStr;
                    driverRideMapVc.endLocationString=destinationLoc;
                    driverRideMapVc.getFareStr=priceStr;
                    driverRideMapVc.getETAstr=timeStr;
                    driverRideMapVc.getimgeUrl=picUrl;
                    driverRideMapVc.getpickUptimrStr=pickupTime;
                    driverRideMapVc.getVehicleType=vehicleStr;
                    driverRideMapVc.handicappedStr=handicapedStr;
                    driverRideMapVc.FromNotification=YES;
                    [navigator pushViewController:driverRideMapVc animated:YES];
                    
                }
                
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                // [alert show];
            }
        }
    }
}


@end
