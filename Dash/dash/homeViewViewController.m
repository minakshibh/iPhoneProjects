//
//  homeViewViewController.m
//  dash
//
//  Created by Krishna_Mac_1 on 4/15/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "homeViewViewController.h"
#import "detailerViewController.h"
#import "AsyncImageView.h"
#import "customerProfileViewController.h"
#import "vehicleListViewController.h"
#import "registerViewController.h"
#import "requestServiceViewController.h"
#import "NSData+Base64.h"
#import "locationListViewController.h"
#import "loginViewController.h"
#import "MyprofileViewController.h"
#import "WorkSamplesViewController.h"


@interface homeViewViewController ()

@end

@implementation homeViewViewController

- (void)viewDidLoad {
    sideView.hidden=YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    
    [super viewDidLoad];
    latitudeArray = [[NSMutableArray alloc] initWithObjects:@"30.723324900000000000",@"30.765380800000000000",@"30.716934800000000000",@"30.690889100000000000", @"30.702591400000000000",nil];
    longitudeArray = [[NSMutableArray alloc] initWithObjects:@"76.807483800000000000",@"76.784125500000070000",@"76.743628299999950000",@"76.737530699999980000",@"76.709119999999980000", nil];
    
    titleArray = [[NSMutableArray alloc]initWithObjects:@"Grain Market Sector-26",@"PEC Sector-12",@"ISBT Sector-43",@"Cricket Stadium  Sector-63",@"IVY Hospital Sector-71", nil];
    
    markersImageArray = [[NSMutableArray alloc]initWithObjects:@"https://shellyfish.files.wordpress.com/2008/09/good-grains.jpg",@"http://upload.wikimedia.org/wikipedia/en/a/ae/Degree_wing_CCET.png",@"http://theoff.info/wordpress/wp-content/uploads/2014/08/Airport-Bus.jpg",@"http://upload.wikimedia.org/wikipedia/commons/9/92/LightsMohali.png",@"https://pbs.twimg.com/profile_images/1514572603/Final_logo_1_.JPG", nil];
    
    rattingArray = [[NSMutableArray alloc]initWithObjects:@"4",@"2",@"3",@"1",@"5", nil];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:30.733314800000000000
                                                            longitude:76.779417900000000000
                                                                 zoom:11];
    
    
    menuIconImg.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);

    
    
    if (IS_IPHONE_4_OR_LESS)
    {
        mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 60, self.view.frame.size.width , self.view.frame.size.height-420)camera:camera];
    }
    if (IS_IPHONE_5)
    {
        mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 70, self.view.frame.size.width , self.view.frame.size.height-370) camera:camera];
    }
    if (IS_IPHONE_6)
    {
        mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 85, self.view.frame.size.width , self.view.frame.size.height-300) camera:camera];
    }
    if (IS_IPHONE_6P)
    {
        mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 90, self.view.frame.size.width , self.view.frame.size.height-250) camera:camera];
    }

    mapDetailsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [latitudeArray count]; i++) {
        mapDetailsOC = [[mapDetailsObj alloc] init];
        mapDetailsOC.latitudeStr = [NSString stringWithFormat:@"%@",[latitudeArray objectAtIndex:i]];
        mapDetailsOC.longitudeStr = [NSString stringWithFormat:@"%@",[longitudeArray objectAtIndex:i]];
        mapDetailsOC.placeName = [NSString stringWithFormat:@"%@",[titleArray objectAtIndex:i]];
        mapDetailsOC.placeImage = [NSString stringWithFormat:@"%@",[markersImageArray objectAtIndex:i]];
        mapDetailsOC.placeRatingStr = [NSString stringWithFormat:@"%@",[rattingArray objectAtIndex:i]];
        [mapDetailsArray addObject:mapDetailsOC];
    }
    
    [mapView_ setDelegate:self];
    mapView_.myLocationEnabled = YES;
    [self.view addSubview:mapView_];
    [self.view sendSubviewToBack:menuSlider];
    [self.view bringSubviewToFront:sideView];


    profileImage.layer.borderColor = [UIColor grayColor].CGColor;
    profileImage.layer.borderWidth = 1.5;
    profileImage.layer.cornerRadius = 10.0;
    [profileImage setClipsToBounds:YES];
    
    
       // Creates a marker in the center of the map.
    for (int i = 0; i < [mapDetailsArray count]; i++) {
        mapDetailsOC = [mapDetailsArray objectAtIndex:i];
        float lat = [mapDetailsOC.latitudeStr floatValue];
        float longit = [mapDetailsOC.longitudeStr floatValue];
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(lat, longit);
        marker.title = mapDetailsOC.placeName;
        marker.icon = [UIImage imageNamed:@"pin1.png"];
        marker.map = mapView_;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    profileName.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userName"]];

    [self fetchProfileInfoFromDatabase];

}
-(void) fetchProfileInfoFromDatabase
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString;
    queryString = [NSString stringWithFormat:@"Select * FROM userProfile where userId=\"%@\" ",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]];
    
    FMResultSet *results = [database executeQuery:queryString];
    while([results next])
    {
        //  nameLbl.text =[results stringForColumn:@"name"];
        NSString*imgUrl=[results stringForColumn:@"image"];
        
        NSURL *imageURL = [NSURL URLWithString:imgUrl];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                profileImage.image = [UIImage imageWithData:imageData];
            });
        });
    }
    [database close];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)mapView:(GMSMapView *)mapView
   markerInfoWindow:(GMSMarker *)marker {
    UIView *infoWindow = [[UIView alloc] init];
    infoWindow.frame = CGRectMake(0, 0, 200, 50);
    infoWindow.backgroundColor = [UIColor whiteColor];
    infoWindow.layer.borderColor =[UIColor grayColor].CGColor;
    infoWindow.layer.borderWidth = 1.0;
    infoWindow.layer.cornerRadius = 6.0;
    infoWindow.layer.shadowColor = [[UIColor blackColor] CGColor];
    infoWindow.layer.shadowOpacity = 1;
    infoWindow.layer.shadowRadius = 10;
    infoWindow.layer.shadowOffset = CGSizeMake(-2, 7);
    [infoWindow setClipsToBounds:YES];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(50, 5, 150, 16);
    titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:13];
    [infoWindow addSubview:titleLabel];
    titleLabel.numberOfLines = 2;
    titleLabel.text = marker.title;
    NSInteger Aindex = 0;
    for (int i = 0; i < [mapDetailsArray count]; i++) {
        mapDetailsOC = [mapDetailsArray objectAtIndex:i];
        if ([mapDetailsOC.placeName isEqualToString:marker.title]) {
             Aindex = i;
        }
    }
    
    mapDetailsOC = [mapDetailsArray objectAtIndex:Aindex];
    
    AsyncImageView *itemImage = [[AsyncImageView alloc] init];
    NSString *imageUrls = [NSString stringWithFormat:@"%@",mapDetailsOC.placeImage];
    itemImage.imageURL = [NSURL URLWithString:imageUrls];
    itemImage.showActivityIndicator = YES;
    itemImage.frame = CGRectMake(5, 5, 40, 40);
    itemImage.contentMode = UIViewContentModeScaleAspectFill;
    itemImage.userInteractionEnabled = YES;
    itemImage.multipleTouchEnabled = YES;
    itemImage.layer.borderColor = [UIColor clearColor].CGColor;
    itemImage.layer.borderWidth = 1.5;
    itemImage.layer.cornerRadius = 4.0;
    [itemImage setClipsToBounds:YES];
    [infoWindow addSubview:itemImage];
    
    UILabel *ratingTitleLabel = [[UILabel alloc] init];
    ratingTitleLabel.frame = CGRectMake(50, 25, 150, 15);
    ratingTitleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:8];
    ratingTitleLabel.text = @"Rating:";
    [infoWindow addSubview:ratingTitleLabel];
    
    int x = 80;
    mapDetailsOC = [mapDetailsArray objectAtIndex:Aindex];
    int rate = [mapDetailsOC.placeRatingStr intValue];
    
    for (int i = 0; i < 5; i++) {
        UIButton *rateButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 27, 12, 12)];
        if (i < rate) {
            [rateButton setBackgroundImage:[UIImage imageNamed:@"yellow-star.png"] forState:UIControlStateNormal];
        }else{
            [rateButton setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
        }
        [infoWindow addSubview:rateButton];
        x= x+12;
    }
   
    
    
    return infoWindow;
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    /* don't move map camera to center marker on tap */
    mapView.selectedMarker = marker;
    return YES;
}

- (void) mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    NSInteger Aindex = 0;
    for (int i = 0; i < [mapDetailsArray count]; i++) {
        mapDetailsOC = [mapDetailsArray objectAtIndex:i];
        if ([mapDetailsOC.placeName isEqualToString:marker.title]) {
            Aindex = i;
        }
    }
    mapDetailsOC = [mapDetailsArray objectAtIndex:Aindex];
    detailerViewController *detailerVC = [[detailerViewController alloc] initWithNibName:@"detailerViewController" bundle:nil];
    detailerVC.mapDetailsOC = mapDetailsOC;
    [self.navigationController pushViewController:detailerVC animated:NO];
    
}

- (IBAction)workSamples:(id)sender
{
    WorkSamplesViewController *workSamples=[[WorkSamplesViewController alloc]initWithNibName:@"WorkSamplesViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:workSamples animated:YES];

    
}

- (IBAction)menuBtnAction:(id)sender

{
    
    if (sideView.frame.origin.x==0)
    {
        [self hideSideView];

        
    }
    else{
        [UIView animateWithDuration:0.3
                              delay:0.1
                            options: UIViewAnimationCurveEaseOut
                         animations:^
         {
             sideView.hidden=NO;
             
             CGRect frame = sideView.frame;
             frame.origin.y = sideView.frame.origin.y;
             frame.origin.x = 0;
             sideView.frame = frame;
         }
                         completion:^(BOOL finished)
         {
             NSLog(@"Completed");
             
         }];
        

        }
}
-(void)hideSideView{
    [UIView animateWithDuration:0.3
                          delay:0.1
                        options: UIViewAnimationCurveEaseIn
                     animations:^
     {
         
         CGRect frame = sideView.frame;
         frame.origin.y = sideView.frame.origin.y;
         frame.origin.x = -225;
         sideView.frame = frame;
     }
                     completion:^(BOOL finished)
     {
         NSLog(@"Completed");
         
     }];
    

}


- (IBAction)registerBtnAction:(id)sender {
    customerProfileViewController *vehiclelistVC = [[customerProfileViewController alloc] initWithNibName:@"customerProfileViewController" bundle:nil];
    vehiclelistVC.registrationType = @"customer";
    [self.navigationController pushViewController:vehiclelistVC animated:NO];
}

- (IBAction)MyVehicles:(id)sender {
    vehicleListViewController *vehiclelistVC = [[vehicleListViewController alloc] initWithNibName:@"vehicleListViewController" bundle:nil];
    [self.navigationController pushViewController:vehiclelistVC animated:NO];
}

- (IBAction)MyLocationsBtn:(id)sender {
    locationListViewController *vehiclelistVC = [[locationListViewController alloc] initWithNibName:@"locationListViewController" bundle:nil];
    [self.navigationController pushViewController:vehiclelistVC animated:NO];
}

- (IBAction)loginBtnAction:(id)sender
{
}

- (IBAction)requestService:(id)sender {
//    requestServiceViewController *requestVC = [[requestServiceViewController alloc] initWithNibName:@"requestServiceViewController" bundle:nil];
//    [self.navigationController pushViewController:requestVC animated:NO];
}

- (IBAction)profileBttn:(id)sender
{
    MyprofileViewController*myProfile = [[MyprofileViewController alloc] initWithNibName:@"MyprofileViewController" bundle:nil];
    [self.navigationController pushViewController:myProfile animated:NO];
    
}

- (IBAction)homeBtnAction:(id)sender {
    [self hideSideView];
}

- (IBAction)serviceHistoryBttn:(id)sender {
}

- (IBAction)logOutBttn:(id)sender {
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"role"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    [self deletDataFromDatabase];
    

    loginViewController*loginVC=[[loginViewController alloc]initWithNibName:@"loginViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:loginVC animated:YES];
    
}

-(void)deletDataFromDatabase
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM locationsList"];
    [database executeUpdate:queryString1];
    
    
    NSString *queryString2 = [NSString stringWithFormat:@"Delete FROM userProfile"];
    [database executeUpdate:queryString2];
    
    NSString *queryString3 = [NSString stringWithFormat:@"Delete FROM vehiclesList"];
    [database executeUpdate:queryString3];
    
    NSString *queryString4 = [NSString stringWithFormat:@"Delete FROM workSamples"];
    [database executeUpdate:queryString4];
    
    [database close];
    


}

-(void) fetchOnlineDetailers
{
 
}

-(void) sendSliderBack{
    [sendBackTimer invalidate];
    [self.view sendSubviewToBack:menuSlider];
}
@end
