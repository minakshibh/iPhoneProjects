//
//  feedbakTableViewCell.m
//  uco
//
//  Created by Krishna_Mac_1 on 4/2/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "feedbakTableViewCell.h"

@implementation feedbakTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setLabelText:(NSString*)date :(NSString*)customerName :(NSString*)comment
{
    self.dateStr.text = [NSString stringWithFormat:@"%@",date];
    self.customerNameStr.text = [NSString stringWithFormat:@"%@",customerName];
    self.commentStr.text = [NSString stringWithFormat:@"%@",comment];
    self.dateStr.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    self.customerNameStr.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    self.commentStr.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
