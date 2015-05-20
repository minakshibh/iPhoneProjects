//
//  reciveRequestViewController.m
//  dash
//
//  Created by Krishna_Mac_1 on 5/13/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "reciveRequestViewController.h"
#import "DetailerFirastViewController.h"
#import "loginViewController.h"
#import "MyprofileViewController.h"
#import "uploadWorkSamplesViewController.h"
#import "WorkSamplesViewController.h"
#import "uploadWorkSamplesViewController.h"
#import "reciveRequestdetailViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
@interface reciveRequestViewController ()

@end

@implementation reciveRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addMapView];
    sideView.hidden=YES;
    NSString *onlineStatus = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Offline/Online Status"]];
    if ([onlineStatus isEqualToString:@"Online"]) {
        [goOnlineBtn setTitle:@"Go Offline" forState:UIControlStateNormal];
    }else{
        [goOnlineBtn setTitle:@"Go Online" forState:UIControlStateNormal];
    }

    nameLbl.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"]];
    
    [tapToAcceptView setFrame:CGRectMake(50, 100, tapToAcceptView.frame.size.width, tapToAcceptView.frame.size.height)];
    [self.view addSubview:tapToAcceptView];
    double value = self.view.frame.size.height - userRequestView.frame.size.height;
    NSLog(@"Height,..... %f",value);
    [userRequestView setFrame:CGRectMake(0, self.view.frame.size.height - userRequestView.frame.size.height , userRequestView.frame.size.width, userRequestView.frame.size.height)];
    [self.view addSubview:userRequestView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [self.view setUserInteractionEnabled:YES];
    [userRequestView addGestureRecognizer:singleTap];


    tapToAcceptView.layer.borderColor = [UIColor clearColor].CGColor;
    tapToAcceptView.layer.borderWidth = 1.5;
    tapToAcceptView.layer.cornerRadius = 6.0;
    [tapToAcceptView setClipsToBounds:YES];
    
    profileImg.layer.borderColor = [UIColor grayColor].CGColor;
    profileImg.layer.borderWidth = 1.5;
    profileImg.layer.cornerRadius = 10.0;
    [profileImg setClipsToBounds:YES];
    
    [super didReceiveMemoryWarning];
    // Do any additional setup after loading the view from its nib.
}
-(void)tapDetected{
    reciveRequestdetailViewController *workSamples=[[reciveRequestdetailViewController alloc]initWithNibName:@"reciveRequestdetailViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:workSamples animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addMapView{
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    lat=self.locationManager.location.coordinate.latitude;
    lon=self.locationManager.location.coordinate.longitude;
    
    NSLog(@"%f %f",lat,lon);
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lon zoom:15];
    
    
    if (IS_IPHONE_4_OR_LESS)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,75, self.view.frame.size.width, self.view.frame.size.height-70) camera:camera];
    }
    if (IS_IPHONE_5)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,65,self.view.frame.size.width, self.view.frame.size.height-65) camera:camera];
    }
    if (IS_IPHONE_6)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,75, self.view.frame.size.width, self.view.frame.size.height-75) camera:camera];
    }
    if (IS_IPHONE_6P)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,75, self.view.frame.size.width, self.view.frame.size.height-75) camera:camera];
    }
    
    // mapView.settings.compassButton = YES;
    //mapView.settings.myLocationButton = YES;
    mapView.delegate = self;
    mapView.myLocationEnabled = YES;
    mapView.layer.borderColor = [UIColor whiteColor].CGColor;
    mapView.layer.borderWidth = 1.5;
    
    mapView.layer.cornerRadius = 5.0;
    
    [mapView setClipsToBounds:YES];
    [self.view addSubview:mapView];
    
    [self.view bringSubviewToFront:sideView];
    [mapView bringSubviewToFront:sideView];
    
    
    marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(lat ,lon );
    marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
    marker.map = mapView;
    
    
}
- (IBAction)myWorkSamples:(id)sender {
    
    WorkSamplesViewController *workSamples=[[WorkSamplesViewController alloc]initWithNibName:@"WorkSamplesViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:workSamples animated:YES];
    
}


- (IBAction)logOutBttn:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"role"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    
    [self deletDataFromDatabase];
    
    loginViewController*loginVC=[[loginViewController alloc]initWithNibName:@"loginViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:loginVC animated:YES];
    
}

- (IBAction)viewProfileBttn:(id)sender {
    MyprofileViewController*myProfile = [[MyprofileViewController alloc] initWithNibName:@"MyprofileViewController" bundle:nil];
    [self.navigationController pushViewController:myProfile animated:NO];
}

- (IBAction)workSamples:(id)sender {
    uploadWorkSamplesViewController *workSamples=[[uploadWorkSamplesViewController alloc]initWithNibName:@"uploadWorkSamplesViewController" bundle:[NSBundle mainBundle]];
    workSamples.trigger=@"add";
    workSamples.backBtnHiden=@"NO";
    [self.navigationController pushViewController:workSamples animated:YES];
}

- (IBAction)menuBttn:(id)sender
{
    
    if (sideView.frame.origin.x==0)
    {
        [UIView animateWithDuration:0.3
                              delay:0.1
                            options: UIViewAnimationCurveEaseIn
                         animations:^
         {
             //   sideView.hidden=YES;
             
             CGRect frame = sideView.frame;
             frame.origin.y = sideView.frame.origin.y;
             frame.origin.x = -239;
             sideView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             NSLog(@"Completed");
             
         }];
        
    }
    else{
        [UIView animateWithDuration:0.3
                              delay:0.1
                            options: UIViewAnimationCurveEaseOut
                         animations:^
         {
             sideView.hidden=NO;
             
             CGRect frame = sideView.frame;
             frame.origin.y = sideView.frame.origin.y;
             frame.origin.x = 0;
             sideView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             NSLog(@"Completed");
             
         }];
        
    }
}

- (IBAction)homeBttn:(id)sender {
    DetailerFirastViewController*myProfile = [[DetailerFirastViewController alloc] initWithNibName:@"DetailerFirastViewController" bundle:nil];
    [self.navigationController pushViewController:myProfile animated:NO];
    
}

- (IBAction)tapToAcceptBtnAction:(id)sender {
    [self tapDetected];
}

-(void)deletDataFromDatabase
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM locationsList"];
    [database executeUpdate:queryString1];
    
    
    NSString *queryString2 = [NSString stringWithFormat:@"Delete FROM userProfile"];
    [database executeUpdate:queryString2];
    
    NSString *queryString3 = [NSString stringWithFormat:@"Delete FROM vehiclesList"];
    [database executeUpdate:queryString3];
    
    NSString *queryString4 = [NSString stringWithFormat:@"Delete FROM workSamples"];
    [database executeUpdate:queryString4];
    
    [database close];
    
    
}
- (IBAction)goOnlineBtnAction:(id)sender {
    if ([goOnlineBtn.titleLabel.text isEqualToString:@"Go Online"]) {
        [goOnlineBtn setTitle:@"Go Offline" forState:UIControlStateNormal];
        [self  onlineStatus:@"Online"];
        [[NSUserDefaults standardUserDefaults] setValue:@"Online" forKey:@"Offline/Online Status"];
    }else{
        [goOnlineBtn setTitle:@"Go Online" forState:UIControlStateNormal];
        [self  onlineStatus:@"Offline"];
        [[NSUserDefaults standardUserDefaults] setValue:@"Offline" forKey:@"Offline/Online Status"];
    }
    
}
-(void) onlineStatus:(NSString*) statusStr
{
    [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    
    NSString*_postData = [NSString stringWithFormat:@"user_id=%@&status=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],statusStr];
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/go-offline.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    NSLog(@"data post >>> %@",_postData);
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
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
    [kappDelegate HideIndicator];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    NSLog(@"ERROR with the Connection ");
    webData =nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    [webData appendData:data1];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
    if ([webData length]==0)
        return;
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableDictionary *userDetailDict=[json objectWithString:responseString error:&error];
    //  NSMutableDictionary *userDetailDict1=[json objectWithString:responseString error:&error];
    [kappDelegate HideIndicator];
    //  NSMutableDictionary *userDetailDicttemp=[json objectWithString:responseString error:&error];
    
}
@end
