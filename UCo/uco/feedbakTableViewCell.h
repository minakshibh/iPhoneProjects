//
//  feedbakTableViewCell.h
//  uco
//
//  Created by Krishna_Mac_1 on 4/2/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface feedbakTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dateStr;
@property (strong, nonatomic) IBOutlet UILabel *customerNameStr;
@property (strong, nonatomic) IBOutlet UILabel *commentStr;
-(void)setLabelText:(NSString*)date :(NSString*)customerName :(NSString*)comment;
@end
