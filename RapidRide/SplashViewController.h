//
//  SplashViewController.h
//  RapidRide
//
//  Created by Br@R on 17/10/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIFormDataRequest.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import <GoogleMaps/GoogleMaps.h>

@interface SplashViewController : UIViewController<UINavigationControllerDelegate,MKMapViewDelegate,MKAnnotation,GMSMapViewDelegate,CLLocationManagerDelegate>
{
    NSMutableData *webData;
    CLLocationManager *locationManager;
    GMSMapView *mapView;
    NSString *emailStr,*passwordStr ,*userIdStr;
    int countr,webservice;
    double current_longitude;
    double current_latitude;

}
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;

@end
