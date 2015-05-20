//
//  reciveRequestViewController.h
//  dash
//
//  Created by Krishna_Mac_1 on 5/13/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import <MapKit/MapKit.h>
#import "DetailerFirastViewController.h"
@interface reciveRequestViewController : UIViewController<MKMapViewDelegate,GMSMapViewDelegate,CLLocationManagerDelegate>
{
    NSMutableData*webData;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    GMSMapView *mapView;
    IBOutlet UILabel *nameLbl;
    CLLocationManager*locManager;
    GMSMarker*marker;
    float lat;
    float lon;
    IBOutlet UIView *sideView;
    IBOutlet UIImageView *profileImg;
    IBOutlet UIView *tapToAcceptView;
    IBOutlet UIView *userRequestView;
    IBOutlet UIButton *goOnlineBtn;
    DetailerFirastViewController *detailerFirstVC;
}
- (IBAction)myWorkSamples:(id)sender;

- (IBAction)goOnlineBtnAction:(id)sender;
- (IBAction)logOutBttn:(id)sender;
- (IBAction)viewProfileBttn:(id)sender;
- (IBAction)workSamples:(id)sender;
- (IBAction)menuBttn:(id)sender;
- (IBAction)homeBttn:(id)sender;
- (IBAction)tapToAcceptBtnAction:(id)sender;

@property(nonatomic, strong) CLLocationManager *locationManager;
@end
