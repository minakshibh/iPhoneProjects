//
//  MapViewController.m
//  RapidRide
//
//  Created by Br@R on 08/10/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import "MapViewController.h"
#import "LocationAndPriceDetailViewController.h"
#import "LoginViewController.h"
#import "EditRiderAccountViewController.h"
#import "PaymentViewController.h"
#import "RideFinishViewController.h"
#import "DriverFirstViewViewController.h"
#import "DriverRequestAndQueueViewController.h"
#import "HelpViewController.h"
#import "AboutUsViewController.h"
#import "DriverRideMapViewController.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import <GoogleMaps/GoogleMaps.h>
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Base64.h"
#import "Reachability.h"

#import "SBJSON.h"
#import "JSON.h"


@interface MapViewController ()

@end

@implementation MapViewController
@synthesize locationSearchTxt,location,startLocationStr,destinationLocationStr,cityStr,countryStr,currentAddressStr,locationArray,searchBtn,placesTableView,headerLbl,isStartLoc,isEndLoc,startLongitude,startLatitude,endLongitude,endLattitude,current_latitude,current_longitude,disableImg,activityIndicatorObject,currntFulAdress,sideView,requestRideBtn,destinationLocationNameStr,startLocNameStr,driverModeToggle,distanceFromCurrntLoc,base_fare,price_per_mile,price_per_minute,driverIdStr,driverIdArray,cancelSearchtn,vehicleType,riderDriverIdStr,isOneWay,isVIP,h_total_fare,f_total_fare,isHalfDay,isFullDay,surgeValue,FavDriverListStr,isFavDriver,vehicleTypeTableView,tempVehicleDict,pickupLocationLbl,editBtn,pickupLocationTxt,cancelpickupBtn,seachPickupBtn,pickUpImg,DestinationImg,activeTripId,driverList,minPrice,againDriverIdStr,againVehiclType;

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
    
    NSString *payTripId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tripId"];
     NSString *payView= [[NSUserDefaults standardUserDefaults]valueForKey:@"PayView"];

    if ([payView isEqualToString:@"PayView"] && payTripId.length>0)
    {
        //rating to driver
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue" ] isEqualToString:@"RiderSide"] )
        {
            RideFinishViewController *ridefinishVC;
            
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                ridefinishVC=[[RideFinishViewController alloc]initWithNibName:@"RideFinishViewController" bundle:nil];
            }
            else if([[UIScreen mainScreen] bounds].size.height == 480)
            {
                ridefinishVC=[[RideFinishViewController alloc]initWithNibName:@"RideFinishViewController_iphone4" bundle:nil];
            }
            
            ridefinishVC.FromNotification=YES;
            NSLog(@"reqId : %@",payTripId);
            [[NSUserDefaults standardUserDefaults]setValue:payTripId forKey:@"tripId"];
            [self.navigationController pushViewController:ridefinishVC animated:YES];
        }
    }

    activeTripId=[[NSUserDefaults standardUserDefaults]valueForKey:@"activeTripId"];
    if (activeTripId.length>0)
    {
        popUptimer= [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(activePopUp) userInfo:nil repeats:NO];
    }
    
  
    isDestinationLocMrkr=YES;
    if (startLocationStr.length==0)
    {
        editBtn.hidden=YES;
        pickupLocationLbl.hidden=YES;
    }
    
    searchResults=0;
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"RiderSide" forKey:@"Queue"];

    if (isVIP)
    {
        [self.vipBtn setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    }
    else if (isOneWay)
   {
        [self.oneWayBtn setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
   }
   else{
       [self.oneWayBtn setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
       [self.vipBtn setBackgroundColor:[UIColor clearColor]];
   }

    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary* dataDict=[[NSMutableDictionary alloc]init];
    
    dataDict=[userdefaults valueForKey: @"riderInfo"];
    userIdStr= [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"userid"]];
    [[NSUserDefaults standardUserDefaults ]setValue:userIdStr forKey:@"riderId"];
    handicapdStr=[NSString stringWithFormat:@"%@",[dataDict valueForKey:@"handicap"]];
    riderDriverIdStr=[NSString stringWithFormat:@"%@",[dataDict valueForKey:@"driverid"]];
    
    NSString *driverStatus =[NSString stringWithFormat:@"%@",[dataDict valueForKey:@"driveractive"]];
    if ([driverStatus isEqualToString:@"false"])
    {
        riderDriverIdStr=@"";
    }
    payment_status=[NSString stringWithFormat:@"%@",[dataDict valueForKey:@"payment_status"]];
    [[NSUserDefaults standardUserDefaults] setValue:payment_status forKey:@"payment_status"];
    NSString*  lastNameStr=[NSString stringWithFormat:@"%@.",[[dataDict valueForKey:@"lastname"] substringToIndex:1]];

    NSString *fullName=[NSString stringWithFormat:@"%@ %@",[dataDict valueForKey:@"firstname"],lastNameStr];

    self.nameLbl.text=[NSString stringWithFormat:@"%@",fullName];
    
    [self serviceUdid];
    
   picUrl=[dataDict valueForKey:@"profilepiclocation"];
    


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

    
    isHomeBtn=NO;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.navigator.navigationBarHidden = YES;

    locationArray=[[NSMutableArray alloc]init];
    [self.view setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    [self.headerView setBackgroundColor:[UIColor colorWithRed:(3.0 / 255.0) green:(15.0 / 255.0) blue:(51.0 / 255.0) alpha:1]];
    [self.lowerTabView setBackgroundColor:[UIColor colorWithRed:(3.0 / 255.0) green:(15.0 / 255.0) blue:(51.0 / 255.0) alpha:1]];

    [headerLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:30]];
    [self.oneWayBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:12]];
    [self.vipBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:12]];
    [locationSearchTxt setFont:[UIFont fontWithName:@"Myriad Pro" size:15]];
    [pickupLocationTxt setFont:[UIFont fontWithName:@"Myriad Pro" size:14]];

    [self.logoutBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:18]];
    [self.editBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:18]];
    [self.driverBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:18]];
    [self.paymentBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:18]];
    [self.myQueueBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:18]];
    [self.contactUsBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:18]];
    [self.viewRideBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:18]];

    [pickupLocationLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:14]];
    pickupLocationLbl.numberOfLines=2;
    [self.requestRideBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:12]];
    [editBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:13]];

    [self.vehicleTypleBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:13]];
    [self.requestRideBtn setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    [self.driverModeLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:18]];
    [self.nameLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:11]];

    now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
   // [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    currentTime= [dateFormatter stringFromDate:now];

    [requestRideBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:14]];
    
    vehicleNameArray=[NSArray arrayWithObjects:@"REGULAR",@"XL",@"EXECUTIVE",@"SUV",@"LUXURY", nil];
    
    vehicleImageArray=[[NSArray alloc]initWithObjects:@"small_car.png" ,@"truck_car.png"  ,@"exec_car.png" ,@"suv_car.png",@"lux_car.png",nil];
    
    if (isStartLoc || isEndLoc)
    {
        self.menuBtn.hidden=YES;
        self.backBtn.hidden=NO;
        self.requestRideBtn.hidden=YES;
    }
    else
    {
        isFavDriver=NO;
        self.menuBtn.hidden=NO;
        self.backBtn.hidden=YES;
        self.requestRideBtn.hidden=NO;
        
        
        isOneWay=YES;
        isVIP=NO;
        
    if ([[[NSUserDefaults standardUserDefaults ]valueForKey:@"prefvehicletype"] isEqualToString:@""])
        {
             vehicleType=[dataDict valueForKey:@"prefvehicletype"];
            if ([vehicleType isEqualToString:@""])
            {
                vehicleType =@"1";
            }
            [[NSUserDefaults standardUserDefaults ]setValue:vehicleType forKey:@"prefvehicletype"];
        }
        else{
            vehicleType=[[NSUserDefaults standardUserDefaults ]valueForKey:@"prefvehicletype"];
          
        }
   
        }

    if ([vehicleType isEqualToString:@"2"]) {
        vehicleTypeName=@"XL";
        [self.vehicleTypleBtn setTitle:[NSString stringWithFormat:@"%@",vehicleTypeName] forState:UIControlStateNormal];
        [self.vehiclFlagImage setImage:[UIImage imageNamed:[vehicleImageArray objectAtIndex:1 ]]];
    }
    else if ([vehicleType isEqualToString:@"3"]) {
        vehicleTypeName=@"EXECUTIVE";
        [self.vehicleTypleBtn setTitle:[NSString stringWithFormat:@"%@",vehicleTypeName] forState:UIControlStateNormal];
        [self.vehiclFlagImage setImage:[UIImage imageNamed:[vehicleImageArray objectAtIndex:2 ]]];
    }
    else if ([vehicleType isEqualToString:@"4"]) {
        vehicleTypeName=@"SUV";
        [self.vehicleTypleBtn setTitle:[NSString stringWithFormat:@"%@",vehicleTypeName]  forState:UIControlStateNormal];
        [self.vehiclFlagImage setImage:[UIImage imageNamed:[vehicleImageArray objectAtIndex:3 ]]];
    } else if ([vehicleType isEqualToString:@"5"]) {
        vehicleTypeName=@"LUXURY";
        [self.vehicleTypleBtn setTitle:[NSString stringWithFormat:@"%@",vehicleTypeName]  forState:UIControlStateNormal];
        [self.vehiclFlagImage setImage:[UIImage imageNamed:[vehicleImageArray objectAtIndex:4 ]]];
    }else{
        vehicleTypeName=@"REGULAR";
        [self.vehicleTypleBtn setTitle:[NSString stringWithFormat:@"%@",vehicleTypeName]  forState:UIControlStateNormal];
        [self.vehiclFlagImage setImage:[UIImage imageNamed:[vehicleImageArray objectAtIndex:0 ]]];
    }
    
    
    [driverModeToggle setOn:NO animated:YES];
    placesTableView.layer.borderColor = [UIColor grayColor].CGColor;
    placesTableView.layer.borderWidth = 1.5;
    placesTableView.layer.cornerRadius = 5.0;
    [placesTableView setClipsToBounds:YES];
    
    self.vehicleTypeTableView.layer.borderColor = [UIColor clearColor].CGColor;
    self.vehicleTypeTableView.layer.borderWidth = 1.5;
    self.vehicleTypeTableView.layer.cornerRadius = 10.0;
    [self.vehicleTypeTableView setClipsToBounds:YES];
    
    self.riderImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.riderImageView.layer.borderWidth = 2.5;
    self.riderImageView.layer.cornerRadius = 10.0;
    [self.riderImageView setClipsToBounds:YES];

    NSLog(@"s latitude..%f",startLatitude);
    NSLog(@"s longitude..%f",startLongitude);
    NSLog(@"e latitude..%f",endLattitude);
    NSLog(@"elogitude..%f",endLongitude);
    
    NSLog(@"s address..%@",startLocationStr);
    NSLog(@"d address..%@",destinationLocationStr);
    
    if (isStartLoc)
    {
        locationSearchTxt.text=startLocationStr;
        locationSearchTxt.textColor =[UIColor colorWithRed:(0.0 / 255.0) green:(102 / 255.0) blue:(51 / 255.0) alpha:1];
        //locationSearchTxt.backgroundColor=[UIColor grayColor];
        [locationSearchTxt setFrame:CGRectMake(locationSearchTxt.frame.origin.x, locationSearchTxt.frame.origin.y-32, locationSearchTxt.frame.size.width,  locationSearchTxt.frame.size.height)];
        
        [cancelSearchtn setFrame:CGRectMake(cancelSearchtn.frame.origin.x, cancelSearchtn.frame.origin.y-32, cancelSearchtn.frame.size.width,  cancelSearchtn.frame.size.height)];
        
        [searchBtn setFrame:CGRectMake(searchBtn.frame.origin.x, searchBtn.frame.origin.y-32, searchBtn.frame.size.width,  searchBtn.frame.size.height)];
        DestinationImg.hidden=YES;
        
        pickupLocationTxt.hidden=YES;
        cancelpickupBtn.hidden=YES;
        seachPickupBtn.hidden=YES;
        
        //isDestinationLocMrkr=NO;
        self.goHomeBTn.userInteractionEnabled=NO;
        self.goHomeBTn.hidden=YES;
        locationSearchTxt.placeholder = @"SEARCH PICKUP";
       // [detailViewBtn setTitle:@"DONE" forState:UIControlStateNormal];
        current_longitude=startLongitude;
        current_latitude=startLatitude;
        NSLog(@"currentLattitude..%f",current_latitude);
        NSLog(@"currentLongitude..%f",current_longitude);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        // [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        now = [NSDate date];
        currentTime= [dateFormatter stringFromDate:now];
        jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%f", current_longitude],@"longitude",[NSString stringWithFormat:@"%f", current_latitude],@"latitude",currentTime,@"currenttime",@"10",@"distance",userIdStr,@"riderid",nil];
        [self fetchVehicleList];
    }
    else if (isEndLoc)
    {
        locationSearchTxt.text=destinationLocationStr;
        DestinationImg.hidden=YES;
        [locationSearchTxt setFrame:CGRectMake(locationSearchTxt.frame.origin.x, locationSearchTxt.frame.origin.y-32, locationSearchTxt.frame.size.width,  locationSearchTxt.frame.size.height)];
        
        [cancelSearchtn setFrame:CGRectMake(cancelSearchtn.frame.origin.x, cancelSearchtn.frame.origin.y-32, cancelSearchtn.frame.size.width,  cancelSearchtn.frame.size.height)];
        
        [searchBtn setFrame:CGRectMake(searchBtn.frame.origin.x, searchBtn.frame.origin.y-32, searchBtn.frame.size.width,  searchBtn.frame.size.height)];
        
        
        pickupLocationTxt.hidden=YES;
        cancelpickupBtn.hidden=YES;
        seachPickupBtn.hidden=YES;
        
        editBtn.hidden=YES;
        pickupLocationLbl.hidden=YES;
        self.favDrivrBtn.hidden=YES;
        self.vehiclFlagImage.hidden=YES;
        self.vehicleTypleBtn.hidden=YES;
        self.vipBtn.hidden=YES;
        self.oneWayBtn.hidden=YES;
        self.vipBtn.userInteractionEnabled=NO;
        self.oneWayBtn.userInteractionEnabled=NO;
        //isDestinationLocMrkr=YES;
        self.vehicleTypleBtn.userInteractionEnabled=NO;
        self.goHomeBTn.userInteractionEnabled=YES;
        self.goHomeBTn.hidden=NO;
        current_longitude=endLongitude;
        current_latitude=endLattitude;
        NSLog(@"currentLattitude..%f",current_latitude);
        NSLog(@"currentLongitude..%f",current_longitude);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        // [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        now = [NSDate date];
        currentTime= [dateFormatter stringFromDate:now];
        jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%f", current_longitude],@"longitude",[NSString stringWithFormat:@"%f", current_latitude],@"latitude",currentTime,@"currenttime",@"10",@"distance",userIdStr,@"riderid",nil];
    }
    else
    {
        //isDestinationLocMrkr=YES;
        self.goHomeBTn.userInteractionEnabled=YES;
        self.goHomeBTn.hidden=NO;

    locationManager = [[CLLocationManager alloc] init];
    current_longitude=locationManager.location.coordinate.longitude;
    current_latitude=locationManager.location.coordinate.latitude;
        //[self fetchVehicleList];
    }
    NSLog(@"%f",current_latitude);
    NSLog(@"%f",current_longitude);
    [self setMarkerAndPositions];
}
-(void) activePopUp
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"You have an active ride." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue"] isEqualToString:@"RiderSide" ])
    {
        alertView.tag=1;
        [alertView show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex
{
    if (alertView.tag==1)
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
        
        driverRideMapVc.GetTripId=activeTripId;
        driverRideMapVc.FromNotification=YES;
        [timer invalidate];
        [Vtimer invalidate];
        [popUptimer invalidate];
        [LocationTimer invalidate];
        [self.navigationController pushViewController:driverRideMapVc animated:YES];
    }
}


-(void) setMarkerAndPositions
{
    if (isStartLoc)
    {
        disableImg.hidden=YES;
        //isDestinationLocMrkr=NO;
        current_longitude=startLongitude;
        current_latitude=startLatitude;
        NSLog(@"currentLattitude..%f",current_latitude);
        NSLog(@"currentLongitude..%f",current_longitude);
    }
    else if (isEndLoc)
    {
        disableImg.hidden=YES;
        //isDestinationLocMrkr=YES;
        current_longitude=endLongitude;
        current_latitude=endLattitude;
        NSLog(@"currentLattitude..%f",current_latitude);
        NSLog(@"currentLongitude..%f",current_longitude);
    }
    
    else
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [locationManager requestWhenInUseAuthorization];
          //  [locationManager requestAlwaysAuthorization];
        }
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        [locationManager startUpdatingLocation];
        current_longitude=locationManager.location.coordinate.longitude;
        current_latitude=locationManager.location.coordinate.latitude;
        disableImg.hidden=NO;
    }
    
    NSLog(@"%f %f",current_latitude,current_longitude);
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:current_latitude longitude:current_longitude zoom:15];
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,70, 320, 458) camera:camera];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        mapView = [GMSMapView mapWithFrame: CGRectMake(00,70, 320, 368) camera:camera];
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
    activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        activityIndicatorObject.center = CGPointMake(160, 190);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        activityIndicatorObject.center = CGPointMake(160, 190);
    }
    else
    {
        activityIndicatorObject.center = CGPointMake(374, 412);
    }
    activityIndicatorObject.color=[UIColor grayColor];
    [self.view addSubview:activityIndicatorObject];
    if ( !isEndLoc && ! isStartLoc)
    {
        disableImg.hidden=NO;
        [self.activityIndicatorObject startAnimating];
      //  self.view.userInteractionEnabled=NO;
    }
    
    [self.view bringSubviewToFront:self.vehicleTypeTableView];
    [mapView bringSubviewToFront:self.vehicleTypeTableView];
    
    [self.view bringSubviewToFront:self.pickupLocationLbl];
    [mapView bringSubviewToFront:self.pickupLocationLbl];
    [self.view bringSubviewToFront:self.editBtn];
    [mapView bringSubviewToFront:self.editBtn];
    [self.view bringSubviewToFront:pickUpImg];
    [mapView bringSubviewToFront:pickUpImg];
    [self.view bringSubviewToFront:DestinationImg];
    [mapView bringSubviewToFront:DestinationImg];
    [self.view bringSubviewToFront:pickupLocationTxt];
    [mapView bringSubviewToFront:pickupLocationTxt];
    [self.view bringSubviewToFront:seachPickupBtn];
    [mapView bringSubviewToFront:seachPickupBtn];
    [self.view bringSubviewToFront:cancelpickupBtn];
    [mapView bringSubviewToFront:cancelpickupBtn];
    [self.view bringSubviewToFront:locationSearchTxt];
    [mapView bringSubviewToFront:locationSearchTxt];
    [self.view bringSubviewToFront:searchBtn];
    [mapView bringSubviewToFront:searchBtn];
    [self.view bringSubviewToFront:placesTableView];
    [mapView bringSubviewToFront:placesTableView];
    [self.view bringSubviewToFront:cancelSearchtn];
    [mapView bringSubviewToFront:cancelSearchtn];
    [self.view bringSubviewToFront:self.vipBackView];
    [mapView bringSubviewToFront:self.vipBackView];
    [self.view bringSubviewToFront:disableImg];
    [mapView bringSubviewToFront:disableImg];
    [self.view bringSubviewToFront:sideView];
    [mapView bringSubviewToFront:sideView];
    
    marker = [[GMSMarker alloc] init];
    [marker setDraggable: YES];
    marker.position = CLLocationCoordinate2DMake(current_latitude ,current_longitude );
    
    
    if (isEndLoc)
    {
        disableImg.hidden=YES;
        marker.title =@"Set destination location";
        marker.snippet=[NSString stringWithFormat:@"%@",destinationLocationStr];
        marker.icon = [UIImage imageNamed:@"red_flag_icon.png"];
    }
    else if (isStartLoc)
    {
        disableImg.hidden=YES;
        marker.title =@"Set pickup location";
        marker.snippet=[NSString stringWithFormat:@"%@",startLocationStr];
        marker.icon = [UIImage imageNamed:@"green_flag_icon.png"];
    }
    else {
        marker.title =@"Set pickup location";
        marker.icon = [UIImage imageNamed:@"green_flag_icon.png"];

    }
    
    endMarker = [[GMSMarker alloc] init];
    endMarker.map=mapView;
    marker.map = mapView;

}
-(void )viewWillAppear:(BOOL)animated
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary* dataDict=[[NSMutableDictionary alloc]init];
    dataDict=[userdefaults valueForKey: @"riderInfo"];
    userIdStr= [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"userid"]];
    [[NSUserDefaults standardUserDefaults ]setValue:userIdStr forKey:@"riderId"];
    handicapdStr=[NSString stringWithFormat:@"%@",[dataDict valueForKey:@"handicap"]];
    riderDriverIdStr=[NSString stringWithFormat:@"%@",[dataDict valueForKey:@"driverid"]];
    
    NSString *driverStatus =[NSString stringWithFormat:@"%@",[dataDict valueForKey:@"driveractive"]];
    if ([driverStatus isEqualToString:@"false"])
    {
        riderDriverIdStr=@"";
    }
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
    if (!isEndLoc)
    {
           Vtimer= [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(fetchVehicleList) userInfo:nil repeats:YES];
    }
  
   // sleep(1);
}

-(void)fetchVehicleList
{
    if(!isdestinationLocSearch)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        now = [NSDate date];
        currentTime= [dateFormatter stringFromDate:now];
        jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%f", current_longitude],@"longitude",[NSString stringWithFormat:@"%f", current_latitude],@"latitude",currentTime,@"currenttime",@"10",@"distance",userIdStr,@"riderid",nil];
        if (!isEndLoc)
        {
            webserviceCode=4;
            
            
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
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
  
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
  
    [locationManager stopUpdatingLocation];
    if (isStartLoc)
    {
        //isDestinationLocMrkr=NO;
        current_longitude=startLongitude;
        current_latitude=startLatitude;
        NSLog(@"currentLattitude..%f",current_latitude);
        NSLog(@"currentLongitude..%f",current_longitude);
    }
    else if (isEndLoc)
    {
        //isDestinationLocMrkr=YES;
        current_longitude=endLongitude;
        current_latitude=endLattitude;
        NSLog(@"currentLattitude..%f",current_latitude);
        NSLog(@"currentLongitude..%f",current_longitude);
    }

    else{
        current_longitude=newLocation.coordinate.longitude;
        current_latitude=newLocation.coordinate.latitude;
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
   
    CLLocation*currentLocation;
    
    if (locations.count>0) {
        currentLocation = [locations objectAtIndex:0];

    }
    [locationManager stopUpdatingLocation];
    
    
    
    NSLog(@"Detected Location : %f, %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
    if (isStartLoc)
    {
       
        marker.position = CLLocationCoordinate2DMake(current_latitude ,current_longitude );
        GMSCameraUpdate *cams = [GMSCameraUpdate setTarget:CLLocationCoordinate2DMake(current_latitude ,current_longitude ) zoom:15];
        [mapView animateWithCameraUpdate:cams];
        //isDestinationLocMrkr=NO;
        current_longitude=startLongitude;
        current_latitude=startLatitude;
        NSLog(@"currentLattitude..%f",current_latitude);
        NSLog(@"currentLongitude..%f",current_longitude);
    }
    else if (isEndLoc)
    {
        //isDestinationLocMrkr=YES;
        current_longitude=endLongitude;
        current_latitude=endLattitude;
        NSLog(@"currentLattitude..%f",current_latitude);
        NSLog(@"currentLongitude..%f",current_longitude);
    }
    else{
        
        
        currentLocMarker = [[GMSMarker alloc] init];
        currentLocMarker.position = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude ,currentLocation.coordinate.longitude );
        
        
        currentLocMarker.title =@"Set pickup location";
        currentLocMarker.icon = [UIImage imageNamed:@"green_flag_icon.png"];
        currentLocMarker.map=mapView;
        
        
        
        marker.position = CLLocationCoordinate2DMake(current_latitude ,current_longitude );
        GMSCameraUpdate *cams = [GMSCameraUpdate setTarget:CLLocationCoordinate2DMake(current_latitude ,current_longitude ) zoom:15];
        [mapView animateWithCameraUpdate:cams];
        current_longitude=currentLocation.coordinate.longitude;
        current_latitude=currentLocation.coordinate.latitude;
        CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
        [geocoder reverseGeocodeLocation:currentLocation
                       completionHandler:^(NSArray *placemarks, NSError *error) {
                           if (error){
                               [activityIndicatorObject stopAnimating];
                               self.view.userInteractionEnabled=YES;
                               self.disableImg.hidden=YES;
                               NSLog(@"Geocode failed with error: %@", error);
                               return;
                           }
                           if (placemarks.count>0)
                           {
                               CLPlacemark *placemark = [placemarks objectAtIndex:0];
                               
                               NSLog(@"placemark.ISOcountryCode %@",placemark.addressDictionary);
                               NSLog(@"placemark.ISOcountryCode %@ %@ %@",[placemark.addressDictionary valueForKey:@"SubLocality"],[placemark.addressDictionary valueForKey:@"City"],[placemark.addressDictionary valueForKey:@"Country"]);
                               cityStr=[placemark.addressDictionary valueForKey:@"City"];
                               countryStr=[placemark.addressDictionary valueForKey:@"Country"];
                               currentAddressStr=[placemark.addressDictionary valueForKey:@"SubLocality"];
                               NSArray* addressArray=[placemark.addressDictionary valueForKey:@"FormattedAddressLines"];
                               NSLog(@"array count .. %lu",(unsigned long)addressArray.count);
                               currntFulAdress= [NSString stringWithFormat:@"%@",addressArray];
                               if (addressArray.count>0) {
                                   for (int j=0;j<addressArray.count; j++)
                                   {
                                       if (j==0)
                                       {
                                           currntFulAdress=[NSString stringWithFormat:@"%@",[addressArray objectAtIndex:j]];
                                       }
                                       else{
                                           
                                           if (currntFulAdress.length==0) {
                                               currntFulAdress=[NSString stringWithFormat:@"%@",[addressArray objectAtIndex:j]];

                                           }
                                           else{
                                               currntFulAdress=[NSString stringWithFormat:@"%@,%@",currntFulAdress,[addressArray objectAtIndex:j]];
                                           }
                                       }
                                   }
                               }
                               if (currentAddressStr.length==0) {
                                   currntFulAdress=[NSString stringWithFormat:@"%@",currntFulAdress];
                               }
                               else{
                                   currntFulAdress=[NSString stringWithFormat:@"%@ ,%@",currentAddressStr,currntFulAdress];
                               }
                               NSLog(@"full address %@",currntFulAdress);
                               CurrentPosStringInMarkr=[NSString stringWithFormat:@"%@",currntFulAdress];
                               
                               currentLocMarker.snippet=[NSString stringWithFormat:@"%@",CurrentPosStringInMarkr];
                               marker.snippet=[NSString stringWithFormat:@"%@",currntFulAdress];
                               startLocationStr=[NSString stringWithFormat:@"%@",currntFulAdress];
                               pickupLocationTxt.text=startLocationStr;
                               pickupLocationTxt.userInteractionEnabled=NO;
                               startLatitude=current_latitude;
                               startLongitude=current_longitude;
                               [activityIndicatorObject stopAnimating];
                               self.view.userInteractionEnabled=YES;
                               self.disableImg.hidden=YES;
                               pickupLocationLbl.text=[NSString stringWithFormat:@"%@",startLocationStr];
                               pickupLocationLbl.hidden=NO;
                               editBtn.hidden=NO;
                               
                            if (tempVehicleDict !=nil)
                               {
                                   FavDriverListStr=[tempVehicleDict valueForKey:@"favouritedriver"];
                                   vehicleListArray=[tempVehicleDict valueForKey:@"ListVehicleInfo"];
                                   vehicleZoneListAray=[tempVehicleDict valueForKey:@"ListZoneInfo"];
                                   
                                   if ( vehicleListArray.count>0 && vehicleZoneListAray.count>0)
                                   {
                                       [self showVehicles];
                                       
                                   }
                                   else if([[[NSUserDefaults standardUserDefaults ]valueForKey:@"first"] isEqualToString:@"first"])
                                   {
                                       [[NSUserDefaults standardUserDefaults ]setValue:@"" forKey:@"first"];
                                       [self.vehicleTypleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                       
                                       UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"No vehicles available in this area." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                       [alertView show];
                                   }
                               }
                               else if([[[NSUserDefaults standardUserDefaults ]valueForKey:@"first"] isEqualToString:@"first"])
                               {
                                   [self.vehicleTypleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                   
                                   [[NSUserDefaults standardUserDefaults ]setValue:@"" forKey:@"first"];
                                   UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"No vehicles available in this area." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                   [alertView show];
                               }
                           }
                    }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logOut:(id)sender
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"activeTripId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userEmail"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPassword"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"riderInfo"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Queue"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RequestType"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"first"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"payment_status"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefvehicletype"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"riderId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"driverid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FareValueForTip"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fullName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey :@"picUrl"];
    
    LoginViewController *loginVc;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        loginVc=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        loginVc=[[LoginViewController alloc]initWithNibName:@"LoginViewController_iphone4" bundle:nil];
    }

    [Vtimer invalidate];
    [timer invalidate];
    [popUptimer invalidate];
    [LocationTimer invalidate];
   
    [self.navigationController pushViewController:loginVc animated:YES];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [sideView.layer addAnimation:transition forKey:nil];
    sideView.hidden=YES;
    
    return ;
}

- (IBAction)searchBtn:(id)sender {
    
  //  [timer invalidate];
    ispickupLocationSearch=NO;
    isdestinationLocSearch=YES;
    
    [self.view endEditing:YES];
    self.placesTableView.hidden=YES;
    [mapView clear];
    
    [locationSearchTxt resignFirstResponder];
    location=nil;
    
    NSString *url=[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", locationSearchTxt.text];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *queryUrl = [NSURL URLWithString:url];
    NSLog(@"query url%@",queryUrl);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *data = [NSData dataWithContentsOfURL:queryUrl];
        [self fetchLongitudeAndLattitude:data];
    });

 }

- (IBAction)homeBtn:(id)sender {
    isHomeBtn=YES;
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary*dataDict=[[NSMutableDictionary alloc]init];
    
    dataDict=[userdefaults valueForKey: @"riderInfo"];
    NSString *homeState=[dataDict valueForKey:@"state"];
    NSString *homeCity=[dataDict valueForKey:@"city"];
    NSString *homeZip=[dataDict valueForKey:@"zip"];
    NSString *homeAddress=[dataDict valueForKey:@"address"];
    NSString *homeFinalAddress=[NSString stringWithFormat:@"%@,%@,%@,%@",homeAddress,homeCity,homeState,homeZip];
 
    if (![homeAddress isEqualToString:@""])
    {
        NSString *url=[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", homeFinalAddress];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *queryUrl = [NSURL URLWithString:url];
        NSLog(@"query url%@",queryUrl);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSData *data = [NSData dataWithContentsOfURL:queryUrl];
            [self fetchLongitudeAndLattitude:data];
        });
        destinationLocationStr=homeFinalAddress;
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Home address is not available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)fetchLongitudeAndLattitude:(NSData *)data{
    searchResults=0;
    LocationAndPriceDetailViewController *detailVc;
    NSDictionary *gc;
   
    
    if (isEndLoc ){
        marker.position = CLLocationCoordinate2DMake(current_latitude ,current_longitude );

        //isDestinationLocMrkr=YES;
        marker.title =@"Set destination location";
        marker.icon = [UIImage imageNamed:@"red_flag_icon.png"];
        
    }
    else if(isStartLoc || ispickupLocationSearch)
    {
        
        currentLocMarker = [[GMSMarker alloc] init];
        currentLocMarker.position = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude ,locationManager.location.coordinate.longitude );
        
        //[marker setDraggable: YES];
        
        currentLocMarker.title =@"Set pickup location";
        currentLocMarker.icon = [UIImage imageNamed:@"green_flag_icon.png"];
        currentLocMarker.map=mapView;
        currentLocMarker.snippet=[NSString stringWithFormat:@"%@", CurrentPosStringInMarkr];

        
        
        
       // isDestinationLocMrkr=NO;
        marker.title =@"Set pickup location";
        marker.icon = [UIImage imageNamed:@"green_flag_icon.png"];
        
        
    }
    else{
        
        marker.position = CLLocationCoordinate2DMake(current_latitude ,current_longitude );

        marker.title =@"Set pickup location";
        marker.icon = [UIImage imageNamed:@"green_flag_icon.png"];
        
    }
    // marker.title =@"Set pickup location";
    // marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
    marker.map = mapView;
    gc=nil;

    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray* results =[json objectForKey:@"results"];
    NSString *latitudeStr;
    NSString *longitudeStr;
    NSLog(@"Data is:%@" ,results);
    NSString *addressStr;
    
    if (isHomeBtn)
    {
        if (results.count>0) {
            for (int i = 0;i <[results count]; i++){
                NSDictionary *result = [results objectAtIndex:i];
                NSDictionary *geometry = [result objectForKey:@"geometry"];
                NSDictionary*locationDict=[geometry objectForKey:@"location"];
                addressStr=[result objectForKey:@"formatted_address"];
                latitudeStr=[locationDict objectForKey:@"lat"];
                longitudeStr=[locationDict objectForKey:@"lng"];
            }
        }
        CLLocationCoordinate2D center;
        center.latitude = [latitudeStr doubleValue];
        center.longitude = [longitudeStr doubleValue];
        NSLog(@"latt of address.. %.2f",[latitudeStr doubleValue]);
        NSLog(@"long of address .. %.2f",[longitudeStr doubleValue]);
        
        GMSMarker *marker2 = [[GMSMarker alloc]init];
        [marker2 setDraggable:YES];
        CLLocationCoordinate2D local;
        if (isStartLoc || ispickupLocationSearch)
        {
            startLatitude=[latitudeStr doubleValue];
            startLongitude=[longitudeStr doubleValue];
            local= CLLocationCoordinate2DMake(startLatitude, startLongitude);
            marker2.title =@"Set pickup location";
            marker2.icon = [UIImage imageNamed:@"green_flag_icon.png"];
            NSLog(@"tittle Name is %@",marker2.title);
            
            marker2.snippet = [NSString stringWithFormat:@"%@",addressStr];
        }
        else
        {
            endLattitude=[latitudeStr doubleValue];
            endLongitude=[longitudeStr doubleValue];
            local= CLLocationCoordinate2DMake(endLattitude, endLongitude);
            marker2.title =@"Set destination location";
            marker2.icon = [UIImage imageNamed:@"red_flag_icon.png"];
            NSLog(@"tittle Name is %@",marker2.title);
            marker2.snippet = [NSString stringWithFormat:@"%@",addressStr];
            
        }
        
        marker2.position = local;
        
        
        marker2.map = mapView;
        GMSCameraUpdate *cams = [GMSCameraUpdate setTarget:local zoom:17];
        [mapView animateWithCameraUpdate:cams];
        

        if ([latitudeStr doubleValue]==0)
        {
            UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Home location not found ,please search on map" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alrt show];
        }
        else {
            
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                detailVc=[[LocationAndPriceDetailViewController alloc]initWithNibName:@"LocationAndPriceDetailViewController" bundle:nil];
            }
            else if([[UIScreen mainScreen] bounds].size.height == 480) {
                detailVc=[[LocationAndPriceDetailViewController alloc]initWithNibName:@"LocationAndPriceDetailViewController_iphone4" bundle:nil];
                // this is iphone 4 xib
            }
             if (base_fare.length==0 || price_per_mile.length==0|| price_per_minute.length==0)
                
            {
                base_fare=@"";
                price_per_minute=@"";
                driverIdStr=@"";
                price_per_mile=@"";
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"No %@ vehicle available in this area.",vehicleTypeName] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                [self.vehicleTypleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }

            else
            {
                if ([[UIScreen mainScreen] bounds].size.height == 568) {
                    detailVc=[[LocationAndPriceDetailViewController alloc]initWithNibName:@"LocationAndPriceDetailViewController" bundle:nil];
                }
                else if([[UIScreen mainScreen] bounds].size.height == 480) {
                    detailVc=[[LocationAndPriceDetailViewController alloc]initWithNibName:@"LocationAndPriceDetailViewController_iphone4" bundle:nil];
                    // this is iphone 4 xib
                }
            }
            detailVc.start_latitude=startLatitude;
            detailVc.start_longitude=startLongitude;
            detailVc.end_latitude=endLattitude;
            detailVc.end_longitude=endLongitude;
            detailVc.startLocAddressStr=startLocationStr;
            detailVc.endLocAddressStr=destinationLocationStr;
            detailVc.price_per_minute=price_per_minute;
            detailVc.price_per_mile=price_per_mile;
            detailVc.base_fare=base_fare;
            detailVc.driverIdStr=driverIdStr;
            detailVc.vehicleType=vehicleType;
            detailVc.driverIdArray=[driverIdArray copy];
            detailVc.isVIP=isVIP;
            detailVc.isOneWay=isOneWay;
            detailVc.surgeValue=surgeValue;
            detailVc.isFavDriver=isFavDriver;
            detailVc.minPrice=minPrice;
            isHomeBtn=NO;
            if (driverIdArray.count<1 || driverIdStr.length==0)
            {
                 marker.position = CLLocationCoordinate2DMake(current_latitude ,current_longitude );
                GMSCameraUpdate *cams = [GMSCameraUpdate setTarget:CLLocationCoordinate2DMake(current_latitude ,current_longitude )];
                [mapView animateWithCameraUpdate:cams];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"No %@ vehicle available in this area.",vehicleTypeName] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                return;
            }
            [Vtimer invalidate];
            [timer invalidate];
            [popUptimer invalidate];
            [LocationTimer invalidate];
            [self.navigationController pushViewController:detailVc animated:YES];
        }
    }
    else{
         CLLocationCoordinate2D posOfMarker;

        if (results.count>0) {
            for (int i = 0;i <[results count]; i++)
            {
                searchResults= searchResults+1;
                NSDictionary *result = [results objectAtIndex:i];
                NSDictionary *geometry = [result objectForKey:@"geometry"];
                NSDictionary*locationDict=[geometry objectForKey:@"location"];
                addressStr=[result objectForKey:@"formatted_address"];
                latitudeStr=[locationDict objectForKey:@"lat"];
                longitudeStr=[locationDict objectForKey:@"lng"];
                NSLog(@"Data is %@", result);
                NSString *address = [result objectForKey:@"formatted_address"];
                NSLog(@"Address is %@", address);
                NSString *name = [result objectForKey:@"name"];
                NSLog(@"name is %@", name);
                NSDictionary *locations = [geometry objectForKey:@"location"];
                NSString *lat =[locations objectForKey:@"lat"];
                NSString *lng =[locations objectForKey:@"lng"];
                NSLog(@"longitude is %@", lng);
                gc = [[NSDictionary alloc]initWithObjectsAndKeys:lat,@"lat",lng,@"lng",address,@"address" ,nil];
                location = gc;
                double lat1 = [[location objectForKey:@"lat"] doubleValue];
                NSLog(@"Marker position%f",lat1);
                double lng1 = [[location objectForKey:@"lng"] doubleValue];
                NSLog(@"Marker position%f",lng1);
                
                GMSMarker *marker2 = [[GMSMarker alloc]init];
                [marker2 setDraggable:YES];
                CLLocationCoordinate2D local = CLLocationCoordinate2DMake(lat1, lng1);
                
                marker2.position = local;
                
                if(i == 0)
                {
                    posOfMarker = local;
                    
                    
                    if (ispickupLocationSearch)
                    {
                        pickupLocationTxt.userInteractionEnabled=NO;
                        if (name.length==0)
                        {
                            marker.snippet=[NSString stringWithFormat:@"%@",address];

                        }
                        else{
                            marker.snippet=[NSString stringWithFormat:@"%@ , %@",name,address];

                        }
                        startLatitude=[latitudeStr doubleValue];
                        startLongitude=[longitudeStr doubleValue];
                    }
                    else{
                        endLattitude=[latitudeStr doubleValue];
                        endLongitude=[longitudeStr doubleValue];
                    }


                }
                
                if (isEndLoc){
                    marker2.title =@"Set destination location";
                    marker2.icon = [UIImage imageNamed:@"red_flag_icon.png"];
                    
                }
                else if(isStartLoc || ispickupLocationSearch){
                   
                    marker2.title =@"Set pickup location";
                    marker2.icon = [UIImage imageNamed:@"green_flag_icon.png"];
                }
                else{
                    marker2.title =@"Set destination location";
                    marker2.icon = [UIImage imageNamed:@"red_flag_icon.png"];
                }
                
                
                NSLog(@"tittle Name is %@",marker2.title);
                marker2.snippet = [NSString stringWithFormat:@"%@",[location objectForKey:@"address"]];
                marker2.map = mapView;
                if (ispickupLocationSearch)
                {
                    marker.position=posOfMarker;
                    current_latitude=startLatitude;
                    current_longitude=startLongitude;

                }
                GMSCameraUpdate *cams = [GMSCameraUpdate setTarget:posOfMarker zoom:18];
                [mapView animateWithCameraUpdate:cams];
               
            }
        }
        if ((!isStartLoc && !ispickupLocationSearch) && searchResults==1)
        {
            [self moveToPricingView];
        }
    }
}

- (IBAction)menuBtn:(id)sender {
    [self.view endEditing:YES];
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

-(void)fetchData:(NSData *)data
{
    searchResults=0;
    LocationAndPriceDetailViewController *detailVc;
    NSDictionary *gc;
    
    
    if (isEndLoc  ){
        marker.position = CLLocationCoordinate2DMake(current_latitude ,current_longitude );
        
        //isDestinationLocMrkr=YES;
        marker.title =@"Set destination location";
        marker.icon = [UIImage imageNamed:@"red_flag_icon.png"];
        
    }
    else if (isdestinationLocSearch)
    {
        marker.title =@"Set pickup location";
        marker.icon = [UIImage imageNamed:@"green_flag_icon.png"];
    }
    else if(isStartLoc || ispickupLocationSearch){
        // isDestinationLocMrkr=NO;
        marker.title =@"Set pickup location";
        marker.icon = [UIImage imageNamed:@"green_flag_icon.png"];
        
        
    }
    else{
        
        currentLocMarker = [[GMSMarker alloc] init];
        currentLocMarker.position = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude ,locationManager.location.coordinate.longitude );
        
        //[marker setDraggable: YES];
        
        currentLocMarker.title =@"Set pickup location";
        currentLocMarker.icon = [UIImage imageNamed:@"green_flag_icon.png"];
        currentLocMarker.map=mapView;
        currentLocMarker.snippet=[NSString stringWithFormat:@"%@", CurrentPosStringInMarkr];

        
        
        
        marker.position = CLLocationCoordinate2DMake(current_latitude ,current_longitude );
        
        marker.title =@"Set pickup location";
        marker.icon = [UIImage imageNamed:@"green_flag_icon.png"];
        
    }
  
    marker.map = mapView;
    gc=nil;

    
    
    NSString *str=[gc objectForKey:@"address"];
    NSLog(@"%@",str);
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray* results =[json objectForKey:@"results"];
    NSString *latitudeStr;
    NSString *longitudeStr;
    NSLog(@"Data is:%@" ,results);
    NSString *addressStr;
  
    
        CLLocationCoordinate2D posOfMarker;
        
        if (results.count>0) {
            for (int i = 0;i <[results count]; i++)
            {
                searchResults= searchResults+1;
                NSDictionary *result = [results objectAtIndex:i];
                NSDictionary *geometry = [result objectForKey:@"geometry"];
                NSDictionary*locationDict=[geometry objectForKey:@"location"];
                addressStr=[result objectForKey:@"formatted_address"];
                latitudeStr=[locationDict objectForKey:@"lat"];
                longitudeStr=[locationDict objectForKey:@"lng"];
                NSLog(@"Data is %@", result);
                NSString *address = [result objectForKey:@"formatted_address"];
                NSLog(@"Address is %@", address);
                NSString *name = [result objectForKey:@"name"];
                NSLog(@"name is %@", name);
                NSDictionary *locations = [geometry objectForKey:@"location"];
                NSString *lat =[locations objectForKey:@"lat"];
                NSString *lng =[locations objectForKey:@"lng"];
                NSLog(@"longitude is %@", lng);
                
                if (name.length>0)
                {
                   address =[NSString stringWithFormat:@"%@ , %@",name,address];
                    
                }
                gc = [[NSDictionary alloc]initWithObjectsAndKeys:lat,@"lat",lng,@"lng",address,@"address" ,nil];
                location = gc;
                double lat1 = [[location objectForKey:@"lat"] doubleValue];
                NSLog(@"Marker position%f",lat1);
                double lng1 = [[location objectForKey:@"lng"] doubleValue];
                NSLog(@"Marker position%f",lng1);
                
                GMSMarker *marker2 = [[GMSMarker alloc]init];
                [marker2 setDraggable:YES];
                CLLocationCoordinate2D local = CLLocationCoordinate2DMake(lat1, lng1);
                
                marker2.position = local;
                
                if(i == 0)
                {
                    posOfMarker = local;
                    
                    
                    if (ispickupLocationSearch)
                    {
                        if (isStartLoc)
                        {
                            locationSearchTxt.text=[NSString stringWithFormat:@"%@",address];
                        }
                        else{
                            pickupLocationTxt.text=[NSString stringWithFormat:@"%@",address];
                        }
                        pickupLocationTxt.userInteractionEnabled=NO;
                        marker.snippet=[NSString stringWithFormat:@"%@",address];
                        startLatitude=[latitudeStr doubleValue];
                        startLongitude=[longitudeStr doubleValue];
                    }
                    else if(isdestinationLocSearch || isEndLoc)
                    {
                        locationSearchTxt.text=[NSString stringWithFormat:@"%@",address];
                        destinationLocationStr=[NSString stringWithFormat:@"%@",address];
                        endLattitude=[latitudeStr doubleValue];
                        endLongitude=[longitudeStr doubleValue];
                    }
                }
                
                if (isEndLoc)
                {

                    marker2.title =@"Set destination location";
                    marker2.icon = [UIImage imageNamed:@"red_flag_icon.png"];
                    
                }
                else if(isStartLoc || ispickupLocationSearch){
                    
                    marker2.title =@"Set pickup location";
                    marker2.icon = [UIImage imageNamed:@"green_flag_icon.png"];
                }
                else{
                    

                    marker2.title =@"Set destination location";
                    marker2.icon = [UIImage imageNamed:@"red_flag_icon.png"];
                }
                
                // marker2.title = @"Set destination location";
                
                // marker2.title = [ location objectForKey:@"name"];
                
                NSLog(@"tittle Name is %@",marker2.title);
                marker2.snippet = [NSString stringWithFormat:@"%@",[location objectForKey:@"address"]];
                marker2.map = mapView;
                if (ispickupLocationSearch)
                {
                    marker.position=posOfMarker;
                    current_latitude=startLatitude;
                    current_longitude=startLongitude;
                    
                }
                GMSCameraUpdate *cams = [GMSCameraUpdate setTarget:posOfMarker zoom:18];
                [mapView animateWithCameraUpdate:cams];
                
            }
        }
        if ((!isStartLoc && !ispickupLocationSearch) && searchResults==1)
        {
            [self moveToPricingView];
        }
    
    GMSCameraUpdate *cams;
    if([results count]>0)
    {
        cams = [GMSCameraUpdate setTarget:posOfMarker zoom:18];
         [mapView animateWithCameraUpdate:cams];
    }
    
    if (results.count<1 && ispickupLocationSearch)
    {
        pickupLocationTxt.text=startLocationStr;
    }
    else if (results.count<1 && isdestinationLocSearch)

    {
        locationSearchTxt.text=destinationLocationStr;
    }
    
    else if (results.count<1 &&isStartLoc )
    {
        locationSearchTxt.text=startLocationStr;

    }
    else if (results.count<1 &&isEndLoc
             )
    {
        locationSearchTxt.text=destinationLocationStr;
        
    }
   
    if (!isStartLoc && searchResults==1)
    {
        [self moveToPricingView];
    }
}






-(void)fetchLocaotionList:(NSData *)data
{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray* results =[json objectForKey:@"predictions"];
    NSLog(@"Data is:%@" ,results);
   
 locationArray=[[NSMutableArray alloc]init];
    if (results.count>0) {
        for (int i = 0;i <[results count]; i++) {
            
            NSDictionary *result = [results objectAtIndex:i];
            NSString *placesName = [result objectForKey:@"description"];
            NSArray* tempArray = [placesName componentsSeparatedByString: @","];
            if (tempArray.count>0) {
                placesName =[NSString stringWithFormat:@"%@", [tempArray objectAtIndex: 0]];

            }
            
            [locationArray addObject:result];
        }

    }
       NSLog(@"places Array ..%@",locationArray);
    [self.placesTableView reloadData];
}
#pragma mark - Text field Delegates


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==locationSearchTxt )
    {
        [self.view endEditing:YES];
        self.placesTableView.hidden=YES;
        [mapView clear];
        
        [locationSearchTxt resignFirstResponder];
        location=nil;
      
        if (locationSearchTxt.text.length==0)
        {
            locationSearchTxt.text=destinationLocationStr;
        }
        
        
        NSString *url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&key=%@",locationSearchTxt.text,KgoogleMapApiKey];

        
        
        
        
        
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *queryUrl = [NSURL URLWithString:url];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
            NSData *data = [NSData dataWithContentsOfURL:queryUrl];
            
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [self fetchData:data];
                           });
        });
    }
    else
    {
        [self.view endEditing:YES];
        self.placesTableView.hidden=YES;
        [mapView clear];
        
        [pickupLocationTxt resignFirstResponder];
        if (pickupLocationTxt.text.length==0)
        {
            pickupLocationTxt.text=startLocationStr;
        }
        location=nil;
        
        NSString *url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&key=%@",pickupLocationTxt.text,KgoogleMapApiKey];
        
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *queryUrl = [NSURL URLWithString:url];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
            NSData *data = [NSData dataWithContentsOfURL:queryUrl];
            
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [self fetchData:data];
                           });
        });
    }
    [textField resignFirstResponder];
    
    return  YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string
{
    self.placesTableView.hidden=NO;
    NSString *substring;
    if(isStartLoc || isEndLoc || isdestinationLocSearch)
    {
        substring = [NSString stringWithString:locationSearchTxt.text];
    }
    else
    {
        substring = [NSString stringWithString:pickupLocationTxt.text];
    }
    substring = [substring stringByReplacingCharactersInRange:range withString:string];

    if(substring.length>=4)
    {
        
        NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
        NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
        
        NSString *url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=establishment&location=%f,%f&radius=5000&key=%@&components=country:%@",substring,current_latitude,current_longitude,KgoogleMapApiKey,countryCode];
        
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
            NSURL *queryUrl = [NSURL URLWithString:url];
            NSData *data = [NSData dataWithContentsOfURL:queryUrl];
            
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [self fetchLocaotionList:data];
                           });
        });
    }
  
    return  YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField==pickupLocationTxt)
    {
       // timer= [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(fetchVehicleList) userInfo:nil repeats:YES];
        ispickupLocationSearch=YES;
        isdestinationLocSearch=NO;
    }
    else{
        if (isStartLoc)
        {
            ispickupLocationSearch=YES;
            isdestinationLocSearch=NO;
        }
        else{
            ispickupLocationSearch=NO;
            isdestinationLocSearch=YES;
        }
    }
        
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [sideView.layer addAnimation:transition forKey:nil];
    sideView.hidden=YES;
}


#pragma mark - TableView field Delegates and Datasources

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==self.vehicleTypeTableView)
    {
         return [vehicleNameArray count];
    }
    else if (tableView==self.placesTableView)
    {
        if (locationArray.count<=5)
        {
            if ([[UIScreen mainScreen] bounds].size.height == 568)
            {
                if (isStartLoc || isEndLoc)
                {
                    placesTableView.frame = CGRectMake(7, 105,255, locationArray.count*30);
                }
                
                else{
                    if (ispickupLocationSearch)
                    {
                        placesTableView.frame = CGRectMake(7, 105,255, locationArray.count*30);
                    }
                    else{
                        placesTableView.frame = CGRectMake(7, 135,255, locationArray.count*30);
                    }
                }
               
               
            }
            else if ([[UIScreen mainScreen] bounds].size.height ==480) {
                placesTableView.frame = CGRectMake(12, 110,255, locationArray.count*30);
                
            }
        }
        else{
            if ([[UIScreen mainScreen] bounds].size.height == 568)
            {
                
                if (isEndLoc || isStartLoc)
                {
                    placesTableView.frame = CGRectMake(7, 105,255, 150);

                }
                else{
                    if (ispickupLocationSearch)
                    {
                        placesTableView.frame = CGRectMake(7, 105,255, 150);
                        
                    }
                    else{
                        placesTableView.frame = CGRectMake(7, 135,255, 150);
                        
                    }
                }
               
            }
            else if ([[UIScreen mainScreen] bounds].size.height ==480) {
                placesTableView.frame = CGRectMake(12, 110,255, 150);
            }
        }
        return [locationArray count];
    }
    return YES;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor=[UIColor lightGrayColor];
    cell.textLabel.textColor=[UIColor blackColor];
    
    if (([[UIScreen mainScreen] bounds].size.height == 568) ||  ([[UIScreen mainScreen] bounds].size.height == 480)) {
        cell.textLabel.font = [UIFont fontWithName:@"Myriad Pro" size:13];
        
        //this is iphone 5 xib
    }
    else
    {
        cell.textLabel.font = [UIFont fontWithName:@"Myriad Pro" size:30];
    }
    
    cell.backgroundColor=[UIColor clearColor];
    
    NSMutableArray *tempLocArray=[[NSMutableArray alloc]init];
    
    if (tableView==self.vehicleTypeTableView)
    {
        cell.backgroundColor =[UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        if (vehicleNameArray.count>0 ){
            cell.textLabel.text=[vehicleNameArray objectAtIndex:indexPath.row];

        }
//        if (vehicleImageArray.count>0 ){
//        //cell.imageView.image = [vehicleImageArray objectAtIndex:indexPath.row];
//        }
    }
    else if (tableView==self.placesTableView)
    {
        if (locationArray.count>0)
        {
            for (int i=0;i<locationArray.count;i++)
            {
                if (locationArray.count>0) {
                    NSMutableDictionary *tempDict=[locationArray objectAtIndex:i];
                    NSString *placesName = [tempDict objectForKey:@"description"];
                    [tempLocArray addObject:placesName];
                }
            }
            if (tempLocArray.count>0)
            {
                cell.textLabel.text=[tempLocArray objectAtIndex:indexPath.row];
            }
        }
    }
  //  self.vehicleTypleBtn.tintColor=[UIColor whiteColor];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (tableView==self.vehicleTypeTableView)
    {
       // [self.vehicleTypleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        if ( vehicleNameArray.count>0) {
            [self.vehicleTypleBtn setTitle:[NSString stringWithFormat:@"%@",[vehicleNameArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
            vehicleTypeName=[vehicleNameArray objectAtIndex:indexPath.row];
            vehicleType=[NSString stringWithFormat:@"%d",indexPath.row+1];
            
            [[NSUserDefaults standardUserDefaults ]setValue:vehicleType forKey:@"prefvehicletype"];
        }
        if ( vehicleImageArray.count>0)
        {
           
            if ([handicapdStr  isEqualToString:@"1"])
            {
                [self.vehiclFlagImage setImage:[UIImage imageNamed:@"small_carblue.png"]];
            }
            else{
                 [self.vehiclFlagImage setImage:[UIImage imageNamed:[vehicleImageArray objectAtIndex:indexPath.row]]];
            }
           
            
        }
        


        [self.vehicleTypeTableView setHidden:YES];
        
              [self showVehicles ];
        //isDestinationLocMrkr=NO;

//        if (!isDestinationLocMrkr){
//            [self showVehicles ];
//        }
    }
    else{
        NSDictionary *PlaceDict;
        if (locationArray .count>0) {
            PlaceDict = [locationArray objectAtIndex:indexPath.row];

        }
        
        if (isStartLoc || ispickupLocationSearch)
        {

            pickupLocationTxt.text=[NSString stringWithFormat:@"%@",[PlaceDict objectForKey:@"description"]];
            if (isStartLoc)
            {
                locationSearchTxt.text=[NSString stringWithFormat:@"%@",[PlaceDict objectForKey:@"description"]];
            }
        }
        else
        {
            locationSearchTxt.text=[NSString stringWithFormat:@"%@",[PlaceDict objectForKey:@"description"]];
        }

        
        
           NSString *url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&key=%@",[PlaceDict objectForKey:@"description"],KgoogleMapApiKey];
        
        
        
        
        
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *queryUrl = [NSURL URLWithString:url];
        NSLog(@"query url%@",queryUrl);
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
            NSData *data = [NSData dataWithContentsOfURL:queryUrl];
            
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [self fetchData:data];
                           });
        });

        
           placesTableView.hidden=YES;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.vehicleTypeTableView)
    {
        return 36.0;
    }
    else{
        return 30.0;
    }
}

- (IBAction)editProfileBtn:(id)sender {
    
    EditRiderAccountViewController *editRegisterRiderVc;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        editRegisterRiderVc=[[EditRiderAccountViewController alloc]initWithNibName:@"EditRiderAccountViewController" bundle:nil];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        editRegisterRiderVc=[[EditRiderAccountViewController alloc]initWithNibName:@"EditRiderAccountViewController_iphone4" bundle:nil];
    }
    [Vtimer invalidate];
    [timer invalidate];
    [popUptimer invalidate];
    [LocationTimer invalidate];
    [self.navigationController pushViewController:editRegisterRiderVc animated:YES];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [sideView.layer addAnimation:transition forKey:nil];
    sideView.hidden=YES;
    return ;
}


- (IBAction)paymentView:(id)sender{
    PaymentViewController *paymentVc;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        paymentVc=[[PaymentViewController alloc]initWithNibName:@"PaymentViewController" bundle:nil];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        paymentVc=[[PaymentViewController alloc]initWithNibName:@"PaymentViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }

    [Vtimer invalidate];
    [timer invalidate];
    [popUptimer invalidate];
    [LocationTimer invalidate];
    [self.navigationController pushViewController:paymentVc animated:YES];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [sideView.layer addAnimation:transition forKey:nil];
    sideView.hidden=YES;
    return ;

}
- (IBAction)requestRideBtn:(id)sender {

        [self moveToPricingView];

}
- (IBAction)vehicleTypeBtn:(id)sender {
    if (isEndLoc){
        
    }
    if (self.vehicleTypeTableView.hidden==YES) {
        [self.vehicleTypeTableView setHidden:NO];

    }
    else{
        [self.vehicleTypeTableView setHidden:YES];

    }
    if (!isEndLoc)
    {
         [self.vehicleTypeTableView reloadData];
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
    NSLog(@"webserviceCode %dd",webserviceCode);
    [self.activityIndicatorObject stopAnimating];
    self.view.userInteractionEnabled=YES;
    disableImg.hidden=YES;
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid Ride" message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
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
    if (webserviceCode == 1 )
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
    
    else if(webserviceCode==2)
    {
        // add vehicles
        
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
            if (result ==1)
            {
                alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
            }
            else if(result ==0)
            {
                alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
            }
            
            //[alert show];
        }
 
    }
    else if(webserviceCode==3)
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
            if (result ==1)
            {
                alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
            }
            else if(result ==0)
            {
            

                timer= [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(fetchVehicleList) userInfo:nil repeats:YES];
                alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            }
            
          //  [alert show];
        }
    }
    else if(webserviceCode==4)
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
        driverInfoDict =[[NSMutableDictionary alloc]init];
        driverZoneDict =[[NSMutableDictionary alloc]init];
        
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        if (result ==0)
        {
            FavDriverListStr=[userDetailDict valueForKey:@"favouritedriver"];
            vehicleListArray=[userDetailDict valueForKey:@"ListVehicleInfo"];
            vehicleZoneListAray=[userDetailDict valueForKey:@"ListZoneInfo"];
        }
        if (!isEndLoc || !isdestinationLocSearch)
        {
            [self showVehicles];

        }
        }
    }
}

-(void)showVehicles
{
    if (!destinationLocationNameStr)
    {
        NSString *markerIconImage;
        driverIdArray =[[NSMutableArray alloc]init];
        NSMutableArray *tempDriverIdArray=[[NSMutableArray alloc]init];
        [mapView clear];
        
        int vehicleCount=0;
       
     
        if (!isdestinationLocSearch)
        {
            
            currentLocMarker = [[GMSMarker alloc] init];
            currentLocMarker.position = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude ,locationManager.location.coordinate.longitude );
            
            //[marker setDraggable: YES];
            
            currentLocMarker.title =@"Set pickup location";
            currentLocMarker.icon = [UIImage imageNamed:@"green_flag_icon.png"];
            currentLocMarker.map=mapView;
            currentLocMarker.snippet=[NSString stringWithFormat:@"%@", CurrentPosStringInMarkr];

            
            
            
            
            CLLocationCoordinate2D posOfMarker = CLLocationCoordinate2DMake(startLatitude, startLongitude);
            marker.position = CLLocationCoordinate2DMake(startLatitude,startLongitude );
            
     
            marker.icon = [UIImage imageNamed:@"green_flag_icon.png"];
            GMSCameraUpdate *cams;
            cams = [GMSCameraUpdate setTarget:posOfMarker zoom:11];
            cams = [GMSCameraUpdate setTarget:posOfMarker];
            [mapView animateWithCameraUpdate:cams];

            if (destinationLocationStr.length>0 && !isEndLoc && !isStartLoc)
            {
                endMarker = [[GMSMarker alloc] init];
                endMarker.position= CLLocationCoordinate2DMake(endLattitude ,endLongitude );
                endMarker.icon = [UIImage imageNamed:@"red_flag_icon.png"];
                endMarker.title=@"Set destination location";
                endMarker.snippet=destinationLocationStr;
                endMarker.map=mapView;
            }
        }
        
            if (vehicleListArray>0)
            {
                NSDictionary *gc;
                gc=nil;
                for (int k=0; k<vehicleListArray.count;k++)
                {
                    if (vehicleZoneListAray.count>0 && k<vehicleZoneListAray.count)
                    {
                        driverZoneDict=[vehicleZoneListAray objectAtIndex:k];
                    }
                    driverInfoDict= [vehicleListArray objectAtIndex:k];
                    NSString*driverid=[driverInfoDict valueForKey:@"driverid"];
                    double longitude=[[driverInfoDict valueForKey:@"longitude"]floatValue];
                    double latitude=[[driverInfoDict valueForKey:@"latitude"]floatValue];
                    NSString*firstname=[driverInfoDict valueForKey:@"firstname"];
                    NSString*lastname=[driverInfoDict valueForKey:@"lastname"];
                    NSString*driverimage=[driverInfoDict valueForKey:@"driverimage"];
                    NSString*vehicleimage=[driverInfoDict valueForKey:@"vehicleimage"];
                    NSString*vehicletypeId=[driverInfoDict valueForKey:@"vehicletype"];
                    
                    
                    if ([vehicleType isEqualToString:vehicletypeId])
                    {
                        [self.vehicleTypleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [driverIdArray addObject:[driverInfoDict valueForKey:@"driverid"]];
                        distanceFromCurrntLoc=[driverInfoDict valueForKey:@"distance"];
                        
                        if ([vehicleType isEqualToString:@"1"])
                        {
                            price_per_minute=[driverZoneDict valueForKey:@"reg_min"];
                            price_per_mile=[driverZoneDict valueForKey:@"reg_price"];
                            base_fare=[driverZoneDict valueForKey:@"reg_base"];
                            surgeValue=[driverZoneDict valueForKey:@"reg_surge"];
                            h_total_fare=[driverZoneDict valueForKey:@"reg_hour"];
                            f_total_fare=[driverZoneDict valueForKey:@"reg_hourfull"];
                            minPrice=[[driverZoneDict valueForKey:@"reg_minbase"]doubleValue];
                            markerIconImage=[vehicleImageArray objectAtIndex:0];
                        }
                        else if ([vehicleType isEqualToString:@"2"])
                        {
                            price_per_minute=[driverZoneDict valueForKey:@"xl_min"];
                            price_per_mile=[driverZoneDict valueForKey:@"xl_price"];
                            base_fare=[driverZoneDict valueForKey:@"xl_base"];
                            surgeValue=[driverZoneDict valueForKey:@"xl_surge"];
                            h_total_fare=[driverZoneDict valueForKey:@"xl_hour"];
                            f_total_fare=[driverZoneDict valueForKey:@"xl_hourfull"];
                            markerIconImage=[vehicleImageArray objectAtIndex:1];
                            minPrice=[[driverZoneDict valueForKey:@"xl_minbase"]doubleValue];
                            
                        }
                        else if ([vehicleType isEqualToString:@"3"])
                        {
                            price_per_minute=[driverZoneDict valueForKey:@"exec_min"];
                            price_per_mile=[driverZoneDict valueForKey:@"exec_price"];
                            base_fare=[driverZoneDict valueForKey:@"exec_base"];
                            surgeValue=[driverZoneDict valueForKey:@"exec_surge"];
                            h_total_fare=[driverZoneDict valueForKey:@"exec_hour"];
                            f_total_fare=[driverZoneDict valueForKey:@"exec_hourfull"];
                            markerIconImage=[vehicleImageArray objectAtIndex:2];
                            minPrice=[[driverZoneDict valueForKey:@"exec_minbase"]doubleValue];
                            
                            
                        }
                        else if ([vehicleType isEqualToString:@"4"])
                        {
                            price_per_minute=[driverZoneDict valueForKey:@"suv_min"];
                            price_per_mile=[driverZoneDict valueForKey:@"suv_price"];
                            base_fare=[driverZoneDict valueForKey:@"suv_base"];
                            surgeValue=[driverZoneDict valueForKey:@"suv_surge"];
                            h_total_fare=[driverZoneDict valueForKey:@"suv_hour"];
                            f_total_fare=[driverZoneDict valueForKey:@"suv_hourfull"];
                            markerIconImage=[vehicleImageArray objectAtIndex:3];
                            minPrice=[[driverZoneDict valueForKey:@"suv_minbase"]doubleValue];
                            
                            
                        }
                        else if ([vehicleType isEqualToString:@"5"])
                        {
                            price_per_minute=[driverZoneDict valueForKey:@"lux_min"];
                            price_per_mile=[driverZoneDict valueForKey:@"lux_price"];
                            base_fare=[driverZoneDict valueForKey:@"lux_base"];
                            surgeValue=[driverZoneDict valueForKey:@"lux_surge"];
                            h_total_fare=[driverZoneDict valueForKey:@"lux_hour"];
                            f_total_fare=[driverZoneDict valueForKey:@"lux_hourfull"];
                            minPrice=[[driverZoneDict valueForKey:@"lux_minbase"]doubleValue];
                            markerIconImage=[vehicleImageArray objectAtIndex:4];
                        }
                        else {
                            price_per_minute=[driverZoneDict valueForKey:@"truck_min"];
                            price_per_mile=[driverZoneDict valueForKey:@"truck_price"];
                            base_fare=[driverZoneDict valueForKey:@"truck_base"];
                            surgeValue=[driverZoneDict valueForKey:@"truck_surge"];
                            h_total_fare=[driverZoneDict valueForKey:@"truck_hour"];
                            f_total_fare=[driverZoneDict valueForKey:@"truck_hourfull"];
                            minPrice=[[driverZoneDict valueForKey:@"truck_minbase"]doubleValue];
                            //   markerIconImage=[vehicleImageArray objectAtIndex:5];
                            
                        }
                        estimatedTimeStr=[driverInfoDict valueForKey:@"Time"];
                        
                        if (estimatedTimeStr.length>7)
                        {
                            NSArray *timeArray = [estimatedTimeStr componentsSeparatedByString:@" "];
                            int minutes=[[timeArray objectAtIndex:2]intValue];
                            int hours=[[timeArray objectAtIndex:0]intValue];
                            minutes=hours*60+minutes;
                            estimatedTimeStr=[NSString stringWithFormat:@"%d",minutes];
                        }
                        
                        NSDictionary *tempDriveridDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:driverid,@"driverId",estimatedTimeStr,@"time" ,surgeValue,@"surgeValue" ,nil];
                        
                        [tempDriverIdArray addObject:tempDriveridDict];
                        
                        vehicleCount++;
                        
                        gc = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",latitude],@"lat",[NSString stringWithFormat:@"%f",longitude],@"lng",vehicleTypeName,@"name",firstname,@"FirstName",lastname,@"LastName" ,estimatedTimeStr,@"Time",nil];
                        
                        location = gc;
                        double lat1 = [[location objectForKey:@"lat"] doubleValue];
                        NSLog(@"Marker position%f",lat1);
                        double lng1 = [[location objectForKey:@"lng"] doubleValue];
                        NSLog(@"Marker position%f",lng1);
                        
                        GMSMarker *vehicleMarker = [[GMSMarker alloc]init];
                        CLLocationCoordinate2D local = CLLocationCoordinate2DMake(lat1, lng1);
                        
                        
                        if (isOneWay && base_fare.length>0)
                        {
                            vehicleMarker.position = local;
                            vehicleMarker.icon = [UIImage imageNamed:markerIconImage];
                            vehicleMarker.map = mapView;
                            
                        }
                        else if (isHalfDay && h_total_fare.length>0)
                        {
                            vehicleMarker.position = local;
                            vehicleMarker.icon = [UIImage imageNamed:markerIconImage];
                            vehicleMarker.map = mapView;
                        }
                        else if (isFullDay && f_total_fare.length>0)
                        {
                            vehicleMarker.position = local;
                            vehicleMarker.icon = [UIImage imageNamed:markerIconImage];
                            vehicleMarker.map = mapView;
                            
                        }
                    }
                }
                
            }
            
            NSArray *favDrivrListArray= [FavDriverListStr componentsSeparatedByString:@","];
            if (tempDriverIdArray.count>0)
            {
                for (int m=0;m<tempDriverIdArray.count; m++)
                {
                    int driverTime=[[[tempDriverIdArray objectAtIndex:m]valueForKey:@"time"]intValue];
                    
                    if (m==0)
                    {
                        NSString *drivrstr=[[tempDriverIdArray objectAtIndex:m]valueForKey:@"driverId"];
                        
                        if ([favDrivrListArray containsObject:drivrstr])
                        {
                            driverIdStr=[[tempDriverIdArray objectAtIndex:m]valueForKey:@"driverId"];
                            nearsCarMintStr=[[tempDriverIdArray objectAtIndex:m]valueForKey:@"time"];
                            surgeValue=[[tempDriverIdArray objectAtIndex:m]valueForKey:@"surgeValue"];
                            if ([driverIdArray containsObject:driverIdStr])
                            {
                                [driverIdArray removeObject:driverIdStr];
                            }
                            [driverIdArray addObject:driverIdStr];
                        }
                        else{
                            driverIdStr=[[tempDriverIdArray objectAtIndex:m]valueForKey:@"driverId"];
                            nearsCarMintStr=[[tempDriverIdArray objectAtIndex:m]valueForKey:@"time"];
                            surgeValue=[[tempDriverIdArray objectAtIndex:m]valueForKey:@"surgeValue"];
                        }
                    }
                    else if ( m>0 && driverTime<tempTime)
                    {
                        
                        NSString *drivrstr=[[tempDriverIdArray objectAtIndex:m]valueForKey:@"driverId"];
                        
                        if  ([favDrivrListArray containsObject:drivrstr])
                        {
                            nearsCarMintStr=[[tempDriverIdArray objectAtIndex:m]valueForKey:@"time"];
                            driverIdStr=[[tempDriverIdArray objectAtIndex:m]valueForKey:@"driverId"];
                            surgeValue=[[tempDriverIdArray objectAtIndex:m]valueForKey:@"surgeValue"];
                            if ([driverIdArray containsObject:driverIdStr])
                            {
                                [driverIdArray removeObject:driverIdStr];
                            }
                            [driverIdArray addObject:driverIdStr];
                        }
                        else{
                            nearsCarMintStr=[[tempDriverIdArray objectAtIndex:m]valueForKey:@"time"];
                            driverIdStr=[[tempDriverIdArray objectAtIndex:m]valueForKey:@"driverId"];
                            surgeValue=[[tempDriverIdArray objectAtIndex:m]valueForKey:@"surgeValue"];
                        }
                    }
                    tempTime=driverTime;
                }
            }
            
            marker.map = mapView;
            if (vehicleCount<1)
            {
                base_fare=@"";
                price_per_minute=@"";
                driverIdStr=@"";
                price_per_mile=@"";
                f_total_fare=@"";
                h_total_fare=@"";
                
                [self.vehicleTypleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                
                if([[[NSUserDefaults standardUserDefaults ]valueForKey:@"first"] isEqualToString:@"first"])
                {
                    [[NSUserDefaults standardUserDefaults ]setValue:@"" forKey:@"first"];
                    NSString *alertMeassageStr=[NSString stringWithFormat:@"%@ vehicles are not available, Try another.",vehicleTypeName ] ;
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Rapid" message:alertMeassageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alertView show];
                }
            }
            if([[[NSUserDefaults standardUserDefaults ]valueForKey:@"first"] isEqualToString:@"first"])
            {
                [[NSUserDefaults standardUserDefaults ]setValue:@"" forKey:@"first"];
            }
  //      }
    }
        

    
    NSLog(@"%@.. drivrarray",driverIdArray);
}

- (IBAction)tipViewBtn:(id)sender
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

    [Vtimer invalidate];
    [timer invalidate];
    [popUptimer invalidate];
    [LocationTimer invalidate];
    [self.navigationController pushViewController:ridefinishVC animated:YES];
}

- (IBAction)favDriverBtn:(id)sender
{
    if (isFavDriver)
    {
        isFavDriver=NO;
        self.favDrivrBtn.backgroundColor=[UIColor clearColor];
        [self showVehicles];
        return;
    }
    else{
        isFavDriver=YES;
        self.favDrivrBtn.backgroundColor=[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1];
        [self showVehicles];
        return;

    }
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelBtn:(id)sender
{
    [locationSearchTxt becomeFirstResponder];
    
    if (ispickupLocationSearch)
    {
        if(isStartLoc)
        {
            self.locationSearchTxt.text=@"";
 
        }
        else {
            self.pickupLocationTxt.text=@"";

        }
        placesTableView.hidden=YES;
       // [self.view endEditing:YES];
    }
    else{
        
        placesTableView.hidden=YES;
        self.locationSearchTxt.text=@"";
       // [self.view endEditing:YES];
    }
  
}

- (IBAction)driverMode:(id)sender
{
    NSLog(@"Toggle is %lu", driverModeToggle.state);
    if ([riderDriverIdStr isEqualToString:@""] && driverModeToggle.state==0)
    {
        [driverModeToggle setOn:NO animated:YES];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"You are not activated to drive yet." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [driverModeToggle setOn:NO animated:YES];
    }
    else
    {
        if (driverModeToggle.state==0)
        {
            [driverModeToggle setOn:YES animated:YES];
            NSLog(@"Driver ID %@",riderDriverIdStr);
            [self updateDriverTokon];
            [[NSUserDefaults standardUserDefaults] setValue:@"DriverSide" forKey:@"Queue"];
            DriverFirstViewViewController*driverFirstVc;
            
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                driverFirstVc=[[DriverFirstViewViewController alloc]initWithNibName:@"DriverFirstViewViewController" bundle:nil];
            }
            else if([[UIScreen mainScreen] bounds].size.height == 480)
            {
                driverFirstVc=[[DriverFirstViewViewController alloc]initWithNibName:@"DriverFirstViewViewController_iphone4" bundle:nil];
                // this is iphone 4 xib
            }

            
            driverFirstVc.driverIdStr=riderDriverIdStr;
            driverFirstVc.RiderIdStr=userIdStr;
            driverFirstVc.driverMode=YES;
            [Vtimer invalidate];
            [timer invalidate];
            [popUptimer invalidate];
            [LocationTimer invalidate];
            [self.navigationController pushViewController:driverFirstVc animated:YES];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [sideView.layer addAnimation:transition forKey:nil];
            sideView.hidden=YES;
        }
        else{
            [[NSUserDefaults standardUserDefaults] setValue:@"RiderSide" forKey:@"Queue"];
            [driverModeToggle setOn:NO animated:YES];
        }
    }
}
-(void)updateDriverTokon
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    webserviceCode =1;
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"Driver"],@"Role",riderDriverIdStr,@"DriverId",userIdStr,@"RiderId",[NSString stringWithFormat:@"%@",[defaults valueForKey:@"user_UDID_Str"]],@"DeviceUDId",[NSString stringWithFormat:@"%@",[defaults valueForKey:@"registrationID"]],@"TokenID",[NSString stringWithFormat:@"ios"],@"Trigger",nil];
    
    
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
- (IBAction)driverBtn:(id)sender;
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [sideView.layer addAnimation:transition forKey:nil];
    sideView.hidden=YES;

    DriverFirstViewViewController*driverFirstVc;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        driverFirstVc=[[DriverFirstViewViewController alloc]initWithNibName:@"DriverFirstViewViewController" bundle:nil];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480)
    {
        driverFirstVc=[[DriverFirstViewViewController alloc]initWithNibName:@"DriverFirstViewViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }

    
    driverFirstVc.driverIdStr=@"9";
    [Vtimer invalidate];
    [timer invalidate];
    [popUptimer invalidate];
    [LocationTimer invalidate];
    [self.navigationController pushViewController:driverFirstVc animated:YES];
}


#pragma marks - marker Delegates

- (void)mapView:(GMSMapView *)mapView didBeginDraggingMarker:(GMSMarker *)marker{
    //ismoveMarkr=YES;
}

- (void)mapView:(GMSMapView *)mapView didDragMarker:(GMSMarker *)marker3{
    NSLog(@"marker  positions lattitude :%f",marker3.position.latitude);
    NSLog(@"marker  positions longitude :%f",marker3.position.longitude);

}

- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate{
    
}

- (void) mapView:(GMSMapView *)mapView1 didTapInfoWindowOfMarker:(GMSMarker *)marker1{
    //isDestinationLocMrkr=YES;
    NSString *locationAdressStr=marker1.snippet;
    float adressLatitude=marker1.position.latitude;
    float adressLongitude=marker1.position.longitude;
    
    NSLog(@"adres .. %@", locationAdressStr);
    NSLog(@"latitud..%f",adressLatitude);
    NSLog(@"log..%f",adressLongitude);
    
    if ( isEndLoc && [marker1.title isEqualToString:@"Set destination location"])
    {
        endLattitude=adressLatitude;
        endLongitude=adressLongitude;
        destinationLocationStr=@"";
        destinationLocationStr=marker1.snippet;
        locationSearchTxt.text=destinationLocationStr;
    }
    else if(isStartLoc && [marker1.title isEqualToString:@"Set pickup location"])
    {
        startLatitude=adressLatitude;
        startLongitude=adressLongitude;
        startLocationStr=@"";
        startLocationStr=marker1.snippet;
        pickupLocationTxt.text=startLocationStr;
    }

    else{
        if ([marker1.title isEqualToString:@"Set pickup location"])
        {
            startLatitude=adressLatitude;
            startLongitude=adressLongitude;
            startLocationStr=@"";
            startLocationStr=marker1.snippet;
            pickupLocationTxt.text=startLocationStr;

        }
        else if ([marker1.title isEqualToString:@"Set destination location"])
        {
            endLattitude=adressLatitude;
            endLongitude=adressLongitude;
            destinationLocationStr=@"";
            destinationLocationStr=marker1.snippet;
            locationSearchTxt.text=destinationLocationStr;
        }
    }
    
   // pickupLocationLbl.text=[NSString stringWithFormat:@"%@",startLocationStr];

    NSLog(@"start latitude..%f",startLatitude);
    NSLog(@"stat longitude..%f",startLongitude);
    NSLog(@"end latitude..%f",endLattitude);
    NSLog(@"endlogitude..%f",endLongitude);
    NSLog(@"start address..%@",startLocationStr);
    NSLog(@"destination address..%@",destinationLocationStr);
    mapView1.selectedMarker = nil;
    
    if (isStartLoc || isEndLoc)
    {
        [self moveToPricingView];
    }
    else if([marker1.title isEqualToString:@"Set destination location"])
    {
        [mapView clear];
        endMarker = [[GMSMarker alloc] init];
        marker.position=CLLocationCoordinate2DMake(startLatitude ,startLongitude );
        endMarker.position=CLLocationCoordinate2DMake(endLattitude ,endLongitude);
        endMarker.icon = [UIImage imageNamed:@"red_flag_icon.png"];
        marker.icon = [UIImage imageNamed:@"green_flag_icon.png"];
        endMarker.title=@"Set destination location";
        marker.title=@"Set pickup location";
        marker.snippet=startLocationStr;
        endMarker.snippet=destinationLocationStr;
        endMarker.map=mapView;
        marker.map=mapView;
       [self moveToPricingView];
    }
    
}

#pragma marks - Custom Marker Window

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker5{
    
    
    int popupWidth = 280;
    int contentWidth = 245;
    int contentHeight = 80;
    int contentPad = 10;
    int popupHeight = 80;
    int popupBottomPadding = 16;
    int popupContentHeight = contentHeight - popupBottomPadding;
    int buttonHeight = 30;
    int anchorSize = 20;
    
    CLLocationCoordinate2D anchor = marker.position;
    CGPoint point = [mapView.projection pointForCoordinate:anchor];


    UIView *outerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, popupWidth, popupHeight)];
  
    float offSet = anchorSize * M_SQRT2;
    CGAffineTransform rotateBy45Degrees = CGAffineTransformMakeRotation(M_PI_4); //rotate by 45 degrees
    UIView *callOut = [[UIView alloc] initWithFrame:CGRectMake((popupWidth - offSet)/2.0, popupHeight - offSet, anchorSize, anchorSize)];
    callOut.transform = rotateBy45Degrees;
    callOut.backgroundColor = [UIColor blackColor];
   // [outerView addSubview:callOut];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, popupWidth, 190)];
    [view setBackgroundColor:[UIColor whiteColor]];

//    view.layer.cornerRadius = 5;
//    view.layer.masksToBounds = YES;
//
//    view.layer.borderColor = [UIColor blackColor].CGColor;
//    view.layer.borderWidth = 2.0f;

    UIImageView *image =[[UIImageView alloc] initWithFrame:CGRectMake(250,20,28,28)];
    image.image=[UIImage imageNamed:@"arrow.png"];

    
    
//    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [editButton addTarget:self
//               action:@selector(editButton:)
//     forControlEvents:UIControlEventTouchUpInside];
//    [editButton setTitle:@"EDIT" forState:UIControlStateNormal];
//    editButton.frame = CGRectMake(200, 0, 100, 30);
  
    UILabel *minutesLabel = [[UILabel alloc] initWithFrame:CGRectMake(150,0,100,22)];
    [minutesLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:12]];
    if (nearsCarMintStr.length==0) {
        minutesLabel.text  =@"No cars";
    }
    else{
        minutesLabel.text  =[NSString stringWithFormat:@"(%@)",nearsCarMintStr];
    }
    minutesLabel.textColor=[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, contentWidth, 22)];
    [titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:17]];
    titleLabel.text = [marker5 title];
    
    UITextView *descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(3, 20, contentWidth, 120)];
    [descriptionView setFont:[UIFont fontWithName:@"Myriad Pro" size:11]];
    descriptionView.editable=NO;
    descriptionView.text = [marker5 snippet];

    if ([marker5.title isEqualToString:@"Set pickup location"]) {
        [view addSubview:minutesLabel];
        [view addSubview:titleLabel];
        [view addSubview:descriptionView];
        [view addSubview:image];
        [outerView addSubview:view];
    }
    else if ([marker5.title isEqualToString:@"Set destination location"])
    {
        [minutesLabel removeFromSuperview];
        [view addSubview:titleLabel];
        [view addSubview:descriptionView];
        [view addSubview:image];
        
        [outerView addSubview:view];

    }
    
   
    return outerView;

}

#pragma marks - MAP VIEW Delegates


- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
}


- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
}
- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture{
    
}


- (IBAction)MyQueueBtnAction:(id)sender
{
     [locationManager stopUpdatingLocation];
    [[NSUserDefaults standardUserDefaults]setValue:@"RiderSide" forKey:@"Queue"];

    DriverRequestAndQueueViewController*driverFirstVc=[[DriverRequestAndQueueViewController alloc]init];
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        driverFirstVc=[[DriverRequestAndQueueViewController alloc]initWithNibName:@"DriverRequestAndQueueViewController" bundle:nil];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480)
    {
        driverFirstVc=[[DriverRequestAndQueueViewController alloc]initWithNibName:@"DriverRequestAndQueueViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }
    
    
    driverFirstVc.RiderIdStr=userIdStr;
    driverFirstVc.RequestType=@"rider";
    //driverFirstVc.driverMode=YES;
    [timer invalidate];
    [Vtimer invalidate];
    [popUptimer invalidate];
    [LocationTimer invalidate];
    [self.navigationController pushViewController:driverFirstVc animated:YES];
    [self.view endEditing:YES];
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

- (IBAction)halfDaySelectBtn:(id)sender {
    
    [self.vipBtn setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    [self.oneWayBtn setBackgroundColor:[UIColor clearColor]];
    self.locationSearchTxt.userInteractionEnabled=NO;
    self.searchBtn.userInteractionEnabled=NO;
    self.cancelSearchtn.userInteractionEnabled=NO;
    isHalfDay=YES;
    isFullDay=NO;
    isVIP=YES;
    isOneWay=NO;
    self.vipBackView.hidden=YES;
    self.goHomeBTn.hidden=YES;
    self.goHomeBTn.userInteractionEnabled=NO;
    
    
     [mapView clear];
    
    current_longitude=locationManager.location.coordinate.longitude;
    current_latitude=locationManager.location.coordinate.latitude;
    marker.position = CLLocationCoordinate2DMake(current_latitude ,current_longitude );
    GMSCameraUpdate *cam;
    CLLocationCoordinate2D posOfMarker=CLLocationCoordinate2DMake(current_latitude, current_longitude);

    cam= [GMSCameraUpdate setTarget:posOfMarker zoom:15];
    [mapView animateWithCameraUpdate:cam];

    marker.map = mapView;

    self.locationSearchTxt.text=@"";

}

- (IBAction)fulDaySelectBTn:(id)sender {
    [self.vipBtn setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    [self.oneWayBtn setBackgroundColor:[UIColor clearColor]];
    self.locationSearchTxt.userInteractionEnabled=NO;
    self.searchBtn.userInteractionEnabled=NO;
    self.cancelSearchtn.userInteractionEnabled=NO;

    isHalfDay=NO;
    isFullDay=YES;
    isVIP=YES;
    isOneWay=NO;
    self.vipBackView.hidden=YES;
    self.goHomeBTn.hidden=YES;
    self.goHomeBTn.userInteractionEnabled=NO;
    
    [mapView clear];
    
    current_longitude=locationManager.location.coordinate.longitude;
    current_latitude=locationManager.location.coordinate.latitude;
    marker.position = CLLocationCoordinate2DMake(current_latitude ,current_longitude );
    CLLocationCoordinate2D posOfMarker=CLLocationCoordinate2DMake(current_latitude, current_longitude);
    
    GMSCameraUpdate*cam= [GMSCameraUpdate setTarget:posOfMarker zoom:15];
    [mapView animateWithCameraUpdate:cam];
    marker.map = mapView;
    self.locationSearchTxt.text=@"";
}

- (IBAction)contactUsBtn:(id)sender {
    [timer invalidate];
    [popUptimer invalidate];
    [LocationTimer invalidate];
[Vtimer invalidate];
  
    HelpViewController*helpVc;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        helpVc=[[HelpViewController alloc]initWithNibName:@"HelpViewController" bundle:nil];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480)
    {
        helpVc=[[HelpViewController alloc]initWithNibName:@"HelpViewController_iphone4" bundle:nil];
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

- (IBAction)seachPickupLocationBtn:(id)sender
{
    Vtimer= [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(fetchVehicleList) userInfo:nil repeats:YES];
    ispickupLocationSearch=YES;
    isdestinationLocSearch=NO;
    [self.view endEditing:YES];
    self.placesTableView.hidden=YES;
    [mapView clear];
    
    [pickupLocationTxt resignFirstResponder];
    location=nil;
    
    NSString *url=[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", pickupLocationTxt.text];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *queryUrl = [NSURL URLWithString:url];
    NSLog(@"query url%@",queryUrl);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *data = [NSData dataWithContentsOfURL:queryUrl];
        [self fetchLongitudeAndLattitude:data];
    });


}

- (IBAction)cancelPickUpBtn:(id)sender {
   
    placesTableView.hidden=YES;
    self.pickupLocationTxt.text=@"";
  //  [self.view endEditing:YES];
    pickupLocationTxt.userInteractionEnabled=YES;
    [pickupLocationTxt becomeFirstResponder];

}

- (IBAction)editBtn:(id)sender {
    //isDestinationLocMrkr=NO;
}

- (IBAction)viewRidesBtn:(id)sender {
    [Vtimer invalidate];
    [timer invalidate];
    [popUptimer invalidate];
    [LocationTimer invalidate];
    viewRideUrl=[NSString stringWithFormat:@"http://appba.riderapid.com/rider_report/?rideid=%@",userIdStr];
    
    AboutUsViewController *aboutus;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        aboutus=[[AboutUsViewController alloc]initWithNibName:@"AboutUsViewController" bundle:nil];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480)
    {
        aboutus=[[AboutUsViewController alloc]initWithNibName:@"AboutUsViewController_iphone4" bundle:nil];
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

- (void)serviceUdid
{
    webserviceCode=3;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *registrationIDStr=[defaults valueForKey:@"registrationID"];
    NSString *user_UDID_Str=[defaults valueForKey:@"user_UDID_Str"];

    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"Rider",@"Role",[NSString stringWithFormat:@"%@",riderDriverIdStr],@"DriverId",userIdStr,@"RiderId",user_UDID_Str,@"DeviceUDId",registrationIDStr,@"TokenID",@"ios",@"Trigger",  nil];
    
   
    NSString *jsonRequest = [jsonDict JSONRepresentation];

    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/RegisterDevice",Kwebservices]];
    
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

- (IBAction)oneWayBtn:(id)sender {
    [self.oneWayBtn setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    [self.vipBtn setBackgroundColor:[UIColor clearColor]];
    self.locationSearchTxt.userInteractionEnabled=YES;
    self.searchBtn.userInteractionEnabled=YES;
    self.cancelSearchtn.userInteractionEnabled=YES;

    isVIP=NO;
    isOneWay=YES;
    self.goHomeBTn.hidden=NO;
    self.goHomeBTn.userInteractionEnabled=YES;
}

- (IBAction)vipBtn:(id)sender
{
    if (self.vipBackView.hidden==NO)
    {
        self.vipBackView.hidden=YES;
    }
    else{
        self.vipBackView.hidden=NO;
    }
}

-(void)moveToPricingView
{
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"payment_status"] isEqualToString:@"1"])
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Please add credit card in your profile." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    [self.view endEditing:YES];
    self.placesTableView.hidden=YES;
    NSLog(@"start latitude..%f",startLatitude);
    NSLog(@"stat longitude..%f",startLongitude);
    NSLog(@"end latitude..%f",endLattitude);
    NSLog(@"endlogitude..%f",endLongitude);
    
    
    if (startLocationStr == nil)
    {
        startLocationStr=@"";
    }
    if (destinationLocationStr == nil)
    {
        destinationLocationStr=@"";
    }
    
    if ([startLocationStr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Select the pickup location." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [pickupLocationTxt becomeFirstResponder];
        
    }
    else if ([destinationLocationStr isEqualToString:@""] && isOneWay)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Select the destination location." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [locationSearchTxt becomeFirstResponder];

    }
    else if (isOneWay &&( base_fare.length==0 || price_per_mile.length==0|| price_per_minute.length==0))
    {
        isdestinationLocSearch=NO;
        ispickupLocationSearch=NO;
        base_fare=@"";
        price_per_minute=@"";
        driverIdStr=@"";
        price_per_mile=@"";
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"No %@ vehicle available in this area.",vehicleTypeName] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [self.vehicleTypleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isdestinationLocSearch=NO;
        
    }
    else if (isVIP && [h_total_fare floatValue]==0 && [f_total_fare floatValue]==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"No %@ vehicle available in this area.",vehicleTypeName] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        isdestinationLocSearch=NO;
    }

    else{
        LocationAndPriceDetailViewController *detailVc;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            detailVc=[[LocationAndPriceDetailViewController alloc]initWithNibName:@"LocationAndPriceDetailViewController" bundle:nil];
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480) {
            detailVc=[[LocationAndPriceDetailViewController alloc]initWithNibName:@"LocationAndPriceDetailViewController_iphone4" bundle:nil];
            // this is iphone 4 xib
        }

        detailVc.start_latitude=startLatitude;
        detailVc.start_longitude=startLongitude;
        detailVc.end_latitude=endLattitude;
        detailVc.end_longitude=endLongitude;
        detailVc.startLocAddressStr=startLocationStr;
        detailVc.endLocAddressStr=destinationLocationStr;
        detailVc.price_per_minute=price_per_minute;
        detailVc.price_per_mile=price_per_mile;
        detailVc.base_fare=base_fare;
        detailVc.driverIdStr=driverIdStr;
        detailVc.vehicleType=vehicleType;
        detailVc.minPrice=minPrice;
        
        detailVc.driverIdArray=[driverIdArray copy];
        detailVc.isVIP=isVIP;
        detailVc.isOneWay=isOneWay;
        detailVc.isHalfDay=isHalfDay;
        detailVc.isFullday=isFullDay;
        detailVc.surgeValue=surgeValue;
        detailVc.isFavDriver=isFavDriver;
        
        if (isVIP && isHalfDay)
        {
            detailVc.actualFare=h_total_fare;
        }
        else if (isVIP && isFullDay)
        {
            detailVc.actualFare=f_total_fare;
        }
        [Vtimer invalidate];
        [timer invalidate];
        [popUptimer invalidate];
        [LocationTimer invalidate];
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}
- (IBAction)finishRideView:(id)sender {
    
    RideFinishViewController*rideFvc=[[RideFinishViewController alloc]init];
  
    [self.navigationController pushViewController:rideFvc animated:YES];

}
@end
