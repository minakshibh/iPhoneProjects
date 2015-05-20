//
//  HistoryTableViewCell.m
//  TutorHelper
//
//  Created by Br@R on 30/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)monthStr :(NSString*)lessons :(NSString*)balance :(NSString*)feesCollected :(NSString*)feesDue
{
    monthLbl.text=monthStr;
    lessonsLbl.text=[NSString stringWithFormat:@": %@",lessons];
    balanceLbl.text=[NSString stringWithFormat:@": %@",balance];
    feesCollectedlbl.text=[NSString stringWithFormat:@": %@",feesCollected];
    feesDueLbl.text=[NSString stringWithFormat:@": %@",feesDue];
}
@end
