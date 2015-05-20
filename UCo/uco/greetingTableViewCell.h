//
//  greetingTableViewCell.h
//  uco
//
//  Created by Krishna Mac Mini 2 on 01/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface greetingTableViewCell : UITableViewCell
{
    
    IBOutlet UIImageView *imageView;
    IBOutlet UILabel *nameLbl;
    IBOutlet UILabel *tableLabl;
    IBOutlet UILabel *specialReqstLbl;
    IBOutlet UILabel *timeLbl;
    IBOutlet UILabel *peopleLbl;
}

-(void)setLabelText:(NSString*)name :(NSString*)table :(NSString*)people :(NSString*)specialRequest :(NSString*)timing :(NSString*)imageUrlStr;

@end
