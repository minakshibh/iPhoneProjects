//
//  PlaylistCell.m
//  Karaoke
//
//  Created by Krishna_Mac_3 on 21/03/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import "CreditSongsCell.h"

@implementation CreditSongsCell
@synthesize numbrOfSongsLbl = _numbrOfSongsLbl;
@synthesize nameOfPlaylistLbl = _nameOfPlaylistLbl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setLabelText:(NSString*)_lbl1 :(NSString*)_lbl2 :(NSString*)_lbl3  ;
 {
    
    self.nameOfPlaylistLbl.text = [NSString stringWithFormat:@"%@",_lbl1];
  //  self.songs.text=[NSString stringWithFormat:@"%@ Songs",_lbl2];
     self.songs.text=[NSString stringWithFormat:@"%@ ",_lbl3];

    
}
@end
