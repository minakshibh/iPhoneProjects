//
//  PaymentViewController.h
//  RapidRide
//
//  Created by Br@R on 17/10/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOS7AlertView.h"


@interface PaymentViewController : UIViewController<UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,CustomIOS7AlertViewDelegate>
{
    CustomIOS7AlertView *alertViewCustom ;
    NSMutableData *webData;
    UIPickerView*myPickerView;
    NSMutableArray *monthsArray ,*yearsArray ,*promocodeArray,*creditCardsNumArray ,*promocodeValueArray;
    NSString *monthStr, *yearString ,*yearStr,*monthYearStr,*userIdStr,*meassageString,*uCreditCardNumStr ;
    NSDateComponents *currentDateComponents;
    NSMutableDictionary *dataDict;
    NSMutableDictionary *promocodeDict,*creditCardsDict;
    int webService;
    int paymentResult;
    UIImageView*DriverImgView;
    UILabel *meassageLbl;
}
@property (weak, nonatomic)  IBOutlet UIButton *paymentBtn;
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;
@property (strong, nonatomic) IBOutlet UILabel *headerView;
@property (strong, nonatomic) IBOutlet UILabel *paymentHeadrLbl;
@property (strong, nonatomic) IBOutlet UILabel *creditHeadrLbl;
@property (strong, nonatomic) IBOutlet UILabel *promocodeHeadrLbl;
@property (strong, nonatomic) IBOutlet UILabel *headerLbl;
@property (strong, nonatomic) IBOutlet UILabel *promocodeListHeaderLbl;
@property (strong, nonatomic) IBOutlet UILabel *creditBackView;
@property (strong, nonatomic) IBOutlet UILabel *promocodeBackView;
@property (strong, nonatomic) IBOutlet UILabel *creditLBL;
@property (strong, nonatomic) IBOutlet UITextField *creditCardNumbrTxt;
@property (strong, nonatomic) IBOutlet UITextField *cExpDateTxt;
@property (strong, nonatomic) IBOutlet UITextField *cZipCodeTxt;
@property (strong, nonatomic) IBOutlet UITextField *creditSecurityTxt;
@property (strong, nonatomic) IBOutlet UITextField *promocodeTxt;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *applyPromocodeBtn;
@property (strong, nonatomic) IBOutlet UIButton *addCreditCardBtn;
@property (strong, nonatomic) IBOutlet UIButton *creditOnfoAddedBtn;
@property (strong, nonatomic) IBOutlet UIButton *creditCancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *PaYnowBtn;
@property (strong, nonatomic) IBOutlet UIButton *refreshbtn;
@property (strong, nonatomic) IBOutlet UIView *addCreditInfoView;
@property (strong, nonatomic) IBOutlet UIView *viewPickr;
@property (strong, nonatomic) IBOutlet UIView *selectCardBackView;
@property (strong, nonatomic) IBOutlet UIImageView *disableImg;
@property (strong, nonatomic) IBOutlet UIImageView *cardImage;
@property (strong, nonatomic) IBOutlet UITableView *promocodeTableView;
@property (strong, nonatomic) IBOutlet UITableView *creditCardTableview;
@property (strong, nonatomic) IBOutlet UITableView *selectCardTableView;
@property (strong, nonatomic) NSString *tripid,*rec_id,*tip_amount,*suggested_fare;


- (IBAction)PayNowBtn:(id)sender;
- (IBAction)refreshBtn:(id)sender;
- (IBAction)addCreditCardBtn:(id)sender;
- (IBAction)backBtn:(id)sender;
- (IBAction)applyBtn:(id)sender;
- (IBAction)expDoneBtn:(id)sender;
- (IBAction)expCancelBtn:(id)sender;
- (IBAction)cExpDateBtn:(id)sender;
- (IBAction)CreditInfoAddedBtn:(id)sender;
- (IBAction)creditCancelBtn:(id)sender;
- (IBAction)paymentBtn:(id)sender;




@end
