//
//  PaymentTableViewCell.h
//  uco
//
//  Created by Krishna Mac Mini 2 on 01/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentTableViewCell : UITableViewCell
{
    
    IBOutlet UILabel *dueDateLbl;
    IBOutlet UILabel *amountLbl;
    IBOutlet UILabel *idLabel;
    IBOutlet UILabel *dateLbl;
}

-(void)setLabelText:(NSString*)dateStr :(NSString*)idStr :(NSString*)amountStr :(NSString*)dueDateStr;

@end
