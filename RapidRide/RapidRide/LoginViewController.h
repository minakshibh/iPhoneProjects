//
//  LoginViewController.h
//  cabBooking
//
//  Created by Br@R on 08/10/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIFormDataRequest.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import <GoogleMaps/GoogleMaps.h>
@interface LoginViewController : UIViewController<UINavigationControllerDelegate,MKMapViewDelegate,MKAnnotation,GMSMapViewDelegate,CLLocationManagerDelegate>
{
    NSMutableData *webData;
    CLLocationManager *locationManager;
    GMSMapView *mapView;
    NSString* uEmailStr ,* uPasswrdStr;
}
@property (strong, nonatomic) IBOutlet UILabel *backView;
@property (strong, nonatomic) IBOutlet UILabel *headerView;
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;
@property (strong, nonatomic) IBOutlet UITextField *userNameTxt;
@property (strong, nonatomic) IBOutlet UITextField *passwordTxt;
@property (strong, nonatomic) IBOutlet UILabel *headerLbl;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIButton *forgotPasswrtBtn;
@property (strong, nonatomic) IBOutlet UIButton *registerBtn;
@property (strong, nonatomic) IBOutlet UIImageView *disableImg;
@property (strong, nonatomic) NSString *uName,*uPasswrd;

- (IBAction)loginBtn:(id)sender;
- (IBAction)forgotPasswrdBtn:(id)sender;
- (IBAction)registerBtn:(id)sender;
- (IBAction)editBtn:(id)sender;
@end
