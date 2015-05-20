//
//  AvailableAlbumsCell.h
//  Karaoke
//
//  Created by Krishna_Mac_3 on 21/03/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvailableAlbumsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *albumsNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *artistNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *numbrOfSongLbl;
@property (strong, nonatomic) IBOutlet UIImageView *albumImage;
- (void)setLabelText:(NSString*)_lbl1 :(NSString*)_lbl2 :(NSString*)_lbl3 :(NSString*)_lbl4 :(NSString*)_lbl5 ;
@property (strong, nonatomic) IBOutlet UILabel *albumPriceLbl;

@end
