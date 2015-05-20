//
//  SplashViewController.m
//  RapidRide
//
//  Created by Br@R on 17/10/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import "SplashViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "MapViewController.h"
#import "DriverFirstViewViewController.h"
#import "DriverRideMapViewController.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import <GoogleMaps/GoogleMaps.h>
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Base64.h"
#import "Reachability.h"


@interface SplashViewController ()

@end

@implementation SplashViewController
@synthesize activityIndicatorObject;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    
    countr=1;
       AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.navigator.navigationBarHidden = YES;
    
    
    activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        activityIndicatorObject.center = CGPointMake(160, 100);
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        activityIndicatorObject.center = CGPointMake(160, 100);
        // this is iphone 4 xib
    }
    else
    {
        activityIndicatorObject.center = CGPointMake(374, 412);
    }
    activityIndicatorObject.color=[UIColor whiteColor];
    [self.view addSubview:activityIndicatorObject];

    
    
    locationManager = [[CLLocationManager alloc] init];
    current_longitude=locationManager.location.coordinate.longitude;
    current_latitude=locationManager.location.coordinate.latitude;
    
    NSLog(@"%f",current_latitude);
    NSLog(@"%f",current_longitude);
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    current_longitude=locationManager.location.coordinate.longitude;
    current_latitude=locationManager.location.coordinate.latitude;
    
    NSLog(@"%f %f",current_latitude,current_longitude);


    [self.view setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(presentnextView) userInfo:nil repeats:NO];


    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)presentnextView
{
    LoginViewController *loginVc;
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary*dataDict=[[NSMutableDictionary alloc]init];
    dataDict=[userdefaults valueForKey: @"riderInfo"];
    
    emailStr=[userdefaults valueForKey:@"userEmail"];
    passwordStr=[userdefaults valueForKey:@"userPassword"];
    userIdStr=[dataDict valueForKey:@"userid"];
    
    if (emailStr.length==0 && passwordStr.length==0 && userIdStr.length==0)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            loginVc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480) {
            loginVc = [[LoginViewController alloc] initWithNibName:@"LoginViewController_iphone4" bundle:nil];
            // this is iphone 4 xib
        }
      
        [self.navigationController pushViewController:loginVc animated:YES];
  
    }
    else{
         [self LoginWebService];

    }
}


-(void)LoginWebService
{
    webservice=1;
    [self.activityIndicatorObject startAnimating];
    self.view.userInteractionEnabled =NO;
    //   disableImg.hidden=NO;
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:emailStr,@"Email",passwordStr,@"Password",  nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/Login",Kwebservices]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
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

#pragma mark - Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if(countr<=3 && webservice==1)
    {
        countr=countr+1;
        [self LoginWebService];
    }
    else
    {
        [self.activityIndicatorObject stopAnimating];
        self.view.userInteractionEnabled=YES;

        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid Ride" message:@"Intenet connection failed.. Please check your connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }
 
    NSLog(@"ERROR with the Connection ");
    webData =nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //   disableImg.hidden=YES;
    
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableDictionary *userDetailDicttemp=[json objectWithString:responseString error:&error];
    
    NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
    
    if (![userDetailDict isKindOfClass:[NSNull class]])
    {
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        
         NSString *errormsg=[userDetailDict valueForKey:@"Message"];
        
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        
        if (webservice==1 && [errormsg isEqualToString:@"There was an error processing the request."]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",errormsg] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [self.activityIndicatorObject stopAnimating];
            self.view.userInteractionEnabled=YES;
            return;
        }
        
        if (result ==1 && webservice==1)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [self.activityIndicatorObject  stopAnimating];
            
        }
        else if (result==1 &&webservice==2)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            MapViewController *mapVc;
            
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
            }
            else if([[UIScreen mainScreen] bounds].size.height == 480)
            {
                mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController_iphone4" bundle:nil];
                // this is iphone 4 xib
            }
           
            
            DriverFirstViewViewController*driverFirstVc;
            
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                driverFirstVc=[[DriverFirstViewViewController alloc]initWithNibName:@"DriverFirstViewViewController" bundle:nil];
            }
            else if([[UIScreen mainScreen] bounds].size.height == 480)
            {
                driverFirstVc=[[DriverFirstViewViewController alloc]initWithNibName:@"DriverFirstViewViewController_iphone4" bundle:nil];
                // this is iphone 4 xib
            }
        
            
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue" ] isEqualToString:@"DriverSide"])
            {
                
                driverFirstVc.driverMode=YES;
                driverFirstVc.fromSplash=YES;
                [self.navigationController pushViewController:driverFirstVc animated:YES];
                
            }
            else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue" ] isEqualToString:@"RiderSide"])
            {
                [[NSUserDefaults standardUserDefaults ]setValue:@"first" forKey:@"first"];
                mapVc.tempVehicleDict=[userDetailDict copy];
                [self.navigationController pushViewController:mapVc animated:YES];
            }
            [self.activityIndicatorObject stopAnimating];
            self.view.userInteractionEnabled=YES;
        }
        
        else
        {
            if (webservice==1)
            {
                NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"riderInfo"];
                [userdefaults setValue:userDetailDicttemp forKey:@"riderInfo"];
                NSString *vehicleType=[userDetailDicttemp valueForKey:@"prefvehicletype"];
                if ([vehicleType isEqualToString:@"0"])
                {
                     [[NSUserDefaults standardUserDefaults ]setValue:@"" forKey:@"prefvehicletype"];
                }
                else{
                     [[NSUserDefaults standardUserDefaults ]setValue:vehicleType forKey:@"prefvehicletype"];
                }
                
                userIdStr= [NSString stringWithFormat:@"%@",[userDetailDicttemp valueForKey:@"userid"]];
                [[NSUserDefaults standardUserDefaults ]setValue:userIdStr forKey:@"riderId"];
                
                NSString *riderDriverIdStr=[NSString stringWithFormat:@"%@",[userDetailDicttemp valueForKey:@"driverid"]];
                [[NSUserDefaults standardUserDefaults ]setValue:riderDriverIdStr forKey:@"driverid"];
             
                
                NSString*  lastNameStr=[NSString stringWithFormat:@"%@.",[[userDetailDicttemp valueForKey:@"lastname"] substringToIndex:1]];
                
                NSString *fullName=[NSString stringWithFormat:@"%@ %@",[userDetailDicttemp valueForKey:@"firstname"],lastNameStr];
                
                NSString* active_tripid=[userDetailDicttemp valueForKey: @"active_tripid"];
                
                NSString* picUrl=[userDetailDicttemp valueForKey:@"profilepiclocation"];
                
                [[NSUserDefaults standardUserDefaults]setValue:fullName forKey:@"fullName"];
                [[NSUserDefaults standardUserDefaults]setValue:picUrl forKey:@"picUrl"];
            

                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
                // [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *now = [NSDate date];
                NSString *currentTime= [dateFormatter stringFromDate:now];
                NSString* Riderside=[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue"];
                if (Riderside.length==0)
                {
                    [[NSUserDefaults standardUserDefaults] setValue:@"RiderSide" forKey:@"Queue"];
                }
 
                [[NSUserDefaults standardUserDefaults ]removeObjectForKey:@"activeTripId"];
  
                if (![active_tripid isEqualToString:@""])
                {
                    [[NSUserDefaults standardUserDefaults]setValue:active_tripid forKey:@"activeTripId"];

                }
               
                    webservice=2;
                    NSDictionary* jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%f", current_longitude],@"longitude",[NSString stringWithFormat:@"%f", current_latitude],@"latitude",currentTime,@"currenttime",@"10",@"distance",userIdStr,@"riderid",nil];
                    
                    NSString *jsonRequest = [jsonDict JSONRepresentation];
                    
                    NSLog(@"jsonRequest is %@", jsonRequest);
                    
                    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/FetchVehicleList",Kwebservices]];
                    
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
               // }

            
            }
            else if (webservice==2)
            {
                NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
                    
                NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
                NSLog(@"responseString:%@",responseString);
                NSError *error;
                    
                responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
                    
                SBJsonParser *json = [[SBJsonParser alloc] init];
                    
                NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
                    
                if (![userDetailDict isKindOfClass:[NSNull class]])
                {
                    MapViewController *mapVc;
                  
                    if ([[UIScreen mainScreen] bounds].size.height == 568) {
                        mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
                    }
                    else if([[UIScreen mainScreen] bounds].size.height == 480)
                    {
                        mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController_iphone4" bundle:nil];
                    // this is iphone 4 xib
                    }
                    else
                    {
                        mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
                    }
                    
                    DriverFirstViewViewController*driverFirstVc;
                    
                    if ([[UIScreen mainScreen] bounds].size.height == 568) {
                        driverFirstVc=[[DriverFirstViewViewController alloc]initWithNibName:@"DriverFirstViewViewController" bundle:nil];
                    }
                    else if([[UIScreen mainScreen] bounds].size.height == 480)
                    {
                        driverFirstVc=[[DriverFirstViewViewController alloc]initWithNibName:@"DriverFirstViewViewController_iphone4" bundle:nil];
                        // this is iphone 4 xib
                    }
                  
                 //   [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"Queue"];
                
                    
                    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue" ] isEqualToString:@"DriverSide"])
                    {
                        
                        driverFirstVc.driverMode=YES;
                        driverFirstVc.fromSplash=YES;
                        
                        [self.navigationController pushViewController:driverFirstVc animated:YES];
                          
                    }
                    else
                    {
                        [[NSUserDefaults standardUserDefaults ]setValue:@"first" forKey:@"first"];
                        mapVc.tempVehicleDict=[userDetailDict copy];
                        [self.navigationController pushViewController:mapVc animated:YES];
                    }
                  
                   
                    [self.activityIndicatorObject stopAnimating];
                    self.view.userInteractionEnabled=YES;

                }
            }
        }
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
