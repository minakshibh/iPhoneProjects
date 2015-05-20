//
//  ManageRestaurantTableViewCell.h
//  uco
//
//  Created by Br@R on 18/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageRestaurantTableViewCell : UITableViewCell
{
    IBOutlet UILabel *nameLbl;
    IBOutlet UILabel *addressLbl;
}
-(void)setLabelText:(NSString*)name :(NSString*)address;

@end
