//
//  AvailbleSongsCell.m
//  Karaoke
//
//  Created by Krishna_Mac_3 on 21/03/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import "AvailbleSongsCell.h"
#import "UIImageView+WebCache.h"
#import "Base64.h"
#import "AppDelegate.h"

@implementation AvailbleSongsCell
@synthesize artistNameLbl = _artistNameLbl;
@synthesize songNameLbl = _songNameLbl;
@synthesize songImage = _songImage;
@synthesize songDurationLbl=_songDurationLbl;
@synthesize trackCodeLbl=_trackCodeLbl;

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
}
- (void)setLabelText:(NSString*)_lbl1 :(NSString*)_lbl2 :(NSString*)_lbl3:(NSString*)_lbl5:(NSString*)_lbl4 {
    
    self.songNameLbl.text = [NSString stringWithFormat:@"%@",_lbl3];
    self.artistNameLbl.text=[NSString stringWithFormat:@"%@",_lbl1];
    self.songDurationLbl.text=[NSString stringWithFormat:@"%@",_lbl5];
    if (![_lbl2 isEqualToString:@""])
    {
        self.trackCodeLbl.text=[NSString stringWithFormat:@"%@",_lbl2];

    }
    self.songImage.image = [UIImage imageNamed:@"song_play_icon.png"];
    if (![_lbl4 isEqualToString:@""]) {
       // self.songPrice.text=[NSString stringWithFormat:@"%@ Credits",_lbl4];
    }
}
- (void)setLabelText2:(NSString*)_lbl1 :(NSString*)_lbl2 :(NSString*)_lbl3: (NSString*)_lbl4 :(NSString*)_lbl5
{
    self.songNameLbl.text = [NSString stringWithFormat:@"%@",_lbl3];
    self.artistNameLbl.text=[NSString stringWithFormat:@"%@",_lbl1];
    if (![_lbl2 isEqualToString:@""])
    {
        self.trackCodeLbl.text=[NSString stringWithFormat:@"%@",_lbl2];
        
    }    self.songDurationLbl.text=_lbl5;
    _lbl4= [_lbl4 stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceCharacterSet]];

    _lbl4 = [_lbl4 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:_lbl4];
    [self.songImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"stub.png"]];
}


@end
