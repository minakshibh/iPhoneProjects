//
//  DashboardViewController.h
//  uco
//
//  Created by Br@R on 17/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSideBarView.h"
#import "UpparBarView.h"
#import "bookingObj.h"
@interface DashboardViewController : UIViewController
{
    bookingObj *bookingOC;
    LeftSideBarView *Leftsideview;
    UpparBarView*upparView;
    NSMutableData *webData;
    IBOutlet UIImageView *userImageView;
    IBOutlet UILabel *userNameLbl;
    IBOutlet UILabel *userEmailLbl;
    IBOutlet UILabel *userContactlbl;
    IBOutlet UIButton *pastBookingbtn;
    IBOutlet UIButton *futureBookingBtn;
    IBOutlet UIButton *specialOffrsbtn;
    IBOutlet UIButton *reviewsBtn;
    IBOutlet UIButton *commentsBtn;
    IBOutlet UITableView *bookingTableView;
    NSMutableArray *bookingArray;
    UIActivityIndicatorView *activityIndicator;
}
- (IBAction)futureBooking:(id)sender;
- (IBAction)pastBooking:(id)sender;
- (IBAction)specialOffers:(id)sender;
- (IBAction)manageVenue:(id)sender;
- (IBAction)comments:(id)sender;

@end
