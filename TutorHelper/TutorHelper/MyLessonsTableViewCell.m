//
//  MyLessonsTableViewCell.m
//  TutorHelper
//
//  Created by Br@R on 17/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "MyLessonsTableViewCell.h"

@implementation MyLessonsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)detailStr :(NSString*)timeStr :(NSString*)DaysStr :(NSString*)students
{
    
    descripTionLbl.text=detailStr;
    timeLbl.text=timeStr;
    studentsTxt.text=[NSString stringWithFormat:@"%@Students",students];
    
    NSArray *daysArray = [DaysStr componentsSeparatedByString:@","];
    for (int k=0; k<daysArray.count; k++)
    {
        if ([[daysArray objectAtIndex:k] isEqualToString:@"Monday"])
        {
            monLbl.textColor=[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        }
        if ([[daysArray objectAtIndex:k] isEqualToString:@"Tuesday"])
        {
            TuesLbl.textColor=[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        }
        if ([[daysArray objectAtIndex:k] isEqualToString:@"Wednesday"])
        {
            WEDLBL.textColor=[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        }
        if ([[daysArray objectAtIndex:k] isEqualToString:@"Thursday"])
        {
            thurLbl.textColor=[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        }
        if ([[daysArray objectAtIndex:k] isEqualToString:@"Friday"])
        {
            friLbl.textColor=[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        }
        if ([[daysArray objectAtIndex:k] isEqualToString:@"Saturday"])
        {
            satLbl.textColor=[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        }
        if ([[daysArray objectAtIndex:k] isEqualToString:@"Sunday"])
        {
            sundayLbl.textColor=[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
        }
    }
}
@end
