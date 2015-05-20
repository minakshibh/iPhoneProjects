//
//  PlaylistCell.h
//  Karaoke
//
//  Created by Krishna_Mac_3 on 21/03/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditSongsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *numbrOfSongsLbl;
@property (strong, nonatomic) IBOutlet UILabel *nameOfPlaylistLbl;
@property (weak, nonatomic) IBOutlet UILabel *songs;
@property (weak, nonatomic) IBOutlet UILabel *price;


- (void)setLabelText:(NSString*)_lbl1 :(NSString*)_lbl2 :(NSString*)_lbl3  ;

@end
