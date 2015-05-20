//
//  HistoryViewController.h
//  TutorHelper
//
//  Created by Br@R on 30/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryList.h"
@interface HistoryViewController : UIViewController
{
    
    IBOutlet UITextField *searchTxt;
    HistoryList*historyListObj;

    NSMutableArray*historyListArray;
}
- (IBAction)backBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *historyTableView;

@end
