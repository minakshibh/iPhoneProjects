//
//  MapViewController.h
//  RapidRide
//
//  Created by Br@R on 08/10/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIFormDataRequest.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MapViewController : UIViewController <UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MKMapViewDelegate,MKAnnotation,GMSMapViewDelegate,CLLocationManagerDelegate>
{
    NSDictionary *tempVehicleDict;
    GMSMapView *mapView;
    NSArray *vehicleNameArray,*vehicleImageArray;
    NSMutableData *webData;
    CLLocationManager *locationManager;
    GMSMarker*marker,*endMarker,*currentLocMarker;
    BOOL isHomeBtn , ismoveMarkr ,isMoveStartLocMarkr,isMoveEndLocMrkr,isDestinationLocMrkr ;
    NSMutableDictionary *driverInfoDict,*driverZoneDict;
    NSArray *vehicleListArray,*vehicleZoneListAray;
    NSString *userIdStr,*vehicleTypeName,*driverIdStr,*moveMrkrStartLocStr,*moveMarkrEnsLocStr;
    NSString *currentTime,*picUrl;
//    UIImageView *yourUIImageview;
    NSDictionary *jsonDict;
    NSString *estimatedTimeStr,*nearsCarMintStr;
    
    int tempTime,searchResults,webserviceCode;
    NSDate *now;
    NSString *payment_status;
    NSString *handicapdStr;
    BOOL ispickupLocationSearch ,isdestinationLocSearch;
    NSString *viewRideUrl ;
    NSTimer *timer,*Vtimer ,*popUptimer,*LocationTimer;
    NSString*CurrentPosStringInMarkr;
}

@property (strong, nonatomic) IBOutlet NSDictionary *tempVehicleDict;
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;
@property (strong, nonatomic) IBOutlet UIView *sideView;
@property (strong, nonatomic) IBOutlet UIView *vipBackView;
@property (strong, nonatomic) IBOutlet UILabel *headerView;
@property (strong, nonatomic) IBOutlet UILabel *lowerTabView;
@property (strong, nonatomic) IBOutlet UILabel *headerLbl;
@property (strong, nonatomic) IBOutlet UILabel *driverModeLbl;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *pickupLocationLbl;
@property (strong, nonatomic) IBOutlet UIButton *vehicleTypleBtn;
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property (strong, nonatomic) IBOutlet UIButton *logoutBtn;
@property (strong, nonatomic) IBOutlet UIButton *requestRideBtn;
@property (strong, nonatomic) IBOutlet UIButton *driverBtn;
@property (strong, nonatomic) IBOutlet UIButton *paymentBtn;
@property (strong, nonatomic) IBOutlet UIButton *goHomeBTn;
@property (strong, nonatomic) IBOutlet UIButton *oneWayBtn;
@property (strong, nonatomic) IBOutlet UIButton *vipBtn;
@property (strong, nonatomic) IBOutlet UIButton *myQueueBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelSearchtn;
@property (strong, nonatomic) IBOutlet UIButton *menuBtn;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIButton *favDrivrBtn;
@property (strong, nonatomic) IBOutlet UIButton *contactUsBtn;
@property (strong, nonatomic) IBOutlet UIButton *locationEditBtn;
@property (strong, nonatomic) IBOutlet UIButton *seachPickupBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelpickupBtn;
@property (strong, nonatomic) IBOutlet UIButton *viewRideBtn;
@property (strong, nonatomic) IBOutlet UITextField *pickupLocationTxt;
@property (strong, nonatomic) IBOutlet UITextField *locationSearchTxt;
@property (strong, nonatomic) IBOutlet UIImageView *DestinationImg;
@property (strong, nonatomic) IBOutlet UIImageView *pickUpImg;
@property (strong, nonatomic) IBOutlet UIImageView *riderImageView;
@property (strong, nonatomic) IBOutlet UIImageView *disableImg;
@property (strong, nonatomic) IBOutlet UIImageView *vehiclFlagImage;
@property (strong, nonatomic) IBOutlet UISwitch *driverModeToggle;
@property (strong, nonatomic) IBOutlet NSMutableArray *driverIdArray;
@property (strong, nonatomic) IBOutlet UITableView *vehicleTypeTableView;
@property (strong, nonatomic) IBOutlet UITableView *placesTableView;
@property (strong, nonatomic)  NSString*againDriverIdStr,*againVehiclType;
@property (strong, nonatomic)  NSString*driverList;
@property (strong, nonatomic)  NSString *distanceFromCurrntLoc;
@property (strong, nonatomic)  NSString *price_per_minute;
@property (strong, nonatomic)  NSString *price_per_mile;
@property (strong, nonatomic)  NSString *base_fare,*h_total_fare,*f_total_fare,*FavDriverListStr;
@property (strong, nonatomic)  NSString *driverIdStr,*vehicleType,*riderDriverIdStr,*surgeValue;
@property (strong, nonatomic)  NSString *startLocationStr;
@property (strong, nonatomic)  NSString *destinationLocationStr;
@property (strong, nonatomic)  NSString *currentAddressStr;
@property (strong, nonatomic)  NSString *destinationLocationNameStr;
@property (strong, nonatomic)  NSString *startLocNameStr;
@property (strong, nonatomic)  NSString *cityStr ,*activeTripId;
@property (strong, nonatomic)  NSString *countryStr ,*currntFulAdress;
@property (nonatomic, assign) double current_latitude;
@property (nonatomic, assign) double current_longitude;
@property (nonatomic, assign) double startLongitude;
@property (nonatomic, assign) double startLatitude;
@property (nonatomic, assign) double endLongitude;
@property (nonatomic, assign) double endLattitude;
@property (nonatomic, assign) double minPrice;
@property (nonatomic, assign) BOOL isOneWay,isFavDriver;
@property (nonatomic, assign) BOOL isVIP,isHalfDay, isFullDay;
@property (nonatomic, assign) BOOL isStartLoc;
@property (nonatomic, assign) BOOL isEndLoc;
@property (strong, nonatomic) NSMutableArray *locationArray;
@property (nonatomic, strong) NSDictionary *location;

- (IBAction)favDriverBtn:(id)sender;
- (IBAction)backBtn:(id)sender;
- (IBAction)cancelBtn:(id)sender;
- (IBAction)oneWayBtn:(id)sender;
- (IBAction)vipBtn:(id)sender;
- (IBAction)driverMode:(id)sender;
- (IBAction)driverBtn:(id)sender;
- (IBAction)logOut:(id)sender;
- (IBAction)searchBtn:(id)sender;
- (IBAction)homeBtn:(id)sender;
- (IBAction)menuBtn:(id)sender;
- (IBAction)editProfileBtn:(id)sender;
- (IBAction)paymentView:(id)sender;
- (IBAction)detailViewBtn:(id)sender;
- (IBAction)requestRideBtn:(id)sender;
- (IBAction)tipViewBtn:(id)sender;
- (IBAction)vehicleTypeBtn:(id)sender;
- (IBAction)MyQueueBtnAction:(id)sender;
- (IBAction)halfDaySelectBtn:(id)sender;
- (IBAction)fulDaySelectBTn:(id)sender;
- (IBAction)contactUsBtn:(id)sender;
- (IBAction)seachPickupLocationBtn:(id)sender;
- (IBAction)cancelPickUpBtn:(id)sender;
- (IBAction)editBtn:(id)sender;
- (IBAction)viewRidesBtn:(id)sender;
- (IBAction)finishRideView:(id)sender;

@end
