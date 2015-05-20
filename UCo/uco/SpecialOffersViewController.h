//
//  SpecialOffersViewController.h
//  uco
//
//  Created by Br@R on 23/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
#import "UpparBarView.h"
@interface SpecialOffersViewController : UIViewController
{
    
    IBOutlet UITableView *specialOffersTableView;
    IBOutlet UIButton *specialOffersBtn;
    IBOutlet UIButton *addOffersBtn;
    NSMutableArray *specialOffersArray;
    Restaurant*restaurantListObj;
    UpparBarView*upparView;

    IBOutlet UITextField *offerTitleTxt;
    IBOutlet UILabel *descriptionLbl;
    IBOutlet UITextField *priceTxt;
    IBOutlet UILabel *termsLbl;
    IBOutlet UILabel *startDateLbl;
    IBOutlet UILabel *startDate;
    IBOutlet UILabel *endDateLbl;
    IBOutlet UILabel *endDate;
    IBOutlet UILabel *feturedLbl;
    IBOutlet UIButton *createOfferBtn;
    IBOutlet UIView *addOfferView;
    IBOutlet UITextView *descriptiontxtView;
    IBOutlet UITextView *termsAndConditionTxtView;
}
- (IBAction)addOffers:(id)sender;
- (IBAction)specialOffersBtn:(id)sender;
@end
