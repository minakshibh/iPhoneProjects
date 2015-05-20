//
//  AvailableAlbumsCell.m
//  Karaoke
//
//  Created by Krishna_Mac_3 on 21/03/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import "AvailableAlbumsCell.h"
#import "UIImageView+WebCache.h"
#import "Base64.h"
#import "AppDelegate.h"

@implementation AvailableAlbumsCell
@synthesize artistNameLbl = _artistNameLbl;
@synthesize albumsNameLbl = _albumsNameLbl;
@synthesize albumImage = _albumImage;
@synthesize numbrOfSongLbl=_numbrOfSongLbl;

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
- (void)setLabelText:(NSString*)_lbl1 :(NSString*)_lbl2 :(NSString*)_lbl3 :(NSString*)_lbl4 :(NSString*)_lbl5 {
    
    self.albumsNameLbl.text = [NSString stringWithFormat:@"%@",_lbl1];
    NSLog(@"%@",  self.albumsNameLbl.text);
//    self.albumPriceLbl.text = [NSString stringWithFormat:@"(%@ Credits)",_lbl2];
    self.artistNameLbl.text=[NSString stringWithFormat:@"%@",_lbl3];
    self.numbrOfSongLbl.text = [NSString stringWithFormat:@"%@ %@ ",_lbl4,_lbl2];

        _lbl5 = [_lbl5 stringByTrimmingCharactersInSet:
                 [NSCharacterSet whitespaceCharacterSet]];
        
        _lbl5 = [_lbl5 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:_lbl5];
        [self.albumImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"stub.png"]];
    
    if (![_lbl2 isEqualToString:@""]) {
       // self.albumPriceLbl.text=[NSString stringWithFormat:@"£%@",_lbl2];
 
    }
}

@end
