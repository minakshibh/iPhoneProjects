//
//  DrawDriverRouteViewController.h
//  mymap
//
//  Created by vikram on 09/12/14.
//  Copyright (c) 2014 Impinge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>


@interface DrawDriverRouteViewController : UIViewController<GMSMapViewDelegate,UIWebViewDelegate>

{
    NSMutableDictionary *LocationsDict;
    GMSMapView *mapView;
    GMSMarker* marker;
    GMSMarker* marker2;
    GMSPolyline *rectangle;

    
    double DriverLatitude;
    double DriverLongitude;
    double RiderLatitude;
    double RiderLongitude;
    NSString *Source;
    NSString *Destination;




}
@property (strong, nonatomic) IBOutlet UILabel *headrView;
@property (strong, nonatomic) IBOutlet UILabel *headrLbl;


- (IBAction)backBtn:(id)sender;

@property(nonatomic,retain)NSString *Source;
@property(nonatomic,retain)NSString *Destination;

@property (nonatomic, assign) double start_latitude;
@property (nonatomic, assign) double start_longitude;

@property (nonatomic, assign) double end_latitude;
@property (nonatomic, assign) double end_longitude;


@property(nonatomic,retain)NSMutableDictionary *LocationsDict;
@property (retain, nonatomic) IBOutlet UIWebView *WebViewOutlet;


@end
