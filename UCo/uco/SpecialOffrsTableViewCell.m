//
//  SpecialOffrsTableViewCell.m
//  uco
//
//  Created by Br@R on 23/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "SpecialOffrsTableViewCell.h"

@implementation SpecialOffrsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)name :(NSString*)address
{
//    nameLbl.text=name;
//    addressLbl.text=address;
     offerName.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    offerDescription.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    startDateLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    endDateLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    orderNumberLabel.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    orderTimeLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    }

@end
