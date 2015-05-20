//
//  venueViewController.h
//  uco
//
//  Created by Krishna_Mac_1 on 4/13/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpparBarView.h"
#import "NIDropDown.h"
@interface venueViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,NIDropDownDelegate>
{
    UpparBarView*upparView;
    IBOutlet UIButton *tableViewTabBtn;
    IBOutlet UIButton *openingTimingTabBtn;
    IBOutlet UIButton *editVenueTabBtn;
    IBOutlet UITableView *daysTimingTableView;
    IBOutlet UITableView *mealTimingsTableView;
    IBOutlet UIView *editVenueView;
    IBOutlet UIView *openingTimingView;
    UITableView *hoursTableDropDown;
    NSMutableArray *daysNameArray, *mealTimingArray,*tempArray,*hoursArray,*minsArray,*dayTypeArray;
    NIDropDown *dropDown;
 
  
}
- (IBAction)editVenueButtonAction:(id)sender;
- (IBAction)openingTimmingBtnAction:(id)sender;
- (IBAction)tableViewBtnAction:(id)sender;
- (IBAction)hoursFromBtnAction:(id)sender;
- (IBAction)minsFromBtnAction:(id)sender;
- (IBAction)dayTypeFromBtnAction:(id)sender;
- (IBAction)dayTypeToBtnAction:(id)sender;
- (IBAction)minsToBtnAction:(id)sender;
- (IBAction)hoursToBtnAction:(id)sender;




@end
