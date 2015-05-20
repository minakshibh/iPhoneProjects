//
//  MarketingViewController.h
//  uco
//
//  Created by Br@R on 18/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSideBarView.h"
#import "UpparBarView.h"
#import "MarketDetail.h"


@interface MarketingViewController : UIViewController
{
    
    LeftSideBarView *Leftsideview;
    UpparBarView*upparView;
    IBOutlet UITableView *listOfMembersTableView;
    NSMutableArray*membersListArray;
    MarketDetail*marketListObj;
    IBOutlet UIButton *sendNewsLetterOutlet;
    IBOutlet UIButton *mailchimpOutlet;
    IBOutlet UIButton *sendTextMessage;
    IBOutlet UILabel *titleLbl;
    IBOutlet UILabel *filterTitle;
    IBOutlet UITextField *firstNameTxt;
    IBOutlet UITextField *secontTxt;
    IBOutlet UITextField *thirdTxt;
    IBOutlet UIButton *contrySelectBtn;
    IBOutlet UILabel *recentBookingLbl;
    IBOutlet UIButton *filterResultBtn;
}
@end
