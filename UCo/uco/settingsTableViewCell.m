//
//  settingsTableViewCell.m
//  uco
//
//  Created by Krishna_Mac_1 on 4/2/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "settingsTableViewCell.h"

@implementation settingsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)name :(NSString*)email :(NSString*)phoneNumber
{
    nameLbl.text = [NSString stringWithFormat:@"%@",name];
    emailLbl.text = [NSString stringWithFormat:@"%@",email];
    phoneNumberLbl.text = [NSString stringWithFormat:@"%@",phoneNumber];
    nameLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    emailLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    phoneNumberLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
}
@end
