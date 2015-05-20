//
//  AddBookingViewController.h
//  uco
//
//  Created by Br@R on 19/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSideBarView.h"
#import "UpparBarView.h"
#import "sessionObj.h"
#import "DDCalendarView.h"
#import "floorObj.h"
#import "categoryObj.h"
#import "tableObj.h"
#import "NIDropDown.h"
#import "manageVenueObj.h"
@interface AddBookingViewController : UIViewController<DDCalendarViewDelegate,NIDropDownDelegate>
{
    DDCalendarView *calendarView;
    NSMutableData *webData;
    NSArray*mrOrMissArray;
    NSMutableArray *tablesSelectdArray,*partySizeArray,*insideZoneArray,*sessionArray,*sourceOfBookingArray,*timeArray,*bookingTimeArray,*floorArray,*categoryArray, *selectedCategoryArray, *selectedTableArray,*restaurantNameListArray;
    LeftSideBarView *Leftsideview;
    UpparBarView*upparView;
    UIActivityIndicatorView *activityIndicator;
    NSString *startTimeStr, *endTimeStr, *slotValue;
    int webserviceCode;
    IBOutlet UITextView *guestNotesTxt;
    IBOutlet UITextField *firstNameTxt;
    IBOutlet UITextField *emailAddressTxt;
    IBOutlet UITextField *phoneNumbrTxt;
    IBOutlet UITextField *lastNameTxt;
    IBOutlet UILabel *dateSelectedLbl;
    IBOutlet UIButton *partySizeBtn;
    IBOutlet UIButton *tableSelectedBtn;
    IBOutlet UIButton *insideZoneSelectdBtn;
    IBOutlet UIButton *timeSelectedBtn;
    IBOutlet UIButton *walkInSelectedBtn;
    IBOutlet UIButton *mrMissSelectdBtn;
    sessionObj *sessionOC;
    floorObj *floorOC;
    categoryObj *categoryOC;
    tableObj *tableOC;
    IBOutlet UIButton *editBookingBtn;
    IBOutlet UIButton *addBookingInnrBtn;
    IBOutlet UIButton *createBookingBtn;
    IBOutlet UITableView *sessionTableView;
    IBOutlet UIButton *sessionBtnTitle;
    IBOutlet UIScrollView *horizontalScroller;
    IBOutlet UIScrollView *tableHorizontalScroller;
    IBOutlet UIButton *showCalendarBtn;
    IBOutlet UIButton *selectFloorBtn;
    IBOutlet UITableView *bookingTimeTableView;
    IBOutlet UITableView *sourceOfBookingTableView;
    IBOutlet UIButton *todaySelectdBtn;
    IBOutlet UITableView *partySizeTableView;
    IBOutlet UITableView *tableSelectdTableView;
    IBOutlet UITableView *insideZoneTableView;
    IBOutlet UITableView *MrMissTableView;
    IBOutlet UILabel *titleLbl;
    IBOutlet UILabel *walkinLbl;
    IBOutlet UILabel *timeLbl;
    IBOutlet UILabel *insideZoneLbl;
    IBOutlet UILabel *tableLbl;
    IBOutlet UILabel *partySizeLbl;
    IBOutlet UILabel *dateLbl;
    IBOutlet UIButton *sourceOfBookingBtnTitle;
    IBOutlet UITableView *floorSelectTableView;
    IBOutlet UIButton *saveTypeBtn;
     NIDropDown *dropDown;
    manageVenueObj *manageVenueOC;
    IBOutlet UIButton *selectRestaurantBtn;
}
- (IBAction)sourceOfBookingBtnAction:(id)sender;
- (IBAction)addBookingBtn:(id)sender;
- (IBAction)editBookingBtn:(id)sender;
- (IBAction)walkInBtn:(id)sender;
- (IBAction)MrOrMissSelectionBtn:(id)sender;
- (IBAction)DateSelectionBtn:(id)sender;
- (IBAction)partySizeSelectionBtn:(id)sender;
- (IBAction)tableSelectionBtn:(id)sender;
- (IBAction)createBookingActionBtn:(id)sender;
- (IBAction)todaySelectionBtn:(id)sender;
- (IBAction)timeSelectedBtn:(id)sender;
- (IBAction)sessionBtnAction:(id)sender;
- (IBAction)floorSeletionBtn:(id)sender;
- (IBAction)saveBtnAction:(id)sender;
- (IBAction)hideTapGesture:(id)sender;
- (IBAction)hideAllTablesAction:(id)sender;
- (IBAction)selectRestaurantBtnAction:(id)sender;


@end
