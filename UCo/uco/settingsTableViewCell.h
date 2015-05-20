//
//  settingsTableViewCell.h
//  uco
//
//  Created by Krishna_Mac_1 on 4/2/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface settingsTableViewCell : UITableViewCell
{
    
    IBOutlet UILabel *nameLbl;
    IBOutlet UILabel *emailLbl;
    IBOutlet UILabel *phoneNumberLbl;

}
-(void)setLabelText:(NSString*)name :(NSString*)email :(NSString*)phoneNumber;
@end
