//
//  ConnectionRequestTableViewCell.m
//  TutorHelper
//
//  Created by Br@R on 08/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "ConnectionRequestTableViewCell.h"

@implementation ConnectionRequestTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)sendrIdStr :(NSString*)senderNameStr
{
    sender_idlbl.text=[NSString stringWithFormat:@"%@",sendrIdStr];
    senderNamelbl.text=[NSString stringWithFormat:@"%@",senderNameStr];
}

@end
