//
//  calendarCellTableViewCell.m
//  uco
//
//  Created by Krishna_Mac_1 on 3/27/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "calendarCellTableViewCell.h"

@implementation calendarCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)tablesName
{
    tableName.font =[UIFont fontWithName:@"Lovelo" size:13.0f];
       tableName.text=tablesName;
    
}
@end
