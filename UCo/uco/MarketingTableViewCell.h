//
//  MarketingTableViewCell.h
//  uco
//
//  Created by Br@R on 18/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarketingTableViewCell : UITableViewCell
{
   IBOutlet UIImageView *userImageView;
    IBOutlet UILabel *userNameLbl;
    IBOutlet UILabel *FrequentGuestLbl;
    IBOutlet UILabel *userEmailLbl;
    IBOutlet UILabel *userContactLbl;
}
-(void)setLabelText:(NSString*)name :(NSString*)emailAddrss :(NSString*)contactNum :(NSString*)guestUser :(NSString*)imageUrlStr;

@end
