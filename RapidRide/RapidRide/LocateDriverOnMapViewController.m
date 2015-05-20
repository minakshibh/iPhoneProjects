//
//  LocateDriverOnMapViewController.m
//  RapidRide
//
//  Created by vikram on 04/11/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import "LocateDriverOnMapViewController.h"

@interface LocateDriverOnMapViewController ()

@end

@implementation LocateDriverOnMapViewController

@synthesize mapview,activityIndicatorObject,DriverIdStr,TripIdStr,startLong,statLat,driverFirstName,notGettingDriverLocBtn,FromNotification,FullColourdView,colourView,colourHeaderLbl,vehicleShown;

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
    
    
    NSMutableAttributedString *String = [[NSMutableAttributedString alloc] initWithString:@"Not Getting To The Driver"];
    [String addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [String length])];
    
    [notGettingDriverLocBtn setAttributedTitle:String forState:UIControlStateNormal];
    notGettingDriverLocBtn.titleLabel.textColor=[UIColor blackColor];
    
    showOnce =YES;
    
    self.colourView.layer.borderColor = [UIColor blackColor].CGColor;
    self.colourView.layer.borderWidth = 2.5;
    self.colourView.layer.cornerRadius = 10.0;
    [self.colourView setClipsToBounds:YES];
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
    [self.disablImg addSubview:activityIndicatorObject];
    [self.view setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    [self.headerView setBackgroundColor:[UIColor colorWithRed:(3.0 / 255.0) green:(15.0 / 255.0) blue:(51.0 / 255.0) alpha:1]];
    [self.headerLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:30]];
    
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self
                   action:@selector(BackButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    //[backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(10, 27, 50, 30);
    [self.view addSubview:backButton];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    if (FromNotification)
    {
        [self GettripData];

    }
    else{
        [self GetDriverLatitudeAndLongitude];
        
        timer= [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(GetDriverLatitudeAndLongitude) userInfo:nil repeats:YES];
    }
    
    
}

#pragma mark - Get Driver Latitude and Longitude


-(void)GetDriverLatitudeAndLongitude
{
    webservice=1;
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:DriverIdStr,@"DriverId",TripIdStr,@"TripId",nil];
    jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetDriverLocation",Kwebservices]];
    [self postWebservices];
}

#pragma mark - Back Button Action

-(IBAction)BackButtonAction:(id)sender
{
    [timer invalidate];
    [gtimer invalidate];
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark - Map View Delegates

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor redColor];
    polylineView.lineWidth = 4.0;
    
    return polylineView;
}

#pragma mark - Post Web Service

-(void)postWebservices
{
    [self.activityIndicatorObject startAnimating];
    self.view.userInteractionEnabled=NO;
    self.disablImg.hidden=NO;
   

    
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
       // alert.tag=2;
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
            
            int result=[[userDetailDict valueForKey:@"result" ]intValue];
            if (result ==1)
            {

            }
            else
            {
                LatestLattitude=[[userDetailDict valueForKey:@"latitude"] floatValue];
                LatestLongitude=[[userDetailDict valueForKey:@"longitude"] floatValue];
                
                    float Servicelattitude=LatestLattitude;
                    float Servicelongitude=LatestLongitude;

                
                // Creates a marker in the center of the map.
                [GoogleMapView removeFromSuperview];
                MapCamera = [GMSCameraPosition cameraWithLatitude:Servicelattitude longitude:Servicelongitude zoom:16];
                GoogleMapView = [GMSMapView mapWithFrame:CGRectMake(0, 64, 320, 510) camera:MapCamera];
                GoogleMapView.delegate = self;
                [self.view addSubview:GoogleMapView];
                
                [self.view bringSubviewToFront:notGettingDriverLocBtn];
                [GoogleMapView bringSubviewToFront:notGettingDriverLocBtn];
                [self.view bringSubviewToFront:colourView];
                [GoogleMapView bringSubviewToFront:colourView];
                [self.view bringSubviewToFront:FullColourdView];
                [GoogleMapView bringSubviewToFront:FullColourdView];
               

        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(Servicelattitude, Servicelongitude);
        marker.map = GoogleMapView;
                
                
                if ([vehicleShown isEqualToString:@"1"])
                {
                    marker.icon=[UIImage imageNamed:@"suv_car.png"];
                }
                else if ([vehicleShown isEqualToString:@"2"])
                {
                    marker.icon=[UIImage imageNamed:@"xl_car.png" ];
                }
                else if ([vehicleShown isEqualToString:@"3"])
                {
                    marker.icon=[UIImage imageNamed:@"exec_car.png" ];
                }
                else if ([vehicleShown isEqualToString:@"4"])
                {
                    marker.icon=[UIImage imageNamed:@"suv_car.png" ];
                }
                else if ([vehicleShown isEqualToString:@"5"])
                {
                    marker.icon=[UIImage imageNamed:@"lux_car.png" ];
                }
                
                

                
                
                NSString *url=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%f,%f&destinations=%f,%f&mode=driving&language=en-EN&sensor=false",[statLat floatValue],[startLong floatValue],Servicelattitude,Servicelongitude];
                
                url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSURL *queryUrl = [NSURL URLWithString:url];
                NSLog(@"query url%@",queryUrl);
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSData *data = [NSData dataWithContentsOfURL:queryUrl];
                    [self fetchData:data];
                });

                
                
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
                
            }
            else
            {
                
                
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue" ] isEqualToString:@"RiderSide"] )
                {
                    driverFirstName=[userDetailDict valueForKey:@"driver_name"];
                    DriverIdStr=[userDetailDict valueForKey:@"driverid"];
                }
               statLat=[userDetailDict valueForKey:@"start_lat"];
                
                startLong=[userDetailDict valueForKey:@"start_lon"];
                
                [self GetDriverLatitudeAndLongitude];
                
                gtimer= [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(GetDriverLatitudeAndLongitude) userInfo:nil repeats:YES];
            }
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
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
            else
            {
                NSLog( @"Response :%@",messageStr);
            }
            
        }
    }
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
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@ is Rapidly approaching. Please be ready.",driverFirstName] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            showOnce=NO;
        }
    }
}

#pragma mark - MemoryManagement

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)GettripData
{
    webservice=3;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:TripIdStr,@"TripId",nil];
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetDetailsByTripId",Kwebservices]];
    [self postWebservices];
    
}

- (IBAction)notGettingDriverLocBtn:(id)sender
{
    self.colourView.hidden=NO;
}

- (IBAction)pinkColorBtn:(id)sender
{
    [FullColourdView setBackgroundColor:[UIColor colorWithRed:(238.0 / 255.0) green:(44.0 / 255.0) blue:(115.0 / 255.0) alpha:1]];
    self.FullColourdView.hidden=NO;
    self.colourView.hidden=YES;
    color=@"pink";
    [self colourSelected];
    
}

- (IBAction)redColorBtn:(id)sender {
    color=@"red";
    self.colourView.hidden=YES;
    self.FullColourdView.hidden=NO;
    [FullColourdView setBackgroundColor:[UIColor colorWithRed:(240.0 / 255.0) green:(60.0 / 255.0) blue:(43.0 / 255.0) alpha:1]];
    [self colourSelected];
}

- (IBAction)greenColorBtn:(id)sender {
    color=@"green";
    self.colourView.hidden=YES;
    self.FullColourdView.hidden=NO;
    [FullColourdView setBackgroundColor:[UIColor colorWithRed:(37.0 / 255.0) green:(168.0 / 255.0) blue:(102.0 / 255.0) alpha:1]];
    [self colourSelected];
}

- (IBAction)yellowColorBtn:(id)sender {
    color=@"yellow";
    self.colourView.hidden=YES;
    self.FullColourdView.hidden=NO;
    [FullColourdView setBackgroundColor:[UIColor colorWithRed:(251.0 / 255.0) green:(236.0 / 255.0) blue:(73.0 / 255.0) alpha:1]];
    [self colourSelected];
}

- (IBAction)orangeColorBtn:(id)sender {
    color=@"orange";
    self.colourView.hidden=YES;
    self.FullColourdView.hidden=NO;
    [FullColourdView setBackgroundColor:[UIColor colorWithRed:(244.0 / 255.0) green:(129.0 / 255.0) blue:(75.0 / 255.0) alpha:1]];
}

- (IBAction)whiteColorBtn:(id)sender {
    color=@"white";
    self.colourView.hidden=YES;
    self.FullColourdView.hidden=NO;
    [FullColourdView setBackgroundColor:[UIColor colorWithRed:(226.0 / 255.0) green:(220.0 / 255.0) blue:(205.0 / 255.0) alpha:1]];
    [self colourSelected];
}

- (IBAction)blueColorBtn:(id)sender {
    color=@"blue";
    self.colourView.hidden=YES;
    self.FullColourdView.hidden=NO;
    [FullColourdView setBackgroundColor:[UIColor colorWithRed:(34.0 / 255.0) green:(175.0 / 255.0) blue:(195.0 / 255.0) alpha:1]];
    [self colourSelected];
}


- (IBAction)closeBtn:(id)sender {
    self.colourView.hidden=YES;
}

- (IBAction)cancelColordViewBtn:(id)sender
{
   self.FullColourdView.hidden=YES;
}

-(void) colourSelected
{
    webservice=4;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:TripIdStr,@"TripId",color,@"Colour",nil];
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/ColorMatch",Kwebservices]];
    [self postWebservices];

}
@end
