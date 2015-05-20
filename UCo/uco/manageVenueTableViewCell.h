//
//  manageVenueTableViewCell.h
//  uco
//
//  Created by Krishna_Mac_1 on 4/2/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface manageVenueTableViewCell : UITableViewCell
{
    
    IBOutlet UILabel *nameLbl;
    IBOutlet UILabel *addressLbl;
    IBOutlet UILabel *descriptionLbl;
    IBOutlet UIImageView *venueImage;
    IBOutlet UIImageView *cellBG;
}
-(void)setLabelText:(NSString*)name :(NSString*)address :(NSString*)desp :(NSString*)imageUrl;
@end
