//
//  DriverRequestAndQueueViewController.m
//  RapidRide
//
//  Created by vikram on 03/11/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import "DriverRequestAndQueueViewController.h"
#import "LocateDriverOnMapViewController.h"
#import "SBJSON.h"
#import "JSON.h"
#import "MapViewController.h"
#import "Base64.h"
#import "DriverRideMapViewController.h"
NSMutableDictionary *UserImageDict;


@interface DriverRequestAndQueueViewController ()

@end

@implementation DriverRequestAndQueueViewController

@synthesize RequestType,activityIndicatorObject,driverIdStr,riderBasicInfoBackView,riderLocatioInfoBackView,driverMode,RiderIdStr,modeType,GetDriverId,CancelRideBtn,handicappdImgView,FromNotification,GetTripId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    
    
    self.riderImage.layer.borderColor = [UIColor grayColor].CGColor;
    self.riderImage.layer.borderWidth = 1.5;
    self.riderImage.layer.cornerRadius = 10.0;
    [self.riderImage setClipsToBounds:YES];

    phNo = @"619-600-5080";
    UserImageDict=[[NSMutableDictionary alloc] init];
    GetDriverId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"driverid"];
    RiderIdStr=[[NSUserDefaults standardUserDefaults ]valueForKey:@"riderId"];
    DriverSwitchBtn.on=YES;
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    [self.headerView setBackgroundColor:[UIColor colorWithRed:(3.0 / 255.0) green:(15.0 / 255.0) blue:(51.0 / 255.0) alpha:1]];
    
    [self.headerLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:30]];
    [self.riderNameLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:17]];
    [self.riderDistanceLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:14]];
    [self.riderEndLocTxtView setFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
    [self.riderStartLocTxtView setFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
    [self.riderSuggestdFareLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
    [self.riderActualFareLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
    [self.activrRidebtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:20]];
    [self.CancelRideBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:20]];
    [self.EtaTimeLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:13]];
    [modelValueLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:13]];
    
    
    self.riderStartLocTxtView.textColor=[UIColor colorWithRed:34/255.0 green:139/255.0 blue:34/255.0 alpha:1];
    self.riderEndLocTxtView.textColor=[UIColor colorWithRed:205/255.0 green:92/255.0 blue:92/255.0 alpha:1];
    
    
    riderBasicInfoBackView.layer.borderColor = [UIColor grayColor].CGColor;
    riderBasicInfoBackView.layer.cornerRadius = 10.0;
    
    riderLocatioInfoBackView.layer.borderColor = [UIColor whiteColor].CGColor;
    riderLocatioInfoBackView.layer.cornerRadius = 10.0;
    
    
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
    [self.view addSubview:activityIndicatorObject];
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        self.activrRidebtn.frame=CGRectMake(85, 490, 150, 60);
        self.CancelRideBtn.frame=CGRectMake(85, 490, 150, 60);
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        self.activrRidebtn.frame=CGRectMake(85, 413, 150, 55);
        self.CancelRideBtn.frame=CGRectMake(85, 413, 150, 55);
        // this is iphone 4 xib
    }
    
    
    [self.view addSubview:self.activrRidebtn];
    self.activrRidebtn.hidden=YES;
    DriverLocBtnOutlet.hidden=YES;
    self.requestTable.hidden=YES;
    [self.view addSubview:self.CancelRideBtn];
    self.CancelRideBtn.hidden=YES;
    
    if (FromNotification)
    {
        [[NSUserDefaults standardUserDefaults ]setValue:@"RideDetailView" forKey:@"RideDetailView"];
        [self GettripData];
        self.disablImg.hidden=NO;
    }
    else
    {
        if ([RequestType isEqualToString:@"requests"])
        {
            handicappdImgView.hidden=NO;
            [self.activityIndicatorObject startAnimating];
            self.view.userInteractionEnabled=NO;
            self.disablImg.hidden=NO;
            [self fetchPendingRequestsDetail];
            
        }
        else if ([RequestType isEqualToString:@"queue"])
        {
            handicappdImgView.hidden=NO;
            
            [self.activityIndicatorObject startAnimating];
            self.view.userInteractionEnabled=NO;
            self.disablImg.hidden=NO;
            [self fetchQueueDetail];
            timer= [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(fetchQueueDetail) userInfo:nil repeats:YES];
            
        }
        else if ([RequestType isEqualToString:@"rider"])
        {
            handicappdImgView.hidden=YES;
            [self.activityIndicatorObject startAnimating];
            self.view.userInteractionEnabled=NO;
            self.disablImg.hidden=NO;
            [self FetchRiderQueueDetails];
            timer1= [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(FetchRiderQueueDetails) userInfo:nil repeats:YES];
        }
    }

    
    [self.requestTable setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:51/255.0 alpha:1]];
    self.requestTable.layer.cornerRadius = 8;
    
    sideView.frame=CGRectMake(0, 66, 151, 501);
    [self.view addSubview:sideView];
    sideView.hidden=YES;
    
   }

-(void)GettripData
{
    [self.activityIndicatorObject startAnimating];
    self.requestTable.hidden=YES;
    self.riderDetailView.hidden=NO;
  
    webservice=8;
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:GetTripId,@"TripId",nil];
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetDetailsByTripId",Kwebservices]];
    [self postWebservices];
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self
                   action:@selector(BackButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(10, 27, 50, 30);
    [self.view addSubview:backButton];
    if (FromNotification)
    {
        self.backBtn.hidden=YES;
    }
    else{
        self.backBtn.hidden=NO;
    }

}

#pragma mark - Back Button Action

-(IBAction)BackButtonAction:(id)sender
{

        if (self.riderDetailView.hidden==YES)
        {
            
            [self.navigationController popViewControllerAnimated:YES];
            [timer invalidate];
            [timer1 invalidate];
            [qtimer invalidate];
            [qtimer1 invalidate];

        }
    else
        
    {
        self.passangerModeBtn.hidden=NO;
       // backButton.hidden=YES;
    }
    
    self.CancelRideBtn.hidden=YES;
    self.activrRidebtn.hidden=YES;
    AcceptBtn.hidden=NO;
    RejectBtn.hidden=NO;
    DriverLocBtnOutlet.hidden=YES;
    
 
    if(self.riderDetailView.hidden==NO)
    {
        self.riderDetailView.hidden=YES;
        self.requestTable.hidden=NO;
        qtimer= [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(fetchQueueDetail) userInfo:nil repeats:YES];
        qtimer1= [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(FetchRiderQueueDetails) userInfo:nil repeats:YES];
    }
    
    else if (self.requestTable.hidden==YES)
    {
        self.requestTable.hidden=NO;
    }
    else
    {
        // self.requestTable.hidden=YES;
    }
    
}

#pragma mark - Fetch Driver All Pending Requests

-(void)fetchPendingRequestsDetail
{
    self.activrRidebtn.hidden=YES;
    self.CancelRideBtn.hidden=YES;
    webservice=1;
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"Driver",@"Role",GetDriverId,@"Id",@"requests",@"Trigger",nil];
    jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/FetchPendingRideRequests",Kwebservices]];
    [self.activityIndicatorObject startAnimating];
    self.view.userInteractionEnabled=NO;
    self.disablImg.hidden=NO;
    [self postWebservices];
    
}

#pragma mark - Fetch Driver All Queues

-(void)fetchQueueDetail
{
    self.activrRidebtn.hidden=YES;
    self.CancelRideBtn.hidden=YES;
    
    webservice=1;
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"Driver",@"Role",GetDriverId,@"Id",@"queue",@"Trigger",nil];
    jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);

    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/FetchPendingRideRequests",Kwebservices]];

    [self postWebservices];
    
}

#pragma mark - Fetch Driver All Queues

-(void)FetchRiderQueueDetails
{
    NSLog(@"Rider");
    webservice=1;
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"Rider",@"Role",RiderIdStr,@"Id",@"queue",@"Trigger",nil];
    jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/FetchPendingRideRequests",Kwebservices]];
    [self postWebservices];
}


- (IBAction)backBtn:(id)sender
{
    [timer invalidate];
    [timer1 invalidate];
    [qtimer invalidate];
    [qtimer1 invalidate];

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Start Ride Button Action

-(IBAction)StartRideButtonAction:(id)sender
{
    webservice=4;
    backButton.hidden=YES;
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:GetTripId,@"TripId",nil];
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/StartRide",Kwebservices]];
    [self.activityIndicatorObject startAnimating];
    self.view.userInteractionEnabled=NO;
    self.disablImg.hidden=NO;
    [self postWebservices];
}


#pragma mark - Alert View Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex{
    
    if (alertView.tag==2)
    {
        if (buttonIndex==1)
        {
           // [self fetchPendingRequests];
        }
    }
    if (alertView==alertt)
    {
        if (buttonIndex==0)
        {
            [qtimer invalidate];
            [qtimer1 invalidate];

            [timer invalidate];
            [timer1 invalidate];

            [self.navigationController popViewControllerAnimated:NO];
        }
    }
    if (alertView.tag==1100)
    {
        if (buttonIndex==1)
        {
            webservice=6;
         //   role=@"rider";
            jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:GetTripId,@"TripId",@"rider",@"Trigger",@"",@"Reason",@"",@"Latitude",@"",@"Longitude",nil];
            jsonRequest = [jsonDict JSONRepresentation];
            
            NSLog(@"jsonRequest is %@", jsonRequest);
            
            
            urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/CancelRide",Kwebservices]];
            [self.activityIndicatorObject startAnimating];
            self.view.userInteractionEnabled=NO;
            self.disablImg.hidden=NO;
            [self postWebservices];
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
        alert=[[UIAlertView alloc]initWithTitle:@"Rapid Ride" message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    }
    else
    {
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
            requestListArray=nil;
            int result=[[userDetailDict valueForKey:@"result" ]intValue];
            if (result ==1)
            {
                alertt=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                //  [alertt show];
            }
            else
            {
                requestListArray=[userDetailDict valueForKey:@"PendingRequestList"];
                NSMutableArray *listOfTime = [[NSMutableArray alloc]initWithArray:requestListArray];
                
                NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"trip_request_pickup_date" ascending:YES];
                
                NSArray *sorters = [[NSArray alloc] initWithObjects:sorter, nil];
                
                sortedArray = [listOfTime sortedArrayUsingDescriptors:sorters];
                
                
                NSMutableArray *sortArray = [[NSMutableArray alloc] init];
                
                [sortArray addObjectsFromArray:sortedArray];
                
                NSLog(@"sortArray : %@",sortArray);
                if (requestListArray.count>0)
                {
                    self.numRequests.text=[NSString stringWithFormat:@"%lu",(unsigned long)requestListArray.count];
                }
                else{
                    self.numRequests.text=[NSString stringWithFormat:@""];
                }
            }
            self.requestTable.hidden=NO;
            [self.requestTable reloadData];
        }
    }
    else if(webservice==2)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
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
                if ([rideReqType isEqualToString:@"Now"])
                {
                    webservice=7;
                    
                    self.locationManager = [[CLLocationManager alloc] init];
                    self.locationManager.delegate = self;
                    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                    self.locationManager.distanceFilter = kCLDistanceFilterNone;
                    [self.locationManager startUpdatingLocation];
                    
                    float  current_longitude=self.locationManager.location.coordinate.longitude;
                    float  current_latitude=self.locationManager.location.coordinate.latitude;
                    
                    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:RiderIdStr,@"RiderId",GetDriverId,@"DriverId",@"Busy",@"Trigger",[NSString stringWithFormat:@"%f",current_longitude],@"Longitude",[NSString stringWithFormat:@"%f",current_latitude],@"Latitude",nil];
                    
                    jsonRequest = [jsonDict JSONRepresentation];
                    NSLog(@"jsonRequest is %@", jsonRequest);
                    
                    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/SwitchBetweenMode",Kwebservices]];
                    
                    [self postWebservices];
                    
                    
                            }
                else{
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    //[alert show];
                    self.riderDetailView.hidden=YES;
                    [self fetchPendingRequestsDetail];
                }
            }
        }
    }
     else if (webservice==3)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result" ]intValue];
            if (result ==1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                //   [alert show];
            }
            else
            {
                // requestListArray=nil;
                
                requestListArray=[userDetailDict valueForKey:@"PendingRequestList"];
                if (requestListArray.count>0)
                {
                    //self.numRequests.text=[NSString stringWithFormat:@"%lu",(unsigned long)requestListArray.count];
                }
                else{
                    self.numRequests.text=[NSString stringWithFormat:@""];
                }
            }
            self.requestTable.hidden=NO;
            [self.requestTable reloadData];
        }
    }
    else if (webservice==4)
    {
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result" ]intValue];
            if (result ==1)
            {
                alertt=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alertt show];
            }
            else
            {
                if ([RequestType isEqualToString:@"rider"])
                {
                    self.activrRidebtn.hidden=YES;
                    self.CancelRideBtn.hidden=YES;
                    endRideButtonOutlet.frame=CGRectMake(165, 510, 150, 30);
                    [self.view addSubview:endRideButtonOutlet];
                }
                else
                {
                    self.CancelRideBtn.hidden=YES;
                    self.activrRidebtn.hidden=YES;
                    endRideButtonOutlet.frame=CGRectMake(60, 512, 199, 30);
                    [self.view addSubview:endRideButtonOutlet];
                }
                
            }
        }
    }

    else if(webservice==5)
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
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                //  [alert show];
                self.riderDetailView.hidden=YES;
                [self fetchPendingRequestsDetail];
            }
        }
    }

    else if (webservice==6)
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
            [timer invalidate];
            [timer1 invalidate];
            [qtimer invalidate];
            [qtimer1 invalidate];
            self.CancelRideBtn.hidden=YES;
            
            self.riderDetailView.hidden=YES;
            [self fetchQueueDetail];
            MapViewController*mapviewObj;
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                mapviewObj = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
                
                //this is iphone 5 xib
            }
            else if([[UIScreen mainScreen] bounds].size.height == 480) {
                mapviewObj = [[MapViewController alloc] initWithNibName:@"MapViewController_iphone4" bundle:nil];
                
                // this is iphone 4 xib
            }
            [self.navigationController pushViewController:mapviewObj animated:NO];
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
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            DriverRideMapViewController*driverRideMapVc;
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                driverRideMapVc = [[DriverRideMapViewController alloc] initWithNibName:@"DriverRideMapViewController" bundle:nil];
                
                //this is iphone 5 xib
            }
            else if([[UIScreen mainScreen] bounds].size.height == 480) {
                driverRideMapVc = [[DriverRideMapViewController alloc] initWithNibName:@"DriverRideMapViewController_iphone4" bundle:nil];
                
                // this is iphone 4 xib
            }
          
            driverRideMapVc.GetNameStr=self.riderNameLbl.text;
            driverRideMapVc.GetTripId=GetTripId;
            driverRideMapVc.getDriverId=driverIdNew;
            driverRideMapVc.getDesignationStr=self.riderStartLocTxtView.text;
            driverRideMapVc.endLocationString=self.riderEndLocTxtView.text;
            driverRideMapVc.getFareStr=suggestdFareStR;
            driverRideMapVc.getETAstr=etaStr;
            driverRideMapVc.getimgeUrl=imgUrlStr;
            driverRideMapVc.getpickUptimrStr=pickuptimeStr;
            driverRideMapVc.getVehicleType=vehicleStr;
            driverRideMapVc.startLong=tripStartLong;
            driverRideMapVc.startLat=TripStartLat;
            driverRideMapVc.endlat=tripEndLat;
            driverRideMapVc.endLong=tripEndLong;
            driverRideMapVc.handicappedStr=handicapStr;
            // driverRideMapVc.colourStr=colourStr;
            [timer invalidate];
            [timer1 invalidate];
            [qtimer invalidate];
            [qtimer1 invalidate];
            
            [self.navigationController pushViewController:driverRideMapVc animated:YES];
            //  [alert show];
        }
    }
    
    else if (webservice==8)
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
            
            NSString *distanceStr=[userDetailDict valueForKey:@"trip_miles_est"];
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue" ] isEqualToString:@"RiderSide"] )
            {
                driverFirstName=[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"driver_name"]];

                self.riderNameLbl.text=[userDetailDict valueForKey:@"driver_name"];
                ratingStr=[userDetailDict valueForKey:@"driver_rating"];
                imgUrlStr=[userDetailDict valueForKey:@"driver_img"];
                
            
                modelValueLbl.hidden=NO;
                vehicleImageView.hidden=NO;

                
            }
            driverIdNew=[userDetailDict valueForKey:@"driverid"];
            
            
            
            NSString *vehicle_color=[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"vehicle_color"]];
            NSString *vehicle_img=[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"vehicle_img"]];
            NSString* vehicle_year=[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"vehicle_year"]];
            NSString *vehicle_name=[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"vehicle_name"]];
            
            modelValueLbl.text=[NSString stringWithFormat:@"%@ %@ %@",vehicle_year,vehicle_color, vehicle_name];

            
            self.riderStartLocTxtView.text= [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"starting_loc"]];
            self.riderEndLocTxtView.text = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"ending_loc"]];
            
            TripStartLat=[userDetailDict valueForKey:@"start_lat"];
            tripStartLong=[userDetailDict valueForKey:@"start_lon"];
            tripEndLat=[userDetailDict valueForKey:@"end_lat"];
            tripEndLong=[userDetailDict valueForKey:@"end_lon"];
            
            suggestdFareStR= [NSString stringWithFormat:@"$%@",[userDetailDict valueForKey:@"offered_fare"]];
            
            float milesEst=[[userDetailDict valueForKey:@"trip_miles_est"]floatValue];
            self.riderDistanceLbl.text = [NSString stringWithFormat:@"Distance: %.2f Miles",milesEst];
            
            self.riderSuggestdFareLbl.text= [NSString stringWithFormat:@"Suggested Fare : $%@",[userDetailDict valueForKey:@"offered_fare"]];
            
            
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"offered_fare"]] forKey:@"FareValueForTip"];
            
            
            pickuptimeStr=[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"trip_request_pickup_date"]];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"YYYYMMddHHmmss"];
            NSDate *date = [dateFormat dateFromString:pickuptimeStr];
            
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
                    pickuptimeStr=[format stringFromDate:date];
                }
                    break;
                case NSOrderedDescending:
                {
                    NSLog(@"NSOrderedDescending");
                    
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    format.dateFormat = @"dd-MM-yyyy";
                    pickuptimeStr=[format stringFromDate:date];
                }
                    break;
            }
            
            vehicleStr=[userDetailDict valueForKey:@"vehicle_type"];
            etaStr=[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"trip_time_est"]];
            
            if ([[userDetailDict valueForKey:@"trip_time_est"] rangeOfString:@"min"].location ==NSNotFound
                ||
                [[userDetailDict valueForKey:@"trip_time_est"] rangeOfString:@"mins"].location ==NSNotFound )
                
            {
                
                self.EtaTimeLbl.text=[NSString stringWithFormat:@"ETA : %@mins",[userDetailDict valueForKey:@"trip_time_est"]];
            }
            else{
                
                self.EtaTimeLbl.text=[NSString stringWithFormat:@"ETA : %@",[userDetailDict valueForKey:@"trip_time_est"]];
            }
            
            
            
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue" ] isEqualToString:@"RiderSide"] )

            {
                if ([[UIScreen mainScreen] bounds].size.height == 568) {
                    self.riderImage.frame=CGRectMake(7, 7, 65, 65);
                    self.riderNameLbl.frame=CGRectMake(5, 60, self.riderNameLbl.frame.size.width, self.riderNameLbl.frame.size.width);            }
                else if([[UIScreen mainScreen] bounds].size.height == 480)
                {
                    self.riderImage.frame=CGRectMake(7, 7, 60, 60);
                    self.riderNameLbl.frame=CGRectMake(5,55, self.riderNameLbl.frame.size.width, self.riderNameLbl.frame.size.width);
                    // this is iphone 4 xib
                }
                
             
                modelValueLbl.hidden=NO;
             
                vehicleImageView.hidden=NO;
                
                
                
                // Set vehicle image Using Dispatch Queue //
                
                UIActivityIndicatorView *objactivityindicator1=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                objactivityindicator1.center = CGPointMake((vehicleImageView.frame.size.width/2),(vehicleImageView.frame.size.height/2));
                [vehicleImageView addSubview:objactivityindicator1];
                //        [objactivityindicator1 startAnimating];
                
                if(vehicle_img.length==0)
                {
                    
                }
                else
                {
                    [objactivityindicator1 startAnimating];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
                        NSURL *imageURL=[NSURL URLWithString:[vehicle_img stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                        NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
                        UIImage *imgData=[UIImage imageWithData:tempData];
                        dispatch_async(dispatch_get_main_queue(), ^
                                       {
                                           if (tempData!=nil && [imgData isKindOfClass:[UIImage class]])
                                           {
                                               [vehicleImageView setImage:imgData];
                                               //  [UserImageDict setObject:imgData forKey:UrlString];
                                               [objactivityindicator1 stopAnimating];
                                           }
                                           else
                                           {
                                               [vehicleImageView setImage:[UIImage imageNamed:@""]];
                                               [objactivityindicator1 stopAnimating];
                                               
                                           }
                                       });
                    });
                }
                ////
            }
            else
            {
                if ([[UIScreen mainScreen] bounds].size.height == 568) {
                    self.riderImage.frame=CGRectMake(15, 20, 90, 100);
                    self.riderNameLbl.frame=CGRectMake(130, 30, self.riderNameLbl.frame.size.width, self.riderNameLbl.frame.size.width);
                }
                else if([[UIScreen mainScreen] bounds].size.height == 480)
                {
                    self.riderImage.frame=CGRectMake(15, 10, 90, 100);
                    self.riderNameLbl.frame=CGRectMake(110, 30, self.riderNameLbl.frame.size.width, self.riderNameLbl.frame.size.width);
                }
                vehicleImageView.hidden=YES;
                modelValueLbl.hidden=YES;
            }
            
            // Set User Image To Cell Using Dispatch Queue //
            
            UIActivityIndicatorView *objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            objactivityindicator.center = CGPointMake((self.riderImage.frame.size.width/2),(self.riderImage.frame.size.height/2));
            [self.riderImage addSubview:objactivityindicator];
            [objactivityindicator startAnimating];
            
            if([UserImageDict objectForKey:imgUrlStr]!=nil && [[UserImageDict objectForKey:imgUrlStr] isKindOfClass:[UIImage class]])
            {
                [self.riderImage setImage:[UserImageDict objectForKey:imgUrlStr]];
            }
            else
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
                    NSURL *imageURL=[NSURL URLWithString:[imgUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
                    UIImage *imgData=[UIImage imageWithData:tempData];
                    dispatch_async(dispatch_get_main_queue(), ^
                                   {
                                       if (tempData!=nil && [imgData isKindOfClass:[UIImage class]])
                                       {
                                           [self.riderImage setImage:imgData];
                                           //  [UserImageDict setObject:imgData forKey:UrlString];
                                           [objactivityindicator stopAnimating];
                                           
                                       }
                                       else
                                       {
                                           [self.riderImage setImage:[UIImage imageNamed:@"dummy_user.png"]];
                                           [objactivityindicator stopAnimating];
                                           
                                       }
                                   });
                });
            }
            ////
        }
        
        if ([rideReqType isEqualToString:@"VIP"])
        {
            self.riderDistanceLbl.hidden=YES;
            self.EtaTimeLbl.hidden=YES;
        }
        else{
            self.riderDistanceLbl.hidden=NO;
            self.EtaTimeLbl.hidden=NO;
            
        }
        if ( etaStr.length==0)
        {
            self.EtaTimeLbl.hidden=YES;
        }
        else {
            self.EtaTimeLbl.hidden=NO;
        }
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue" ] isEqualToString:@"DriverSide"] &&[RequestType isEqualToString:@"queue"])
        {
            messageBtn.hidden=YES;
            self.callBtn.hidden=YES;
        }
        else{
            messageBtn.hidden=NO;
            self.callBtn.hidden=NO;
        }
        
        self.riderActualFareLbl.hidden=YES;
        AcceptBtn.hidden=YES;
        RejectBtn.hidden=YES;
        DriverLocBtnOutlet.hidden=NO;
        
        
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self.CancelRideBtn.frame=CGRectMake(85, 490, 150, 60);
            //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480) {
            self.CancelRideBtn.frame=CGRectMake(85, 413, 150, 55);
            // this is iphone 4 xib
        }
        
        
        self.CancelRideBtn.hidden=NO;
        
        
        //  self.riderDetailView.hidden=NO;
        
        [[NSUserDefaults standardUserDefaults ]setValue:GetTripId forKey:@"tripId"];
        [[NSUserDefaults standardUserDefaults ]setValue:driverIdNew forKey:@"driverid"];
    }
    
}


#pragma mark - TableView field Delegates and Datasources

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( requestListArray.count<=5 && requestListArray.count>0)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self.requestTable.frame = CGRectMake(self.requestTable.frame.origin.x, self.requestTable.frame.origin.y,self.requestTable.frame.size.width, requestListArray.count*75);
        }
        else if ([[UIScreen mainScreen] bounds].size.height ==480) {
            self.requestTable.frame = CGRectMake(self.requestTable.frame.origin.x, self.requestTable.frame.origin.y,self.requestTable.frame.size.width, requestListArray.count*60+30);
        }
    }
    else if (requestListArray.count==0)
    {
        self.requestTable.frame = CGRectMake(self.requestTable.frame.origin.x, self.requestTable.frame.origin.y,self.requestTable.frame.size.width, 0);
    }
    else
    {
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self.requestTable.frame = CGRectMake(10, self.requestTable.frame.origin.y,self.requestTable.frame.size.width, 415);
        }
        else if ([[UIScreen mainScreen] bounds].size.height ==480) {
            self.requestTable.frame = CGRectMake(self.requestTable.frame.origin.x, self.requestTable.frame.origin.y,self.requestTable.frame.size.width,380);
        }
    }
    return [requestListArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *tempReqArray=[[NSMutableArray alloc]init];
    NSMutableArray *tempNameArray=[[NSMutableArray alloc]init];
    UILabel *UserNameLabel;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil)
//    {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //  UserName Lebal 
    
    UserNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 10, 75, 25)];
    //  UserNameLabel.backgroundColor=[UIColor whiteColor];
    UserNameLabel.textColor=[UIColor whiteColor];
    [cell.contentView addSubview:UserNameLabel];
    [UserNameLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:13]];
    
    //  Rating Lebal 
    
    UILabel *RatingLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 34, 100, 25)];
    //  UserNameLabel.backgroundColor=[UIColor whiteColor];
    RatingLabel.textColor=[UIColor whiteColor];
    [RatingLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:12]];
    
    [cell addSubview:RatingLabel];
    
    //  User Image  
    
    UIImageView *userImageView=[[UIImageView alloc] initWithFrame:CGRectMake(4, 10, 40, 50)];
    userImageView.layer.cornerRadius=3.0;
    userImageView.backgroundColor=[UIColor clearColor];
    //userImageView.image=[UIImage imageNamed:@"dummy_user.png"];
    [cell addSubview:userImageView];
    
    //  User Location Info Label 
    
    UserLocInfo=[[UILabel alloc] initWithFrame:CGRectMake(115, 10, 125, 50)];
    //UserLocInfo.backgroundColor=[UIColor whiteColor];
    UserLocInfo.textColor=[UIColor colorWithRed:50/255.0 green:205/255.0 blue:50/255.0 alpha:1];
    [UserLocInfo setFont:[UIFont fontWithName:@"Myriad Pro" size:12]];
    [cell addSubview:UserLocInfo];
    
    
    //  PickUp Status Label 
    
    UILabel *PickUpStatusLabel=[[UILabel alloc] initWithFrame:CGRectMake(243, 25, 40, 15)];
    // PickUpStatusLabel.backgroundColor=[UIColor whiteColor];
    PickUpStatusLabel.textColor=[UIColor whiteColor];
    [PickUpStatusLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:12]];
    PickUpStatusLabel.text=@"Pickup";
    [cell addSubview:PickUpStatusLabel];
    
    //  Time Status Label 
    
    UILabel *TimeStatusLabel=[[UILabel alloc] initWithFrame:CGRectMake(243, 42, 85, 15)];
    TimeStatusLabel.textColor=[UIColor whiteColor];
    [TimeStatusLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:12]];
    [cell addSubview:TimeStatusLabel];
    
    
    UILabel *reqTypeLabel=[[UILabel alloc] initWithFrame:CGRectMake(243, 10, 85, 15)];
    reqTypeLabel.textColor=[UIColor redColor];
    [reqTypeLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:10]];
    [cell addSubview:reqTypeLabel];


    
    cell.backgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:51/255.0 alpha:1];
    
    cell.textLabel.textColor=[UIColor whiteColor];
    
    if (([[UIScreen mainScreen] bounds].size.height == 568) ||  ([[UIScreen mainScreen] bounds].size.height == 480)) {
        cell.textLabel.font = [UIFont fontWithName:@"Myriad Pro" size:17];
        
        //this is iphone 5 xib
    }
    else
    {
        cell.textLabel.font = [UIFont fontWithName:@"Myriad Pro" size:30];
    }
    
    cell.backgroundColor=[UIColor clearColor];
    
    // Set User Image To Cell Using Dispatch Queue //
    
    UIActivityIndicatorView *objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    objactivityindicator.center = CGPointMake((userImageView.frame.size.width/2),(userImageView.frame.size.height/2));
    [userImageView addSubview:objactivityindicator];
    [objactivityindicator startAnimating];
    
    
    if ([RequestType isEqualToString:@"rider"]){
        UrlString=[[sortedArray objectAtIndex:indexPath.row] valueForKey:@"driver_image"];
        
    }
    else
    {
        UrlString=[[sortedArray objectAtIndex:indexPath.row] valueForKey:@"rider_image"];
        
    }

    if([UserImageDict objectForKey:UrlString]!=nil && [[UserImageDict objectForKey:UrlString] isKindOfClass:[UIImage class]])
    {
        
        [userImageView setImage:[UserImageDict objectForKey:UrlString]];
        
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
            NSURL *imageURL=[NSURL URLWithString:[UrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
            UIImage *imgData=[UIImage imageWithData:tempData];
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               if (tempData!=nil && [imgData isKindOfClass:[UIImage class]])
                               {
                                   [userImageView setImage:imgData];
                                 //  [UserImageDict setObject:imgData forKey:UrlString];
                                   [objactivityindicator stopAnimating];
                                   
                               }
                               else
                               {
                                   [userImageView setImage:[UIImage imageNamed:@"dummy_user.png"]];
                                   [objactivityindicator stopAnimating];
                                   
                               }
                           });
        });
    }
    ////
    
    // Set Pick Up Time //
    
    //Get Date from Service
    NSString *PickUpTimeStr=[[sortedArray objectAtIndex:indexPath.row] valueForKey:@"trip_request_pickup_date"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYYMMddHHmmss"];
    NSDate *date = [dateFormat dateFromString:PickUpTimeStr];
    
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
            TimeStatusLabel.text=[format stringFromDate:date];
        }
            break;
        case NSOrderedDescending:
        {
            NSLog(@"NSOrderedDescending");
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            format.dateFormat = @"dd-MM-yyyy";
            TimeStatusLabel.text=[format stringFromDate:date];
        }
            break;
    }
    
    ////

    if (sortedArray.count>0)
    {
        NSString *riderNameStr;
        if ([RequestType isEqualToString:@"rider"]){
            riderNameStr =[[sortedArray objectAtIndex:indexPath.row ]valueForKey:@"driver_first"];
            ratingStr=[[sortedArray objectAtIndex:indexPath.row ]valueForKey:@"driver_rating"];
        }
        else
        {
            riderNameStr =[[sortedArray objectAtIndex:indexPath.row ]valueForKey:@"rider_first"];
            ratingStr=[[sortedArray objectAtIndex:indexPath.row ]valueForKey:@"rider_rating"];
        }
        reqTypeLabel.text=[[sortedArray objectAtIndex:indexPath.row ]valueForKey:@"request_type"];
        
        NSString *reqType=[[sortedArray objectAtIndex:indexPath.row ]valueForKey:@"request_type"];
        NSString *placesNameStr;
        
        if (![reqType isEqualToString:@"VIP"])
        {
             placesNameStr=[[sortedArray objectAtIndex:indexPath.row ]valueForKey:@"destination_loc"];
        }
        else{
            placesNameStr =[[sortedArray objectAtIndex:indexPath.row ]valueForKey:@"start_loc"];
        }

        
        RatingLabel.text=[NSString stringWithFormat:@"Rating : %@",ratingStr];
        UserLocInfo.text=[NSString stringWithFormat:@"%@",placesNameStr];
        UserNameLabel.text=[NSString stringWithFormat:@"%@",riderNameStr];
        UserLocInfo.numberOfLines=4;
    }
    requestListArray=nil;
    requestListArray =[sortedArray copy];
    
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [timer invalidate];
    [timer1 invalidate];
    [qtimer invalidate];
    [qtimer1 invalidate];
    
    if ([RequestType isEqualToString:@"queue"])
    {
        AcceptBtn.hidden=YES;
        RejectBtn.hidden=YES;
        self.activrRidebtn.hidden=NO;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self.activrRidebtn.frame=CGRectMake(15, 490, 150, 60);
            self.CancelRideBtn.frame=CGRectMake(180, 490, 150, 60);
            //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480) {
            self.activrRidebtn.frame=CGRectMake(10, 413, 145, 55);
            self.CancelRideBtn.frame=CGRectMake(160, 413, 145, 55);
            // this is iphone 4 xib
        }
        self.CancelRideBtn.hidden=NO;
    }
    
    else if ([RequestType isEqualToString:@"rider"])
    {
        AcceptBtn.hidden=YES;
        RejectBtn.hidden=YES;
        self.activrRidebtn.hidden=YES;
        
        if ([[[requestListArray objectAtIndex:indexPath.row] valueForKey:@"status"] isEqualToString:@"Accepted"])
        {
            //  DriverLocBtnOutlet.frame=CGRectMake(5, 500, 150, 65);
            DriverLocBtnOutlet.hidden=NO;
            
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                self.activrRidebtn.frame=CGRectMake(85, 490, 150, 60);
                //this is iphone 5 xib
            }
            else if([[UIScreen mainScreen] bounds].size.height == 480) {
                self.activrRidebtn.frame=CGRectMake(15, 413, 150, 55);
                // this is iphone 4 xib
            }
            self.activrRidebtn.hidden=YES;
        }
        else
        {
            DriverLocBtnOutlet.hidden=YES;
        }
        
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self.CancelRideBtn.frame=CGRectMake(85, 490, 150, 60);
            //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480) {
            self.CancelRideBtn.frame=CGRectMake(85, 413, 150, 55);
            // this is iphone 4 xib
        }
                self.CancelRideBtn.hidden=NO;
    }
    else
    {
        self.activrRidebtn.hidden=YES;
    }
    
    [self.view endEditing:YES];
    
    if (requestListArray.count>0)
    {
        
        NSDictionary *reqDict = [requestListArray objectAtIndex:indexPath.row];
        reqId = [NSString stringWithFormat:@"%@",[reqDict objectForKey:@"tripId"]];
        NSString *riderId = [NSString stringWithFormat:@"%@",[reqDict objectForKey:@"riderId"]];
        driverIdNew = [NSString stringWithFormat:@"%@",[reqDict objectForKey:@"driverId"]];
        NSString *vehicle_color=[NSString stringWithFormat:@"%@",[reqDict objectForKey:@"vehicle_color"]];
        NSString *vehicle_img=[NSString stringWithFormat:@"%@",[reqDict objectForKey:@"vehicle_img"]];
        NSString* vehicle_year=[NSString stringWithFormat:@"%@",[reqDict objectForKey:@"vehicle_year"]];
        NSString *vehicle_name=[NSString stringWithFormat:@"%@",[reqDict objectForKey:@"vehicle_name"]];
        modelValueLbl.text=[NSString stringWithFormat:@"%@ %@ %@",vehicle_year,vehicle_color, vehicle_name];
        
        GetTripId = [NSString stringWithFormat:@"%@",[reqDict objectForKey:@"tripId"]];
        
        if ([RequestType isEqualToString:@"rider"]){
            driverFirstName=[NSString stringWithFormat:@"%@",[reqDict objectForKey:@"driver_first"]];
            self.riderNameLbl.text=[NSString stringWithFormat:@"%@",[reqDict objectForKey:@"driver_first"]];
            //phNo=[reqDict objectForKey:@"active_phone_driver"];
        }
        else
        {
            handicapStr=[reqDict objectForKey:@"rider_handicap"];
            if ([[reqDict objectForKey:@"rider_handicap"] isEqualToString:@"1"])
            {
                handicappdImgView.hidden=NO;
                handicappdImgView.image =[UIImage imageNamed:@"Handicap.png"];
            }
            else {
                handicappdImgView.image=nil;
                handicappdImgView.hidden=YES;
            }
            self.riderNameLbl.text=[NSString stringWithFormat:@"%@",[reqDict objectForKey:@"rider_first"]];
        }
        rideReqType=[reqDict objectForKey:@"request_type"];
        
        self.riderStartLocTxtView.text= [NSString stringWithFormat:@"%@",[reqDict objectForKey:@"start_loc"]];
        self.riderEndLocTxtView.text = [NSString stringWithFormat:@"%@",[reqDict objectForKey:@"destination_loc"]];
        float milesEst=[[reqDict objectForKey:@"trip_miles_est"]floatValue];
        self.riderDistanceLbl.text = [NSString stringWithFormat:@"Distance: %.2f Miles",milesEst];
        self.riderSuggestdFareLbl.text= [NSString stringWithFormat:@"Suggested Fare : $%@",[reqDict objectForKey:@"offered_fare"]];
        
        TripStartLat=[reqDict objectForKey:@"start_lat"];
        tripStartLong=[reqDict objectForKey:@"start_long"];
        tripEndLat=[reqDict objectForKey:@"end_lat"];
        tripEndLong=[reqDict objectForKey:@"end_long"];
        
        suggestdFareStR= [NSString stringWithFormat:@"$%@",[reqDict objectForKey:@"offered_fare"]];
        
        self.riderActualFareLbl.text = [NSString stringWithFormat:@"Actual fare : $%@",[reqDict objectForKey:@"setfare"]];
        
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@",[reqDict objectForKey:@"offered_fare"]] forKey:@"FareValueForTip"];
        
        
        pickuptimeStr=[NSString stringWithFormat:@"%@",[reqDict objectForKey:@"trip_request_pickup_date"]];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"YYYYMMddHHmmss"];
        NSDate *date = [dateFormat dateFromString:pickuptimeStr];
        
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
                pickuptimeStr=[format stringFromDate:date];
            }
                break;
            case NSOrderedDescending:
            {
                NSLog(@"NSOrderedDescending");
                
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                format.dateFormat = @"dd-MM-yyyy";
                pickuptimeStr=[format stringFromDate:date];
            }
                break;
        }
        
        
        vehicleStr=[reqDict objectForKey:@"vehicle_type"];
        etaStr=[NSString stringWithFormat:@"%@",[reqDict objectForKey:@"trip_time_est"]];
        if (etaStr.length==0)
        {
            self.EtaTimeLbl.hidden=YES;
        }
        
        if (etaStr.length==0)
        {
            self.EtaTimeLbl.hidden=YES;
        }
        if ([[reqDict objectForKey:@"trip_time_est"] rangeOfString:@"min"].location ==NSNotFound
            ||
            [[reqDict objectForKey:@"trip_time_est"] rangeOfString:@"mins"].location ==NSNotFound )
            
        {
            
            self.EtaTimeLbl.text=[NSString stringWithFormat:@"ETA : %@mins",[reqDict objectForKey:@"trip_time_est"]];
            
        }
        else{
            self.EtaTimeLbl.text=[NSString stringWithFormat:@"ETA : %@",[reqDict objectForKey:@"trip_time_est"]];
        }
        
        [Base64 initialize];
        
        NSString *baseStr;
        
        if ([RequestType isEqualToString:@"rider"])
        {
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                self.riderImage.frame=CGRectMake(7, 7, 65, 65);
                self.riderNameLbl.frame=CGRectMake(5, 60, self.riderNameLbl.frame.size.width, self.riderNameLbl.frame.size.width);            }
            else if([[UIScreen mainScreen] bounds].size.height == 480)
            {
                self.riderImage.frame=CGRectMake(7, 7, 60, 60);
                self.riderNameLbl.frame=CGRectMake(5,55, self.riderNameLbl.frame.size.width, self.riderNameLbl.frame.size.width);
                // this is iphone 4 xib
            }
            modelValueLbl.hidden=NO;
            vehicleImageView.hidden=NO;
            
            // Set vehicle image Using Dispatch Queue //
            
            UIActivityIndicatorView *objactivityindicator1=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            objactivityindicator1.center = CGPointMake((vehicleImageView.frame.size.width/2),(vehicleImageView.frame.size.height/2));
            [vehicleImageView addSubview:objactivityindicator1];
            //        [objactivityindicator1 startAnimating];
            
            if(vehicle_img.length==0)
            {
                
            }
            else
            {
                [objactivityindicator1 startAnimating];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
                    NSURL *imageURL=[NSURL URLWithString:[vehicle_img stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
                    UIImage *imgData=[UIImage imageWithData:tempData];
                    dispatch_async(dispatch_get_main_queue(), ^
                                   {
                                       if (tempData!=nil && [imgData isKindOfClass:[UIImage class]])
                                       {
                                           [vehicleImageView setImage:imgData];
                                           //  [UserImageDict setObject:imgData forKey:UrlString];
                                           [objactivityindicator1 stopAnimating];
                                       }
                                       else
                                       {
                                           [vehicleImageView setImage:[UIImage imageNamed:@""]];
                                           [objactivityindicator1 stopAnimating];
                                       }
                                   });
                });
            }
            ////
            baseStr=[NSString stringWithFormat:@"%@",[reqDict objectForKey:@"driver_image"] ];
        }
        else
        {
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                self.riderImage.frame=CGRectMake(15, 20, 90, 100);
                self.riderNameLbl.frame=CGRectMake(130, 30, self.riderNameLbl.frame.size.width, self.riderNameLbl.frame.size.width);
            }
            else if([[UIScreen mainScreen] bounds].size.height == 480)
            {
                self.riderImage.frame=CGRectMake(15, 10, 90, 100);
                self.riderNameLbl.frame=CGRectMake(110, 30, self.riderNameLbl.frame.size.width, self.riderNameLbl.frame.size.width);
            }
            vehicleImageView.hidden=YES;
            modelValueLbl.hidden=YES;
            baseStr=[NSString stringWithFormat:@"%@",[reqDict objectForKey:@"rider_image"]];
        }
        
        // Set User Image To Cell Using Dispatch Queue //
        
        UIActivityIndicatorView *objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        objactivityindicator.center = CGPointMake((self.riderImage.frame.size.width/2),(self.riderImage.frame.size.height/2));
        [self.riderImage addSubview:objactivityindicator];
        [objactivityindicator startAnimating];
        
        
        if ([RequestType isEqualToString:@"rider"]){
            imgUrlStr=[[requestListArray objectAtIndex:indexPath.row] valueForKey:@"driver_image"];
        }
        else
        {
            imgUrlStr=[[requestListArray objectAtIndex:indexPath.row] valueForKey:@"rider_image"];
        }
        
        if([UserImageDict objectForKey:imgUrlStr]!=nil && [[UserImageDict objectForKey:imgUrlStr] isKindOfClass:[UIImage class]])
        {
            [self.riderImage setImage:[UserImageDict objectForKey:imgUrlStr]];
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
                NSURL *imageURL=[NSURL URLWithString:[imgUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
                UIImage *imgData=[UIImage imageWithData:tempData];
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   if (tempData!=nil && [imgData isKindOfClass:[UIImage class]])
                                   {
                                       [self.riderImage setImage:imgData];
                                       //  [UserImageDict setObject:imgData forKey:UrlString];
                                       [objactivityindicator stopAnimating];
                                       
                                   }
                                   else
                                   {
                                       [self.riderImage setImage:[UIImage imageNamed:@"dummy_user.png"]];
                                       [objactivityindicator stopAnimating];
                                       
                                   }
                               });
            });
        }
        ////
    }
    
    if ([rideReqType isEqualToString:@"VIP"])
    {
        self.riderDistanceLbl.hidden=YES;
        self.EtaTimeLbl.hidden=YES;
    }
    else{
        self.riderDistanceLbl.hidden=NO;
        self.EtaTimeLbl.hidden=NO;
    }
    if ( etaStr.length==0)
    {
        self.EtaTimeLbl.hidden=YES;
    }
    else {
        self.EtaTimeLbl.hidden=NO;
    }
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue" ] isEqualToString:@"DriverSide"] &&[RequestType isEqualToString:@"queue"])
    {
        messageBtn.hidden=YES;
        self.callBtn.hidden=YES;
    }
    else{
        messageBtn.hidden=NO;
        self.callBtn.hidden=NO;
    }
    self.riderDetailView.hidden=NO;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.0;
}

#pragma mark - Passenger Mode Button Action

- (IBAction)passangerMode:(id)sender
{
 
    [self.view bringSubviewToFront:sideView];
    [self.activrRidebtn bringSubviewToFront:sideView];
    
    [self.view bringSubviewToFront:sideView];
    [self.CancelRideBtn bringSubviewToFront:sideView];
    
    
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

#pragma mark - Accept Request Button Action

- (IBAction)callBtn:(id)sender {
   
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"tel://%@",phNo]];
    
    
     [[UIApplication sharedApplication] openURL:phoneUrl];

}

- (IBAction)CancelRideBtn:(id)sender
{
    //webservice=6;
   // NSString *role;
    
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
    else
    {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Rapid Ride" message:@"Do You Want to Cancel Ride. Cancelation charges may apply" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
        warningAlert.tag=1100;
        [warningAlert show];

    }
    
}



- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *reasonStr=@"";
    switch (popup.tag) {
          
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


#pragma mark - Reject Request Button Action

- (IBAction)rejectRequest:(id)sender {
    
    self.riderDetailView.hidden=YES;
    [self fetchPendingRequestsDetail];
    

}

#pragma mark - Send Message

- (IBAction)messageBtn:(id)sender {

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


#pragma mark - Start Driver Location Button Action

-(IBAction)StartDriverLocation:(id)sender
{
    LocateDriverOnMapViewController*ViewObj;
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        ViewObj=[[LocateDriverOnMapViewController alloc]initWithNibName:@"LocateDriverOnMapViewController" bundle:nil];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480)
    {
        ViewObj=[[LocateDriverOnMapViewController alloc]initWithNibName:@"LocateDriverOnMapViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }

    ViewObj.DriverIdStr=driverIdNew;
    ViewObj.TripIdStr=GetTripId;
    [timer invalidate];
    [timer1 invalidate];
    [qtimer invalidate];
    [qtimer1 invalidate];
    [self.navigationController pushViewController:ViewObj animated:YES];
}

#pragma mark - End Ride Button Action

- (IBAction)EndRideButton:(id)sender
{

}

- (IBAction)ActiveRideBtn:(id)sender
{
    
    webservice=7;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    float  current_longitude=self.locationManager.location.coordinate.longitude;
    float  current_latitude=self.locationManager.location.coordinate.latitude;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:RiderIdStr,@"RiderId",GetDriverId,@"DriverId",@"Busy",@"Trigger",[NSString stringWithFormat:@"%f",current_longitude],@"Longitude",[NSString stringWithFormat:@"%f",current_latitude],@"Latitude",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/SwitchBetweenMode",Kwebservices]];
    
    [self postWebservices];
    
}


#pragma mark - Touch Delegates


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

#pragma mark - Driver Switch Action

- (IBAction)DriverSwitchButtonAction:(id)sender
{
    if (DriverSwitchBtn.on==NO)
    {
        self.activrRidebtn.hidden=YES;
        self.CancelRideBtn.hidden=YES;
        
        DriverSwitchBtn.on=NO;
        // [self.navigationController popViewControllerAnimated:NO];
        MapViewController*mapVc;
        
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480)
        {
            mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController_iphone4" bundle:nil];
            // this is iphone 4 xib
        }


        [timer invalidate];
        [timer1 invalidate];
        [qtimer invalidate];
        [qtimer1 invalidate];

        [self.navigationController pushViewController:mapVc  animated:NO];
    }
}


#pragma mark - Post Web Service

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

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)findMyDriverLocBtn:(id)sender
{
    LocateDriverOnMapViewController*ViewObj;
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        ViewObj=[[LocateDriverOnMapViewController alloc]initWithNibName:@"LocateDriverOnMapViewController" bundle:nil];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480)
    {
        ViewObj=[[LocateDriverOnMapViewController alloc]initWithNibName:@"LocateDriverOnMapViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }

    ViewObj.statLat=TripStartLat;
    ViewObj.startLong=tripStartLong;
    ViewObj.driverFirstName=driverFirstName;
    ViewObj.DriverIdStr=driverIdNew;
    ViewObj.TripIdStr=GetTripId;
    ViewObj.vehicleShown=vehicleStr;
    [timer invalidate];
    [timer1 invalidate];
    [qtimer invalidate];
    [qtimer1 invalidate];

    [self.navigationController pushViewController:ViewObj animated:YES];

}
    

-(void) cancelDriverRide :(NSString*)reason
{
    CLLocationManager*locationManager = [[CLLocationManager alloc] init];
    
    NSString*curLatStr=[NSString stringWithFormat:@"%f",locationManager.location.coordinate.latitude];
    NSString*curLongStr=[NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude];
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:GetTripId,@"TripId",@"driver",@"Trigger",[reason lowercaseString],@"Reason",curLatStr,@"Latitude",curLongStr,@"Longitude",nil];
    jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    webservice=6;
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/CancelRide",Kwebservices]];
    [self.activityIndicatorObject startAnimating];
    self.view.userInteractionEnabled=NO;
    self.disablImg.hidden=NO;
    [self postWebservices];
    
    
}
@end
