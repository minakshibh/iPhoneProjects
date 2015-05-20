//
//  manageVenueViewController.h
//  uco
//
//  Created by Krishna_Mac_1 on 4/2/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpparBarView.h"
#import "manageVenueObj.h"
@interface manageVenueViewController : UIViewController
{
    NSMutableData *webData;
    manageVenueObj *manageVenueOC;
    UpparBarView*upparView;
    IBOutlet UITableView *manageVenueTableView;
    NSMutableArray *venueArray;
    UIActivityIndicatorView *activityIndicator;
    IBOutlet UIButton *updateVenue;
    IBOutlet UILabel *venueTypeLbl;
    IBOutlet UITextView *descriptionTextView;
    IBOutlet UIView *venueView;
    
}
@property (assign, nonatomic) int flag;
- (IBAction)updateVenueBtn:(id)sender;
@end
