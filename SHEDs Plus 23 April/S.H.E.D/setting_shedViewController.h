//
//  setting_shedViewController.h
//  S.H.E.D
//
//  Created by Krishna_Mac on 1/14/14.
//  Copyright (c) 2014 Krishna_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/SKStoreProductViewController.h>
#import "AppDelegate.h"
@interface setting_shedViewController : UIViewController<SKStoreProductViewControllerDelegate,UIActionSheetDelegate>
{
    UIAlertController *alertController;
}
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) IBOutlet UILabel *headertitle;
@property (strong, nonatomic) IBOutlet UIButton *aboutusbtn;
@property (strong, nonatomic) IBOutlet UIButton *passcodebtn;
@property (strong, nonatomic) IBOutlet UIButton *ratebtn;
@property (strong, nonatomic) IBOutlet UIButton *gratitudeSettings;
@property (strong, nonatomic) IBOutlet UISwitch *popUpToggle;
@property (strong, nonatomic) IBOutlet UIButton *enablePopupBtn;
@property (strong, nonatomic) IBOutlet UISwitch *gratToggle;
@property (nonatomic, assign) int gratPopUp;
@property (strong, nonatomic) IBOutlet UIDatePicker *pickdate;
@property (strong, nonatomic) UIActionSheet *actionsheet;
@property (strong, nonatomic) IBOutlet UILabel *gratNotifyTime;
@property (strong, nonatomic) IBOutlet UILabel *gratNotifyTitle;
@property (strong, nonatomic) IBOutlet UIView *pickrViewIpad;
@property (strong, nonatomic) IBOutlet UIButton *gratNotifyBtn;
@property (strong, nonatomic) IBOutlet UIButton *dailyGratReminderTitle;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerIpad;
@property (assign) BOOL is24h;
@property (strong, nonatomic) IBOutlet UIView *gratClickView;
@property (strong, nonatomic) IBOutlet UIImageView *downArrow;
@property (strong, nonatomic) IBOutlet UIImageView *sideArrow;
@property (strong, nonatomic) NSString *saveTimeStr;
- (IBAction)PostToFacebook:(id)sender;
- (IBAction)gratitudeToggle:(id)sender;
- (IBAction)gratitudeReminder:(id)sender;
- (IBAction)resignBtn:(id)sender;

- (IBAction)popUpToggle:(id)sender;
- (IBAction)gratitudeNotify:(id)sender;


- (IBAction)aboutusbtn:(id)sender;
- (IBAction)moveback:(id)sender;
- (IBAction)ratingbtn:(id)sender;
- (IBAction)passcodeBtn:(id)sender;
- (IBAction)GratitudeSettng:(id)sender;

@end
