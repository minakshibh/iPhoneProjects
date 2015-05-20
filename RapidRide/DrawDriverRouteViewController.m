//
//  DrawDriverRouteViewController.m
//  mymap
//
//  Created by vikram on 09/12/14.
//  Copyright (c) 2014 Impinge. All rights reserved.
//

#import "DrawDriverRouteViewController.h"

@interface DrawDriverRouteViewController ()

@end

@implementation DrawDriverRouteViewController
@synthesize LocationsDict,WebViewOutlet,Source,Destination,start_latitude,start_longitude,end_latitude,end_longitude;


#pragma mark - View Life Cycle

- (void)viewDidLoad
{
 
    [super viewDidLoad];
    
    [self.headrView setBackgroundColor:[UIColor colorWithRed:(3.0 / 255.0) green:(15.0 / 255.0) blue:(51.0 / 255.0) alpha:1]];
    [self.headrLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:30]];

    
    CLLocationManager*locationManager = [[CLLocationManager alloc] init];
    
    start_longitude=locationManager.location.coordinate.longitude;
    start_latitude=locationManager.location.coordinate.latitude;

    
    CLLocationCoordinate2D start = { (start_latitude), (start_longitude) };
    CLLocationCoordinate2D end = { (end_latitude), (end_longitude) };
    
 
    NSString *routeString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f&output=html",start.latitude,start.longitude,end.latitude,end.longitude];

    


    NSString* addr = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        
    addr = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%1.6f,%1.6f&saddr=Posizione attuale", end.latitude,end.longitude];
    }
    else {
        addr = [NSString stringWithFormat:@"http://maps.apple.com/maps?daddr=%1.6f,%1.6f&saddr=Posizione attuale",start.latitude,start.longitude];
    }
    
    NSURL* url1 = [[NSURL alloc] initWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url1];
    

    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
