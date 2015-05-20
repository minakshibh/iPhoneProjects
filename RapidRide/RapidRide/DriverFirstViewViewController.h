//
//  DriverFirstViewViewController.h
//  RapidRide
//
//  Created by Br@R on 29/10/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIFormDataRequest.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DriverFirstViewViewController : UIViewController<MKMapViewDelegate,MKAnnotation,GMSMapViewDelegate,CLLocationManagerDelegate>
{
    NSTimer *timer;
    NSTimer *timer2;

    NSMutableData *webData;
    NSString  *reqId;
    NSArray *requestListArray;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest ;
    UILabel *UserLocInfo;
    IBOutlet UIView *sideView;
    IBOutlet UISwitch *DriverSwitchBtn;
    IBOutlet UIButton *AcceptBtn;
    IBOutlet UIButton *RejectBtn;
    IBOutlet UIButton *StartRide;
    UIButton *backButton;
    NSString *RiderIdStr;
    NSString *modeType,*viewRideUrl;
     GMSMapView *mapView;
    GMSMarker* marker;
   // UILabel *UserNameLabel;
    
}
@property(nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;
@property (strong, nonatomic) IBOutlet UIView *riderDetailView;
@property (strong, nonatomic) IBOutlet UIView *riderBasicInfoBackView;
@property (strong, nonatomic) IBOutlet UIView *riderLocatioInfoBackView;
@property (strong, nonatomic) IBOutlet UITableView *requestTable;
@property (strong, nonatomic) IBOutlet UILabel *riderNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *riderDistanceLbl;
@property (strong, nonatomic) IBOutlet UILabel *riderActualFareLbl;
@property (strong, nonatomic) IBOutlet UILabel *driverModeLbl;
@property (strong, nonatomic) IBOutlet UILabel *numRequests;
@property (strong, nonatomic) IBOutlet UILabel *headerView;
@property (strong, nonatomic) IBOutlet UILabel *headerLbl;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *riderSuggestdFareLbl;
@property (strong, nonatomic) IBOutlet UITextView *riderStartLocTxtView;
@property (strong, nonatomic) IBOutlet UITextView *riderEndLocTxtView;
@property (strong, nonatomic) IBOutlet UIButton *helpBtn;
@property (strong, nonatomic) IBOutlet UIButton *viewRidesBtn;
@property (strong, nonatomic) IBOutlet UIButton *paymentsBtn;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIButton *passangerModeBtn;
@property (strong, nonatomic) IBOutlet UIButton *driverBtn;
@property (strong, nonatomic) IBOutlet UIButton *requestsBtn;
@property (strong, nonatomic) IBOutlet UIButton *myQueueBtn;
@property (strong, nonatomic) IBOutlet UIImageView *riderImageView;
@property (strong, nonatomic) IBOutlet UIImageView *riderImage;
@property (strong, nonatomic) IBOutlet UIImageView *disablImg;

@property (strong, nonatomic) NSString*driverIdStr ,*picUrl;
@property (nonatomic, retain) NSString *RiderIdStr;
@property (nonatomic, retain) NSString *modeType;
@property (nonatomic, assign) double current_latitude;
@property (nonatomic, assign) double current_longitude;
@property (nonatomic, assign) BOOL driverMode ,fromSplash;

- (IBAction)acceptRequest:(id)sender;
- (IBAction)rejectRequest:(id)sender;
- (IBAction)DriverSwitchButtonAction:(id)sender;
- (IBAction)MyQueueButtonAction:(id)sender;
- (IBAction)StartRideButtonAction:(id)sender;
- (IBAction)passangerMode:(id)sender;
- (IBAction)backBtn:(id)sender;
- (IBAction)requestsBtn:(id)sender;
- (IBAction)helpBtn:(id)sender;
- (IBAction)paymentsBtn:(id)sender;
- (IBAction)viewRidesBtn:(id)sender;



@end
