//
//  RegistrationRiderViewController.h
//  RapidRide
//
//  Created by Br@R on 14/10/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RegistrationRiderViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate>
{
    NSMutableData *webData;
    int webservice;
    NSString*riderIdString;
    NSString *phoneCode;

}
@property (strong, nonatomic) NSString* uEmailAdressStr,* uPasswordStr;

@property (strong, nonatomic) IBOutlet UILabel *backView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *uContactNoTxt;
@property (strong, nonatomic) IBOutlet UILabel *regHeaderLbl;
@property (strong, nonatomic) IBOutlet UITextField *uFirstNameTxt;
@property (strong, nonatomic) IBOutlet UITextField *uEmailAddressTxt;
@property (strong, nonatomic) IBOutlet UITextField *uPasswordTxt;
@property (strong, nonatomic) IBOutlet UITextField *uLastNameTxt;
@property (strong, nonatomic) IBOutlet UITextField *uConfirmPasswrdTxt;
@property (strong, nonatomic) IBOutlet UIButton *registerBtn;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *loginLbl;
@property (strong, nonatomic) IBOutlet UIButton *loginHereBtn;
@property (strong, nonatomic) IBOutlet UIImageView *disableImg;
@property (strong, nonatomic) IBOutlet UILabel *headerView;
@property (strong, nonatomic) IBOutlet UILabel *headerLbl;
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;

- (IBAction)loginHereBtn:(id)sender;
- (IBAction)backBtn:(id)sender;

- (IBAction)registeratioBtn:(id)sender;
- (IBAction)uploadImageBtn:(id)sender;
@end
