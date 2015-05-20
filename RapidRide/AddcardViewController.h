//
//  AddcardViewController.h
//  RapidRide
//
//  Created by Br@R on 19/12/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddcardViewController : UIViewController
{
    NSMutableArray *monthsArray ,*yearsArray ;
    NSString *monthStr, *yearString ,*yearStr,*monthYearStr,*uCreditCardNumStr ;
    NSDateComponents *currentDateComponents;    
    UIPickerView*myPickerView;
    NSString *jsonRequest;
    NSMutableData *webData;
    NSDictionary *jsonDict;
    int webservice;
    
}
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;
@property (strong, nonatomic) IBOutlet UIImageView *disablImg;
@property (strong, nonatomic) IBOutlet UILabel *headerLbl;
@property (strong, nonatomic) IBOutlet UILabel *headerView;
@property (strong, nonatomic) IBOutlet UIView *viewPickr;
@property (strong, nonatomic) IBOutlet UITextField *creditCardNumbrTxt;
@property (strong, nonatomic) IBOutlet UITextField *cExpDateTxt;
@property (strong, nonatomic) IBOutlet UITextField *cZipCodeTxt;
@property (strong, nonatomic) IBOutlet UITextField *creditSecurityTxt;
@property (strong, nonatomic) IBOutlet UILabel *creditBackView;
@property (strong, nonatomic) IBOutlet UIButton *creditOnfoAddedBtn;
@property (strong, nonatomic) IBOutlet UIButton *creditCancelBtn;


- (IBAction)cExpDateBtn:(id)sender;
- (IBAction)CreditInfoAddedBtn:(id)sender;
- (IBAction)creditCancelBtn:(id)sender;
- (IBAction)expDoneBtn:(id)sender;
- (IBAction)expCancelBtn:(id)sender;


@end
