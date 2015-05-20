//
//  DriverFirstViewViewController.m
//  RapidRide
//
//  Created by Br@R on 29/10/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import "DriverFirstViewViewController.h"
#import "DriverRequestAndQueueViewController.h"
#import "SBJSON.h"
#import "JSON.h"
#import "MapViewController.h"
#import "Base64.h"
#import "HelpViewController.h"
#import "AboutUsViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface DriverFirstViewViewController ()

@end

@implementation DriverFirstViewViewController
@synthesize activityIndicatorObject,driverIdStr,riderBasicInfoBackView,riderLocatioInfoBackView,driverMode,RiderIdStr,modeType,current_latitude,current_longitude,picUrl,fromSplash;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma  mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    RiderIdStr= [[NSUserDefaults standardUserDefaults ]valueForKey:@"riderId"];
    driverIdStr=[[NSUserDefaults standardUserDefaults ]valueForKey:@"driverid"];
    [[NSUserDefaults standardUserDefaults] setValue:@"DriverSide" forKey:@"Queue"];

    
    if (fromSplash)
    {
        [self updateDriverTokon];
    }
    self.riderImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.riderImageView.layer.borderWidth = 2.5;
    self.riderImageView.layer.cornerRadius = 10.0;
    [self.riderImageView setClipsToBounds:YES];
    self.nameLbl.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"fullName"]];

    picUrl=[[NSUserDefaults standardUserDefaults]valueForKey:@"picUrl"];
    if ([picUrl isEqualToString:@""]) {
        self.riderImageView.image = [UIImage imageNamed:@"dummy_user.png"];
    }
    else{
        UIActivityIndicatorView *objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        objactivityindicator.center = CGPointMake((self.riderImageView.frame.size.width/2),(self.riderImageView.frame.size.height/2));
        [self.riderImageView addSubview:objactivityindicator];
        [objactivityindicator startAnimating];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
            NSURL *imageURL=[NSURL URLWithString:[picUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
            UIImage *imgData=[UIImage imageWithData:tempData];
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               if (tempData!=nil && [imgData isKindOfClass:[UIImage class]])
                               {
                                   [self.riderImageView setImage:imgData];
                                   //  [UserImageDict setObject:imgData forKey:UrlString];
                                   [objactivityindicator stopAnimating];
                                   
                               }
                               else
                               {
                                   //[self.imageview setImage:[UIImage imageNamed:@"dummy_user.png"]];
                                   [objactivityindicator stopAnimating];
                                   
                               }
                           });
        });
    }
    
    
    DriverSwitchBtn.on=YES;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    current_longitude=self.locationManager.location.coordinate.longitude;
    current_latitude=self.locationManager.location.coordinate.latitude;

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:current_latitude longitude:current_longitude zoom:15];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        mapView = [GMSMapView mapWithFrame: CGRectMake(10,77, 300, 481) camera:camera];
    }
    
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        mapView = [GMSMapView mapWithFrame: CGRectMake(10,75, 300, 400) camera:camera];
    }
    
    else{
        mapView = [GMSMapView mapWithFrame: CGRectMake(22,168, 720, 732) camera:camera];
    }
    mapView.settings.compassButton = YES;
    mapView.settings.myLocationButton = YES;
    mapView.delegate = self;
    mapView.myLocationEnabled = YES;
    mapView.layer.borderColor = [UIColor whiteColor].CGColor;
    mapView.layer.borderWidth = 1.5;
    
    mapView.layer.cornerRadius = 5.0;
    
    [mapView setClipsToBounds:YES];
    [self.view addSubview:mapView];
    [self.view bringSubviewToFront:self.disablImg];
    [mapView bringSubviewToFront:self.disablImg];
    marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(current_latitude ,current_longitude );
    marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
    marker.map = mapView;
    [self.view setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    [self.headerView setBackgroundColor:[UIColor colorWithRed:(3.0 / 255.0) green:(15.0 / 255.0) blue:(51.0 / 255.0) alpha:1]];
    [self.headerLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:30]];
    [self.riderNameLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
    [self.riderDistanceLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:14]];
    [self.riderEndLocTxtView setFont:[UIFont fontWithName:@"Myriad Pro" size:18]];
    [self.riderStartLocTxtView setFont:[UIFont fontWithName:@"Myriad Pro" size:18]];
    [self.riderSuggestdFareLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
    [self.riderActualFareLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
    self.riderStartLocTxtView.textColor=[UIColor colorWithRed:34/255.0 green:139/255.0 blue:34/255.0 alpha:1];
    self.riderEndLocTxtView.textColor=[UIColor colorWithRed:205/255.0 green:92/255.0 blue:92/255.0 alpha:1];
    [self.requestsBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:18]];
    [self.myQueueBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:18]];
    [self.helpBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:18]];
    [self.viewRidesBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:18]];
    [self.paymentsBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:18]];

    [self.driverBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:18]];
    [self.driverModeLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:18]];
    [self.nameLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:11]];

    riderBasicInfoBackView.layer.borderColor = [UIColor grayColor].CGColor;
   // riderBasicInfoBackView.layer.borderWidth = 1.5;
    riderBasicInfoBackView.layer.cornerRadius = 10.0;
    //[riderBasicInfoBackView setClipsToBounds:YES];
    
    riderLocatioInfoBackView.layer.borderColor = [UIColor whiteColor].CGColor;
    //riderLocatioInfoBackView.layer.borderWidth = 1.5;
    riderLocatioInfoBackView.layer.cornerRadius = 10.0;
  //  [riderLocatioInfoBackView setClipsToBounds:YES];
    
    
    activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        activityIndicatorObject.center = CGPointMake(160, 190);
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        activityIndicatorObject.center = CGPointMake(160, 190);
        // this is iphone 4 xib
    }
    else
    {
        activityIndicatorObject.center = CGPointMake(374, 412);
    }
    activityIndicatorObject.color=[UIColor grayColor];
    [self.view addSubview:activityIndicatorObject];

    
    [self fetchPendingRequests];
 
    [self.requestTable setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:51/255.0 alpha:1]];
    self.requestTable.layer.cornerRadius = 8;

    sideView.frame=CGRectMake(0, 66, 151, 501);
    [self.view addSubview:sideView];
    sideView.hidden=YES;
    
    StartRide.frame=CGRectMake(60, 510, 199, 30);
    [self.view addSubview:StartRide];
    StartRide.hidden=YES;

}
-(void)updateDriverTokon
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    webservice =5;
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"Driver"],@"Role",driverIdStr,@"DriverId",RiderIdStr,@"RiderId",[NSString stringWithFormat:@"%@",[defaults valueForKey:@"user_UDID_Str"]],@"DeviceUDId",[NSString stringWithFormat:@"%@",[defaults valueForKey:@"registrationID"]],@"TokenID",[NSString stringWithFormat:@"ios"],@"Trigger",nil];
    
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/RegisterDevice",Kwebservices]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    
    NSLog(@"Request:%@",urlString);
    //  data = [NSData dataWithContentsOfURL:urlString];
    
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



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [mapView clear];

    current_longitude=newLocation.coordinate.longitude;
    current_latitude=newLocation.coordinate.latitude;
    CLLocationCoordinate2D local;
    local= CLLocationCoordinate2DMake(current_latitude, current_longitude);
    marker.position = local;
    marker.map = mapView;
    GMSCameraUpdate *cams = [GMSCameraUpdate setTarget:local];
    [mapView animateWithCameraUpdate:cams];

}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation*currentLocation;
    
    if (locations.count>0) {
        currentLocation = [locations objectAtIndex:0];
    }
    NSLog(@"Detected Location : %f, %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
    [mapView clear];
    current_longitude=currentLocation.coordinate.longitude;
    current_latitude=currentLocation.coordinate.latitude;
    CLLocationCoordinate2D local;
    local= CLLocationCoordinate2DMake(current_latitude, current_longitude);
    marker.position = local;
    marker.map = mapView;
    GMSCameraUpdate *cams = [GMSCameraUpdate setTarget:local];
    [mapView animateWithCameraUpdate:cams];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self fetchPendingRequests];
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self
               action:@selector(BackButtonAction:)
     forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(10, 27, 50, 30);
    [self.view addSubview:backButton];
    backButton.hidden=YES;
    if ([modeType isEqualToString:@"rider"])
    {
        self.requestTable.hidden=NO;
        self.passangerModeBtn.hidden=YES;
        backButton.hidden=NO;
    }
    timer= [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(SetDriverModeOnToServer) userInfo:nil repeats:YES];
    // Set Driver Mode To On
}

#pragma mark - Back Button Action

-(IBAction)BackButtonAction:(id)sender
{
    
    if ([modeType isEqualToString:@"rider"])
    {
        if (self.riderDetailView.hidden==YES)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        self.passangerModeBtn.hidden=NO;
        backButton.hidden=YES;
    }

    StartRide.hidden=YES;
    AcceptBtn.hidden=NO;
    RejectBtn.hidden=NO;
    
    [[NSUserDefaults standardUserDefaults]setValue:@"requests" forKey:@"RequestType"];
    if(self.riderDetailView.hidden==NO)
    {
        self.riderDetailView.hidden=YES;
        self.requestTable.hidden=NO;
    }
    
    else if (self.requestTable.hidden==YES) {
        self.requestTable.hidden=NO;
    }
    else{
        // self.requestTable.hidden=YES;
    }
}

#pragma mark  - Fetch Request From Server

-(void)fetchPendingRequests
{
    StartRide.hidden=YES;

    webservice=1;
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"Driver",@"Role",driverIdStr,@"Id",@"requests",@"Trigger",nil];
    jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/FetchPendingRideRequests",Kwebservices]];
    [self postWebservices];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Request Button Action

- (IBAction)requestsBtn:(id)sender
{
    self.numRequests.text=@"";

    [timer invalidate];
    [timer2 invalidate];
    DriverRequestAndQueueViewController*ViewObj;
    

    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        ViewObj = [[DriverRequestAndQueueViewController alloc] initWithNibName:@"DriverRequestAndQueueViewController" bundle:nil];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        ViewObj = [[DriverRequestAndQueueViewController alloc] initWithNibName:@"DriverRequestAndQueueViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }
    
    ViewObj.RequestType=@"requests";
    ViewObj.GetDriverId=driverIdStr;
    [self.locationManager stopUpdatingLocation];
    [self.navigationController pushViewController:ViewObj animated:YES];
    [self HideAndShowSideView];
    
}

- (IBAction)helpBtn:(id)sender {
    [timer invalidate];
    [timer2 invalidate];

    HelpViewController*helpVc;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        helpVc = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        helpVc = [[HelpViewController alloc] initWithNibName:@"HelpViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }
    
    
    
    [self.navigationController pushViewController: helpVc animated:YES];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [sideView.layer addAnimation:transition forKey:nil];
    sideView.hidden=YES;
    return ;
}

#pragma mark - My Queue Button Action

-(IBAction)MyQueueButtonAction:(id)sender
{
    [timer invalidate];
    [timer2 invalidate];
    DriverRequestAndQueueViewController*ViewObj;
    
  //  HelpViewController*helpVc;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        ViewObj = [[DriverRequestAndQueueViewController alloc] initWithNibName:@"DriverRequestAndQueueViewController" bundle:nil];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        ViewObj = [[DriverRequestAndQueueViewController alloc] initWithNibName:@"DriverRequestAndQueueViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }
    

    
    ViewObj.RequestType=@"queue";
    ViewObj.GetDriverId=driverIdStr;
     [self.locationManager stopUpdatingLocation];
    [self.navigationController pushViewController:ViewObj animated:YES];
    [self HideAndShowSideView];


}

#pragma mark - Start Ride Button Action

-(IBAction)StartRideButtonAction:(id)sender
{
    
}

#pragma mark - Side View Action

-(void)HideAndShowSideView
{
    if (sideView.hidden==YES)
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [sideView.layer addAnimation:transition forKey:nil];
        
        // [sideView addSubview:self.view];
        sideView.hidden=NO;
        return ;
    }
    else
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [sideView.layer addAnimation:transition forKey:nil];
        sideView.hidden=YES;
        return ;
    }
}

#pragma mark - Alert View Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex{
    
    if (alertView.tag==2)
    {
        if (buttonIndex==1)
        {
            [self fetchPendingRequests];

        }
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
    [self.activityIndicatorObject stopAnimating];
    self.view.userInteractionEnabled=YES;
    self.disablImg.hidden=YES;
    
      UIAlertView *alert;
    if (webservice==1)
    {
          alert=[[UIAlertView alloc]initWithTitle:@"Rapid Ride" message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Try Again", nil];
        alert.tag=2;
    }
    else{
          alert=[[UIAlertView alloc]initWithTitle:@"Rapid Ride" message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    }
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
    [self.activityIndicatorObject stopAnimating];
    self.view.userInteractionEnabled=YES;
    self.disablImg.hidden=YES;
    
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    
    NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
    
    if (webservice==1)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result" ]intValue];
            if (result ==1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
               // [alert show];
            }
            else
            {
                requestListArray=nil;
                requestListArray=[userDetailDict valueForKey:@"PendingRequestList"];
                
                if (requestListArray.count>0)
                {
                    self.numRequests.text=[NSString stringWithFormat:@"%lu",(unsigned long)requestListArray.count];
                }
                else{
                     self.numRequests.text=[NSString stringWithFormat:@""];
                }
            }
            [self.requestTable reloadData];
        }
        [self SetDriverModeOnToServer];

    }
    else if(webservice==2)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
           int result=[[userDetailDict valueForKey:@"result" ]intValue];
            if (result==1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                self.riderDetailView.hidden=YES;
                [self fetchPendingRequests];
            }
        }
    }
    else if (webservice==3)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result" ]intValue];
            if (result==1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
            }
            else
            {
                requestListArray=nil;

                requestListArray=[userDetailDict valueForKey:@"PendingRequestList"];
                if (requestListArray.count>0)
                {
                }
                else{
                    self.numRequests.text=[NSString stringWithFormat:@""];
                }
            }
            [self.requestTable reloadData];
        }
    }
    else if(webservice==4)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result" ]intValue];
            if (result ==1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                // [alert show];
            }
            else
            {
                
                NSLog(@"%@",userDetailDict);
            }
        }
    }
    if (webservice == 5 )
    {
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        SBJsonParser *json = [[SBJsonParser alloc] init];
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            UIAlertView *alert;
            
            int result=[[userDetailDict valueForKey:@"result" ]intValue];
            if (result==1)
            {
                alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
            }
            else if(result ==0)
            {
                alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
            }
            // [alert show];
        }
    }
}


#pragma mark - Slider Button Action

- (IBAction)passangerMode:(id)sender
{
 
    [self.view bringSubviewToFront:sideView];
    [StartRide bringSubviewToFront:sideView];
    
    if (sideView.hidden==YES)
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [sideView.layer addAnimation:transition forKey:nil];
        sideView.hidden=NO;
        return ;
    }
    else
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [sideView.layer addAnimation:transition forKey:nil];
        sideView.hidden=YES;
        return ;
    }
}

#pragma mark - Accept Button Action

- (IBAction)acceptRequest:(id)sender {
    webservice=2;
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:reqId,@"TripId",@"Accepted",@"Status",nil];
    jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    
   urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/AcceptOrRejectRequest",Kwebservices]];
    [self.activityIndicatorObject startAnimating];
    self.view.userInteractionEnabled=NO;
    self.disablImg.hidden=NO;
    
    [self postWebservices];

}

#pragma mark - Reject Button Action

- (IBAction)rejectRequest:(id)sender {
    
    self.riderDetailView.hidden=YES;
    [self fetchPendingRequests];

}

#pragma mark - Touch Delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

#pragma mark - Driver ON/OFF Switch Action

- (IBAction)DriverSwitchButtonAction:(id)sender
{
    if (DriverSwitchBtn.on==NO)
    {
        // Set Driver Mode To Off
        [timer invalidate];
        [timer2 invalidate];

        [self SetDriverModeOffToServer];
        
        StartRide.hidden=YES;
          DriverSwitchBtn.on=NO;
        MapViewController*mapVc;
        
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480)
        {
            mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController_iphone4" bundle:nil];
            // this is iphone 4 xib
        }


        [self.locationManager stopUpdatingLocation];
         [self.navigationController pushViewController:mapVc  animated:NO];
    }
}

#pragma mark - Post JSON Web Service

-(void)postWebservices
{
    
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

#pragma mark - Set Diver Status On To Server

-(void)SetDriverModeOnToServer
{
    webservice=4;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:RiderIdStr,@"RiderId",driverIdStr,@"DriverId",@"Activate",@"Trigger",[NSString stringWithFormat:@"%f",current_longitude],@"Longitude",[NSString stringWithFormat:@"%f",current_latitude],@"Latitude",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);

    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/SwitchBetweenMode",Kwebservices]];

    [self postWebservices];
}

#pragma mark - Set Diver Status Off To Server

-(void)SetDriverModeOffToServer
{
    webservice=4;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:RiderIdStr,@"RiderId",driverIdStr,@"DriverId",@"Busy",@"Trigger",[NSString stringWithFormat:@"%f",current_longitude],@"Longitude",[NSString stringWithFormat:@"%f",current_latitude],@"Latitude",nil];
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/SwitchBetweenMode",Kwebservices]];

    [self postWebservices];
    
}
- (IBAction)paymentsBtn:(id)sender
{
    [timer invalidate];
    [timer2 invalidate];

    viewRideUrl=[NSString stringWithFormat:@"http://appba.riderapid.com/dpayment/?driverid=%@",driverIdStr];
    
    
    AboutUsViewController *aboutus;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        aboutus = [[AboutUsViewController alloc]initWithNibName:@"AboutUsViewController" bundle:nil];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        aboutus = [[AboutUsViewController alloc]initWithNibName:@"AboutUsViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }
    
    
    aboutus.linkUrl=viewRideUrl;
    [self.navigationController pushViewController:aboutus  animated:YES];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [sideView.layer addAnimation:transition forKey:nil];
    sideView.hidden=YES;
    return ;
}

- (IBAction)viewRidesBtn:(id)sender {
    [timer invalidate];
    [timer2 invalidate];

    viewRideUrl=[NSString stringWithFormat:@"http://appba.riderapid.com/driver_report/?driverid=%@",driverIdStr];
    
    AboutUsViewController *aboutus;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        aboutus = [[AboutUsViewController alloc]initWithNibName:@"AboutUsViewController" bundle:nil];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        aboutus = [[AboutUsViewController alloc]initWithNibName:@"AboutUsViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }
    aboutus.linkUrl=viewRideUrl;
    [self.navigationController pushViewController:aboutus  animated:YES];

    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [sideView.layer addAnimation:transition forKey:nil];
    sideView.hidden=YES;
    return ;
}
@end
