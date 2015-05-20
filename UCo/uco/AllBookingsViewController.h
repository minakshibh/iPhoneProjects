//
//  AllBookingsViewController.h
//  uco
//
//  Created by Br@R on 18/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSideBarView.h"
#import "UpparBarView.h"
#import "AllBookings.h"


@interface AllBookingsViewController : UIViewController
{
    NSMutableData *webData;
    LeftSideBarView *Leftsideview;
    UpparBarView*upparView;
    IBOutlet UITableView *allBookingTableView;
    NSMutableArray*bookingsListArray;
    AllBookings*allBookingsListObj;
    IBOutlet UILabel *bookingTitle;
    IBOutlet UILabel *dateHeaderLbl;
    IBOutlet UILabel *timeHeaderLbl;
    IBOutlet UILabel *customerNameHeaderLbl;
    IBOutlet UILabel *partySizeHeaderLbl;
    IBOutlet UILabel *tableNumberHeaderLbl;
    IBOutlet UIButton *allBookingsBtn;
    IBOutlet UIButton *pastBookings;
    IBOutlet UIButton *futureBookingsBtn;
    NSString *bookingType;
    bool isAllBooking, isPastBooking, isFutureBooking;
    UIActivityIndicatorView *activityIndicator;
}

- (IBAction)allBookingBtnAction:(id)sender;
- (IBAction)pastBookingBtnAction:(id)sender;
- (IBAction)futureBookingBtnAction:(id)sender;

@end
