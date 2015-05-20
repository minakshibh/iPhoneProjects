//
//  venuOpeningTimingTableViewCell.m
//  uco
//
//  Created by Krishna_Mac_1 on 4/13/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "venuOpeningTimingTableViewCell.h"

@implementation venuOpeningTimingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)name{
    daysNameLbl.text = [NSString stringWithFormat:@"%@",name];
}
@end
