//
//  createahabitViewController.h
//  S.H.E.D
//
//  Created by Krishna_Mac on 11/21/13.
//  Copyright (c) 2013 Krishna_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "SHED_listViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SHED.h"
#import "AppDelegate.h"


@interface createahabitViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPopoverControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UITextViewDelegate>
{
    sqlite3 *contactDB;
    UIButton *habitname;
    NSString* result1;
    NSString *rewardImageStr, *rewrardDetailStr,*rewardStreakStr;
    BOOL rewardStatus;
    BOOL isnumericKeyboard;
    NSDate *resultDate ;
    UIScrollView*scrollView;
   
    
}
@property (strong, nonatomic) IBOutlet UIButton *photoGalaryBtn;

- (IBAction)photoUpload:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *ScrollViewBg;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) IBOutlet UILabel *titlelbl;
@property (strong, nonatomic) IBOutlet UIView *header;
@property (strong, nonatomic) IBOutlet UIView *sub_header;
@property (strong, nonatomic) IBOutlet UIView *footer;
@property (strong, nonatomic) IBOutlet UITableView *habitstableview;
@property (strong, nonatomic) IBOutlet UISwitch *toggleswitch;
@property (strong, nonatomic) IBOutlet UISwitch *rewardTogleswitch;

@property (strong, nonatomic) IBOutlet UIDatePicker *pickdate;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UITableView *daystable;
@property (strong, nonatomic) IBOutlet UIButton *savebtn;
@property (strong, nonatomic) IBOutlet UIView *HabittextfeildView;
@property (strong, nonatomic) IBOutlet UITextView *habittextview;
@property (strong, nonatomic) IBOutlet UIButton *donebutton;
@property (strong, nonatomic) IBOutlet UIView *pickrViewIpad;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerIpad;
@property (strong, nonatomic) IBOutlet UILabel *pickrTittle;
@property (strong, nonatomic) NSString *databasePath;
@property (strong, nonatomic) NSMutableArray *celltitles;
@property (strong, nonatomic) NSMutableArray *daysarray;
@property (strong, nonatomic) NSMutableArray *alarmstatusarray;
@property (strong, nonatomic) UILabel *timelbl;
@property (strong, nonatomic) UILabel *timetitlelbl;
@property (strong, nonatomic) UILabel *alerttitlelbl;
@property (strong, nonatomic) UILabel *worktitlelbl;
@property (strong, nonatomic) UILabel *lifetitlelbl;
@property (strong, nonatomic) UIButton *workBtn;
@property (strong, nonatomic) UIButton *lifeBtn;
@property (strong, nonatomic) UIButton *habitname;
@property (strong, nonatomic) UITextField *dscptxt;
@property (retain, nonatomic) NSIndexPath* checkedIndexPath;
@property (strong, nonatomic) UIPopoverController *popoverController;

@property (strong, nonatomic) NSString *isMasteredstr;
@property (strong, nonatomic) UIActionSheet *actionsheet;
@property (strong, nonatomic) NSMutableSet *model ;
@property (strong, nonatomic) NSString *daysString,*shedNameStr;
@property (strong, nonatomic) UIImageView *checkmark;
@property (strong, nonatomic) NSString *habitnamestr;
@property (strong, nonatomic) NSString *insertSQL, *tempStr;
@property (strong, nonatomic) NSString *alarmdaysstr;
@property (strong, nonatomic) SHED *shedobj;
@property (strong, nonatomic) NSString * result;
@property (strong, nonatomic) NSString *str;
@property (strong, nonatomic) SHED_listViewController *SHEDlist;
@property (assign) BOOL isworkBtn;
@property (assign) BOOL isLifeBtn;
@property (assign) BOOL datePickerIsShowing;
@property (assign) BOOL is24h;
@property (assign) int flag;
@property (strong, nonatomic) NSString *saveTimeStr;
@property (strong, nonatomic) IBOutlet UIView *rewardsPopUpView;
@property (strong, nonatomic) IBOutlet UIButton *addRewardsDone;
@property (strong, nonatomic) IBOutlet UIImageView *rewardImgView;
@property (strong, nonatomic) IBOutlet UITextField *rewardStreakTxt;
@property (strong, nonatomic) IBOutlet UITextView *rewardDetailTxt;
@property (strong, nonatomic) IBOutlet UILabel *rewarddetailLbl;
- (IBAction)cancelBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UILabel *daysLbl;
- (IBAction)deleteImage:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIButton *removIcon;


@property (strong, nonatomic) NSMutableArray *imagearray;

- (IBAction)imageBtn:(id)sender;
- (IBAction)addRewardsBtn:(id)sender;
- (IBAction)header_back:(id)sender;
- (IBAction)savedata:(id)sender;
- (IBAction)addthetext:(id)sender;
- (IBAction)resignBtn:(id)sender;

- (IBAction)PostToFacebook:(id)sender;
-(void) scheduleNotificationForDate: (NSString*)days: (NSString*)myDate1: (NSString*)desc;
@end
