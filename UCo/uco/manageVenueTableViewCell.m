//
//  manageVenueTableViewCell.m
//  uco
//
//  Created by Krishna_Mac_1 on 4/2/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "manageVenueTableViewCell.h"

@implementation manageVenueTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)name :(NSString*)address :(NSString*)desp :(NSString*)imageUrl
{
    NSLog(@"Name... %@" ,name);
    NSLog(@"Address.... %@", address);
    NSLog(@"description.... %@", desp);
    
    nameLbl.text = [NSString stringWithFormat:@"%@",name];
    addressLbl.text = [NSString stringWithFormat:@"%@",address];
    descriptionLbl.text = [NSString stringWithFormat:@"%@",desp];
    
    venueImage.layer.borderColor = [UIColor clearColor].CGColor;
    venueImage.layer.borderWidth = 1.5;
    venueImage.layer.cornerRadius = 4.0;
    [venueImage setClipsToBounds:YES];
    
    cellBG.layer.borderColor = [UIColor clearColor].CGColor;
    cellBG.layer.borderWidth = 1.5;
    cellBG.layer.cornerRadius = 8.0;
    [cellBG setClipsToBounds:YES];
    
}

@end
