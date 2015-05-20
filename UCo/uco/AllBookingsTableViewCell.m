//
//  AllBookingsTableViewCell.m
//  uco
//
//  Created by Br@R on 19/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "AllBookingsTableViewCell.h"

@implementation AllBookingsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)dateStr :(NSString*)timeStr :(NSString*)customerNameStr :(NSString*)partySizeStr :(NSString*)tableNumStr{
    dateLbl.text=[NSString stringWithFormat:@"%@",dateStr];
    timeLbl.text=[NSString stringWithFormat:@"%@",timeStr];
    customerNameLbl.text=[NSString stringWithFormat:@"%@",customerNameStr];
    partySizeLbl.text=[NSString stringWithFormat:@"%@",partySizeStr];
    tableNumLbl.text=[NSString stringWithFormat:@"%@",tableNumStr];
    dateLbl.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    timeLbl.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    customerNameLbl.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    partySizeLbl.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    tableNumLbl.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
}
@end
