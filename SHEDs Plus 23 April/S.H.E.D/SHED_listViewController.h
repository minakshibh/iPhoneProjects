//
//  SHED_listViewController.h
//  S.H.E.D
//
//  Created by Krishna_Mac on 12/3/13.
//  Copyright (c) 2013 Krishna_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "SHED.h"
#import "habitstatisticsViewController.h"
#import "Gratitude.h"
#import "AppDelegate.h"
#import<FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import "CustomIOS7AlertView.h"
#import <CFNetwork/CFNetwork.h>
#import <MessageUI/MessageUI.h>
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>
#import <StoreKit/SKStoreProductViewController.h>


@interface SHED_listViewController : UIViewController <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,CustomIOS7AlertViewDelegate,SKPSMTPMessageDelegate,FBFriendPickerDelegate,FBLoginViewDelegate,SKStoreProductViewControllerDelegate>
{
    sqlite3 *contactDB;
    UIImageView *disableImg;
    NSString *issueStr;
    UIView* myView;
    UITextView*txtView;
    UIImageView *dot;

    
}
@property (strong, nonatomic) SHED *shed;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) habitstatisticsViewController *habit;
@property (strong, nonatomic) Gratitude *gratitudeoc;
@property (strong, nonatomic) IBOutlet UILabel *titlelbl;
@property (strong, nonatomic) IBOutlet UIView *header;
@property (strong, nonatomic) IBOutlet UIView *sub_header;
@property (strong, nonatomic) IBOutlet UIView *footer;
@property (strong, nonatomic) IBOutlet UIView *shed_view;
@property (strong, nonatomic) IBOutlet UITableView *list_table;
@property (strong, nonatomic) IBOutlet UIButton *postbtn;
@property (strong, nonatomic) IBOutlet UIButton *fbInvitebtn;

@property (strong, nonatomic) IBOutlet UILabel *gratTitle;
@property (strong, nonatomic) IBOutlet UILabel *backlbl;
@property (strong, nonatomic) IBOutlet UIButton *alphabatical;
@property (strong, nonatomic) IBOutlet UIButton *coronological;
@property (strong, nonatomic) NSMutableArray *shed_list;
@property (strong, nonatomic) NSMutableArray *habitstats_list;
@property (strong, nonatomic) NSMutableArray *indexList;
@property (strong, nonatomic) NSMutableArray *data3;
@property (strong, nonatomic) NSMutableArray *followeddate;
@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccount *fbAccount;
@property (strong, nonatomic) UILabel *IDlbl;
@property (strong, nonatomic) UIButton *tickbtn;
@property (strong, nonatomic) UIButton *crossbtn;
@property (strong, nonatomic) NSString *databasePath;
@property (strong, nonatomic) UITextView *gratitudetxt;
@property (strong, nonatomic) UITextView *gratitudelbl;
@property (strong, nonatomic) NSString *queryString;
@property (strong, nonatomic) NSArray *shedlist;
@property (strong, nonatomic) NSString *sortingString;
@property (strong, nonatomic) NSMutableArray *date_array;
@property (strong, nonatomic) NSUserDefaults *value;
@property (strong, nonatomic) NSString *str ,*gratType ,*shedIdStrForFetch;
@property (strong, nonatomic) UILabel *shedname;
@property (assign, nonatomic) int totaldaysSelected;
@property (strong, nonatomic) IBOutlet UIButton *lifeTab;
@property (strong, nonatomic) IBOutlet UIButton *workTab;
@property (strong, nonatomic) NSString *shedType;
@property (assign, nonatomic) int size;
@property (assign) int addFlag;
@property (assign) int typeFlag;
@property (assign) int flag;
@property (assign) int countFlag;
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;
@property (strong, nonatomic) IBOutlet UIView *issueView;
@property (assign) int alertTxt;
@property (assign) int fbTxt;

@property (assign) BOOL issecondTym, isGratitudeAdded;

@property (strong, nonatomic) IBOutlet UIButton *backBtnOutlt;
-(void) disabled;
-(void) enabled;
- (IBAction)alphabatical:(id)sender;
- (IBAction)posttoFacebook:(id)sender;
- (IBAction)coronological:(id)sender;
//- (IBAction)dissmisKeyboard:(id)sender;
- (IBAction)postgratitude:(id)sender;
- (IBAction)header_back:(id)sender;
- (IBAction)workTab:(id)sender;
- (IBAction)lifeTab:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *fbButton;

@end
