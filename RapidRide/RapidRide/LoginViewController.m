//
//  LoginViewController.m
//  cabBooking
//
//  Created by Br@R on 08/10/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import "LoginViewController.h"
#import "EditRiderAccountViewController.h"
#import "AppDelegate.h"
#import "MapViewController.h"
#import "RegistrationRiderViewController.h"
#import "ForgotPasswordViewController.h"
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
#import "DriverRideMapViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize userNameTxt,passwordTxt,headerLbl,loginBtn,registerBtn,forgotPasswrtBtn,activityIndicatorObject,disableImg,headerView,backView,uName,uPasswrd;

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
    [super viewDidLoad];
//    backView.layer.borderColor = [UIColor colorWithRed:(38.0 / 255.0) green:(98.0 / 255.0) blue:(165.0 / 255.0) alpha:1].CGColor;

    backView.layer.borderColor = [UIColor whiteColor].CGColor;
    backView.layer.borderWidth = 1.5;
    
    // Set image corner radius
    backView.layer.cornerRadius = 5.0;
    
    // To enable corners to be "clipped"
    [backView setClipsToBounds:YES];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    [self.headerView setBackgroundColor:[UIColor colorWithRed:(3.0 / 255.0) green:(15.0 / 255.0) blue:(51.0 / 255.0) alpha:1]];
    [self.backView setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:0.5]];

    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
   NSString *str= [dateFormatter stringFromDate:now];
 
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.navigator.navigationBarHidden = YES;
  
    locationManager = [[CLLocationManager alloc] init];
    

    
    double current_longitude=locationManager.location.coordinate.longitude;
    double current_latitude=locationManager.location.coordinate.latitude;
    
    NSLog(@"%f",current_latitude);
    NSLog(@"%f",current_longitude);
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    current_longitude=locationManager.location.coordinate.longitude;
    current_latitude=locationManager.location.coordinate.latitude;
    
    NSLog(@"%f %f",current_latitude,current_longitude);
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:current_latitude longitude:current_longitude zoom:4];
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        mapView = [GMSMapView mapWithFrame: CGRectMake(10,100, 300, 450) camera:camera];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        mapView = [GMSMapView mapWithFrame: CGRectMake(10,90, 300, 300) camera:camera];
    }
    else{
        mapView = [GMSMapView mapWithFrame: CGRectMake(22,168, 720, 732) camera:camera];
    }
    mapView.settings.compassButton = YES;
    mapView.settings.myLocationButton = YES;
    mapView.delegate = self;
    mapView.myLocationEnabled = YES;
    
    
   GMSMarker* marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(current_latitude ,current_longitude );
    marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
    marker.title =@"Set pickup location";
    marker.map = mapView;
    


    [headerLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:30]];
   
    [loginBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:30]];
    [registerBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:13]];
    [forgotPasswrtBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:13]];
    
  
    
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
    activityIndicatorObject.color=[UIColor whiteColor];
    [self.view addSubview:activityIndicatorObject];
    
    NSMutableAttributedString *registerString = [[NSMutableAttributedString alloc] initWithString:@"Register Here"];
    [registerString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [registerString length])];
    
    [registerBtn setAttributedTitle:registerString forState:UIControlStateNormal];
    
    NSMutableAttributedString *ForgtPasswrdStr = [[NSMutableAttributedString alloc] initWithString:@"Forgot Password?"];
    [ForgtPasswrdStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [ForgtPasswrdStr length])];
    [forgotPasswrtBtn setAttributedTitle:ForgtPasswrdStr forState:UIControlStateNormal];

    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    userNameTxt.text=uName;
    passwordTxt.text=uPasswrd;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)loginBtn:(id)sender {
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailReg];
    [self.view endEditing:YES];
    
    
    uEmailStr = [userNameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    uPasswrdStr = [passwordTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    if([uEmailStr isEqualToString:@""] &&[uPasswrdStr isEqualToString:@""] )
        
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  @"RapidRide" message:@"Please enter all the details to login." delegate:nil
                                                 cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    else if ([uEmailStr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Enter the username to login." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if ([emailTest evaluateWithObject:uEmailStr] != YES)
    {
        UIAlertView *loginalert = [[UIAlertView alloc] initWithTitle:@"Rapid" message:@"Enter valid user email" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [loginalert show];
    }

    else if ([uPasswrdStr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Enter the password to login." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [self.activityIndicatorObject startAnimating];
        self.view.userInteractionEnabled =NO;
        disableImg.hidden=NO;
        NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:uEmailStr,@"Email",uPasswrdStr,@"Password",  nil];
        
        NSString *jsonRequest = [jsonDict JSONRepresentation];
        
        NSLog(@"jsonRequest is %@", jsonRequest);
        NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/Login",Kwebservices]];
        
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

- (IBAction)forgotPasswrdBtn:(id)sender {
    [self.view endEditing:YES];
    ForgotPasswordViewController*forgotpasswrdVc;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        forgotpasswrdVc=[[ForgotPasswordViewController alloc]initWithNibName:@"ForgotPasswordViewController" bundle:nil];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        forgotpasswrdVc=[[ForgotPasswordViewController alloc]initWithNibName:@"ForgotPasswordViewController_iphone4" bundle:nil];
    }

    userNameTxt.text=@"";
    passwordTxt.text=@"";

    
    [self.navigationController pushViewController:forgotpasswrdVc animated:YES];

}
#pragma mark - Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
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
    [self.activityIndicatorObject stopAnimating];
    self.view.userInteractionEnabled=YES;
    disableImg.hidden=YES;

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
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        
        NSString *errormsg=[userDetailDict valueForKey:@"Message"];

        if ([errormsg isEqualToString:@"There was an error processing the request."])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",errormsg] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [self.activityIndicatorObject  stopAnimating];
            return;
        }

        
        
        if (result==1)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag=2;
            [alert show];
        }
        else
        {
            [userDetailDicttemp setValue:[NSString stringWithFormat:@"%@",uEmailStr] forKey:@"uEmailAddress"];
            [userDetailDicttemp setValue:[NSString stringWithFormat:@"%@",uPasswrdStr] forKey:@"uPassword"];

            NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"riderInfo"];
            [userdefaults setValue:userDetailDicttemp forKey:@"riderInfo"];
           
            [userdefaults removeObjectForKey:@"userEmail"];
            [userdefaults removeObjectForKey:@"userPassword"];
            [userdefaults setValue:uEmailStr forKey:@"userEmail"];
            [userdefaults setValue:uPasswrdStr forKey:@"userPassword"];
            
        
            NSString *vehicleType=[userDetailDicttemp valueForKey:@"prefvehicletype"];
            [[NSUserDefaults standardUserDefaults ]setValue:vehicleType forKey:@"prefvehicletype"];
            
           NSString* userIdStr= [NSString stringWithFormat:@"%@",[userDetailDicttemp valueForKey:@"userid"]];
            [[NSUserDefaults standardUserDefaults ]setValue:userIdStr forKey:@"riderId"];
            NSString *riderDriverIdStr=[NSString stringWithFormat:@"%@",[userDetailDicttemp valueForKey:@"driverid"]];
           

            [[NSUserDefaults standardUserDefaults ]setValue:riderDriverIdStr forKey:@"driverid"];
            
            NSString*  lastNameStr=[NSString stringWithFormat:@"%@.",[[userDetailDicttemp valueForKey:@"lastname"] substringToIndex:1]];
            
            NSString *fullName=[NSString stringWithFormat:@"%@ %@",[userDetailDicttemp valueForKey:@"firstname"],lastNameStr];
            
            
            
            
//            NSString *fullName=[NSString stringWithFormat:@"%@ %@",[userDetailDicttemp valueForKey:@"firstname"],[userDetailDicttemp valueForKey:@"lastname"]];
            
            
            NSString* picUrl=[userDetailDicttemp valueForKey:@"profilepiclocation"];
            
            [[NSUserDefaults standardUserDefaults]setValue:fullName forKey:@"fullName"];
            [[NSUserDefaults standardUserDefaults]setValue:picUrl forKey:@"picUrl"];
            NSString* active_tripid=[userDetailDicttemp valueForKey: @"active_tripid"];
            [[NSUserDefaults standardUserDefaults ]removeObjectForKey:@"activeTripId"];
            if (active_tripid.length>0)
            {
                [[NSUserDefaults standardUserDefaults]setValue:active_tripid forKey:@"activeTripId"];
            }

            NSString* Riderside=[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue"];
            if (Riderside.length==0)
                
            {
                 [[NSUserDefaults standardUserDefaults] setValue:@"RiderSide" forKey:@"Queue"];
            }

            userNameTxt.text=@"";
            passwordTxt.text=@"";
            MapViewController *mapVc;

                if ([[UIScreen mainScreen] bounds].size.height == 568) {
                    mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
                }
                else if([[UIScreen mainScreen] bounds].size.height == 480) {
                    mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController_iphone4" bundle:nil];
                }
                [self.navigationController pushViewController:mapVc animated:YES];

        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex{
    if (alertView.tag==1)
    {
        if (buttonIndex==0)
        {
            userNameTxt.text=@"";
            passwordTxt.text=@"";
            MapViewController *mapVc;
            
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
            }
            else if([[UIScreen mainScreen] bounds].size.height == 480) {
                mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController_iphone4" bundle:nil];
            }

            [self.navigationController pushViewController:mapVc animated:YES];
        }
    }
    else if (alertView.tag==2)
    {
        passwordTxt.text=@"";
    }
}


- (IBAction)registerBtn:(id)sender {
    [self.view endEditing:YES];
    RegistrationRiderViewController *registerRiderVc;
    userNameTxt.text=@"";
    passwordTxt.text=@"";

    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        registerRiderVc=[[RegistrationRiderViewController alloc]initWithNibName:@"RegistrationRiderViewController" bundle:nil];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        registerRiderVc=[[RegistrationRiderViewController alloc]initWithNibName:@"RegistrationRiderViewController_iphone4" bundle:nil];
    }
    [self.navigationController pushViewController:registerRiderVc animated:YES];

}



- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return  YES;
}
@end
