//
//  EditRiderAccountViewController.h
//  RapidRide
//
//  Created by Br@R on 14/10/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface EditRiderAccountViewController : UIViewController<UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

{
    BOOL isContactNumber;
    NSMutableData *webData;
    UIPickerView*myPickerView;
    NSMutableArray *monthsArray ,*yearsArray;
    NSMutableArray * countriesArray ;
    NSDateComponents *currentDateComponents;
    NSMutableDictionary*dataDict;
    NSArray *promocodeArray,*creditCardArray,*promoValueArray;
    NSString *monthStr, *yearString ,*yearStr,*monthYearStr,*userIdStr,*vehicleType,*phoneCode;
    NSString* uFirstNameStr ,* uLastNameStr ,* uPasswordStr ,* uConfrmPassStr ,* uContactNumStr ,* uAddressStr,* uCityStr,* uStateStr,* uCountryStr ,* uAddressZipStr ,*picUrl,*userEmailStr,*driverId,*specialneedString,*specialNeedStr,*flightNumbrStr;
    
    int handicaped ;
    int animal ;
    NSTimer*timer;
    BOOL iseditView;

    
    IBOutlet UITextView *specialneedTxtView;
    IBOutlet UILabel *specialneedHdrLbl;
    IBOutlet UILabel *handicapedlbl;
    IBOutlet UILabel *servicAnimlLbl;
    IBOutlet UIButton *animalNobtn;
    IBOutlet UIButton *animalYesBtn;
    
}
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;
@property (strong, nonatomic) IBOutlet UILabel *registertionLbl;
@property (strong, nonatomic) IBOutlet UITextField *flightNumTxt;
@property (strong, nonatomic) IBOutlet UILabel *headerLbl;
@property (strong, nonatomic) IBOutlet UIButton *selectCountryBtn;
@property (strong, nonatomic) IBOutlet UITextField *userFirstNameTxt;
@property (strong, nonatomic) IBOutlet UITextField *userLastNameTxt;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageview;
@property (strong, nonatomic) IBOutlet UITextField *passwordTxt;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswrdTxt;
@property (strong, nonatomic) IBOutlet UITextField *contactNumbrTxt;
@property (strong, nonatomic) IBOutlet UIButton *editDoneBtn;
@property (strong, nonatomic) IBOutlet UILabel *adressLbl;
@property (strong, nonatomic) IBOutlet UITextField *addressTxt;
@property (strong, nonatomic) IBOutlet UITextField *countryTxt;
@property (strong, nonatomic) IBOutlet UITextField *cityTxt;
@property (strong, nonatomic) IBOutlet UITextField *stateTxt;
@property (strong, nonatomic) IBOutlet UITextField *addressZipTxt;
@property (strong, nonatomic) IBOutlet UILabel *headerView;
@property (strong, nonatomic) IBOutlet UILabel *loginAsLbl;
@property (strong, nonatomic) IBOutlet UILabel *userInfoBackView;
@property (strong, nonatomic) IBOutlet UILabel *addressBackView;
@property (strong, nonatomic) IBOutlet UILabel *userAccountHeader;
@property (strong, nonatomic) IBOutlet UIButton *editPhotoBtn;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property (strong, nonatomic) IBOutlet UIImageView *disablImg;
@property (strong, nonatomic) IBOutlet UIButton *handicapedYesBtn;
@property (strong, nonatomic) IBOutlet UIButton *handicapedNoBtn;
@property (strong, nonatomic) IBOutlet UITableView *countryListTable;

- (IBAction)SelectCountry:(id)sender;
- (IBAction)editBtn:(id)sender;
- (IBAction)editDoneBtn:(id)sender;
- (IBAction)selectImageBtn:(id)sender;
- (IBAction)backBtn:(id)sender;
- (IBAction)aniamlNoBtn:(id)sender;
- (IBAction)handicapedYes:(id)sender;
- (IBAction)handycapedNoBtn:(id)sender;
- (IBAction)animalYesBtn:(id)sender;


@end
