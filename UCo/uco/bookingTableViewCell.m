//
//  bookingTableViewCell.m
//  uco
//
//  Created by Krishna_Mac_1 on 4/14/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "bookingTableViewCell.h"

@implementation bookingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)bookingStatus :(NSString*)contact :(NSString*)name :(NSString*)tablesNumber:(NSString*)guests:(NSString*)time
{
    bookingStatusLbl.text =[NSString stringWithFormat:@"%@",bookingStatus];
    contactLbl.text = [NSString stringWithFormat:@"%@",contact];
    nameLabel.text = [NSString stringWithFormat:@"%@",name];
    tableLbl.text = [NSString stringWithFormat:@"%@",tablesNumber];
    guestsLbl.text = [NSString stringWithFormat:@"%@ Guests",guests];
    timeLbl.text = [NSString stringWithFormat:@"%@",time];
}
@end
