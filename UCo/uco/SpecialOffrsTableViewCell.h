//
//  SpecialOffrsTableViewCell.h
//  uco
//
//  Created by Br@R on 23/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialOffrsTableViewCell : UITableViewCell{
    
    IBOutlet UILabel *offerName;
    IBOutlet UILabel *offerDescription;
    IBOutlet UILabel *startDateLbl;
    IBOutlet UILabel *endDateLbl;
    IBOutlet UILabel *orderNumberLabel;
    IBOutlet UILabel *orderTimeLbl;
}
-(void)setLabelText:(NSString*)name :(NSString*)address;

@end
