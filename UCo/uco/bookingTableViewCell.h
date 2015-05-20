//
//  bookingTableViewCell.h
//  uco
//
//  Created by Krishna_Mac_1 on 4/14/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bookingTableViewCell : UITableViewCell
{
    IBOutlet UILabel *bookingStatusLbl;
    IBOutlet UILabel *contactLbl;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *tableLbl;
    IBOutlet UILabel *guestsLbl;
    IBOutlet UILabel *timeLbl;
}
-(void)setLabelText:(NSString*)bookingStatus :(NSString*)contact :(NSString*)name :(NSString*)tablesNumber:(NSString*)guests:(NSString*)time;
@end
