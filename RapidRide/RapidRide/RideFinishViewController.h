//
//  RideFinishViewController.h
//  RapidRide
//
//  Created by Br@R on 08/10/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJSON.h"
#import "JSON.h"
#import "CustomIOS7AlertView.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIFormDataRequest.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import <GoogleMaps/GoogleMaps.h>

@interface RideFinishViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate,CustomIOS7AlertViewDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{
    CustomIOS7AlertView *alertViewCustom ;

    IBOutlet UIPickerView *pickerView;
    IBOutlet UILabel *DiscountValueLabel;
    IBOutlet UIView *RatingView;
    IBOutlet UILabel *RatingStatusLabel;
    IBOutlet UIView *RatingTypeView;
    IBOutlet UITextField *CommentTextField;
    IBOutlet UILabel *linELblOne;
    IBOutlet UIButton *goHomeBtn;
    IBOutlet UIButton *backPickUpbtn;
    IBOutlet UILabel *lineLblTwo;
    IBOutlet UITextView *commentTextView;
    IBOutlet UIButton *goodBtn;
    IBOutlet UIButton *BadBtn;
    IBOutlet UILabel *lineTwo;
    IBOutlet UILabel *dateTimeLbl;
    IBOutlet UILabel *lineOne;
    IBOutlet UILabel *lineThree;
    IBOutlet UIButton *addCardBtn;
    IBOutlet UIImageView *cardSecltdIamge;
    IBOutlet UILabel *cardNumLbl;
    IBOutlet UIButton *changeBtn;
    IBOutlet UILabel *userCreditCardHdrLbl;
    IBOutlet UILabel *usePromocodeHeadrLbl;
   
    NSMutableDictionary *driverInfoDict,*driverZoneDict;
    NSMutableArray  *creditCardsNumArray,*promocodesArray,*promocodeValueArray ;
    NSMutableArray*driverIdArray;
    NSMutableArray *locationArray;
    NSMutableArray*tipArray;
    NSMutableArray *monthsArray ,*yearsArray ;
    NSArray *vehicleListArray,*vehicleZoneListAray;
    NSURL *urlString;
    NSMutableData *webData;
    NSDictionary *jsonDict;
    int webservice,FavDriver, giveRating;
    int searchResults;
    int paymentResult;
    NSDate *dateAftrHours;
    NSDate *selectedDate;
    NSIndexPath*indxPath;
    NSDateComponents *currentDateComponents;
    UIPickerView*myPickerView;
    NSString *monthStr, *yearString ,*yearStr,*monthYearStr;
    NSString*uCreditCardNumStr ;
    NSString *homeFinalAddress;
    NSString*trip_request_date;
    NSString *jsonRequest;
    NSString *tipFare;
    NSString *RatingStatus,*ratingTrigger;
    NSString *minimumTip, *maximumTip;

}

@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;
@property (strong, nonatomic) IBOutlet UITableView *placesTableView;
@property (strong, nonatomic) IBOutlet UILabel *fareLbl;
@property (strong, nonatomic) IBOutlet UILabel *tipLbl;
@property (strong, nonatomic) IBOutlet UILabel *headerLbl;
@property (strong, nonatomic) IBOutlet UILabel *fareLblOutlet;
@property (strong, nonatomic) IBOutlet UILabel *tipLblOutlet;
@property (strong, nonatomic) IBOutlet UILabel *rideCompleteLbl;
@property (strong, nonatomic) IBOutlet UILabel *headerView;
@property (weak, nonatomic)   IBOutlet UILabel *tipAmmountLabl;
@property (weak, nonatomic)   IBOutlet UILabel *tipAmountCalculatedLbl;
@property (strong, nonatomic) IBOutlet UILabel *requestBackLbl;
@property (strong, nonatomic) IBOutlet UILabel *starsBackView;
@property (strong, nonatomic) IBOutlet UIButton *finishBtnOutlet;
@property (weak, nonatomic)   IBOutlet UIButton *addAsFavDriverbtn;
@property (strong, nonatomic) IBOutlet UIButton *ratingDoneBtn;
@property (strong, nonatomic) IBOutlet UIButton *ratingFiveBtn;
@property (strong, nonatomic) IBOutlet UIButton *ratingFourBtn;
@property (strong, nonatomic) IBOutlet UIButton *ratingThreeBtn;
@property (strong, nonatomic) IBOutlet UIButton *ratingTwoBtn;
@property (strong, nonatomic) IBOutlet UIButton *ratingOneBtn;
@property (strong, nonatomic) IBOutlet UIImageView *disablImg;
@property (strong, nonatomic) IBOutlet UIImageView *ratingDisableImage;
@property (strong, nonatomic) IBOutlet UITextField *destinationTxtField;
@property (strong, nonatomic) IBOutlet UIView *selectCardBackView;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIView *requestView;
@property (strong, nonatomic) IBOutlet UIView *pickupdatetimeView;
@property (strong, nonatomic) IBOutlet UITableView *promocodesTableview;
@property (strong, nonatomic) IBOutlet UITableView *selectCardTableView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, assign) double endLocLatitude;
@property (nonatomic, assign) double startLocLattiude;
@property (nonatomic, assign) double startLocLongitude;
@property (nonatomic, assign) double endLocLongitude;
@property (nonatomic, assign) double minPrice;
@property (nonatomic, assign) BOOL FromNotification;
@property (nonatomic, assign) BOOL cancelride;
@property (nonatomic, assign) BOOL isOneWay;
@property (strong, nonatomic) NSString*prefVehicle;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (strong ,nonatomic) NSString *rec_id;
@property (strong ,nonatomic) NSString *tripId,*DriverId;
@property (strong ,nonatomic) NSString *startLocStr,*endLocStr,  *getFareStr,*getETAstr,*price_per_mile,*price_per_minute,*requestType,*surgeValue;
@property (strong, nonatomic)  NSString *base_fare,*h_total_fare,*f_total_fare;


- (IBAction)cancelRideBtn:(id)sender;
- (IBAction)donePickupDateEdittingBtn:(id)sender;
- (IBAction)cancelDateSelectingBtn:(id)sender;
- (IBAction)changeDateTime:(id)sender;
- (IBAction)editPickupTimeBtn:(id)sender;
- (IBAction)changeDatetimeBtn:(id)sender;
- (IBAction)requestRideBtn:(id)sender;
- (IBAction)backToPickUpBtn:(id)sender;
- (IBAction)goHomeBtn:(id)sender;
- (IBAction)PayNowBtn:(id)sender;
- (IBAction)ratingOne:(id)sender;
- (IBAction)ratingTwo:(id)sender;
- (IBAction)ratingThree:(id)sender;
- (IBAction)ratingFour:(id)sender;
- (IBAction)ratingFive:(id)sender;
- (IBAction)backBtn:(id)sender;
- (IBAction)finishBtn:(id)sender;
- (IBAction)CloseButtonAction:(id)sender;
- (IBAction)SelectRating:(id)sender;
- (IBAction)GoodBtn:(id)sender;
- (IBAction)BadBtn:(id)sender;
- (IBAction)DoneButtonAction:(id)sender;
- (IBAction)addAsFavDriverBtn:(id)sender;
- (IBAction)addNewCardBtn:(id)sender;
- (IBAction)changeCardBtn:(id)sender;


@end
