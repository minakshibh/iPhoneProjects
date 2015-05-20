//
//  ManageRestaurantTableViewCell.m
//  uco
//
//  Created by Br@R on 18/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "ManageRestaurantTableViewCell.h"

@implementation ManageRestaurantTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)name :(NSString*)address
{
    nameLbl.font =[UIFont fontWithName:@"Lovelo" size:13.0f];
    addressLbl.font =[UIFont fontWithName:@"Lovelo" size:13.0f];
    nameLbl.text=name;
    addressLbl.text=address;
}

@end
