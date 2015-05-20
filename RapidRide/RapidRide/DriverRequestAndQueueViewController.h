//
//  DriverRequestAndQueueViewController.h
//  RapidRide
//
//  Created by vikram on 03/11/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RideFinishViewController.h"
#import <MessageUI/MessageUI.h>


@interface DriverRequestAndQueueViewController : UIViewController<CLLocationManagerDelegate,MFMessageComposeViewControllerDelegate,UIActionSheetDelegate>

{
    NSTimer *timer;
    NSTimer *timer1;
    NSTimer *qtimer;
    NSTimer *qtimer1;
    NSArray *sortedArray;
    NSString *RequestType ,*handicapStr;
    NSMutableData *webData;
    NSString  *reqId ;
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
    IBOutlet UIButton *DriverLocBtnOutlet;
    NSString *phNo;
    IBOutlet UIButton *messageBtn;
    UIButton *backButton;
    NSString *RiderIdStr;
    NSString *modeType;
    NSString *GetDriverId;
    NSString *UrlString;
    UIAlertView *alertt;
    NSString *driverIdNew,*riderDesignationLattitude,*riderDesignationLongitude,*ratingStr,*driverFirstName;
    NSString *rideReqType ,*pickuptimeStr,*estimatedTimeStr;
    IBOutlet UIButton *endRideButtonOutlet;
    float currentLatestLattitude;
    float currentLatestLongitude;
    NSString *imgUrlStr,*suggestdFareStR,*etaStr ,*vehicleStr;
    NSString* TripStartLat ,*tripEndLat;
    NSString* tripStartLong,*tripEndLong;
  
    IBOutlet UIImageView *vehicleImageView;
    IBOutlet UILabel *modelValueLbl;
}
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,retain) NSString *GetDriverId;
@property (nonatomic,retain) NSString *RequestType;
@property (nonatomic,retain) NSString *RiderIdStr;
@property (nonatomic,retain) NSString *modeType;
@property (strong,nonatomic) NSString*driverIdStr,*GetTripId;
@property (nonatomic, assign) BOOL FromNotification;
@property (nonatomic, assign) BOOL driverMode;
@property (strong, nonatomic) IBOutlet UILabel *EtaTimeLbl;
@property (strong, nonatomic) IBOutlet UIView *riderDetailView;
@property (strong, nonatomic) IBOutlet UILabel *headerView;
@property (strong, nonatomic) IBOutlet UILabel *headerLbl;
@property (strong, nonatomic) IBOutlet UIImageView *disablImg;
@property (strong, nonatomic) IBOutlet UILabel *numRequests;
@property (strong, nonatomic) IBOutlet UITableView *requestTable;
@property (strong, nonatomic) IBOutlet UILabel *riderNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *riderDistanceLbl;
@property (strong, nonatomic) IBOutlet UILabel *riderActualFareLbl;
@property (strong, nonatomic) IBOutlet UILabel *riderSuggestdFareLbl;
@property (strong, nonatomic) IBOutlet UITextView *riderStartLocTxtView;
@property (strong, nonatomic) IBOutlet UITextView *riderEndLocTxtView;
@property (strong, nonatomic) IBOutlet UIView *riderBasicInfoBackView;
@property (strong, nonatomic) IBOutlet UIView *riderLocatioInfoBackView;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIButton *passangerModeBtn;
@property (strong, nonatomic) IBOutlet UIButton *activrRidebtn;
@property (strong, nonatomic) IBOutlet UIImageView *riderImage;
@property (strong, nonatomic) IBOutlet UIButton *FindMyDriverLocBtn;
@property (strong, nonatomic) IBOutlet UIButton *callBtn;
@property (strong, nonatomic) IBOutlet UIButton *CancelRideBtn;
@property (strong, nonatomic) IBOutlet UIImageView *handicappdImgView;


- (IBAction)passangerMode:(id)sender;
- (IBAction)backBtn:(id)sender;
- (IBAction)requestsBtn:(id)sender;
- (IBAction)acceptRequest:(id)sender;
- (IBAction)rejectRequest:(id)sender;
- (IBAction)messageBtn:(id)sender;
- (IBAction)DriverSwitchButtonAction:(id)sender;
- (IBAction)MyQueueButtonAction:(id)sender;
- (IBAction)StartRideButtonAction:(id)sender;
- (IBAction)StartDriverLocation:(id)sender;
- (IBAction)EndRideButton:(id)sender;
- (IBAction)ActiveRideBtn:(id)sender;
- (IBAction)findMyDriverLocBtn:(id)sender;
- (IBAction)callBtn:(id)sender;
- (IBAction)CancelRideBtn:(id)sender;

@end
