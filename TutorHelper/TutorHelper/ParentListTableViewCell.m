//
//  ParentListTableViewCell.m
//  TutorHelper
//
//  Created by Br@R on 26/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "ParentListTableViewCell.h"

@implementation ParentListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)parentName :(NSString*)Students :(NSString*)balance :(NSString*)lessons
{
    parentNameLbl.text=parentName;
    NumbrOfStudntsLbl.text=[NSString stringWithFormat:@": %@",Students];
    balanceLbl.text=[NSString stringWithFormat:@": $%@",balance];
    lessonsLbl.text=[NSString stringWithFormat:@": %@",lessons];

}
@end
