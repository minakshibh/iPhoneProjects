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

@interface SHED_listViewController : UIViewController <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    sqlite3 *contactDB;
    
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
@property (strong, nonatomic) IBOutlet UILabel *gratTitle;
@property (strong, nonatomic) IBOutlet UILabel *backlbl;
@property (strong, nonatomic) IBOutlet UIButton *alphabetical;
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
@property (strong, nonatomic) NSString *str;
@property (strong, nonatomic) UILabel *shedname;
@property (assign, nonatomic) int totaldaysSelected;
@property (assign, nonatomic) int size;
@property (assign) int flag;

- (IBAction)alphabetical:(id)sender;
- (IBAction)posttoFacebook:(id)sender;
- (IBAction)coronological:(id)sender;
- (IBAction)dissmisKeyboard:(id)sender;
- (IBAction)postgratitude:(id)sender;
- (IBAction)header_back:(id)sender;

@end
