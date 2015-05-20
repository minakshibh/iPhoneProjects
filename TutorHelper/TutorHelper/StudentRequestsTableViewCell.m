//
//  StudentRequestsTableViewCell.m
//  TutorHelper
//
//  Created by Br@R on 13/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "StudentRequestsTableViewCell.h"

@implementation StudentRequestsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)sendrIdStr :(NSString*)senderNameStr :(NSString*) feesStr :(NSString*)emailStr :(NSString*)contactStr {
    idLbl.text=sendrIdStr;
    nameLbl.text=senderNameStr;
    feesLbl.text=feesStr;
    emailLbl.text=emailStr;
    contactLbl.text=contactStr;
}
@end
