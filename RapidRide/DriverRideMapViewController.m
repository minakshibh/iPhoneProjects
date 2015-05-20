//
//  DriverRideMapViewController.m
//  RapidRide
//
//  Created by Br@R on 13/11/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import "DriverRideMapViewController.h"
#import "SBJSON.h"
#import "JSON.h"
#import "MapViewController.h"
#import "Base64.h"
#import <CoreLocation/CoreLocation.h>
#import "DrawDriverRouteViewController.h"

@interface DriverRideMapViewController ()

@end

@implementation DriverRideMapViewController
@synthesize current_latitude,current_longitude,GetTripId,activityIndicatorObject,getDriverId,nameLbl,GetNameStr
,getDesignationStr,getETAstr,getFareStr,getpickUptimrStr,getimgeUrl,getVehicleType,FromNotification,ratingStr,startLong,startLat,endlat,endLong,endLocationString,handicappedStr,arrivedBtn,Disttimer,getEstimatedMilesStr,Disttimer1;


- (void)viewDidLoad
{
    [[NSUserDefaults standardUserDefaults ]removeObjectForKey:@"RideDetailView"];

    [super viewDidLoad];
    //FromNotification=YES;
    showOnce=YES;
   
    arrivedCall=NO;
    phNo = @"619-600-5080";
   
    flag=0;
    
    getDriverId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"driverid"];
    
    basicInfoBackView.layer.borderColor = [UIColor clearColor].CGColor;
    basicInfoBackView.layer.borderWidth = 2.5;
    basicInfoBackView.layer.cornerRadius = 5.0;
    [basicInfoBackView setClipsToBounds:YES];
    
    footerBackView.layer.borderColor = [UIColor clearColor].CGColor;
    footerBackView.layer.borderWidth = 2.5;
    footerBackView.layer.cornerRadius = 6.0;
    [footerBackView setClipsToBounds:YES];
    
    
    nameLbl.text=GetNameStr;
    
    self.designationTxtView.text=getDesignationStr;
    fareValueLbl.text=[NSString stringWithFormat:@"%@",getFareStr] ;
    [[NSUserDefaults standardUserDefaults] setValue:getFareStr forKey:@"FareValueForTip"];

    etaTimeLbl.text=[NSString stringWithFormat:@"%@",getETAstr];
    
    pickupDteTimeLbl.text=getpickUptimrStr;
    self.ratingLbl.text=[NSString stringWithFormat:@"Rating : %d",[ratingStr intValue]];
    trigger=GetTripId;
    
    if ( getETAstr.length==0)
    {
        etaLbl.hidden=YES;
        etaTimeLbl.hidden=YES;

    }
    else {
        etaLbl.hidden=NO;
        etaTimeLbl.hidden=NO;
    }

    if ([getimgeUrl isEqualToString:@""]) {
        ImageView.image = [UIImage imageNamed:@"dummy_user.png"];
    }
    else{
        UIActivityIndicatorView *objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        objactivityindicator.center = CGPointMake((ImageView.frame.size.width/2),(ImageView.frame.size.height/2));
        [ImageView addSubview:objactivityindicator];
        [objactivityindicator startAnimating];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
            NSURL *imageURL=[NSURL URLWithString:[getimgeUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
            UIImage *imgData=[UIImage imageWithData:tempData];
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               if (tempData!=nil && [imgData isKindOfClass:[UIImage class]])
                               {
                                   [ImageView setImage:imgData];
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
    
    NSString *str=[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue"];
     [[NSUserDefaults standardUserDefaults]setValue:@"RideStart" forKey:@"View"];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue"] isEqualToString:@"RiderSide"])
    {
        [fareValueLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:15]];
        
        
        self.GPSbtn.hidden=YES;
        [self.menuView  setFrame:CGRectMake(self.menuView.frame.origin.x, self.menuView.frame.origin.y, self.menuView.frame.size.width,85)];
        self.cancelRideBtn.hidden=YES;
       // self.menuBtn.hidden=YES;
        self.menuView.hidden=YES;
        arrivedBtn.hidden=YES;
        startRideBtn.hidden=YES;
        endRideBtn.hidden=YES;
    }
    else
    {
        [fareValueLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:13]];

        self.cancelRideBtn.hidden=NO;
        self.GPSbtn.hidden=NO;
        [self.menuView  setFrame:CGRectMake(self.menuView.frame.origin.x, self.menuView.frame.origin.y, self.menuView.frame.size.width,125)];
        self.menuView.hidden=YES;
        self.menuBtn.hidden=NO;
        arrivedBtn.hidden=NO;
        startRideBtn.hidden=YES;
        endRideBtn.hidden=YES;
    }
    
    activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        activityIndicatorObject.center = CGPointMake(160, 190);
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480)
    {
        activityIndicatorObject.center = CGPointMake(160, 190);
        // this is iphone 4 xib
    }
    else
    {
        activityIndicatorObject.center = CGPointMake(374, 412);
    }
    activityIndicatorObject.color=[UIColor grayColor];
  

    [self.view setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    [self.headerView setBackgroundColor:[UIColor colorWithRed:(3.0 / 255.0) green:(15.0 / 255.0) blue:(51.0 / 255.0) alpha:1]];
    [self.headerLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:30]];
    [ arrivedBtn setBackgroundColor:[UIColor colorWithRed:(204.0 / 255.0) green:(204.0 / 255.0) blue:(0.0 / 255.0) alpha:1]];

    [startRideBtn setBackgroundColor:[UIColor colorWithRed:(0 / 255.0) green:(102.0 / 255.0) blue:(0.0 / 255.0) alpha:1]];
    [endRideBtn setBackgroundColor:[UIColor colorWithRed:(255.0 / 255.0) green:(51.0 / 255.0) blue:(51.0 / 255.0) alpha:1]];
    [fareLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:13]];

    [arrivedBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:15]];
    [startRideBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:15]];
    [endRideBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:15]];

    [self.ratingLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:10]];

    [nameLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:11]];
    [self.designationTxtView setFont:[UIFont fontWithName:@"Myriad Pro" size:11]];
    [pickupDteTimeLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:10]];
    [pickUpLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:11]];
    


    [etaTimeLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:12]];
    [etaLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:13]];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    current_longitude=self.locationManager.location.coordinate.longitude;
    current_latitude=self.locationManager.location.coordinate.latitude;
    
    NSLog(@"%f %f",current_latitude,current_longitude);
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:current_latitude longitude:current_longitude zoom:15];
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(10,130, 300, 370) camera:camera];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        mapView = [GMSMapView mapWithFrame: CGRectMake(10,120, 300, 310) camera:camera];
    }

    
    mapView.settings.compassButton = YES;
    mapView.settings.myLocationButton = YES;
    mapView.delegate = self;
    mapView.myLocationEnabled = YES;
    [self.view addSubview:mapView];
    mapView.myLocationEnabled=YES;
    marker1=[[GMSMarker alloc]init];
    marker1.position=CLLocationCoordinate2DMake(current_latitude, current_longitude);
    marker1.groundAnchor=CGPointMake(0.5,0.5);
    marker1.map=mapView;
    
    
    marker2=[[GMSMarker alloc]init];
    marker2.icon=[UIImage imageNamed:@"suv_car.png"];
    marker2.groundAnchor=CGPointMake(0.5,0.5);
    marker2.map=mapView;
    endMarker=[[GMSMarker alloc]init];
    endMarker.position=CLLocationCoordinate2DMake([endlat floatValue], [endLong floatValue]);
    endMarker.icon=[GMSMarker markerImageWithColor:[UIColor redColor]];
    endMarker.groundAnchor=CGPointMake(0.5,0.5);
    endMarker.map=mapView;
    endMarker.title=@"Destination Address";
    endMarker.snippet=[NSString stringWithFormat:@"%@",endLocationString];
    
    
    startMarker=[[GMSMarker alloc]init];
    startMarker.position=CLLocationCoordinate2DMake([startLat floatValue], [startLong floatValue]);
    startMarker.icon=[GMSMarker markerImageWithColor:[UIColor greenColor]];
    startMarker.groundAnchor=CGPointMake(0.5,0.5);
    startMarker.map=mapView;
    startMarker.title=@"Pickup Address";
    startMarker.snippet=[NSString stringWithFormat:@"%@",getDesignationStr];

    
    if ([getVehicleType isEqualToString:@"1"])
    {
        marker2.icon=[UIImage imageNamed:@"suv_car.png"];
        marker1.icon=[UIImage imageNamed:@"suv_car.png"];
    }
    else if ([getVehicleType isEqualToString:@"2"])
    {
        marker2.icon=[UIImage imageNamed:@"xl_car.png" ];
        marker1.icon=[UIImage imageNamed:@"xl_car.png"];
    }
    else if ([getVehicleType isEqualToString:@"3"])
    {
        marker2.icon=[UIImage imageNamed:@"exec_car.png" ];
        marker1.icon=[UIImage imageNamed:@"exec_car.png"];
    }
    else if ([getVehicleType isEqualToString:@"4"])
    {
        marker2.icon=[UIImage imageNamed:@"suv_car.png" ];
        marker1.icon=[UIImage imageNamed:@"suv_car.png"];
    }
    else if ([getVehicleType isEqualToString:@"5"])
    {
        marker2.icon=[UIImage imageNamed:@"lux_car.png" ];
        marker1.icon=[UIImage imageNamed:@"lux_car.png"];
    }
    if ([handicappedStr isEqualToString:@"1"])
    {
        marker2.icon=[UIImage imageNamed:@"small_carblue.png" ];
        marker1.icon=[UIImage imageNamed:@"small_carblue.png"];
    }
    
    
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary* dataDict=[[NSMutableDictionary alloc]init];
    
    dataDict=[userdefaults valueForKey: @"riderInfo"];
    
    NSString* handicapdStr=[NSString stringWithFormat:@"%@",[dataDict valueForKey:@"handicap"]];
    
    
    if ([handicapdStr isEqualToString:@"1"])
    {
      marker2.icon=[UIImage imageNamed:@"small_carblue.png" ];
    }
    
      [self.disablImg addSubview:activityIndicatorObject];
    
    [self.view bringSubviewToFront:self.menuView];
    [mapView bringSubviewToFront:self.menuView];
    
    [self.view bringSubviewToFront:self.disablImg];
    [mapView bringSubviewToFront:self.disablImg];
    
    [self.view bringSubviewToFront:basicInfoBackView];
    [mapView bringSubviewToFront:basicInfoBackView];

    [self.view bringSubviewToFront:nameLbl];
    [mapView bringSubviewToFront:nameLbl];
    [self.view bringSubviewToFront:self.ratingLbl];
    [mapView bringSubviewToFront:self.ratingLbl];
    [self.view bringSubviewToFront:self.designationTxtView];
    [mapView bringSubviewToFront:self.designationTxtView];
    
    [self.view bringSubviewToFront:pickupDteTimeLbl];
    [mapView bringSubviewToFront:pickupDteTimeLbl];
    [self.view bringSubviewToFront:pickUpLbl];
    [mapView bringSubviewToFront:pickUpLbl];
    [self.view bringSubviewToFront:ImageView];
    [mapView bringSubviewToFront:ImageView];
    [self.view bringSubviewToFront:self.menuView];
    [mapView bringSubviewToFront:self.menuView];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue"] isEqualToString:@"RiderSide"])
    {
        if (FromNotification)
        {
            [self GettripData];
        }
        else{
            [self GetDriverLatitudeAndLongitude];
            gtimer4= [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(GetDriverLatitudeAndLongitude) userInfo:nil repeats:YES];
        }
    }
    else
    {
        if (!FromNotification)
        {
            [self updateDriverLocation];
            trigger=@"second";
            timer5 = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(updateDriverLocation) userInfo:nil repeats:YES];
        }
        else{
            [self updateDriverLocation];
            trigger=@"second";
            timer5 = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(updateDriverLocation) userInfo:nil repeats:YES];

             [self GettripData];
        }
    }
}


#pragma mark - Get Driver Latitude and Longitude

-(void)GetDriverLatitudeAndLongitude
{
    webservice=4;
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:getDriverId,@"DriverId",GetTripId,@"TripId",nil];
    jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetDriverLocation",Kwebservices]];
    [self postWebservices];
    
}

-(void)DrawPathOnMap
{
    rectangle.map=nil;
    
    GMSMutablePath *path = [GMSMutablePath path];
    [path addCoordinate:CLLocationCoordinate2DMake(@(oldLat).doubleValue,@(oldLong).doubleValue)];
    [path addCoordinate:CLLocationCoordinate2DMake(@(current_latitude).doubleValue,@(current_longitude).doubleValue)];
    
    marker2.position=CLLocationCoordinate2DMake(current_latitude, current_longitude);
    
    GMSCameraUpdate *cams = [GMSCameraUpdate setTarget:CLLocationCoordinate2DMake(current_latitude, current_longitude)];
    [mapView animateWithCameraUpdate:cams];
    
    rectangle = [GMSPolyline polylineWithPath:path];
    rectangle.strokeWidth = 8.f;
    rectangle.strokeColor=[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1];
    rectangle.map = mapView;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    [mapView clear];
    endMarker.position=CLLocationCoordinate2DMake([endlat floatValue], [endLong floatValue]);
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    current_longitude=newLocation.coordinate.longitude;
    current_latitude=newLocation.coordinate.latitude;
    CLLocationCoordinate2D local;
    local= CLLocationCoordinate2DMake(current_latitude, current_longitude);
    marker.position = local;
    marker.map = mapView;
    GMSCameraUpdate *cams = [GMSCameraUpdate setTarget:local zoom:15];
    [mapView animateWithCameraUpdate:cams];
    
    marker1.position=CLLocationCoordinate2DMake(current_latitude, current_longitude);
    
    if ([getVehicleType isEqualToString:@"1"])
    {
        marker.icon=[UIImage imageNamed:@"suv_car.png"];
    }
    else if ([getVehicleType isEqualToString:@"2"])
    {
        marker.icon=[UIImage imageNamed:@"xl_car.png" ];
    }
    else if ([getVehicleType isEqualToString:@"3"])
    {
        marker.icon=[UIImage imageNamed:@"exec_car.png" ];
    }
    else if ([getVehicleType isEqualToString:@"4"])
    {
        marker.icon=[UIImage imageNamed:@"suv_car.png" ];
    }
    else if ([getVehicleType isEqualToString:@"5"])
    {
        marker.icon=[UIImage imageNamed:@"lux_car.png" ];
    }
    if ([handicappedStr isEqualToString:@"1"])
    {
        marker.icon=[UIImage imageNamed:@"small_carblue.png" ];
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation*currentLocation;
    if (locations.count>0) {
        currentLocation = [locations objectAtIndex:0];
    }
    current_longitude=currentLocation.coordinate.longitude;
    current_latitude=currentLocation.coordinate.latitude;
    if (flag==0)
    {
        flag=1;
        oldLat=current_latitude;
        oldLong=current_longitude;
    }
    marker1.position=CLLocationCoordinate2DMake(current_latitude, current_longitude);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancelRideBTn:(id)sender {
     self.menuView.hidden=YES;
    webservice=7;
    NSString *role;
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue"] isEqualToString:@"DriverSide"])
    {
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Cancel Ride" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                    @"Rider requested cancel",
                                    @"Rider cancelled donot charge",
                                    @"Send to another driver",
                                    @"Cancel ride",
                                    nil];
        popup.tag = 1;
        [popup showInView:[UIApplication sharedApplication].keyWindow];
    }
    else{
        role=@"rider";
        jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:GetTripId,@"TripId",role,@"Trigger",@"",@"Reason",@"",@"Latitude",@"",@"Longitude",nil];
        jsonRequest = [jsonDict JSONRepresentation];
            
        NSLog(@"jsonRequest is %@", jsonRequest);
            
            
        urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/CancelRide",Kwebservices]];
        [self.activityIndicatorObject startAnimating];
        self.view.userInteractionEnabled=NO;
        self.disablImg.hidden=NO;
        [self postWebservices];
    }
}
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *reasonStr=@"";
    switch (popup.tag)
    {
        case 1:
        {
            switch (buttonIndex)
            {
                    
                case 0:
                    reasonStr=@"rider requested cancel";
                    [self cancelDriverRide:reasonStr];
                    break;
                case 1:
                    reasonStr=@"rider cancelled donot charge";
                    [self cancelDriverRide:reasonStr];
                    break;
                case 2:
                    reasonStr=@"send to another driver";
                    [self cancelDriverRide:reasonStr];
                    break;
                case 3:
                    reasonStr=@"cancel ride";
                    [self cancelDriverRide:reasonStr];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    
}

-(void) cancelDriverRide: (NSString*)reason
{
    CLLocationManager*locationManager = [[CLLocationManager alloc] init];
    
    NSString*curLatStr=[NSString stringWithFormat:@"%f",locationManager.location.coordinate.latitude];
    NSString*curLongStr=[NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude];
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:GetTripId,@"TripId",@"driver",@"Trigger",[reason lowercaseString],@"Reason",curLatStr,@"Latitude",curLongStr,@"Longitude",nil];
    jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/CancelRide",Kwebservices]];
    [self.activityIndicatorObject startAnimating];
    self.view.userInteractionEnabled=NO;
    self.disablImg.hidden=NO;
    [self postWebservices];
    
    
}
- (IBAction)menuBtn:(id)sender {
    
    if (self.menuView.hidden==YES)
    {
         self.menuView.hidden=NO;
        return;
    }
    else{
          self.menuView.hidden=YES;
        return;
    }
  
}

- (IBAction)backBtn:(id)sender {
   
    [timer invalidate];
    [timer1 invalidate];
    [timer4 invalidate];
    [timer5 invalidate];
    [utimer5 invalidate];
    [gtimer4 invalidate];
    [Disttimer1 invalidate];
    [Disttimer invalidate];
    
  
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Arrive  Button Action

- (IBAction)ArrivedBtn:(id)sender
{
    arrivedBtn.hidden=YES;
    startRideBtn.hidden=NO;

    self.menuView.hidden=YES;
      webservice=5;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:GetTripId,@"TripId",[NSString stringWithFormat:@"%f",current_latitude],@"Latitude",[NSString stringWithFormat:@"%f",current_longitude],@"Longitude",nil];
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/ArriveRide",Kwebservices]];
    [self postWebservices];
  
}

#pragma mark - End Ride Button Action

- (IBAction)EndRideAction:(id)sender
{
    self.menuView.hidden=YES;
    UIAlertView *endAlert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Are you sure to end this ride?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    endAlert.tag=4;
    [endAlert show];
    
 }

#pragma mark - Start Ride Button Action

- (IBAction)StartRideAction:(id)sender
{
    self.designationTxtView.text=endLocationString;

    self.menuView.hidden=YES;
    startRideBtn.hidden=YES;
    endRideBtn.hidden=NO;
    [self.view bringSubviewToFront:self.disablImg];
    [mapView bringSubviewToFront:self.disablImg];
    
    webservice=2;
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:GetTripId,@"TripId",[NSString stringWithFormat:@"%f",current_latitude],@"Latitude",[NSString stringWithFormat:@"%f",current_longitude],@"Longitude",nil];
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/StartRide",Kwebservices]];
    [self postWebservices];
    timer1= [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(SaveLatLongToServer) userInfo:nil repeats:YES];
}

- (IBAction)messageBtn:(id)sender {
    self.menuView.hidden=YES;
    MFMessageComposeViewController *messageComposer =[[MFMessageComposeViewController alloc] init];
    if ([MFMessageComposeViewController canSendText]) {
        
        NSString *message = @"";
        [messageComposer setBody:message];
        messageComposer.recipients = [NSArray arrayWithObjects:phNo, nil];
        
        messageComposer.messageComposeDelegate = self;
        [self presentViewController:messageComposer animated:YES completion:nil];
    }

}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Rapid" message:@"Message sent successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
            
        }
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)callBtn:(id)sender {
     self.menuView.hidden=YES;
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"tel://%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
}
#pragma mark - Save Lat Long To Server

-(void)SaveLatLongToServer
{
    webservice=2;
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"second",@"trigger",[NSString stringWithFormat:@"%f",current_longitude],@"longitude",[NSString stringWithFormat:@"%f",current_latitude],@"latitude",getDriverId,@"DriverId",nil];
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/UpdateDriverLocation",Kwebservices]];
    trigger=@"second";
    [self postWebservices];

}


#pragma mark - Post Web Service

-(void)postWebservices
{
    if(webservice!=2)
    {
        if (webservice==4 ||webservice==8) {
            [self.activityIndicatorObject stopAnimating];
            self.view.userInteractionEnabled=YES;
            self.disablImg.hidden=YES;
        }
        else{
            [self.activityIndicatorObject startAnimating];
            self.view.userInteractionEnabled=NO;
            self.disablImg.hidden=NO;

        }
    }
    else{
        [self.activityIndicatorObject stopAnimating];
        self.view.userInteractionEnabled=YES;
        self.disablImg.hidden=YES;
    }
    
    if (webservice==4 )
    {
        [self.activityIndicatorObject stopAnimating];
        self.view.userInteractionEnabled=YES;
        self.disablImg.hidden=YES;
    }
    if (webservice==8)
    {
        [self.activityIndicatorObject stopAnimating];
        self.view.userInteractionEnabled=YES;
        self.disablImg.hidden=YES;

    }
    
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
    [self.activityIndicatorObject stopAnimating];
    self.view.userInteractionEnabled=YES;
    self.disablImg.hidden=YES;
    
    UIAlertView *alert;
    if (webservice==1)
    {
        alert=[[UIAlertView alloc]initWithTitle:@"Rapid Ride" message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    else
    {
        alert=[[UIAlertView alloc]initWithTitle:@"Rapid Ride" message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    }
    [alert show];
    NSLog(@"ERROR with the Connection ");
    webData =nil;
    if (webservice==6)
    {
        [self GettripData];
    }
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
        
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result" ]intValue];
            if (result==0)
            {
             
                RideFinishViewController *ridefinishVC;
                if ([[UIScreen mainScreen] bounds].size.height == 568) {
                    ridefinishVC=[[RideFinishViewController alloc]initWithNibName:@"RideFinishViewController" bundle:nil];
                }
                else if([[UIScreen mainScreen] bounds].size.height == 480)
                {
                    ridefinishVC=[[RideFinishViewController alloc]initWithNibName:@"RideFinishViewController_iphone4" bundle:nil];
                    // this is iphone 4 xib
                }

                ridefinishVC.DriverId=getDriverId;
                ridefinishVC.tripId=GetTripId;
                ridefinishVC.prefVehicle=getVehicleType;
                
              [self.locationManager stopUpdatingLocation];
                [timer invalidate];
                [timer1 invalidate];
                [timer4 invalidate];
                [timer5 invalidate];
                [utimer5 invalidate];
                [gtimer4 invalidate];
                [Disttimer invalidate];
                [Disttimer1 invalidate];
                [self.navigationController pushViewController:ridefinishVC animated:YES];
                
            }
            else
            {
                UIAlertView* alertt=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alertt show];
            }
        
    }
    
    else if (webservice==2)
    {
        
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result" ]intValue];
            if (result ==0)
            {
                
                backBtn.hidden=YES;
            
                if (flag1==0)
                {
                    flag1=1;
                    timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(DrawPathOnMap) userInfo:nil repeats:YES];
                    
                }
                arrivedBtn.hidden=YES;
                startRideBtn.hidden=YES;
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue"] isEqualToString:@"RiderSide"])
                {
                     endRideBtn.hidden=YES;
                    [[NSUserDefaults standardUserDefaults] setObject:getDriverId forKey:@"driverid"];
                    [[NSUserDefaults standardUserDefaults ]setObject:GetTripId forKey:@"tripId"];
                }
                else{
                    endRideBtn.hidden=NO;
                }
                [self CalculateFareAndTime];
                Disttimer= [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(CalculateFareAndTime) userInfo:nil repeats:YES];
            }
        
            else
            {
                UIAlertView* alertt=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alertt show];
            }
    }
    else if (webservice==4)
    {
    
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result" ]intValue];
            if (result ==1)
            {
                
            }
            else
            {
                oldLat=current_latitude;
                oldLong=current_longitude;
                current_latitude=[[userDetailDict valueForKey:@"latitude"] floatValue];
                current_longitude=[[userDetailDict valueForKey:@"longitude"] floatValue];
                [self DrawPathOnMap];
            }
        }
    }
    
    else if (webservice==5)
    {
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        if (result ==0)
        {
            arrivedBtn.hidden=YES;
            startRideBtn.hidden=NO;
            endRideBtn.hidden=YES;
          UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        else
        {
            UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
        }
    }
    else if(webservice==6)
    {
       
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        if (result==1)
        {
            [self GettripData];
        }
        else{
   
            NSString *activeRideDate=[userDetailDict valueForKey:@"trip_accept_date"];
            NSString *arrivedDate=[userDetailDict valueForKey:@"trip_arrive_date"];
            NSString *startRideDate=[userDetailDict valueForKey:@"trip_begin_date"];
          //  colourStr=[userDetailDict valueForKey:@"finder_color"];

            handicappedStr=[userDetailDict valueForKey:@"rider_handicap"];
            getVehicleType=[userDetailDict valueForKey:@"rider_prefer_vehicle"];
            
            if ([getVehicleType isEqualToString:@"1"])
            {
                marker2.icon=[UIImage imageNamed:@"suv_car.png"];
                marker1.icon=[UIImage imageNamed:@"suv_car.png"];
                
            }
            else if ([getVehicleType isEqualToString:@"2"])
            {
                marker2.icon=[UIImage imageNamed:@"xl_car.png" ];
                marker1.icon=[UIImage imageNamed:@"xl_car.png"];
            }
            else if ([getVehicleType isEqualToString:@"3"])
            {
                marker2.icon=[UIImage imageNamed:@"exec_car.png" ];
                marker1.icon=[UIImage imageNamed:@"exec_car.png"];
                
            }
            else if ([getVehicleType isEqualToString:@"4"])
            {
                marker2.icon=[UIImage imageNamed:@"suv_car.png" ];
                marker1.icon=[UIImage imageNamed:@"suv_car.png"];
                
            }
            else if ([getVehicleType isEqualToString:@"5"])
            {
                marker2.icon=[UIImage imageNamed:@"lux_car.png" ];
                marker1.icon=[UIImage imageNamed:@"lux_car.png"];
            }
            if ([handicappedStr isEqualToString:@"1"])
            {
                marker2.icon=[UIImage imageNamed:@"small_carblue.png" ];
                marker1.icon=[UIImage imageNamed:@"small_carblue.png"];
            }
            
            
            
            NSString *distanceStr=[userDetailDict valueForKey:@"trip_miles_est"];
            if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue" ] isEqualToString:@"RiderSide"] )
            {
                GetNameStr=[userDetailDict valueForKey:@"rider_name"];
                ratingStr=[userDetailDict valueForKey:@"rider_rating"];
                getimgeUrl=[userDetailDict valueForKey:@"rider_img"];
                if (arrivedDate.length==0)
                {
                    arrivedBtn.hidden=NO;
                }
                else if (startRideDate.length==0)
                {
                    startRideBtn.hidden=NO;
                }
                else{
                    endRideBtn.hidden=NO;
                }
                startLat=[userDetailDict valueForKey:@"start_lat"];
                startLong=[userDetailDict valueForKey:@"start_lon"];
                endlat=[userDetailDict valueForKey:@"end_lat"];
                endLong=[userDetailDict valueForKey:@"end_lon"];
            }
            else{
                [[NSUserDefaults standardUserDefaults ]removeObjectForKey:@"TripDetail"];
                [[NSUserDefaults standardUserDefaults]setValue:userDetailDict forKey:@"TripDetail"];
                
                GetNameStr=[userDetailDict valueForKey:@"driver_name"];
                ratingStr=[userDetailDict valueForKey:@"driver_rating"];
                getimgeUrl=[userDetailDict valueForKey:@"driver_img"];
                }
            
            getDriverId=[userDetailDict valueForKey:@"driverid"];
            startLat=[userDetailDict valueForKey:@"start_lat"];
            startLong=[userDetailDict valueForKey:@"start_lon"];
            endlat=[userDetailDict valueForKey:@"end_lat"];
            endLong=[userDetailDict valueForKey:@"end_lon"];
           
            startMarker.position=CLLocationCoordinate2DMake([startLat floatValue], [startLong floatValue]);
            endMarker.position=CLLocationCoordinate2DMake([endlat floatValue], [endLong floatValue]);
        
            
            startLocation=[userDetailDict valueForKey:@"starting_loc"];
            NSString *driverId=[userDetailDict valueForKey:@"driverid"];

            endLocationString=[userDetailDict valueForKey:@"ending_loc"];
            
            getDesignationStr=[userDetailDict valueForKey:@"ending_loc"];
            
            
            
            endMarker.title=@"Destination Address";
            endMarker.snippet=[NSString stringWithFormat:@"%@",endLocationString];
            
            
            startMarker.title=@"Pickup Address";
            startMarker.snippet=[NSString stringWithFormat:@"%@",startLocation];

            [self CalculateFareAndTime];
            Disttimer1= [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(CalculateFareAndTime) userInfo:nil repeats:YES];
            
            getFareStr=[userDetailDict valueForKey:@"offered_fare"];
            [[NSUserDefaults standardUserDefaults] setValue:getFareStr forKey:@"FareValueForTip"];
            getETAstr=[userDetailDict valueForKey:@"trip_time_est"];
            getpickUptimrStr=[userDetailDict valueForKey:@"trip_request_pickup_date"];
                        
            if ([getimgeUrl isEqualToString:@""]) {
                ImageView.image = [UIImage imageNamed:@"dummy_user.png"];
            }
            else{
                UIActivityIndicatorView *objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                objactivityindicator.center = CGPointMake((ImageView.frame.size.width/2),(ImageView.frame.size.height/2));
                [ImageView addSubview:objactivityindicator];
                [objactivityindicator startAnimating];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
                    NSURL *imageURL=[NSURL URLWithString:[getimgeUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
                    UIImage *imgData=[UIImage imageWithData:tempData];
                    dispatch_async(dispatch_get_main_queue(), ^
                                   {
                                       if (tempData!=nil && [imgData isKindOfClass:[UIImage class]])
                                       {
                                           [ImageView setImage:imgData];
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

            
            
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"YYYYMMddHHmmss"];
            NSDate *date = [dateFormat dateFromString:getpickUptimrStr];
            
            unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
            NSCalendar* calendar = [NSCalendar currentCalendar];
            
            NSDateComponents* components = [calendar components:flags fromDate:date];
            
            NSDate* dateOnly = [calendar dateFromComponents:components];
            
            
            //Current Date
            NSDate *CurrentDate=[NSDate date];
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
                    getpickUptimrStr=[format stringFromDate:date];
                }
                    break;
                case NSOrderedDescending:
                {
                    NSLog(@"NSOrderedDescending");
                    
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    format.dateFormat = @"dd-MM-yyyy";
                    getpickUptimrStr=[format stringFromDate:date];
                }
                    break;
            }
            
            [[NSUserDefaults standardUserDefaults ]setValue:GetTripId forKey:@"tripId"];
            [[NSUserDefaults standardUserDefaults ]setValue:getDriverId forKey:@"driverid"];

            nameLbl.text=GetNameStr;
            self.ratingLbl.text=[NSString stringWithFormat:@"Rating : %d",[ratingStr intValue]];
         
            
            self.designationTxtView.text=getDesignationStr;
            
            fareValueLbl.text=[NSString stringWithFormat:@"$ %@",getFareStr] ;
            etaTimeLbl.text=[NSString stringWithFormat:@"%@",getETAstr];
            pickupDteTimeLbl.text=getpickUptimrStr;
            if ( getETAstr.length==0)
            {
                etaLbl.hidden=YES;
                etaTimeLbl.hidden=YES;
            }
            else {
                etaLbl.hidden=NO;
                etaTimeLbl.hidden=NO;
            }
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue"] isEqualToString:@"RiderSide"])
            {
                [self GetDriverLatitudeAndLongitude];
                timer4= [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(GetDriverLatitudeAndLongitude) userInfo:nil repeats:YES];
            }
            else{
                [self updateDriverLocation];
                 trigger=@"second";
                utimer5 = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(updateDriverLocation) userInfo:nil repeats:YES];
            }
        }
    }
    
    else if (webservice==7)
    {
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        if (result ==1)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
            [alert show];
        }
        else
        {
            self.cancelRideBtn.hidden=YES;
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            RideFinishViewController *ridefinishVC;
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                ridefinishVC=[[RideFinishViewController alloc]initWithNibName:@"RideFinishViewController" bundle:nil];
            }
            else if([[UIScreen mainScreen] bounds].size.height == 480)
            {
                ridefinishVC=[[RideFinishViewController alloc]initWithNibName:@"RideFinishViewController_iphone4" bundle:nil];
                    // this is iphone 4 xib
            }

            ridefinishVC.DriverId=getDriverId;
            ridefinishVC.tripId=GetTripId;
            ridefinishVC.cancelride=YES;
            [self.locationManager stopUpdatingLocation];
            [timer invalidate];
            [timer1 invalidate];
            [timer4 invalidate];
            [timer5 invalidate];
            [utimer5 invalidate];
            [gtimer4 invalidate];
            [Disttimer1 invalidate];
            [Disttimer invalidate];
            ridefinishVC.prefVehicle=getVehicleType;

            [self.navigationController pushViewController:ridefinishVC animated:YES];
        }
    }
    else if (webservice==8)
    {
        
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        if (result ==1)
        {
            UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        else
        {
            UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
          //  [alert show];
        }
    }
}

#pragma mark - Alert View Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex
{
    
    if (alertView.tag==4 && buttonIndex!= [alertView cancelButtonIndex])
        
    {
        
        
        
        RideFinishViewController *ridefinishVC;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            ridefinishVC=[[RideFinishViewController alloc]initWithNibName:@"RideFinishViewController" bundle:nil];
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480)
        {
            ridefinishVC=[[RideFinishViewController alloc]initWithNibName:@"RideFinishViewController_iphone4" bundle:nil];
            // this is iphone 4 xib
        }
     
        ridefinishVC.DriverId=getDriverId;
        ridefinishVC.tripId=GetTripId;
        ridefinishVC.prefVehicle=getVehicleType;
           rectangle.map=nil;
        [self.locationManager stopUpdatingLocation];
        [timer invalidate];
        [timer1 invalidate];
        [timer4 invalidate];
        [timer5 invalidate];
        [utimer5 invalidate];
        [gtimer4 invalidate];
        [Disttimer invalidate];
        [Disttimer1 invalidate];
        [self.navigationController pushViewController:ridefinishVC animated:YES];
        
     
      
    }
}
-(void)GettripData
{
    webservice=6;
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:GetTripId,@"TripId",nil];
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetDetailsByTripId",Kwebservices]];
    [self postWebservices];

}

-(void)fetchData:(NSData *)data
{
    NSString*estimatedTimeStr;
    NSString *distanceStr;
    NSError *error;
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray* results =[json objectForKey:@"rows"];
    NSLog(@"Data is:%@" ,results);
    
    for (int i = 0;i <[results count]; i++) {
        NSDictionary *result = [results objectAtIndex:i];
        NSLog(@"Data is %@", result);
        
        NSString *statusStr=[[[result objectForKey:@"elements"]valueForKey:@"status"]objectAtIndex:0];
        if ([statusStr isEqualToString:@"ZERO_RESULTS"])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Invalid Request." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.tag=5;
            //[alert show];
            return;
        }
        NSString *tempdistaceStr = [[[[result objectForKey:@"elements"]valueForKey:@"distance"]valueForKey:@"text"]objectAtIndex:0];
        estimatedTimeStr = [[[[result objectForKey:@"elements"]valueForKey:@"duration"]valueForKey:@"text"]objectAtIndex:0];
        
        NSArray *distArray = [distanceStr componentsSeparatedByString:@" "];
        NSString *kmStr=[distArray objectAtIndex:1];
        distanceStr=[distanceStr stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        int minutes;
        if (estimatedTimeStr.length>7)
        {
            NSArray *timeArray = [estimatedTimeStr componentsSeparatedByString:@" "];
            minutes=[[timeArray objectAtIndex:2]intValue];
            int hours=[[timeArray objectAtIndex:0]intValue];
            minutes=hours*60+minutes;
            estimatedTimeStr=[NSString stringWithFormat:@"%d",minutes];
            
        }
        else{
            minutes=[[estimatedTimeStr substringToIndex:2]intValue];
        }
        if (minutes<2 && showOnce)
        {
            arrivedCall=YES;
            self.menuView.hidden=YES;
            webservice=5;
            
            jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:GetTripId,@"TripId",[NSString stringWithFormat:@"%f",current_latitude],@"Latitude",[NSString stringWithFormat:@"%f",current_longitude],@"Longitude",nil];
            jsonRequest = [jsonDict JSONRepresentation];
            NSLog(@"jsonRequest is %@", jsonRequest);
            urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/ArriveRide",Kwebservices]];
            [self postWebservices];
            showOnce=NO;
        }
    }
}

-(void) updateDriverLocation
{
    if (arrivedBtn.hidden==NO)
    {
        NSString *url=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%f,%f&destinations=%f,%f&mode=driving&language=en-EN&sensor=false",current_latitude,current_longitude,[startLat floatValue],[startLong floatValue]];
        
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *queryUrl = [NSURL URLWithString:url];
        NSLog(@"query url%@",queryUrl);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSData *data = [NSData dataWithContentsOfURL:queryUrl];
            [self fetchData:data];
        });
    }
    webservice=8;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:trigger,@"trigger",[NSString stringWithFormat:@"%f",current_longitude],@"longitude",[NSString stringWithFormat:@"%f",current_latitude],@"latitude",getDriverId,@"DriverId",nil];
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/UpdateDriverLocation",Kwebservices]];
    trigger=@"second";
    [self postWebservices];

}

- (IBAction)GPSbtn:(id)sender
{
    DrawDriverRouteViewController *drawPathView;
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        drawPathView = [[DrawDriverRouteViewController alloc]initWithNibName:@"DrawDriverRouteViewController" bundle:nil];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        drawPathView = [[DrawDriverRouteViewController alloc]initWithNibName:@"DrawDriverRouteViewController_iphone4" bundle:nil];
    }
    
    double endLatLOc;
    double endLongLoc;
    
    if (endRideBtn.hidden==YES)
    {
        endLongLoc=[startLong doubleValue];
        endLatLOc=[startLat doubleValue];
    }
    else
    {
        endLongLoc=[endLong doubleValue];
        endLatLOc=[endlat doubleValue];
    }
    
    
    
    CLLocationManager*locationManager = [[CLLocationManager alloc] init];

    
    double  start_longitude=locationManager.location.coordinate.longitude;
    double start_latitude=locationManager.location.coordinate.latitude;
    
    
    CLLocationCoordinate2D start = { (start_latitude), (start_longitude) };
    CLLocationCoordinate2D end = { (endLatLOc), (endLongLoc) };
    
    NSString *routeString;
    
    BOOL canOpenUrl = [[UIApplication sharedApplication] canOpenURL:
                       [NSURL URLWithString:@"comgooglemaps://"]];
    
    if(canOpenUrl)
        routeString = [NSString stringWithFormat:@"comgooglemaps://?saddr=%f,%f&daddr=%f,%f",start.latitude,start.longitude,end.latitude,end.longitude];
    else{
        routeString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",start.latitude,start.longitude,end.latitude,end.longitude];
    }
    
    NSURL* url1 = [[NSURL alloc] initWithString:[routeString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [[UIApplication sharedApplication] openURL:url1];
 
}




-(void)CalculateFareAndTime
{
    NSString *url=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%f,%f&destinations=%f,%f&mode=driving&language=en-EN&sensor=false",oldLat,oldLong,current_latitude,current_longitude];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *queryUrl = [NSURL URLWithString:url];
    //  NSLog(@"query url%@",queryUrl);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *data = [NSData dataWithContentsOfURL:queryUrl];
        [self fetchFareData:data];
    });
    
}
#pragma mark - Fetch all data of ride

-(void)fetchFareData:(NSData *)data
{
    NSError *error;
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //  NSLog(@"responseString:%@",responseString);
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray* results =[json objectForKey:@"rows"];
    //NSLog(@"Data is:%@" ,results);
    
    for (int i = 0;i <[results count]; i++)
    {
        NSDictionary *result = [results objectAtIndex:i];
        //  NSLog(@"Data is %@", result);
        
        NSString *statusStr=[[[result objectForKey:@"elements"]valueForKey:@"status"]objectAtIndex:0];
        if ([statusStr isEqualToString:@"ZERO_RESULTS"])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:@"Invalid Request." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            //[alert show];
            return;
        }
        NSString *tempdistaceStr = [[[[result objectForKey:@"elements"]valueForKey:@"distance"]valueForKey:@"text"]objectAtIndex:0];
        estimatedTimeStr = [[[[result objectForKey:@"elements"]valueForKey:@"duration"]valueForKey:@"text"]objectAtIndex:0];
        
        distanceStr =[NSString stringWithFormat:@"%@",tempdistaceStr];
        
        NSArray *distArray = [distanceStr componentsSeparatedByString:@" "];
        NSString *kmStr=[distArray objectAtIndex:1];
        distanceStr=[distanceStr stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        
        if( [kmStr caseInsensitiveCompare:@"KM"] == NSOrderedSame )
        {
            distanceStr= [distanceStr stringByReplacingOccurrencesOfString:@"km" withString:@""];
            
            
            estimatedDistance= [distanceStr floatValue]*0.62137*1000;
            estimatedDistance=estimatedDistance/1000;
        }
        else{
            distanceStr= [distanceStr stringByReplacingOccurrencesOfString:@"m" withString:@""];
            
            estimatedDistance= [distanceStr floatValue]* 0.00062137;
        }
        
        
        if (estimatedTimeStr.length>7)
        {
            NSArray *timeArray = [estimatedTimeStr componentsSeparatedByString:@" "];
            int minutes=[[timeArray objectAtIndex:2]intValue];
            int hours=[[timeArray objectAtIndex:0]intValue];
            minutes=hours*60+minutes;
            estimatedTimeStr=[NSString stringWithFormat:@"%d",minutes];
        }
        else
        {
        }
    }
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"estimatedTimeStr"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"estimatedDistance"];
    [[NSUserDefaults standardUserDefaults ]setValue:estimatedTimeStr forKey:@"estimatedTimeStr"];
    [[NSUserDefaults standardUserDefaults ]setValue:[NSString stringWithFormat:@"%f",estimatedDistance] forKey:@"estimatedDistance"];
    
    NSLog(@"estTime==%@",estimatedTimeStr);
    NSLog(@"estDiastanc ==%f",estimatedDistance);
    
    float TimeDiffr=[estimatedTimeStr floatValue]-[getETAstr floatValue];
    float mileDiffr=estimatedDistance -[estimateDistanceStr floatValue];
    
    if (TimeDiffr >=7 || mileDiffr >=1)
    {
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"estimatedTimeStr"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"estimatedDistance"];
    }
}




@end
