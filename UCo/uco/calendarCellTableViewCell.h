//
//  calendarCellTableViewCell.h
//  uco
//
//  Created by Krishna_Mac_1 on 3/27/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface calendarCellTableViewCell : UITableViewCell
{
    IBOutlet UILabel *tableName;
    
}
-(void)setLabelText:(NSString*)tablesName ;
@end
