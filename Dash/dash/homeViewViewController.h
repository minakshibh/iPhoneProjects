//
//  homeViewViewController.h
//  dash
//
//  Created by Krishna_Mac_1 on 4/15/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "mapDetailsObj.h"
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>

@interface homeViewViewController : UIViewController<GMSMapViewDelegate>
{
    GMSMapView *mapView_;
    NSMutableArray *latitudeArray, *longitudeArray, *titleArray, *markersImageArray, *rattingArray, *mapDetailsArray;
    mapDetailsObj *mapDetailsOC;
    IBOutlet UIScrollView *menuSlider;
    UITapGestureRecognizer *letterTapRecognizer;
    NSTimer *sendBackTimer;
    IBOutlet UIImageView *menuIconImg;
    IBOutlet UIImageView *profileImage;
    IBOutlet UILabel *profileName;
    
    IBOutlet UIView *sideView;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
}
@property(strong,nonatomic)    NSString*fromView;
- (IBAction)workSamples:(id)sender;

- (IBAction)menuBtnAction:(id)sender;
- (IBAction)registerBtnAction:(id)sender;
- (IBAction)MyVehicles:(id)sender;
- (IBAction)MyLocationsBtn:(id)sender;
- (IBAction)loginBtnAction:(id)sender;
- (IBAction)requestService:(id)sender;
- (IBAction)profileBttn:(id)sender;
- (IBAction)homeBtnAction:(id)sender;
- (IBAction)serviceHistoryBttn:(id)sender;
- (IBAction)logOutBttn:(id)sender;


@end
