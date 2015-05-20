//
//  LocateDriverOnMapViewController.h
//  RapidRide
//
//  Created by vikram on 04/11/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>

#import "SBJSON.h"
#import "JSON.h"



@interface LocateDriverOnMapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, MKOverlay,GMSMapViewDelegate>

{
    
    GMSMapView *GoogleMapView;
    GMSCameraPosition *MapCamera;
    NSTimer *timer,*gtimer;
    BOOL showOnce;
    NSString*color;
    UIButton *backButton;
    CLLocationManager *lm;
    NSURL *urlString;
    NSString *jsonRequest;
    NSMutableData *webData;
    NSDictionary *jsonDict;
    int webservice;
    NSString *DriverIdStr;
    NSString *TripIdStr;
    float LatestLattitude;
    float LatestLongitude;


}
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorObject;
@property (strong, nonatomic) NSString *DriverIdStr;
@property (strong, nonatomic) NSString *TripIdStr;
@property (strong, nonatomic) NSString *statLat,*startLong,*driverFirstName;
@property (strong, nonatomic) NSString *vehicleShown;
@property (nonatomic, assign) BOOL FromNotification;
@property (strong, nonatomic) IBOutlet UILabel *headerView;
@property (strong, nonatomic) IBOutlet UILabel *headerLbl;
@property (strong, nonatomic) IBOutlet UIImageView *disablImg;
@property (strong, nonatomic) IBOutlet UIButton *notGettingDriverLocBtn;
@property (weak, nonatomic)   IBOutlet MKMapView *mapview;
@property (strong, nonatomic) IBOutlet UIView *FullColourdView;
@property (strong, nonatomic) IBOutlet UIView *colourView;
@property (strong, nonatomic) IBOutlet UILabel *colourHeaderLbl;

- (IBAction)pinkColorBtn:(id)sender;
- (IBAction)redColorBtn:(id)sender;
- (IBAction)greenColorBtn:(id)sender;
- (IBAction)yellowColorBtn:(id)sender;
- (IBAction)orangeColorBtn:(id)sender;
- (IBAction)whiteColorBtn:(id)sender;
- (IBAction)blueColorBtn:(id)sender;
- (IBAction)closeBtn:(id)sender;
- (IBAction)notGettingDriverLocBtn:(id)sender;
- (IBAction)cancelColordViewBtn:(id)sender;

@end
