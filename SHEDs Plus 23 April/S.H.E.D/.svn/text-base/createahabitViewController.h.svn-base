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


@interface createahabitViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPopoverControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    sqlite3 *contactDB;
    UIButton *habitname;


}
@property ( assign) int flag;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) IBOutlet UILabel *titlelbl;
@property (strong, nonatomic) IBOutlet UIView *header;
@property (strong, nonatomic) IBOutlet UIView *sub_header;
@property (strong, nonatomic) IBOutlet UIView *footer;
@property (strong, nonatomic) IBOutlet UITableView *habitstableview;
@property (strong, nonatomic) IBOutlet UISwitch *toggleswitch;
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
@property (nonatomic, strong) NSMutableArray *alarmstatusarray;
@property (strong, nonatomic) UILabel *timelbl;
@property (strong, nonatomic) UILabel *timetitlelbl;
@property (strong, nonatomic) UIButton *habitname;
@property (strong, nonatomic) UITextField *dscptxt;
@property (nonatomic, retain) NSIndexPath* checkedIndexPath;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) NSDateFormatter *df;
@property (nonatomic, strong) NSString *isMasteredstr;
@property (nonatomic, strong) UIActionSheet *actionsheet;
@property (nonatomic, strong) NSMutableSet *model ;
@property (nonatomic, strong) NSString *daysString;
@property (nonatomic, strong) UIImageView *checkmark;
@property (nonatomic, strong) NSString *habitnamestr;
@property (nonatomic, strong) NSString *insertSQL, *tempStr;
@property (nonatomic, strong) NSString *alarmdaysstr;
@property (nonatomic, strong) SHED *shedobj;
@property (nonatomic, strong) NSString * result;
@property (nonatomic, strong) NSString *str;
@property (nonatomic, strong) SHED_listViewController *SHEDlist;
@property (assign) BOOL datePickerIsShowing;

- (IBAction)header_back:(id)sender;
- (IBAction)savedata:(id)sender;
- (IBAction)addthetext:(id)sender;
- (IBAction)resignBtn:(id)sender;
@end
