//
//  calendarViewController.h
//  uco
//
//  Created by Krishna_Mac_1 on 3/27/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSideBarView.h"
#import "UpparBarView.h"
#import "calenderRestaurantObj.h"
#import "menuSlotsObj.h"
#import "floorObj.h"
#import "NIDropDown.h"
#import "DDCalendarView.h"
@interface calendarViewController : UIViewController<NIDropDownDelegate,DDCalendarViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    LeftSideBarView *Leftsideview;
    UpparBarView*upparView;
     IBOutlet UILabel *calenderViewLbl;
    IBOutlet UILabel *calenderDateLbl;
    IBOutlet UILabel *todayLbl;
    IBOutlet UILabel *tomorrowLbl;
    IBOutlet UILabel *saturdayLbl;
    IBOutlet UILabel *sundayLbl;
    NSMutableArray *tableBookingList, *bookingStartTimeList, * bookingEndTimeList,*calendarRestaurantList, *calenderMenuSlots,* calenderFloorList, *menuSlotListArray, *floorListArray,*restaurantListArray;
    NSString *startTimeStr;
    NSString *endTimeString;
    NSMutableData *webData;
    calenderRestaurantObj *calenderRestaurantOC;
    IBOutlet UITableView *calenderTableView;
    BOOL isCalenderRestaurantList, isExpanded;
    int webserviceCode;
    menuSlotsObj *menuSlotsOC;
    floorObj *floorOC;
    NIDropDown *dropDown;
    DDCalendarView *calendarView;
    UIActivityIndicatorView *activityIndicator;
    NSIndexPath *calenderSelectionIndexPath;
    UITableView *floorDropDown, *menuSlotsDropDown, *restaurantListDropDown;
    IBOutlet UIView *selectionView;
    IBOutlet UILabel *selectionNameLbl;
    NSIndexPath *newFloorIndexPath, *newMenuSlotIndexPath;
     NSInteger expandedRowIndex;
    UIButton *restaurantNameBtn,*calenderDateBtn,*floorBtn,*menuSlotBtn;
    IBOutlet UIScrollView *calenderScrollView;
}
@end
