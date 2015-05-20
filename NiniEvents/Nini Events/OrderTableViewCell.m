//
//  OrderTableViewCell.m
//  Nini Events
//
//  Created by Br@R on 29/01/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "UIImageView+WebCache.h"


@implementation OrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)orderName :(int)quantity :(NSString*)price :(UIImage*)imageUrl{
    
    name.text = [[NSString stringWithFormat:@"%@",orderName]uppercaseString];
    priceLbl.text = [NSString stringWithFormat:@"$%.2f",[price floatValue]];
    quantityLbl.text = [NSString stringWithFormat:@"%d",quantity];
    [productImageView setImage:imageUrl];
    
}

@end
