//
//  manageRestaurantViewController.h
//  uco
//
//  Created by Br@R on 18/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSideBarView.h"
#import "UpparBarView.h"
#import "Restaurant.h"


@interface manageRestaurantViewController : UIViewController
{
    LeftSideBarView *Leftsideview;
    UpparBarView*upparView;
    IBOutlet UITableView *restaurantListtableView;
    NSMutableArray*restaurantListArray;
    Restaurant*restaurantListObj;
    IBOutlet UILabel *manageRestaurantLbl;
    IBOutlet UILabel *addressHeaderTitle;
    IBOutlet UILabel *nameheaderTitle;
}


@end
