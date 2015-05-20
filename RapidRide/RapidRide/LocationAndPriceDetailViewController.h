//
//  LocationAndPriceDetailViewController.h
//  RapidRide
//
//  Created by Br@R on 08/10/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationAndPriceDetailViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource,UIScrollViewDelegate>
{
    NSString *minimumPrice, *maximumPrice,*userIdStr,*start_loc,*destination_loc,*suggestedFare,*riderMobileNum,*driverMobileNum,*estimatedTimeStr;
    UIPickerView*myPickerView;
    NSMutableArray *priceArray;
    NSMutableData *webData;
    float estimatedDistance;
    NSString *trip_request_date;
    NSDate *currentDate;
    NSString *currentDateStr,*riderDriverIdStr;
    NSDate *selectedDate;
    NSDate *dateAftrHours;
    IBOutlet UIButton *startEditBTn;
    NSString *color;
  
}
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;
@property (strong, nonatomic) IBOutlet UITextView *startLocationView;
@property (strong, nonatomic) IBOutlet UITextView *destinationLocView;
@property (strong, nonatomic) IBOutlet UIView *priceBackView;
@property (strong, nonatomic) IBOutlet UIView *locationBackView;
@property (strong, nonatomic) IBOutlet UIView *selectColorBackView;
@property (strong, nonatomic) IBOutlet UIView *colourView;
@property (strong, nonatomic) IBOutlet UIView *pickupDateView;
@property (strong, nonatomic) IBOutlet UIImageView *disableImg;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *mypriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *destinationNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *startLocNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *ownProceLbl;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;
@property (strong, nonatomic) IBOutlet UILabel *nameurPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *distLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *destinationLocHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *headerLbl;
@property (strong, nonatomic) IBOutlet UILabel *colourLbl;
@property (strong, nonatomic) IBOutlet UILabel *dateTimeLbl;
@property (strong, nonatomic) IBOutlet UILabel *estimatedTimeLbl;
@property (strong, nonatomic) IBOutlet UILabel *colourHeaderLbl;
@property (strong, nonatomic) IBOutlet UILabel *headerView;
@property (strong, nonatomic) IBOutlet UILabel *priceLbl;
@property (strong, nonatomic) IBOutlet UILabel *distanceLbl;
@property (strong, nonatomic) IBOutlet UIButton *requestBtn;
@property (strong, nonatomic) IBOutlet UIButton *editDestinationBtn;
@property (strong, nonatomic) IBOutlet UIButton *dateDoneBtn;
@property (strong, nonatomic) IBOutlet UIButton *dateCancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *selectDriverBtn;

@property (strong, nonatomic) NSArray *driverIdArray;
@property (strong, nonatomic) NSString *driverList;
@property (strong, nonatomic) NSString *pickupdatetimestrfromView;
@property (strong, nonatomic) NSString *price_per_minute;
@property (strong, nonatomic) NSString *price_per_mile;
@property (strong, nonatomic) NSString *base_fare;
@property (strong, nonatomic) NSString *driverIdStr,*vehicleType;
@property (strong, nonatomic) NSString *startLocAddressStr;
@property (strong, nonatomic) NSString *endLocAddressStr;
@property (strong, nonatomic) NSString *startLocNameStr;
@property (strong, nonatomic) NSString *endLocNameStr;
@property (strong, nonatomic) NSString *distanceStr,*actualFare,*surgeValue;
@property (nonatomic, assign) BOOL isOneWay,fromEndView ;
@property (nonatomic, assign) BOOL isVIP, isHalfDay ,isFullday,isFavDriver;
@property (nonatomic, assign) double start_longitude;
@property (nonatomic, assign) double start_latitude;
@property (nonatomic, assign) double end_longitude;
@property (nonatomic, assign) double end_latitude;
@property (nonatomic, assign) double minPrice;


- (IBAction)pinkColorBtn:(id)sender;
- (IBAction)redColorBtn:(id)sender;
- (IBAction)greenColorBtn:(id)sender;
- (IBAction)yellowColorBtn:(id)sender;
- (IBAction)orangeColorBtn:(id)sender;
- (IBAction)whiteColorBtn:(id)sender;
- (IBAction)blueColorBtn:(id)sender;
- (IBAction)closeBtn:(id)sender;
- (IBAction)editColourBtn:(id)sender;
- (IBAction)donePickupDateEdittingBtn:(id)sender;
- (IBAction)cancelDateSelectingBtn:(id)sender;
- (IBAction)changeDateTime:(id)sender;
- (IBAction)editPickupTimeBtn:(id)sender;
- (IBAction)selectDriverBtn:(id)sender;
- (IBAction)backBtn:(id)sender;
- (IBAction)editStartLocation:(id)sender;
- (IBAction)editEndLocation:(id)sender;
- (IBAction)requestPickupBtn:(id)sender;

@end
