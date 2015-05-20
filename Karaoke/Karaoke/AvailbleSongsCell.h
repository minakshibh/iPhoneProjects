//
//  AvailbleSongsCell.h
//  Karaoke
//
//  Created by Krishna_Mac_3 on 21/03/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvailbleSongsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *artistNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *songNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *songDurationLbl;
@property (strong, nonatomic) IBOutlet UIImageView *songImage;
@property (strong, nonatomic) IBOutlet UILabel *trackCodeLbl;
@property (strong, nonatomic) IBOutlet UILabel *songPrice;

- (void)setLabelText:(NSString*)_lbl1 :(NSString*)_lbl2 :(NSString*)_lbl3 :(NSString*)_lbl5:(NSString*)_lbl4 ;
- (void)setLabelText2:(NSString*)_lbl1 :(NSString*)_lbl2 :(NSString*)_lbl3 :(NSString *)_lbl4:(NSString*)_lbl5;

@end
