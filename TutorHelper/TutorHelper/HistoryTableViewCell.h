//
//  HistoryTableViewCell.h
//  TutorHelper
//
//  Created by Br@R on 30/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell
{
    IBOutlet UILabel *monthLbl;
    IBOutlet UILabel *lessonsLbl;
    IBOutlet UILabel *balanceLbl;
    IBOutlet UILabel *feesCollectedlbl;
    IBOutlet UILabel *feesDueLbl;
}
-(void)setLabelText:(NSString*)monthStr :(NSString*)lessons :(NSString*)balance :(NSString*)feesCollected :(NSString*)feesDue;

@end
