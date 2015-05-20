//
//  AppDelegate.h
//  RapidRide
//
//  Created by Br@R on 08/10/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "CustomIOS7AlertView.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,GMSMapViewDelegate,CustomIOS7AlertViewDelegate,CLLocationManagerDelegate>
{
    NSMutableData *webData;
    NSString *RiderIdStr;
    NSString *driverIdStr;
    NSString* user_UDID_Str ,*registrationIDStr,*message,*result;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest ,*reqId,*reqType;
    NSTimer *timer ,*stopWatchTimer;
    CustomIOS7AlertView *alertViewCustom ;
    UIView *animatedView;
    UIImageView*DriverImgView;
    UILabel *DriverNameLbl;
    UILabel *MessageLbl;
    BOOL acceptReq;
    NSString *distanceStr;
    NSString *currentLocStr;
    NSString *priceStr;
    NSString *destinationLoc;
    NSString *riderNameStr;
    NSString *timeStr;
    UILabel *timeLbl;
    NSString *colour;
    NSString *picUrl,*ratingStr,*handicapedStr,*pickupTime,*vehicleStr,*getRiderNameStr;
    AVAudioPlayer*masterAudioPlayer;
    int Time;
    UIView*view;
}
@property(nonatomic, strong) CLLocationManager *locationManager;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigator;


@end
