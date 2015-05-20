//
//  DriverRideMapViewController.h
//  RapidRide
//
//  Created by Br@R on 13/11/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIFormDataRequest.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "RideFinishViewController.h"
#import <MessageUI/MessageUI.h>



@interface DriverRideMapViewController : UIViewController<MKMapViewDelegate,MKAnnotation,GMSMapViewDelegate,CLLocationManagerDelegate,MFMessageComposeViewControllerDelegate,UIActionSheetDelegate>
{
    GMSMarker *marker2;
    GMSPolyline *rectangle;
    GMSMapView *mapView;
    GMSMarker* marker;
    GMSMarker *marker1,*endMarker,*startMarker;
    NSTimer*timer,*timer1,*timer4,*timer5,*gtimer4,*utimer5;
    NSString *phNo,*trigger ,*estimatedTimeStr,*distanceStr;
    NSString *estimateDistanceStr;

    NSDictionary *jsonDict;
    NSMutableData *webData;
    NSURL *urlString;
    
    NSString *jsonRequest ;
    NSString *startLocation;
    NSString *GetTripId;
    float estimatedDistance;

    int webservice;
    int flag;
    int flag1;
    double oldLat;
    double oldLong;
    BOOL arrivedCall;
    BOOL showOnce;
    
    IBOutlet UIButton *messageBtn;
    IBOutlet UIButton *callBtn;
    IBOutlet UILabel *pickUpLbl;
    IBOutlet UILabel *etaTimeLbl;
    IBOutlet UILabel *fareValueLbl;
    IBOutlet UILabel *etaLbl;
    IBOutlet UILabel *fareLbl;
    IBOutlet UILabel *footerBackView;
    IBOutlet UILabel *basicInfoBackView;
    IBOutlet UIButton *backBtn;
    IBOutlet UILabel *pickupDteTimeLbl;
    IBOutlet UIImageView *ImageView;
    IBOutlet UIButton *endRideBtn;
    IBOutlet UIButton *startRideBtn;
}


@property (strong, nonatomic) IBOutlet UIButton *cancelRideBtn;
@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UIButton *menuBtn;
@property (strong, nonatomic) IBOutlet UITextView *designationTxtView;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *ratingLbl;
@property (strong, nonatomic) IBOutlet UIImageView *colorImage;
@property (strong, nonatomic) IBOutlet UIButton *GPSbtn;
@property (strong, nonatomic) IBOutlet UIImageView *disablImg;
@property (weak, nonatomic)   IBOutlet UIButton *arrivedBtn;
@property (strong, nonatomic) IBOutlet UILabel *headerView;
@property (strong, nonatomic) IBOutlet UILabel *headerLbl;
@property (nonatomic, retain)  UIActivityIndicatorView *activityIndicatorObject;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) double current_latitude;
@property (nonatomic, assign) double current_longitude;
@property (nonatomic, assign) BOOL FromNotification;
@property (strong, nonatomic) NSString *ratingStr ,*startLat,*startLong ,*endlat,*endLong ,*handicappedStr;
@property (nonatomic,retain)  NSString *GetTripId,*getDriverId,*GetNameStr,*getDesignationStr,*endLocationString,*getpickUptimrStr,*getFareStr,*getETAstr,*getimgeUrl,*getVehicleType,*getEstimatedMilesStr;

@property (strong, nonatomic) NSTimer*Disttimer,*Disttimer1;

- (IBAction)cancelRideBTn:(id)sender;
- (IBAction)menuBtn:(id)sender;
- (IBAction)backBtn:(id)sender;
- (IBAction)ArrivedBtn:(id)sender;
- (IBAction)EndRideAction:(id)sender;
- (IBAction)StartRideAction:(id)sender;
- (IBAction)messageBtn:(id)sender;
- (IBAction)callBtn:(id)sender;
- (IBAction)GPSbtn:(id)sender;



@end
