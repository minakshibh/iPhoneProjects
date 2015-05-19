//
//  habitstatisticsViewController.h
//  S.H.E.D
//
//  Created by Krishna_Mac on 11/28/13.
//  Copyright (c) 2013 Krishna_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHED.h"
#import "sqlite3.h"
#import "AppDelegate.h"
#import "TKCalendarMonthView.h"
#import "shed_data.h"

@interface habitstatisticsViewController : UIViewController<UIGestureRecognizerDelegate,TKCalendarMonthViewDataSource,TKCalendarMonthViewDelegate,UIAlertViewDelegate>
{
    TKCalendarMonthView *calendar;
    UILabel *toolTipLabel;
    sqlite3 *contactDB;
    NSArray *docPaths;
    NSString *documentsDir;
    NSString *dbPath;
    FMDatabase *database;
    
}
@property (nonatomic, retain) TKCalendarMonthView *calendar;
@property (strong, nonatomic) SHED *shed;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) shed_data *shed_Data;
@property (strong, nonatomic) IBOutlet UIImageView *appliedDaysbackView;
@property (strong, nonatomic) IBOutlet UILabel *titlelbl;
@property (strong, nonatomic) IBOutlet UILabel *datelbl;
@property (strong, nonatomic) IBOutlet UILabel *longrunlbl;
@property (strong, nonatomic) IBOutlet UILabel *currentrunlbl;
@property (strong, nonatomic) IBOutlet UILabel *habitpercentdays;
@property (strong, nonatomic) IBOutlet UILabel *habitstotaldays;
@property (strong, nonatomic) IBOutlet UIButton *masteredbtn;
@property (strong, nonatomic) IBOutlet UIButton *editshedbtn;
@property (strong, nonatomic) IBOutlet UIButton *deleteshedbtn;
@property (strong, nonatomic) IBOutlet UIButton *daysappliedbtn;
@property (strong, nonatomic) IBOutlet UILabel *startdatenamelbl;
@property (strong, nonatomic) IBOutlet UILabel *daysappliednamelbl;
@property (strong, nonatomic) IBOutlet UILabel *totaldaysnamelbl;
@property (strong, nonatomic) IBOutlet UILabel *percentdaysnamelbl;
@property (strong, nonatomic) IBOutlet UILabel *currentrunnamelbl;
@property (strong, nonatomic) IBOutlet UILabel *longestrunnamelbl;
@property (strong, nonatomic) IBOutlet UIButton *backbtn;
@property (strong, nonatomic) IBOutlet UIView *habit_view;
@property (strong, nonatomic) IBOutlet NSString *date1;
@property (strong, nonatomic) NSMutableArray *data1;
@property (strong, nonatomic) NSMutableArray *data3;
@property (strong, nonatomic) NSMutableArray *marks;
@property (strong, nonatomic) NSMutableArray *habitstatslist;
@property (strong, nonatomic) NSMutableArray* rowData;
@property (strong, nonatomic) NSMutableArray *indexList;
@property (strong, nonatomic) NSDateComponents *comp;
@property (strong, nonatomic) NSString *tabstring;
@property (strong, nonatomic) NSString *databasePath;
@property (strong, nonatomic) NSString *masteredstr;
@property (assign, nonatomic) int totaldaysSelected;
@property ( assign) int flag;

- (int) getindex:(NSString*) mystring;
- (IBAction)backbtn:(id)sender;
- (IBAction)deleteshed:(id)sender;
- (IBAction)editshed:(id)sender;
- (IBAction)daysapplied:(id)sender;
- (IBAction)masteredshed:(id)sender;


@end
