//
//  PaymentViewController.h
//  uco
//
//  Created by Br@R on 18/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSideBarView.h"
#import "UpparBarView.h"
#import "Payment.h"


@interface PaymentViewController : UIViewController
{
    Payment*paymentListObj;
    NSMutableArray*paymentListArray;
    
    IBOutlet UILabel *dueDateLabl;
    IBOutlet UILabel *amountLabl;
    IBOutlet UILabel *idLabl;
    IBOutlet UILabel *dateLabl;
    LeftSideBarView *Leftsideview;
    UpparBarView*upparView;
    IBOutlet UITableView *paymenyTableView;
}
@end
