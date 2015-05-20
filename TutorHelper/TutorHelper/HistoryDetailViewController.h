//
//  HistoryDetailViewController.h
//  TutorHelper
//
//  Created by Br@R on 30/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryList.h"

@interface HistoryDetailViewController : UIViewController
{
    HistoryList*historyListObj;
    
    NSMutableArray*historyListArray;
    IBOutlet UIButton *byMonthSortBtn;

    IBOutlet UIButton *byParentSortBtn;
    IBOutlet UILabel *feesCollectedLbl;
    IBOutlet UILabel *feesDueLbl;
    IBOutlet UILabel *totalOutstndngBalancLbl;
    IBOutlet UITableView *historyTableView;
    NSString*sortByStr;
    
}
- (IBAction)backBtn:(id)sender;
- (IBAction)byMonthSortBtn:(id)sender;
- (IBAction)byParentSortBtn:(id)sender;

- (IBAction)addCreditBtn:(id)sender;
- (IBAction)statementBtn:(id)sender;
- (IBAction)invoiceBtn:(id)sender;
- (IBAction)paymentBtn:(id)sender;
@end
