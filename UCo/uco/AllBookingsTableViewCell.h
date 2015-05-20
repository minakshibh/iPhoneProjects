//
//  AllBookingsTableViewCell.h
//  uco
//
//  Created by Br@R on 19/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllBookingsTableViewCell : UITableViewCell
{
    IBOutlet UILabel *dateLbl;
    IBOutlet UILabel *timeLbl;
    IBOutlet UILabel *customerNameLbl;
    IBOutlet UILabel *partySizeLbl;
    IBOutlet UILabel *tableNumLbl;
}
-(void)setLabelText:(NSString*)dateStr :(NSString*)timeStr :(NSString*)customerNameStr :(NSString*)partySizeStr :(NSString*)tableNumStr;

@end
