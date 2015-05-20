//
//  PaymentTableViewCell.m
//  uco
//
//  Created by Krishna Mac Mini 2 on 01/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "PaymentTableViewCell.h"

@implementation PaymentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)dateStr :(NSString*)idStr :(NSString*)amountStr :(NSString*)dueDateStr{
    dateLbl.text=dateStr;
    idLabel.text=idStr;
    amountLbl.text=amountStr;
    dueDateLbl.text=dueDateStr;
    
    dateLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    idLabel.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    amountLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    dueDateLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
}
@end
